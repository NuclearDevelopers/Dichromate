$ErrorActionPreference = "Stop"

$installpath = "C:\Users\$env:USERNAME\AppData\Local\Dichromate\Application"
$untrustedpath = "C:\Users\$env:USERNAME\Downloads\Untrusted Files"

$uninstall = $args[0]

if ($uninstall -eq "uninstall") {
    $confirmremoval = Read-Host -Prompt "Do you want to uninstall the Windows Sandbox addon for Dichromate(Y/N)"
    if (($confirmremoval -eq "Y") -or ($confirmremoval -eq "y")) {
        Write-Host "Uninstalling Windows Sandbox Addon... " -NoNewline
        Remove-Item (Join-Path $installpath dichromate.wsb) -ErrorAction SilentlyContinue
        Remove-Item (Join-Path $installpath darkmode.reg) -ErrorAction SilentlyContinue
        Remove-Item (Join-Path $installpath dichromate-sandbox.ico) -ErrorAction SilentlyContinue
        Remove-Item (Join-Path $installpath wallpaper.png) -ErrorAction SilentlyContinue
        Remove-Item (Join-Path $installpath login.bat) -ErrorAction SilentlyContinue
        Remove-Item "C:\Users\$env:USERNAME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Dichromate Sandbox.lnk" -ErrorAction SilentlyContinue
        Remove-Item "C:\Users\$env:USERNAME\Desktop\Dichromate Sandbox.lnk" -ErrorAction SilentlyContinue
        Write-Host "Done" -ForegroundColor Green
        Write-Host "INFO: The folder 'C:\Users\$env:USERNAME\Downloads\Untrusted Files' is kept intact." -ForegroundColor Yellow
        Write-Host "Press any key to exit..." -NoNewline
        [void][System.Console]::ReadKey($true)
        Exit
    }
    else {
        Write-Host "Cancelled uninstall." -ForegroundColor Green
        Write-Host "Press any key to exit..."
        [void][System.Console]::ReadKey($true)
        Exit
    }
}

Write-Host "Press any key to start the installation..." -NoNewline
[void][System.Console]::ReadKey($true)

Write-Host ""

Write-Host "Checking for Dichromate installation... " -NoNewline

if (!(Test-Path $installpath)) {
    Write-Host "NOT FOUND" -ForegroundColor Red
    $dichromate = Read-Host -Prompt "Do you want to install Dichromate(Y/N)"
    if (($dichromate -eq "Y") -or ($dichromate -eq "y")) {
        $originalCSV = curl.exe -s https://omahaproxy.appspot.com/all?csv=1 | ConvertFrom-Csv -Delimiter "," | Select-String "os=win; channel=stable"
        $removeWhitespace = $originalCSV -split "\s+"
        $selectVersionpart = $removeWhitespace[2]
        $removeVariable = $selectVersionpart -split "="
        $almostdone = $removeVariable[1]
        $version = $almostdone -replace ';',""
        Write-Host "Downloading the installer"
        curl.exe -O -L https://github.com/NuclearDevelopers/Dichromate/releases/download/$version/dichromate-$version.exe
        Write-Host "Running the installer"
        Start-Process dichromate-$version.exe
        Write-Host "Please re-run the setup now."
        Exit
    }
    else {
        Write-Host "Dichromate is required for this to work."
        Exit
    }
}

else {
    Write-Host "OK" -ForegroundColor Green
}

if (!(Test-Path $untrustedpath)) {
    New-Item -ItemType Directory -Path $untrustedpath | Out-Null
}

Write-Host "Copying source files... " -NoNewline

curl.exe -s -O https://raw.githubusercontent.com/NuclearDevelopers/Dichromate/main/windows-sandbox/config/dichromate-sandbox.ico
curl.exe -s -O https://raw.githubusercontent.com/NuclearDevelopers/Dichromate/main/windows-sandbox/config/dichromate.wsb
curl.exe -s -O https://raw.githubusercontent.com/NuclearDevelopers/Dichromate/main/windows-sandbox/dark-mode/darkmode.reg
curl.exe -s -O https://raw.githubusercontent.com/NuclearDevelopers/Dichromate/main/windows-sandbox/dark-mode/login.bat
curl.exe -s -O https://raw.githubusercontent.com/NuclearDevelopers/Dichromate/main/windows-sandbox/dark-mode/wallpaper.png

Copy-Item -Path dichromate.wsb -Destination $installpath -Force

Copy-Item -Path dichromate-sandbox.ico -Destination $installpath -Force

Copy-Item -Path darkmode.reg -Destination $installpath -Force

Copy-Item -Path login.bat -Destination $installpath -Force

Copy-Item -Path wallpaper.png -Destination $installpath -Force

Write-Host "Done" -ForegroundColor Green 

Write-Host "Generating a WSB file for your system... " -NoNewline

$File = Join-Path $installpath dichromate.wsb

$lineNumber = 6
$textToAdd = "          <HostFolder>$installpath</HostFolder>"
$fileContent = Get-Content $File
$fileContent[$lineNumber-1] = $textToAdd
$fileContent | Set-Content $File

$lineNumber2 = 11
$textToAdd = "          <HostFolder>$untrustedpath</HostFolder>"
$fileContent = Get-Content $File
$fileContent[$lineNumber2-1] = $textToAdd
$fileContent | Set-Content $File

$NewContent = Get-Content -Path $File |
    ForEach-Object {
        $_

        if($_ -match ('^' + [regex]::Escape("<Configuration>"))) {
            "<!--Generated by install.exe-->"
        }
    } 

$NewContent | Out-File -FilePath $File -Encoding Default -Force

Write-Host "Done" -ForegroundColor Green 

Write-Host "Adding Desktop and Start Menu shortcuts... " -NoNewline

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\Users\$env:USERNAME\Desktop\Dichromate Sandbox.lnk")
$Shortcut.TargetPath = Join-Path $installpath dichromate.wsb
$Shortcut.IconLocation = Join-Path $installpath dichromate-sandbox.ico
$Shortcut.Save()

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\Users\$env:USERNAME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Dichromate Sandbox.lnk")
$Shortcut.TargetPath = Join-Path $installpath dichromate.wsb
$Shortcut.IconLocation = Join-Path $installpath dichromate-sandbox.ico
$Shortcut.Save()

Write-Host "Done" -ForegroundColor Green 

Write-Host "Cleaning up... " -NoNewline

Remove-Item dichromate-sandbox.ico
Remove-Item dichromate.wsb
Remove-Item darkmode.reg
Remove-Item login.bat
Remove-Item wallpaper.png

Write-Host "Done" -ForegroundColor Green

Write-Host "The installation has completed successfully" -ForegroundColor Green
Write-Host "Press any key to exit..." -NoNewline
[void][System.Console]::ReadKey($true)
