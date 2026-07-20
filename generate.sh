#!/bin/bash
# ═══════════════════════════════════════════════════════
#  AI HTML GENERATOR — Creates a fresh link hub from your site list
#  Usage: ./generate.sh
# ═══════════════════════════════════════════════════════

echo ""
echo "🎨  LINK HUB GENERATOR"
echo "═══════════════════════════════════════════════════════"
echo ""

# Check if user has a custom HTML ready
if [ -f "custom.html" ]; then
    echo "📄  Found custom.html — using that."
    cp custom.html dist/index.html
    echo "✅  Copied custom.html → dist/index.html"
    exit 0
fi

# Otherwise, generate from the built-in template
echo "📝  No custom.html found. Generating from template..."
echo "    (Replace sites[] in this script with your actual URLs)"
echo ""

# The template is already in dist/index.html — just confirm
cat > dist/index.html << 'HTMLEOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Link Hub — takeanickortwo</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #0a0a0f;
            --surface: #12121a;
            --surface-hover: #1a1a25;
            --border: #252535;
            --border-hover: #3a3a50;
            --text: #e8e8f0;
            --text-muted: #8888a0;
            --text-dim: #555570;
            --accent: #00d4ff;
            --accent-glow: rgba(0, 212, 255, 0.15);
            --accent2: #7b2cbf;
            --success: #00ff88;
            --warning: #ffaa00;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', -apple-system, sans-serif;
            background: var(--bg);
            color: var(--text);
            min-height: 100vh;
            padding: 2rem 1rem;
            line-height: 1.6;
        }
        .container { max-width: 960px; margin: 0 auto; }

        /* Header */
        header { text-align: center; margin-bottom: 2.5rem; }
        .logo {
            font-size: 3rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            letter-spacing: -0.02em;
        }
        .tagline { color: var(--text-muted); font-size: 1.1rem; margin-top: 0.5rem; }

        /* Stats bar */
        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
            gap: 1rem;
            margin-bottom: 2.5rem;
        }
        .stat {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 1.25rem;
            text-align: center;
            transition: all 0.3s ease;
        }
        .stat:hover { border-color: var(--border-hover); transform: translateY(-2px); }
        .stat-value {
            font-size: 2rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .stat-label { font-size: 0.85rem; color: var(--text-muted); margin-top: 0.25rem; }

        /* Categories */
        .category { margin-bottom: 2rem; }
        .category-header {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 1rem;
            padding-bottom: 0.75rem;
            border-bottom: 1px solid var(--border);
        }
        .category-icon { font-size: 1.5rem; }
        .category-title { font-size: 1.1rem; font-weight: 700; color: var(--text); }
        .category-count {
            margin-left: auto;
            background: var(--surface);
            border: 1px solid var(--border);
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            color: var(--text-muted);
        }

        /* Link cards */
        .links { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 0.75rem; }
        .link-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 1rem 1.25rem;
            text-decoration: none;
            color: var(--text);
            transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
            display: flex;
            align-items: center;
            gap: 1rem;
            position: relative;
            overflow: hidden;
        }
        .link-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: linear-gradient(135deg, var(--accent-glow), transparent);
            opacity: 0;
            transition: opacity 0.3s;
        }
        .link-card:hover {
            border-color: var(--accent);
            transform: translateY(-3px);
            box-shadow: 0 12px 32px rgba(0,0,0,0.3), 0 0 20px var(--accent-glow);
        }
        .link-card:hover::before { opacity: 1; }
        .link-card > * { position: relative; z-index: 1; }

        .link-icon {
            width: 44px; height: 44px;
            background: linear-gradient(135deg, #1a1a2e, #252540);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.3rem;
            flex-shrink: 0;
        }
        .link-info { flex: 1; min-width: 0; }
        .link-name { font-weight: 600; font-size: 0.95rem; margin-bottom: 0.15rem; }
        .link-url { font-size: 0.8rem; color: var(--text-dim); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .link-arrow { color: var(--text-dim); font-size: 1.2rem; transition: all 0.2s; }
        .link-card:hover .link-arrow { color: var(--accent); transform: translateX(4px); }

        /* Status indicators */
        .status {
            width: 8px; height: 8px;
            border-radius: 50%;
            background: var(--success);
            box-shadow: 0 0 8px var(--success);
            flex-shrink: 0;
        }

        /* Footer */
        footer {
            text-align: center;
            margin-top: 3rem;
            padding: 2rem;
            border-top: 1px solid var(--border);
            color: var(--text-dim);
            font-size: 0.85rem;
        }
        .footer-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: var(--surface);
            border: 1px solid var(--border);
            padding: 0.5rem 1rem;
            border-radius: 20px;
            margin-top: 0.75rem;
        }
        .pulse {
            width: 6px; height: 6px;
            background: var(--success);
            border-radius: 50%;
            animation: pulse 2s infinite;
        }
        @keyframes pulse {
            0% { box-shadow: 0 0 0 0 rgba(0, 255, 136, 0.4); }
            70% { box-shadow: 0 0 0 6px rgba(0, 255, 136, 0); }
            100% { box-shadow: 0 0 0 0 rgba(0, 255, 136, 0); }
        }

        /* Responsive */
        @media (max-width: 600px) {
            .logo { font-size: 2rem; }
            .links { grid-template-columns: 1fr; }
            .stats { grid-template-columns: repeat(3, 1fr); }
        }

        /* Search */
        .search-box {
            width: 100%;
            max-width: 400px;
            margin: 0 auto 2rem;
            position: relative;
        }
        .search-box input {
            width: 100%;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 0.875rem 1rem 0.875rem 2.5rem;
            color: var(--text);
            font-size: 0.95rem;
            outline: none;
            transition: all 0.2s;
        }
        .search-box input:focus {
            border-color: var(--accent);
            box-shadow: 0 0 0 3px var(--accent-glow);
        }
        .search-box::before {
            content: '🔍';
            position: absolute;
            left: 0.875rem;
            top: 50%;
            transform: translateY(-50%);
            font-size: 0.9rem;
            opacity: 0.5;
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <div class="logo">🔗 Link Hub</div>
            <p class="tagline">All projects. One page. Zero friction.</p>
        </header>

        <div class="search-box">
            <input type="text" id="search" placeholder="Search projects..." onkeyup="filterLinks()">
        </div>

        <div class="stats">
            <div class="stat"><div class="stat-value">11</div><div class="stat-label">Projects</div></div>
            <div class="stat"><div class="stat-value">5</div><div class="stat-label">Categories</div></div>
            <div class="stat"><div class="stat-value">∞</div><div class="stat-label">Bandwidth</div></div>
            <div class="stat"><div class="stat-value">0</div><div class="stat-label">Downtime</div></div>
        </div>

        <div class="category" data-category="tools">
            <div class="category-header">
                <span class="category-icon">🛠️</span>
                <span class="category-title">Tools & Utilities</span>
                <span class="category-count">2</span>
            </div>
            <div class="links">
                <a href="https://dabtimer.pages.dev" class="link-card" target="_blank" data-name="dab timer">
                    <div class="link-icon">⏱️</div>
                    <div class="link-info"><div class="link-name">Dab Timer</div><div class="link-url">dabtimer.pages.dev</div></div>
                    <div class="status"></div>
                    <span class="link-arrow">→</span>
                </a>
                <a href="https://antievedrop.pages.dev" class="link-card" target="_blank" data-name="antievedrop">
                    <div class="link-icon">🔒</div>
                    <div class="link-info"><div class="link-name">AntiEvedrop</div><div class="link-url">antievedrop.pages.dev</div></div>
                    <div class="status"></div>
                    <span class="link-arrow">→</span>
                </a>
            </div>
        </div>

        <div class="category" data-category="knowledge">
            <div class="category-header">
                <span class="category-icon">📚</span>
                <span class="category-title">Knowledge & Media</span>
                <span class="category-count">4</span>
            </div>
            <div class="links">
                <a href="https://historicsymposium.pages.dev" class="link-card" target="_blank" data-name="historic symposium">
                    <div class="link-icon">🏛️</div>
                    <div class="link-info"><div class="link-name">Historic Symposium</div><div class="link-url">historicsymposium.pages.dev</div></div>
                    <div class="status"></div>
                    <span class="link-arrow">→</span>
                </a>
                <a href="https://newoldwisdom.pages.dev" class="link-card" target="_blank" data-name="new old wisdom">
                    <div class="link-icon">🦉</div>
                    <div class="link-info"><div class="link-name">New Old Wisdom</div><div class="link-url">newoldwisdom.pages.dev</div></div>
                    <div class="status"></div>
                    <span class="link-arrow">→</span>
                </a>
                <a href="https://losslesstrimonics.pages.dev" class="link-card" target="_blank" data-name="lossless trimonics">
                    <div class="link-icon">🎵</div>
                    <div class="link-info"><div class="link-name">Lossless Trimonics</div><div class="link-url">losslesstrimonics.pages.dev</div></div>
                    <div class="status"></div>
                    <span class="link-arrow">→</span>
                </a>
                <a href="https://harmoniouscocada.pages.dev" class="link-card" target="_blank" data-name="harmonious cocada">
                    <div class="link-icon">🌊</div>
                    <div class="link-info"><div class="link-name">Harmonious Cocada</div><div class="link-url">harmoniouscocada.pages.dev</div></div>
                    <div class="status"></div>
                    <span class="link-arrow">→</span>
                </a>
            </div>
        </div>

        <div class="category" data-category="monitoring">
            <div class="category-header">
                <span class="category-icon">🌍</span>
                <span class="category-title">Global Monitoring</span>
                <span class="category-count">2</span>
            </div>
            <div class="links">
                <a href="https://globalflashpoint.pages.dev" class="link-card" target="_blank" data-name="global flashpoint">
                    <div class="link-icon">⚡</div>
                    <div class="link-info"><div class="link-name">Global Flashpoint</div><div class="link-url">globalflashpoint.pages.dev</div></div>
                    <div class="status"></div>
                    <span class="link-arrow">→</span>
                </a>
                <a href="https://flashpoint-dashboard.pages.dev" class="link-card" target="_blank" data-name="flashpoint dashboard">
                    <div class="link-icon">📊</div>
                    <div class="link-info"><div class="link-name">Flashpoint Dashboard</div><div class="link-url">flashpoint-dashboard.pages.dev</div></div>
                    <div class="status"></div>
                    <span class="link-arrow">→</span>
                </a>
            </div>
        </div>

        <div class="category" data-category="osint">
            <div class="category-header">
                <span class="category-icon">🔍</span>
                <span class="category-title">OSINT & Intelligence</span>
                <span class="category-count">1</span>
            </div>
            <div class="links">
                <a href="https://osintloadoff.pages.dev" class="link-card" target="_blank" data-name="osint loadoff">
                    <div class="link-icon">🕵️</div>
                    <div class="link-info"><div class="link-name">OSINT Loadoff</div><div class="link-url">osintloadoff.pages.dev</div></div>
                    <div class="status"></div>
                    <span class="link-arrow">→</span>
                </a>
            </div>
        </div>

        <div class="category" data-category="community">
            <div class="category-header">
                <span class="category-icon">👥</span>
                <span class="category-title">Community</span>
                <span class="category-count">1</span>
            </div>
            <div class="links">
                <a href="https://epicdabber.pages.dev" class="link-card" target="_blank" data-name="epic dabber">
                    <div class="link-icon">🔥</div>
                    <div class="link-info"><div class="link-name">Epic Dabber</div><div class="link-url">epicdabber.pages.dev</div></div>
                    <div class="status"></div>
                    <span class="link-arrow">→</span>
                </a>
            </div>
        </div>

        <footer>
            <p>Built with DeepSeek + Kimi • Deployed on Cloudflare</p>
            <div class="footer-badge"><div class="pulse"></div> All systems operational</div>
        </footer>
    </div>

    <script>
        function filterLinks() {
            const query = document.getElementById('search').value.toLowerCase();
            document.querySelectorAll('.link-card').forEach(card => {
                const name = card.getAttribute('data-name');
                card.style.display = name.includes(query) ? 'flex' : 'none';
            });
            document.querySelectorAll('.category').forEach(cat => {
                const visible = cat.querySelectorAll('.link-card[style*="flex"]').length;
                cat.style.display = visible > 0 ? 'block' : 'none';
            });
        }
    </script>
</body>
</html>
HTMLEOF

echo "✅  Generated dist/index.html from template"
echo ""
echo "    💡  To use your own HTML:"
echo "       1. Save your AI-generated HTML as 'custom.html' in this folder"
echo "       2. Run ./generate.sh again"
echo "       3. Or just: cp custom.html dist/index.html"
echo ""
