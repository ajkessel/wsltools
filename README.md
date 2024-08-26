## Background
These tools allow you to execute Windows commands in WSL with proper pathname parsing.

For example, if notepad.exe is in your path, you could execute:
```
notepad.exe ~/readme.txt
```
Causing notepad to open and correctly find readme.txt in your WSL home directory.
## Installation
* Make sure you have these lines in `/etc/wsl.conf`:
```
[interop]
enabled=true
appendWindowsPath=false
```
* Copy wsl.conf from this repository to /etc/binfmt.d
* wsl-wrapper to /usr/local/bin
* Restart your WSL install
