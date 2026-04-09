#!/usr/bin/env python3
"""Generate article images via OpenRouter image models.

Usage:
    python3 gen-image.py --slug SLUG --prompt "PROMPT" [--model MODEL] [--out-dir DIR]

Defaults:
    model: google/gemini-2.5-flash-image
    out-dir: site/public/images/articles/

Notes:
    - Attempts to save as exact-size WEBP when Pillow is available.
    - If Pillow is unavailable and the provider does not return WEBP, the original
      format may be saved instead.
"""

import argparse
import base64
import io
import json
import os
import sys

import requests

DEFAULT_MODEL = "google/gemini-3-pro-image-preview"
# This script lives at <site>/tools/gen-image.py; default output is <site>/public/images/articles
DEFAULT_OUT = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "public", "images", "articles"))
DEFAULT_WIDTH = 1536
DEFAULT_HEIGHT = 1024
DEFAULT_WEBP_QUALITY = 88


def get_api_key():
    """Read OpenRouter API key from openclaw config."""
    config_path = os.path.expanduser("~/.openclaw/openclaw.json")
    with open(config_path) as f:
        config = json.load(f)
    return config["models"]["providers"]["openrouter"]["apiKey"]


def generate_image(prompt, model, api_key):
    """Call OpenRouter chat completions with image modality."""
    resp = requests.post(
        "https://openrouter.ai/api/v1/chat/completions",
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json"
        },
        json={
            "model": model,
            "messages": [{"role": "user", "content": prompt}],
            "modalities": ["image", "text"],
            "max_tokens": 2000
        },
        timeout=120
    )
    resp.raise_for_status()
    data = resp.json()
    if "error" in data:
        raise RuntimeError(f"API error: {data['error']}")

    msg = data["choices"][0]["message"]
    images = msg.get("images", [])
    if not images:
        raise RuntimeError(f"No images returned. Content: {msg.get('content', '')[:200]}")

    img_url = images[0]["image_url"]["url"]
    usage = data.get("usage", {})
    cost = usage.get("cost", 0)

    if img_url.startswith("data:"):
        header, b64 = img_url.split(",", 1)
        img_bytes = base64.b64decode(b64)
        if "png" in header:
            ext = "png"
        elif "webp" in header:
            ext = "webp"
        elif "jpeg" in header or "jpg" in header:
            ext = "jpg"
        else:
            ext = "png"
        return img_bytes, ext, cost

    raise RuntimeError(f"Unexpected image URL format: {img_url[:100]}")


def convert_to_exact_webp(img_bytes, width, height, quality):
    """Convert image bytes to exact-size WEBP using center-crop cover logic."""
    try:
        from PIL import Image
    except ImportError as exc:
        raise RuntimeError("Pillow is required to enforce exact WEBP dimensions") from exc

    img = Image.open(io.BytesIO(img_bytes)).convert("RGB")
    src_w, src_h = img.size
    src_ratio = src_w / src_h
    dst_ratio = width / height

    if src_ratio > dst_ratio:
        new_h = height
        new_w = round(height * src_ratio)
    else:
        new_w = width
        new_h = round(width / src_ratio)

    resample = getattr(Image, "Resampling", Image).LANCZOS
    img = img.resize((new_w, new_h), resample)

    left = max(0, (new_w - width) // 2)
    top = max(0, (new_h - height) // 2)
    img = img.crop((left, top, left + width, top + height))

    buf = io.BytesIO()
    img.save(buf, format="WEBP", quality=quality, method=6)
    return buf.getvalue()


def main():
    parser = argparse.ArgumentParser(description="Generate article images via OpenRouter")
    parser.add_argument("--slug", required=True, help="Article slug (used as filename)")
    parser.add_argument("--prompt", required=True, help="Image generation prompt")
    parser.add_argument("--model", default=DEFAULT_MODEL, help=f"Model ID (default: {DEFAULT_MODEL})")
    parser.add_argument("--out-dir", default=DEFAULT_OUT, help="Output directory")
    parser.add_argument("--width", type=int, default=DEFAULT_WIDTH, help=f"Target width (default: {DEFAULT_WIDTH})")
    parser.add_argument("--height", type=int, default=DEFAULT_HEIGHT, help=f"Target height (default: {DEFAULT_HEIGHT})")
    parser.add_argument("--quality", type=int, default=DEFAULT_WEBP_QUALITY, help=f"WEBP quality (default: {DEFAULT_WEBP_QUALITY})")
    args = parser.parse_args()

    api_key = get_api_key()
    print(f"Generating: {args.slug}")
    print(f"Model: {args.model}")
    print(f"Prompt: {args.prompt[:80]}...")
    print(f"Target: {args.width}x{args.height} WEBP")

    img_bytes, ext, cost = generate_image(args.prompt, args.model, api_key)
    out_path = os.path.join(args.out_dir, f"{args.slug}.webp")

    try:
        img_bytes = convert_to_exact_webp(img_bytes, args.width, args.height, args.quality)
    except RuntimeError as exc:
        if ext == "webp":
            print(f"Warning: {exc}. Saving provider WEBP without resizing.")
        else:
            fallback_path = os.path.join(args.out_dir, f"{args.slug}.{ext}")
            os.makedirs(args.out_dir, exist_ok=True)
            with open(fallback_path, "wb") as f:
                f.write(img_bytes)
            print(f"Warning: {exc}. Saved original file instead: {fallback_path}")
            print(f"Cost: ${cost:.4f}")
            return

    os.makedirs(args.out_dir, exist_ok=True)
    with open(out_path, "wb") as f:
        f.write(img_bytes)

    print(f"Saved: {out_path} ({len(img_bytes):,} bytes)")
    print(f"Cost: ${cost:.4f}")


if __name__ == "__main__":
    main()
