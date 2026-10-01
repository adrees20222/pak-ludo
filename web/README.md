# 🌐 Pak Ludo - Web & Blogger Theme

Complete web distribution of **Pak Ludo**, compiled into standalone and Blogger-compatible theme formats.

---

## 📁 Files in this directory

| File | Purpose | How to Use |
| --- | --- | --- |
| `pak-ludo-blogger-theme.xml` | Full standalone Blogger XML Theme | Go to **Blogger Dashboard > Theme > Customize dropdown > Restore > Upload XML** |
| `blogger-widget-embed.html` | Embeddable HTML/JS gadget | Add as an **HTML/JavaScript Gadget** inside any existing Blogger layout |
| `index.html` | Single-file offline/online Web Game | Open directly in any modern browser or host on GitHub Pages / Netlify / Vercel |

---

## 🛠️ Rebuilding Web Assets

From the project root directory:

```bash
# Install dependencies
pnpm install

# Build Blogger theme and standalone web assets
pnpm run build:blogger
```
