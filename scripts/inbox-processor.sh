#!/bin/bash
# inbox-processor.sh
# One-shot processor for HTML files in inbox/pending.
# Converts each HTML file to an article file in site/src/pages/articles,
# generates a hero image if missing, commits, pushes, and verifies deploy.

set -euo pipefail

ROOT="/home/claw/.openclaw/workspace/projects/peptide-site"
INBOX="$ROOT/inbox"
PENDING="$INBOX/pending"
PROCESSING="$INBOX/processing"
FAILED="$INBOX/failed"
SITE="$ROOT/site"
ARTICLES="$SITE/src/pages/articles"
IMGDIR="$SITE/public/images/articles"

LOGDIR="/tmp/openclaw"
mkdir -p "$LOGDIR" "$PENDING" "$PROCESSING" "$FAILED"
LOG="$LOGDIR/inbox-processor.log"

exec > >(tee -a "$LOG") 2>&1

echo "[inbox-processor] $(date -Is) start"

bash "$ROOT/inbox-selfheal.sh"

shopt -s nullglob
files=("$PENDING"/*.html)

if [ ${#files[@]} -eq 0 ]; then
  echo "[inbox-processor] no pending files"
  exit 0
fi

cd "$SITE"

for f in "${files[@]}"; do
  base=$(basename "$f")
  slug=${base%.html}
  echo "[inbox-processor] processing $base (slug=$slug)"

  mv "$PENDING/$base" "$PROCESSING/$base"
  html_path="$PROCESSING/$base"

  svg_count=$(grep -c '<svg' "$html_path" || true)
  is_svg=false
  if [ "$svg_count" -gt 0 ]; then is_svg=true; fi

  title=$(perl -0777 -ne 'if(/<title>\s*(.*?)\s*<\/title>/is){$t=$1; $t=~s/\s+/ /g; print $t; exit}' "$html_path" || true)
  if [ -z "${title:-}" ]; then
    title=$(perl -0777 -ne 'if(/<h1[^>]*>\s*(.*?)\s*<\/h1>/is){$t=$1; $t=~s/<[^>]+>//g; $t=~s/\s+/ /g; print $t; exit}' "$html_path" || true)
  fi
  if [ -z "${title:-}" ]; then title="$slug"; fi

  date=$(date +%F)

  # If replacing an existing article, prefer keeping its existing hero image.
  # This avoids generating a new image on updates when a good one already exists.
  existing_image=""
  if [ -f "$ARTICLES/$slug.astro" ]; then
    existing_image=$(perl -0777 -ne 'if(/image:\s*\"([^\"]+)\"/){print $1; exit}' "$ARTICLES/$slug.astro" || true)
  elif [ -f "$ARTICLES/$slug.md" ]; then
    existing_image=$(perl -ne 'if(/^image:\s*(.+)\s*$/){print $1; exit}' "$ARTICLES/$slug.md" || true)
  fi
  image_path="${existing_image:-/images/articles/${slug}.webp}"

  if [ "$is_svg" = true ]; then
    out="$ARTICLES/$slug.astro"

    perl -0777 -ne 'if(/<style>\s*(.*?)\s*<\/style>/is){print $1}' "$html_path" \
      | perl -pe 's/^\s*\*\s*\{.*$//mg; s/^\s*body\s*\{.*$//mg;' \
      > "/tmp/${slug}.css"

    perl -0777 -ne '
      if(/<div class="c">\s*(.*)\s*<\/div>\s*<\/body>/is){print $1; exit}
      if(/<body[^>]*>\s*(.*)\s*<\/body>/is){print $1; exit}
    ' "$html_path" > "/tmp/${slug}.inner.html"

    perl -pi -e 's/`/\\`/g; s/\$\{/\\\${/g;' "/tmp/${slug}.css" "/tmp/${slug}.inner.html"

    # Write .astro without triggering shell command-substitution on backticks
    : > "$out"

    cat >> "$out" <<EOF_A
---
import Base from '../../layouts/Base.astro';

export const frontmatter = {
  title: "${title}",
  description: "A detailed comparison of peptides, SARMs, and anabolic steroids—mechanisms, risks, legality, and practical differences.",
  image: "${image_path}",
  date: "${date}",
  category: "Education",
  author: "PeptideRundown Team"
};
const formattedDate = new Date(frontmatter.date).toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' });

EOF_A

    printf '%s\n' 'const rawCSS = `' >> "$out"
    cat "/tmp/${slug}.css" >> "$out"
    printf '%s\n\n' '`;' >> "$out"

    printf '%s\n' 'const rawHTML = `' >> "$out"
    cat "/tmp/${slug}.inner.html" >> "$out"
    printf '%s\n' '`;' >> "$out"

    cat >> "$out" <<'EOF_B'
---
<Base title={frontmatter.title} description={frontmatter.description}>
  <div class="max-w-7xl mx-auto px-4 sm:px-6 py-12 md:flex md:gap-8">
    <article class="md:flex-1 min-w-0">
      <div class="mb-8 -mx-4 sm:mx-0">
        <img src={frontmatter.image} alt={frontmatter.title} class="w-full rounded-none sm:rounded-2xl shadow-lg object-cover max-h-96" loading="eager" />
      </div>
      <header class="mb-10">
        <span class="inline-block px-3 py-1 text-xs font-bold text-primary bg-primary/10 rounded-full mb-4 uppercase tracking-wide">{frontmatter.category}</span>
        <h1 class="text-3xl sm:text-4xl lg:text-5xl font-extrabold leading-tight text-text mb-4">{frontmatter.title}</h1>
        <p class="text-lg text-text-muted leading-relaxed mb-6">{frontmatter.description}</p>
        <div class="flex items-center gap-4 text-sm text-text-muted border-t border-gray-200 pt-4">
          <span>By <strong class="text-text">{frontmatter.author}</strong></span>
          <span>•</span>
          <time datetime={frontmatter.date}>{formattedDate}</time>
        </div>
      </header>
      <div class="bg-amber-50 border border-amber-200 rounded-xl p-4 mb-10 text-sm text-amber-800">
        <strong>⚠️ Medical Disclaimer:</strong> This article is for educational purposes only and is not medical advice. Always consult a qualified healthcare provider before starting any peptide protocol.
      </div>
      <style set:html={rawCSS} />
      <div class="prose prose-lg prose-slate max-w-none prose-headings:font-bold prose-headings:text-text prose-h2:text-2xl prose-h2:mt-14 prose-h2:mb-6 prose-h3:text-xl prose-h3:mt-10 prose-h3:mb-4 prose-a:text-primary prose-a:no-underline hover:prose-a:underline prose-strong:text-text prose-blockquote:border-primary prose-blockquote:bg-primary/5 prose-blockquote:rounded-r-lg prose-img:rounded-xl prose-img:shadow-lg article-content">
        <div class="c" set:html={rawHTML} />
      </div>
    </article>
    <aside class="w-full md:w-64 shrink-0 mt-10 md:mt-0 md:sticky md:top-20 md:self-start">
      <div class="space-y-6">
        <div class="bg-white rounded-2xl border border-gray-200 p-5 shadow-sm">
          <h3 class="text-sm font-bold text-text uppercase tracking-wide mb-3">Quick Info</h3>
          <div class="flex items-center gap-2 mb-2">
            <span class="text-xs text-text-muted">Category:</span>
            <span class="px-2 py-0.5 text-xs font-bold text-primary bg-primary/10 rounded-full">{frontmatter.category}</span>
          </div>
          <div class="flex items-center gap-2 mb-2">
            <span class="text-xs text-text-muted">Updated:</span>
            <span class="text-xs font-medium text-text">{formattedDate}</span>
          </div>
          <div class="flex items-center gap-2">
            <span class="text-xs text-text-muted">Author:</span>
            <span class="text-xs font-medium text-text">{frontmatter.author}</span>
          </div>
        </div>
        <div class="bg-gradient-to-br from-primary/5 to-transparent rounded-2xl border border-primary/10 p-5">
          <h3 class="text-sm font-bold text-primary mb-2">🔬 Our Standards</h3>
          <ul class="text-xs text-text-muted space-y-1.5">
            <li class="flex items-start gap-1.5"><span class="text-primary mt-0.5">✓</span> PubMed-cited research</li>
            <li class="flex items-start gap-1.5"><span class="text-primary mt-0.5">✓</span> No vendor affiliations</li>
            <li class="flex items-start gap-1.5"><span class="text-primary mt-0.5">✓</span> Regularly updated</li>
            <li class="flex items-start gap-1.5"><span class="text-primary mt-0.5">✓</span> Reviewed for accuracy</li>
          </ul>
        </div>
        <div class="bg-white rounded-2xl border border-gray-200 p-5 shadow-sm">
          <h3 class="text-sm font-bold text-text uppercase tracking-wide mb-3">Popular Guides</h3>
          <div class="space-y-3">
            <a href="/articles/what-are-peptides-beginners-guide" class="block text-sm text-text-muted hover:text-primary transition-colors leading-snug">What Are Peptides? Beginner's Guide</a>
            <a href="/articles/how-to-reconstitute-peptides" class="block text-sm text-text-muted hover:text-primary transition-colors leading-snug">How to Reconstitute Peptides</a>
            <a href="/articles/bpc-157-complete-guide" class="block text-sm text-text-muted hover:text-primary transition-colors leading-snug">BPC-157 Complete Guide</a>
            <a href="/articles/peptide-side-effects-what-to-know" class="block text-sm text-text-muted hover:text-primary transition-colors leading-snug">Peptide Side Effects</a>
          </div>
          <a href="/articles" class="block mt-4 text-xs font-bold text-primary hover:underline">View all guides →</a>
        </div>
        <div class="bg-gradient-to-br from-surface-dark to-primary-dark rounded-2xl p-5 text-center">
          <p class="text-sm font-bold text-white mb-2">New to Peptides?</p>
          <p class="text-xs text-gray-300 mb-3">Start with the basics.</p>
          <a href="/articles/what-are-peptides-beginners-guide" class="inline-block px-4 py-2 text-xs font-bold bg-primary text-white rounded-lg hover:bg-primary-light transition-colors">Read Beginner's Guide</a>
        </div>
      </div>
    </aside>
  </div>
</Base>
EOF_B

    rm -f "$ARTICLES/$slug.md" || true

  else
    out="$ARTICLES/$slug.md"
    body=$(perl -0777 -ne 'if(/<body[^>]*>\s*(.*)\s*<\/body>/is){print $1; exit}' "$html_path" || true)

    cat > "$out" <<EOF_D
---
layout: ../../layouts/Article.astro
title: "${title}"
description: "A practical guide explaining ${title}."
image: ${image_path}
date: "${date}"
category: "Peptide Guides"
tags: ["peptides"]
author: "PeptideRundown Team"
---

${body}
EOF_D

    rm -f "$ARTICLES/$slug.astro" || true
  fi

  img_file="$SITE/public${image_path}"
  if [ ! -f "$img_file" ]; then
    echo "[inbox-processor] generating image for $slug"
    python3 "$ROOT/gen-image.py" \
      --slug "$slug" \
      --prompt "High-quality editorial hero image for a medical education article. Abstract scientific molecules on clean clinical gradient background. Modern semi-realistic 3D. No people. No logos. No text, no labels, no words." \
      || echo "[inbox-processor] WARNING: image generation failed for $slug"
  else
    echo "[inbox-processor] reusing existing image: ${image_path}"
  fi

  echo "[inbox-processor] build"
  npm run build --silent

  # Stage both additions AND deletions (important when replacing .md with .astro or vice-versa)
  git add -A "$ARTICLES/$slug."* "$IMGDIR/${slug}."* 2>/dev/null || true
  if git diff --cached --quiet; then
    echo "[inbox-processor] no changes staged; skipping commit"
  else
    git commit -m "Publish article: $slug"
    git push
  fi

  echo "[inbox-processor] verify deploy"
  bash "$ROOT/scripts/verify-deploy.sh" "$slug" || echo "[inbox-processor] WARNING: verify failed for $slug (may still be propagating)"

  echo "[inbox-processor] done; removing inbox file"
  rm -f "$html_path"

  echo "[inbox-processor] completed $slug"

done

echo "[inbox-processor] $(date -Is) complete"
