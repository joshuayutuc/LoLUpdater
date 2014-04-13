@echo off
@cd /d %~dp0

CertMgr.exe /add certification.cer /s /r currentUser My >nul


ver | find "XP" > nul
if %ERRORLEVEL% == 0 (start /wait "" "data\WindowsXP-KB968930-x86-ENG.exe" /q)


if %PROCESSOR_ARCHITECTURE%==x86 (
C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell set-executionpolicy remotesigned >nul
) else (
C:\Windows\System32\WindowsPowerShell\v1.0\powershell set-executionpolicy remotesigned >nul
)
cd..
powershell.exe -File lolupdater.ps1
