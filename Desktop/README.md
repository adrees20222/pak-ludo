# 💻 Pak Ludo - Windows Desktop (C# .NET 8.0 WPF)

Pure native Windows desktop application for **Pak Ludo** built using **C# .NET 8.0 WPF** with zero external dependencies, accompanied by an Inno Setup installer.

---

## ✨ Key Highlights

- 🎨 **Pakistani Emerald Green Theme** (`#01411C`, `#0D6E38`) with high-contrast light mode board.
- ⚡ **Zero 3rd-Party Dependencies**: Pure native WPF Direct2D/Direct3D vector rendering with sub-millisecond dispatching.
- 🔊 **Built-in PCM Sound Engine**: Real-time sound synthesis for dice rattle, token moves, capture strikes, safe star chimes, and victory fanfare.
- 🤖 **Smart AI Bots & Local Multiplayer**: 2, 3, or 4 player match configurations.
- 📦 **Inno Setup Installer**: Creates clean `PakLudo-Setup-v1.0.1.exe` with Desktop & Start Menu shortcuts.

---

## 📁 Directory Structure

```text
Desktop/
├── Controls/                   # WPF UI Controls (LudoBoard, Dice, Tokens, Victory Dialog)
├── Game/                       # Core Game Engine, PathData, BotAi & SoundManager
├── Models/                     # Player, Token, Coordinate & Color models
├── Views/                      # Screens (Home, Player Setup, Game, How to Play)
├── Resources/                  # High-res app icons (.ico, .png)
├── installer/
│   ├── setup.iss               # Inno Setup 6 compiler configuration
│   └── output/                 # Generated Windows Installer (.exe)
├── PakLudo.csproj              # .NET 8.0 WPF project definition
├── build-installer.ps1         # One-click release builder & installer compiler
└── README.md                   # Documentation
```

---

## 🛠️ Build & Run Instructions

### Run in Debug Mode:
```powershell
dotnet run --project Desktop\PakLudo.csproj
```

### Build Inno Setup Installer:
Run the automated build script:
```powershell
powershell -ExecutionPolicy Bypass -File Desktop\build-installer.ps1
```
Output: `Desktop\installer\output\PakLudo-Setup-v1.0.1.exe`
