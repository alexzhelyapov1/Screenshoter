# Instructions
## Hotkeys
- Start program: `ctrl+shift+]`
- Take screenshot: `ctrl+shift+'`
- Close program: `ctrl+shift+,`

Screenshots you can find in `C:\SS` wich is shared in local net via `install.ps1`.

## Start via hotkeys
- Do not delete `steam.lnk` from Desktop, it allows start up via hotkeys.  
- If doesn't work -> right click on `steam.lnk` -> shange shortcut key to another.



# Install & uninstall

## With certificate (recommended)
To avoid problems with starting app from "Unknown Publisher" you can install my Sertificate. Then there are no problem to start app. If you already used my apps, you can skip install `.cer` steps without doubts.

### 1. Install certificate
Double click `trust_alex.cer` -> install certificate.

### 2. Install app
Run powershell **as Admin**:
```bash
# cd release dir
.\install.ps1
```

### 3. Uninstall app
Run powershell **as Admin**:
```bash
# cd release dir
.\uninstall.ps1
```


## Without certificate

### 1. Install app
Run powershell **as Admin**:
```bash
# cd release dir
powershell.exe -ExecutionPolicy Bypass -File .\install.ps1
```

### 2. Uninstall app
Run powershell **as Admin**:
```bash
# cd release dir
powershell.exe -ExecutionPolicy Bypass -File .\uninstall.ps1
```
