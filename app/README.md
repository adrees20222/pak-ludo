# 📱 Pak Ludo - Android App (Flutter)

Native Android mobile implementation of **Pak Ludo** built with Flutter and Kotlin SoundPool.

---

## 🚀 Features

- 🎨 **Pakistani Emerald Green Theme** with clean light mode high-contrast board.
- 🔊 **Zero-Latency Audio Engine**: Built with Android native `SoundPool` for instant dice rattle, token moves, capture strikes, star chimes, and victory fanfare.
- 🤖 **Smart AI Bots & Offline Pass-and-Play**: 2 to 4 player local multiplayer.
- 📱 **Adaptive UI**: Optimized for all phone and tablet screen dimensions.
- 🔗 **Direct External Link Redirection**: Built-in support for Web, Chrome Extension, Portfolio, and Policy links via `url_launcher`.

---

## 🛠️ Build & Development Instructions

### Prerequisites
- Flutter SDK (>= 3.7.0)
- Android SDK (API 34) & Android Studio

### Run Locally
```bash
flutter pub get
flutter run
```

### Build Production Release APK
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### Build Google Play App Bundle (AAB)
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`
