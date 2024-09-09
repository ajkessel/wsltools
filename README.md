## Quickstart
Just clone this repository (`git clone https://github.com/ajkessel/wsltools.git`) and then run [install.sh](install.sh) as root.
## Background
[wsl-wrapper](wsl-wrapper) allows you to execute Windows commands in WSL with proper pathname parsing.

For example, if notepad.exe is in your path, with this solution, you can execute:
```
notepad.exe ~/readme.txt
```
...causing notepad to open and correctly find `readme.txt` in your WSL home directory, rather than throw an error because it doesn't know about `~`.

This wrapper should also allow you to specify a number of parameters, including command-line switches and multiple filenames, for example:
```
gvim.exe -o ~/file1.txt ~/path/file2.txt
```
This should open the Windows `gvim.exe` executable with a split-pane view and both `file1.txt` and `path/file2.txt` from your WSL home directory open.
## Installation
* First, make sure you have these lines in `/etc/wsl.conf`, as described in [https://learn.microsoft.com/en-us/windows/wsl/wsl-config](https://learn.microsoft.com/en-us/windows/wsl/wsl-config):
```
[interop]
enabled=true
appendWindowsPath=false
```
* Copy [wsl.conf](wsl.conf) from this repository to `/etc/binfmt.d`
* Copy [wsl-wrapper](wsl-wrapper) to `/usr/local/bin`
* Make sure the file is world-readable/executable (`chmod a+rx /usr/local/bin/wsl-wrapper`)
* Reload binfmt configuration (either `sudo systemctl restart systemd-binfmt` or just restart WSL instance `wsl --shutdown` from PowerShell)
## PowerShell
You can use this same technique to make PowerShell scripts executable just from their filenames in WSL with the wrapper [powershell-wrapper](powershell-wrapper). Follow these steps:
* Copy [powershell.conf](powershell.conf) to `/etc/binfmt.d`
* Copy [powershell-wrapper](powershell-wrapper) to `/usr/local/bin/`
* Make sure the file is world-readable/executable (`chmod a+rx /usr/local/bin/powershell-wrapper`)
* Reload binfmt or restart WSL

You should then be able to execute a PowerShell just by name (e.g., `~/myscript.ps1 argument1 argument2`) and it will work from WSL.

As currently implemented, the PowerShell wrapper does its best to find a Windows PowerShell executable, and if that fails, it tries to find a PowerShell executable. Feel free to hardcode `$powerExe` in the script with your path preference.
## Office
Same deal with Microsoft Office files via [office-wrapper](office-wrapper). Follow these steps:
* Copy [office.conf](office.conf) to `/etc/binfmt.d`
* Copy [office-wrapper](office-wrapper) to `/usr/local/bin/`
* Make sure the file is world-readable/executable (`chmod a+rx /usr/local/bin/office-wrapper`)
* Reload binfmt or restart WSL

You should then be able to open a Microsoft Office document just by name (e.g., `~/docs/mydocument.docx` or `/mnt/c/documents/myspreadsheet.xlsx`) and it will work from WSL.
## wslshim 
[wslshim](wslshim) is a script that will symlink a Windows executable into ~/.local/bin without the filename extension. So, for example, if you run:
```
wslshim notepad
```
...it will locate notepad.exe and create a symlink to it in ~/.local/bin/notepad.

You can optionally use wslshim to map filename arguments to the executable, similar to the wrapper method above, by specifying `-f` with the invocation. But the [wsl-wrapper](wsl-wrapper) method renders that unnecessary.
## Troubleshooting
If you see this message in `/var/log/syslog`:
```
systemd[1]: systemd-binfmt.service - Set Up Additional Binary Formats was skipped because of an unmet condition check (ConditionVirtualization=!wsl).
```
You can fix it by removing `/usr/lib/systemd/system/systemd-binfmt.service.d/wsl.conf` (or commenting out the ConditionVirtualization line therein), and then restart WSL.

I have filed [an issue on WSL](https://github.com/microsoft/WSL/issues/12013) to try to figure out what's going on with that as it only recently started happening.
## TODO
If there is enough interest in this, I may package it up as a Debian/Ubuntu package for easier installation.
