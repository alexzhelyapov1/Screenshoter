### Instructions
- Start program: `ctrl+shift+]`
- Take screenshot: `ctrl+shift+'`
- Close program: `ctrl+shift+,`

Screenshots you can find in `C:\SS` wich is shared in local net via `install.ps1`.
**Note:** do not delete `steam.lnk` from Desctop, it allows start up via hotkeys.


### Install
Run powershell as Admin
```bash
# cd release dir
powershell.exe -ExecutionPolicy Bypass -File .\install.ps1
```

### Uninstall
Run powershell as Admin
```bash
# cd release dir
powershell.exe -ExecutionPolicy Bypass -File .\uninstall.ps1
```