; Inno Setup Script for Pak Ludo Windows Desktop
; Target: .NET 8.0 WPF Native Windows Application

#define MyAppName "Pak Ludo"
#define MyAppVersion "1.0.1"
#define MyAppPublisher "Muhammad Adrees"
#define MyAppURL "https://github.com/adrees20222/pak-ludo"
#define MyAppExeName "PakLudo.exe"

[Setup]
; App Metadata
AppId={{D37D861F-1E2B-4A73-810A-B37D82672B10}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} v{#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL="https://my-extension.blogspot.com/p/support.html"
AppUpdatesURL="https://github.com/adrees20222/pak-ludo/releases"

; Installation Directories
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
OutputDir=output
OutputBaseFilename=PakLudo-Setup-v1.0.1
SetupIconFile=..\Resources\app_icon.ico
UninstallDisplayIcon={app}\{#MyAppExeName}

; Compression & Performance
Compression=lzma2/ultra64
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64compatible

; Modern Visual Styling
WizardStyle=modern
DisableProgramGroupPage=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "..\publish\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Excludes: "*.pdb"

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
