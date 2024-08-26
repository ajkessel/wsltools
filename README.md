## Background
[wsl-wrapper](wsl-wrapper) allows you to execute Windows commands in WSL with proper pathname parsing.

For example, if notepad.exe is in your path, with this solution, you can execute:
```
notepad.exe ~/readme.txt
```
...causing notepad to open and correctly find readme.txt in your WSL home directory, rather than throw an error because it doesn't know about `~`.

This wrapper should also allowed you to specify a number of parameters, including command-line switches and multiple filenames, for example:
```
gvim.exe -o ~/file1.txt ~/path/file2.txt
```
This should open the Windows gvim.exe executable with a split-pane view and both file1.txt and file2.txt from your WSL home directory open.
## Installation
* Make sure you have these lines in `/etc/wsl.conf`:
```
[interop]
enabled=true
appendWindowsPath=false
```
* Copy [wsl.conf](wsl.conf) from this repository to /etc/binfmt.d
* Copy [wsl-wrapper](wsl-wrapper) to /usr/local/bin
* Restart your WSL instance (e.g. `wsl --shutdown` from PowerShell)
## wslshim 
[wslshim](wslshim) is a script that will symlink a Windows executable into ~/.local/bin without the filename exetnsion. So, for example, if you run:
```
wslshim notepad
```
...it will locate notepad.exe and create a symlink to it in ~/.local/bin/notepad.

You can optionally use wslshim to map filename arguments to the executable, similar to the wrapper method above, by specifying `-f` with the invocation. But the [wsl-wrapper](wsl-wrapper) method renders that unnecessary.
