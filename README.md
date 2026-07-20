# 🔗 takeanickortwo Link Hub

> Zero-friction deployment for your AI-generated static sites.

## 🚀 Quick Start (30 seconds)

```bash
# 1. Install dependencies (one time)
make setup
# or: npm run setup

# 2. Generate or copy your HTML
make generate
# or just drop your AI-generated HTML into dist/index.html

# 3. Deploy
make deploy
# Done. Live in ~10 seconds.
```

## 📁 Project Structure

```
.
├── dist/
│   └── index.html          # ← Your compiled HTML (replace this)
├── .github/
│   └── workflows/
│       └── deploy.yml      # Auto-deploy on every git push
├── wrangler.jsonc          # Cloudflare config
├── deploy.sh               # Smart deploy with error checking
├── generate.sh             # Auto-generates HTML from template
├── Makefile                # One-letter commands
├── package.json            # npm scripts
└── README.md
```

## 🛠️ Commands

| Command | Shortcut | What it does |
|---------|----------|--------------|
| `make deploy` | `make d` | Deploy to Cloudflare |
| `make generate` | `make g` | Generate HTML from template |
| `make dev` | `make v` | Preview locally with Wrangler |
| `make setup` | `make s` | Install Wrangler + login |
| `make preview` | `make p` | Preview with npx serve |
| `make status` | `make st` | Check Cloudflare login |

Or use npm:
```bash
npm run deploy      # Deploy
npm run generate    # Generate HTML
npm run dev         # Local preview
npm run setup       # First-time setup
npm run preview     # Static preview
npm run status      # Check auth
```

## 🔄 Workflow

```
DeepSeek/Kimi → index.html → make deploy → 🌐 Live
```

## 🤖 Auto-Deploy (GitHub)

Push to `main` and it deploys automatically:

1. Go to **Settings → Secrets** in your GitHub repo
2. Add `CF_API_TOKEN` and `CF_ACCOUNT_ID`
3. Push — done.

Get your tokens:
- **API Token**: [dash.cloudflare.com/profile/api-tokens](https://dash.cloudflare.com/profile/api-tokens) → Create Token → Use "Edit Cloudflare Workers" template
- **Account ID**: Found on the right sidebar of any Cloudflare dashboard page

## 📝 Customizing

### Update URLs
Edit `dist/index.html` or use your own AI-generated HTML.

### Add a custom domain
```bash
wrangler pages domain add yourdomain.com
```

### Change project name
Edit `name` in `wrangler.jsonc`.

## 📊 Your Sites

| Category | Sites |
|----------|-------|
| 🛠️ Tools & Utilities | Dab Timer, AntiEvedrop |
| 📚 Knowledge & Media | Historic Symposium, New Old Wisdom, Lossless Trimonics, Harmonious Cocada |
| 🌍 Global Monitoring | Global Flashpoint, Flashpoint Dashboard |
| 🔍 OSINT & Intelligence | OSINT Loadoff |
| 👥 Community | Epic Dabber |

**Total: 11 projects across 5 categories**

---

Built with 💻 DeepSeek + Kimi • Deployed on ⚡ Cloudflare
