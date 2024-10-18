# PSI Proctored Exam Preparation - Unallowed Windows App/Settings

# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# https://learn.microsoft.com/en-us/powershell/module/defender/set-mppreference?view=windowsserver2022-ps
Set-MpPreference -DisableRealtimeMonitoring $True
Get-MpPreference | Select DisableRealtime*
NetSh Advfirewall set allprofiles state off
taskkill /t /f /im GoogleDriveFS.exe
taskkill /t /f /im cloud-drive-ui.exe
taskkill /t /f /im cloud-drive-daemon.exe
taskkill /t /f /im discord.exe
wsl --shutdown
pause 30
