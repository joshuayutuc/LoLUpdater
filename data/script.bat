@echo off
@cd /d %~dp0

ver | find "XP" > nul
if %ERRORLEVEL% == 0 (start /wait "" "data\WindowsXP-KB968930-x86-ENG.exe" /quiet)

if %PROCESSOR_ARCHITECTURE%==x86 (
C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe -SetexecutionPolicy Bypass -File lolupdater.ps1
) else (
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -SetexecutionPolicy Bypass -File lolupdater.ps1
)
