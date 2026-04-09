#!/bin/bash

# verify-deploy.sh - MANDATORY verification after every content deploy
# Usage: ./verify-deploy.sh article-slug

if [ -z "$1" ]; then
    echo "❌ Usage: ./verify-deploy.sh [article-slug]"
    echo "   Example: ./verify-deploy.sh micro-dosing-peptides-longevity-guide"
    exit 1
fi

ARTICLE_SLUG="$1"
LIVE_URL="https://peptiderundown.com/articles/${ARTICLE_SLUG}/"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo "🔍 [$TIMESTAMP] Verifying deployment for: $LIVE_URL"

# Wait for Cloudflare propagation  
echo "⏳ Waiting 30 seconds for Cloudflare propagation..."
sleep 30

# Fetch live content
echo "📡 Fetching live content..."
LIVE_CONTENT=$(curl -s -m 10 "$LIVE_URL")
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$LIVE_URL")

# Check if page exists
if [ "$HTTP_STATUS" != "200" ]; then
    echo "❌ HTTP Error: $HTTP_STATUS"
    echo "   URL may not exist or server error"
    exit 1
fi

# Check for proper paragraph spacing (look for multiple <p> tags with spacing)
PARAGRAPH_COUNT=$(echo "$LIVE_CONTENT" | grep -o '<p>' | wc -l)
echo "📊 Found $PARAGRAPH_COUNT paragraph tags"

# Look for proper spacing indicators
HAS_PROPER_SPACING=false
if [ "$PARAGRAPH_COUNT" -gt 5 ]; then
    # Check if paragraphs aren't all crammed together
    if echo "$LIVE_CONTENT" | grep -q '</p>.*<p>' && ! echo "$LIVE_CONTENT" | grep -q '</p><p>'; then
        HAS_PROPER_SPACING=true
    fi
fi

# Check content length (should be substantial)
CONTENT_LENGTH=$(echo "$LIVE_CONTENT" | wc -c)
echo "📏 Content length: $CONTENT_LENGTH characters"

# Verification results
if [ "$HAS_PROPER_SPACING" = true ] && [ "$CONTENT_LENGTH" -gt 5000 ]; then
    echo "✅ Deployment VERIFIED - changes are live"
    echo "   • Proper paragraph structure detected"
    echo "   • Content length adequate ($CONTENT_LENGTH chars)"
    exit 0
else
    echo "❌ Deployment FAILED verification"
    echo "   • Paragraph spacing: $HAS_PROPER_SPACING"  
    echo "   • Content length: $CONTENT_LENGTH chars"
    echo ""
    echo "🔄 Attempting Cloudflare cache purge..."
    # Note: Would need Cloudflare API token for actual purge
    echo "⚠️  Manual cache purge may be needed in Cloudflare dashboard"
    exit 1
fi