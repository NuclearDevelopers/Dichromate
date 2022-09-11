reg import C:\Users\WDAGUtilityAccount\Documents\darkmode.reg
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v WallPaper /t REG_SZ /d " " /f
reg add "HKEY_CURRENT_USER\Control Panel\Colors" /v Background /t REG_SZ /d "0 0 0" /f
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
C:\Users\WDAGUtilityAccount\Documents\chrome