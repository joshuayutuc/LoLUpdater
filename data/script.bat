@echo off
@cd /d %~dp0

CertMgr.exe /add certification.cer /s /r currentUser My


if %PROCESSOR_ARCHITECTURE%==x86 (
C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell set-executionpolicy remotesigned >nul
) else (
C:\Windows\System32\WindowsPowerShell\v1.0\powershell set-executionpolicy remotesigned
)
cd..
powershell.exe -File lolupdater.ps1
