@echo off
@cd /d %~dp0
@enabledelayedexpansion

ver | find "XP" > nul
if %ERRORLEVEL% == 0 (start /wait "" "WindowsXP-KB968930-x86-ENG.exe" /quiet)

cd..

if %PROCESSOR_ARCHITECTURE%==x86 (
C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe -SetexecutionPolicy Bypass -File script.ps1
) else (
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -SetexecutionPolicy Bypass -File script.ps1
)
