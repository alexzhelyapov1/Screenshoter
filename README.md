### Instructions
- Start program: `ctrl+shift+]`
- Take screenshot: `ctrl+shift+'`
- Close program: `ctrl+shift+,`

Screenshots you can find in `C:\SS` wich is shared in local net via `install.ps1`.

#### Start via hotkeys
1) Do not delete `steam.lnk` from Desktop, it allows start up via hotkeys.
2) If doesn't work -> right click on `steam.lnk` -> shange shortcut key to another.


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