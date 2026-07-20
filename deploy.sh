#!/bin/bash
set -e

# ═══════════════════════════════════════════════════════
#  LINK HUB AUTO-DEPLOY — Zero-Friction Cloudflare Deploy
#  Usage: ./deploy.sh [staging|production]
# ═══════════════════════════════════════════════════════

ENV=${1:-production}
PROJECT_NAME="takeanickortwo-linkhub"

echo ""
echo "🚀  LINK HUB DEPLOYER"
echo "═══════════════════════════════════════════════════════"
echo ""

# ── Check dependencies ─────────────────────────────────
if ! command -v npx &> /dev/null; then
    echo "❌  npx not found. Install Node.js first:"
    echo "    https://nodejs.org/"
    exit 1
fi

if ! npx wrangler --version &> /dev/null 2>&1; then
    echo "📦  Installing Wrangler..."
    npm install -g wrangler
fi

# ── Check if logged in ─────────────────────────────────
if ! npx wrangler whoami &> /dev/null 2>&1; then
    echo "🔐  Not logged in. Opening Cloudflare auth..."
    npx wrangler login
fi

# ── Validate dist/ folder ──────────────────────────────
if [ ! -d "dist" ]; then
    echo "📁  Creating dist/ folder..."
    mkdir -p dist
fi

if [ ! -f "dist/index.html" ]; then
    echo "⚠️   No dist/index.html found!"
    echo ""
    echo "    Options:"
    echo "    1. Copy your AI-generated HTML:  cp mypage.html dist/index.html"
    echo "    2. Use the sample included:       cp sample-index.html dist/index.html"
    echo "    3. Generate fresh HTML:           ./generate.sh"
    echo ""
    exit 1
fi

# ── Show what we're deploying ──────────────────────────
FILE_SIZE=$(du -h dist/index.html | cut -f1)
FILE_LINES=$(wc -l < dist/index.html | tr -d ' ')
echo "📄  Deploying: dist/index.html"
echo "    Size: ${FILE_SIZE} | Lines: ${FILE_LINES}"
echo "    Environment: ${ENV}"
echo ""

# ── Deploy ─────────────────────────────────────────────
echo "⬆️   Uploading to Cloudflare edge..."
echo ""

if [ "$ENV" = "staging" ]; then
    npx wrangler deploy --env staging
else
    npx wrangler deploy
fi

# ── Success ────────────────────────────────────────────
echo ""
echo "✅  DEPLOYED SUCCESSFULLY"
echo "═══════════════════════════════════════════════════════"
echo ""
echo "    🌐  Your site is live at:"
echo "       https://${PROJECT_NAME}.workers.dev"
echo ""
echo "    📝  To add a custom domain:"
echo "       wrangler pages domain add yourdomain.com"
echo ""
echo "    🔄  To deploy again:"
echo "       ./deploy.sh"
echo ""
