# 🎲 Pak Ludo

<p align="center">
  <img src="public/icons/favicon.png" alt="Pak Ludo Logo" width="128" />
</p>

<p align="center">
  <strong>The classic, ad-free Ludo board game featuring Pakistani Emerald Green theme, local multiplayer, smart AI bots, and ultra-responsive low-latency sound effects.</strong>
</p>

<p align="center">
  <a href="https://pak-ludo.blogspot.com/"><img src="https://img.shields.io/badge/🌐_Web_Game-Play_Online-01411C?style=for-the-badge" alt="Web Version" /></a>
  <a href="https://chromewebstore.google.com/detail/dmbglbhnkjeknkaiokpafonjbkcimgcb"><img src="https://img.shields.io/badge/🧩_Chrome_Extension-Install-0D6E38?style=for-the-badge&logo=googlechrome" alt="Chrome Extension" /></a>
  <a href="https://github.com/adrees20222/pak-ludo/releases"><img src="https://img.shields.io/badge/📱_Android_App-Download_APK-15803D?style=for-the-badge&logo=android" alt="Android App" /></a>
  <a href="https://adrees2022.blogspot.com/"><img src="https://img.shields.io/badge/💼_Developer-Portfolio-0284C7?style=for-the-badge" alt="Portfolio" /></a>
</p>

---

## 🎮 Available Platforms

* 🌐 **Web Game (Blogger & Browser)**: [https://pak-ludo.blogspot.com/](https://pak-ludo.blogspot.com/)
* 🧩 **Chrome Web Store Extension**: [Install from Chrome Web Store](https://chromewebstore.google.com/detail/dmbglbhnkjeknkaiokpafonjbkcimgcb)
* 📱 **Android Native App (Flutter)**: [Download Latest APK from GitHub Releases](https://github.com/adrees20222/pak-ludo/releases)
* ⭐ **GitHub Repository**: [https://github.com/adrees20222/pak-ludo](https://github.com/adrees20222/pak-ludo)

---

## ✨ Features

- 🎨 **Pakistani Emerald Green Theme** – Elegant `#01411C` / `#0D6E38` green styling with a high-contrast clean light mode board.
- 🎲 **Local Multiplayer (2–4 Players)** – Play with friends or family on a single screen.
- 🤖 **Smart AI Bots** – Play solo against strategic computer players.
- 🔊 **Sound Effects & Tactile Feedback** – Real-time audio synthesis & SoundPool (dice rattle, token steps, capture strike, safe star chime, and victory fanfare) with an instant mute toggle.
- 📜 **Full Standard Ludo Rules** – Safe star spots, knockout captures with retreat animation, 3 consecutive sixes penalty, and bonus turns.
- 🛡️ **Zero Ads & 100% Private** – No pop-ups, no tracking, no accounts needed.
- 💾 **Auto-Save & Resume** – Matches automatically persist locally across browser reloads or app closures.

---

## 📁 Repository Structure

```text
pak-ludo/
├── app/                        # 📱 Native Android App (Flutter + Kotlin SoundPool)
│   ├── android/
│   ├── lib/
│   └── pubspec.yaml
├── web/                        # 🌐 Blogger Theme & Standalone Web App
│   ├── pak-ludo-blogger-theme.xml
│   ├── blogger-widget-embed.html
│   └── index.html
├── src/                        # 🧩 React Web & Chrome Extension Core
│   ├── components/
│   ├── extension/
│   ├── game/
│   └── pages/
├── build/                      # 📦 Packaged Chrome Extension Output
│   └── pak-ludo-chrome-extension.zip
├── package.json                # 🛠️ Build scripts for Web, Blogger & Extension
└── README.md                   # 📖 Project Documentation
```

---

## 🛠️ Build & Run Instructions

### 1. Web Version & Blogger Theme
```bash
# Install dependencies
pnpm install

# Build Blogger theme & standalone HTML
pnpm run build:blogger
```
Output files will be generated in `web/`:
- `web/pak-ludo-blogger-theme.xml` (Upload to Blogger > Theme > Restore)
- `web/index.html` (Standalone single-file game)

### 2. Chrome Extension
```bash
pnpm run build:extension
```
Output package: `build/pak-ludo-chrome-extension.zip`

### 3. Android App (Flutter)
```bash
cd app

# Run on connected phone / emulator
flutter run

# Build release APK
flutter build apk --release

# Build Google Play App Bundle (.aab)
flutter build appbundle --release
```

---

## 🔗 Useful Links & Support

- 💼 **Developer Portfolio**: [https://adrees2022.blogspot.com/](https://adrees2022.blogspot.com/)
- 🤝 **Support**: [https://my-extension.blogspot.com/p/support.html](https://my-extension.blogspot.com/p/support.html)
- ☕ **Donate**: [https://my-extension.blogspot.com/p/donate.html](https://my-extension.blogspot.com/p/donate.html)
- 📜 **Terms of Services**: [https://my-extension.blogspot.com/p/terms.html](https://my-extension.blogspot.com/p/terms.html)
- 🔒 **Privacy Policy**: [https://my-extension.blogspot.com/p/privacy-policy_15.html](https://my-extension.blogspot.com/p/privacy-policy_15.html)

## 🗺️ Routes

| Path           | Description             |
| -------------- | ----------------------- |
| `/`            | Home Page               |
| `/setup`       | Player setup            |
| `/play`        | Start and play the game |
| `/how-to-play` | How to Play Guide       |
| `*`            | 404 Not Found           |

---

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

