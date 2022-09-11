# Dichromate Windows Sandbox

Dichromate can integrate with Windows Sandbox to provide a more secure browsing experience.

# Requirements

Windows Sandbox is only available on Windows 10/11 Pro, Enterprise, and Education. Windows Home users are out of luck. 

To enable Windows Sandbox, run: 
```
PS> Enable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online
```
Another option is to type "Turn Windows Features on or off" in the search bar to access the Windows Optional Features tool, then select Windows Sandbox and then OK. <br>
You may need to restart your computer.

# Installation
```
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/NuclearDevelopers/Dichromate-Windows-Sandbox/main/setup.ps1)
```
It does **not** require administrative privilege. 

The script can also be downloaded and run manually, but it still requires an internet connection to download the source code.

# Usage

The installer creates a desktop shortcut and a start menu shortcut. When run, it launches an instance of Dichromate inside Windows Sandbox. 

The downloads folder in the sandbox is mapped to C:\Users\<your username>\Downloads\Untrusted Files.

# Uninstall 
Simply download the script and run:
```
.\setup.ps1 uninstall
```

A one command solution like the install script is coming soon.