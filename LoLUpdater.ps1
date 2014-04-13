﻿function Set-WindowTitle($text)

{

$Host.UI.RawUI.WindowTitle = $text

}
$sScriptVersion = "Beta 1"
Set-Alias title Set-WindowTitle
title "LoLTweaker $sScriptVersion"
$dir = Split-Path -parent $MyInvocation.MyCommand.Definition
$ErrorActionPreference = "SilentlyContinue"

$sLogPath = "$dir"
$sLogName = "errorlog.log"
$sLogFile = $sLogPath + "\" + $sLogName

pop-location
push-location "$dir\RADS\solutions\lol_game_client_sln\releases"
$sln = gci | ? { $_.PSIsContainer } | sort CreationTime -desc | select -f 1

pop-location
push-location "$dir\RADS\projects\lol_launcher\releases"
$launch = gci | ? { $_.PSIsContainer } | sort CreationTime -desc | select -f 1

pop-location
push-location "$dir\RADS\projects\lol_air_client\releases"
$air = gci | ? { $_.PSIsContainer } | sort CreationTime -desc | select -f 1

cd $dir

New-Item -ItemType directory -Path $dir\Backup
Write-Host "Backing up and updating..."
Copy-Item "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy\dbghelp.dll" "Backup"
Copy-Item "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy\tbb.dll" "Backup"
Copy-Item "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy\BsSndRpt.exe" "Backup"
Copy-Item "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy\BugSplat.dll" "Backup"
Copy-Item "$dir\RADS\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0\Adobe Air.dll" "Backup"
Copy-Item "$dir\RADS\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0\resources\NPSWF32.dll" "Backup"
Copy-Item "$dir\RADS\projects\lol_launcher\releases\$launch\deploy\cg.dll" "Backup"
Copy-Item "$dir\RADS\projects\lol_launcher\releases\$launch\deploy\cgD3D9.dll" "Backup"
Copy-Item "$dir\RADS\projects\lol_launcher\releases\$launch\deploy\cggl.dll" "Backup"
start-process .\data\dxwebsetup.exe /q

Function Log-Start{

[CmdletBinding()]
Param ([Parameter(Mandatory=$true)][string]$LogPath, [Parameter(Mandatory=$true)][string]$LogName, [Parameter(Mandatory=$true)][string]$ScriptVersion)
Process{
$sFullPath = $LogPath + "\" + $LogName
If((Test-Path -Path $sFullPath)){
Remove-Item -Path $sFullPath -Force
}
New-Item -Path $LogPath -Name $LogName –ItemType File
Add-Content $sFullPath "***************************************************************************************************"
Add-Content $sFullPath "Started processing at [$([DateTime]::Now)]."
Add-Content $sFullPath "***************************************************************************************************"
Add-Content $sFullPath ""
Add-Content $sFullPath "Running script version [$ScriptVersion]."
Add-Content $sFullPath ""
Add-Content $sFullPath "***************************************************************************************************"
Add-Content $sFullPath ""
}
}

Function Log-Error{

[CmdletBinding()]
Param ([Parameter(Mandatory=$true)][string]$LogPath, [Parameter(Mandatory=$true)][string]$ErrorDesc, [Parameter(Mandatory=$true)][boolean]$ExitGracefully)
Process{
Add-Content -Path $LogPath -Value "Error: An error has occurred [$ErrorDesc]."

If ($ExitGracefully -eq $True){
Log-Finish -LogPath $LogPath
Break
}
}
}
 
Function Log-Finish{

[CmdletBinding()]
Param ([Parameter(Mandatory=$true)][string]$LogPath, [Parameter(Mandatory=$false)][string]$NoExit)
Process{
Add-Content $LogPath ""
Add-Content $LogPath "***************************************************************************************************"
Add-Content $LogPath "Finished processing at [$([DateTime]::Now)]."
Add-Content $LogPath "***************************************************************************************************"


If(!($NoExit) -or ($NoExit -eq $False)){
Exit
}
}
}

Function restore {
Write-Host "Restoring..."
Copy-ISet-AuthenticodeSignature C:\Users\Loggan\Documents\GitHub\LoLUpdater\lolupdater.ps1 @(Get-ChildItem cert:\CurrentUser\My -codesigning)[0] -timestampserver http://timestamp.comodoca.com/authenticodetem "backup\dbghelp.dll" "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "backup\cg.dll" "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "backup\cgD3D9.dll" "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "backup\cggl.dll" "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "backup\tbb.dll" "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "backup\BsSndRpt.exe" "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "backup\BugSplat.dll" "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "backup\Adobe Air.dll" "$dir\RADS\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0"
Copy-Item "backup\NPSWF32.dll" "$dir\RADS\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0\resources"
Copy-Item "backup\cg.dll" "$dir\RADS\projects\lol_launcher\releases\$launch\deploy"
Copy-Item "backup\cgD3D9.dll" "$dir\RADS\projects\lol_launcher\releases\$launch\deploy"
Copy-Item "backup\cggl.dll" "$dir\RADS\projects\lol_launcher\releases\$launch\deploy"
Read-host -prompt "LoLTweaks finished!"
exit
}

Function patch{
Param()
Process{
Try{
Log-Start -LogPath $sLogPath -LogName $sLogName -ScriptVersion $sScriptVersion
Write-Host "Closing League of Legends..."
stop-process -processname LoLLauncher
stop-process -processname LoLClient
stop-process -processname "League of Legends"
cls
Write-Host "Downloading files..."
import-module bitstransfer
Start-BitsTransfer http://developer.download.nvidia.com/cg/Cg_3.1/Cg-3.1_April2012_Setup.exe
cls
Write-Host "Copying files..."
start-process .\Cg-3.1_April2012_Setup.exe /silent -Windowstyle Hidden -wait
Copy-Item "data\BsSndRpt.exe" "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "data\BugSplat.dll" "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "data\dbghelp.dll" "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "data\tbb.dll" "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "data\NPSWF32.dll" "$dir\RADS\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0\Resources"
Copy-Item "data\Adobe AIR.dll" "$dir\RADS\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0"


if($env:PROCESSOR_ARCHITECTURE -eq "AMD64")
    {
Copy-Item "${env:programfiles(x86)}\NVIDIA Corporation\Cg\bin\cg.dll" "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "${env:programfiles(x86)}\NVIDIA Corporation\Cg\bin\cgD3D9.dll" "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "${env:programfiles(x86)}\NVIDIA Corporation\Cg\bin\cggl.dll" "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "${env:programfiles(x86)}\NVIDIA Corporation\Cg\bin\cg.dll" "$dir\RADS\projects\lol_launcher\releases\$launch\deploy"
Copy-Item "${env:programfiles(x86)}\NVIDIA Corporation\Cg\bin\cgD3D9.dll" "$dir\RADS\projects\lol_launcher\releases\$launch\deploy"
Copy-Item "${env:programfiles(x86)}\NVIDIA Corporation\Cg\bin\cggl.dll" "$dir\RADS\projects\lol_launcher\releases\$launch\deploy"
    }
    else
    {
Copy-Item "$env:programfiles\NVIDIA Corporation\Cg\bin\cg.dll" "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "$env:programfiles\NVIDIA Corporation\Cg\bin\cgD3D9.dll" "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "$env:programfiles\NVIDIA Corporation\Cg\bin\cggl.dll" "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "$env:programfiles\NVIDIA Corporation\Cg\bin\cg.dll" "$dir\RADS\projects\lol_launcher\releases\$launch\deploy"
Copy-Item "$env:programfiles\NVIDIA Corporation\Cg\bin\cgD3D9.dll" "$dir\RADS\projects\lol_launcher\releases\$launch\deploy"
Copy-Item "$env:programfiles\NVIDIA Corporation\Cg\bin\cggl.dll" "$dir\RADS\projects\lol_launcher\releases\$launch\deploy"

    }
    cls
Write-Host "Cleaning up..."
if ((Test-Path -path "${Env:ProgramFiles(x86)}\NVIDIA Corporation\Cg\unins000.exe"))
{ start-process "${Env:ProgramFiles(x86)}\NVIDIA Corporation\Cg\unins000.exe"
}
if ((Test-Path -path "${Env:ProgramFiles}\NVIDIA Corporation\Cg\unins000.exe"))
{ start-process "${Env:ProgramFiles}\NVIDIA Corporation\Cg\unins000.exe"
}
$key = (Get-ItemProperty "HKLM:\HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Pando Networks\PMB")."program directory"

if ((Test-Path -path $key\uninst.exe))
{ start-process "$key\uninst.exe"
}

Write-Host "Starting LoL-Launcher..."
start-process lol.launcher.exe
cls
Write-Host "#              #       #######"
Write-Host "#        ####  #          #    #    # ######   ##   #    #  ####"
Write-Host "#       #    # #          #    #    # #       #  #  #   #  #"
Write-Host "#       #    # #          #    #    # #####  #    # ####    ####"
Write-Host "#       #    # #          #    # ## # #      ###### #  #        #"
Write-Host "#       #    # #          #    ##  ## #      #    # #   #  #    #"
Write-Host "#######  ####  #######    #    #    # ###### #    # #    #  ####"
Write-Host ""
Read-host -prompt "LoLTweaks finished!"

Log-Finish -LogPath $sLogFile
}
Catch{
$sError = $Error[0] | Out-String
Log-Error -LogPath $sLogFile -ErrorDesc $sError -ExitGracefully $True
Break
}
}
}


cls
$message = "Do you want to patch or restore LoL to it's original state?"

$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&patch"

$no = New-Object System.Management.Automation.Host.ChoiceDescription "&restore"

$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)

$result = $host.ui.PromptForChoice($title, $message, $options, 0)

switch ($result)
    {
        0 {patch}
        1 {restore}
    }
# SIG # Begin signature block
# MIILEgYJKoZIhvcNAQcCoIILAzCCCv8CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUee1zlYdBKvyHn1o8jkubArfv
# ZJigggbUMIICOTCCAaagAwIBAgIQuz5MB7mTK6tAf7h69wy1FzAJBgUrDgMCHQUA
# MCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdDAe
# Fw0xNDA0MTMxMDQ3MjVaFw0zOTEyMzEyMzU5NTlaMBoxGDAWBgNVBAMTD1Bvd2Vy
# U2hlbGwgVXNlcjCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAnDcQGjgvRfXF
# saFpgq3ZbtOotU0LsxvZ1/wk5L6gFQHNp06BOvAZRGC9l9h+Uj0EpLqoWH4OGdBI
# l3Sv63+nYbqAYe58zmehGXS6hFfuTogAeSxve+FwCLnP6pOVeDsb7q9LIPiuHKl7
# /8Tw+hnV7MO+9fuLlo59bW7DTtDx178CAwEAAaN2MHQwEwYDVR0lBAwwCgYIKwYB
# BQUHAwMwXQYDVR0BBFYwVIAQ5nF8jrl4ebXAMucz3ni5waEuMCwxKjAoBgNVBAMT
# IVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdIIQqwCmAC9r/Y5C3K8z
# jqJqSTAJBgUrDgMCHQUAA4GBACqQ31ANvxuhuYx7At26XlF8bSFp6Q9AjQEQwiyH
# lJdwJVLZpjsjF+4BMfcPpa8XX43ORjuq7XQcJgmZZ+O/HbPE1gymprICTJ1GqKzZ
# EoZtRVXW4UMAWqBpLUUkYDv3wr8IDuOpYKEnI7Eg30C1aVEMRWihkZvcDPoIWpLm
# oWhCMIIEkzCCA3ugAwIBAgIQR4qO+1nh2D8M4ULSoocHvjANBgkqhkiG9w0BAQUF
# ADCBlTELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAlVUMRcwFQYDVQQHEw5TYWx0IExh
# a2UgQ2l0eTEeMBwGA1UEChMVVGhlIFVTRVJUUlVTVCBOZXR3b3JrMSEwHwYDVQQL
# ExhodHRwOi8vd3d3LnVzZXJ0cnVzdC5jb20xHTAbBgNVBAMTFFVUTi1VU0VSRmly
# c3QtT2JqZWN0MB4XDTEwMDUxMDAwMDAwMFoXDTE1MDUxMDIzNTk1OVowfjELMAkG
# A1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMH
# U2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxJDAiBgNVBAMTG0NP
# TU9ETyBUaW1lIFN0YW1waW5nIFNpZ25lcjCCASIwDQYJKoZIhvcNAQEBBQADggEP
# ADCCAQoCggEBALw1oDZwIoERw7KDudMoxjbNJWupe7Ic9ptRnO819O0Ijl44CPh3
# PApC4PNw3KPXyvVMC8//IpwKfmjWCaIqhHumnbSpwTPi7x8XSMo6zUbmxap3veN3
# mvpHU0AoWUOT8aSB6u+AtU+nCM66brzKdgyXZFmGJLs9gpCoVbGS06CnBayfUyUI
# EEeZzZjeaOW0UHijrwHMWUNY5HZufqzH4p4fT7BHLcgMo0kngHWMuwaRZQ+Qm/S6
# 0YHIXGrsFOklCb8jFvSVRkBAIbuDlv2GH3rIDRCOovgZB1h/n703AmDypOmdRD8w
# BeSncJlRmugX8VXKsmGJZUanavJYRn6qoAcCAwEAAaOB9DCB8TAfBgNVHSMEGDAW
# gBTa7WR0FJwUPKvdmam9WyhNizzJ2DAdBgNVHQ4EFgQULi2wCkRK04fAAgfOl31Q
# YiD9D4MwDgYDVR0PAQH/BAQDAgbAMAwGA1UdEwEB/wQCMAAwFgYDVR0lAQH/BAww
# CgYIKwYBBQUHAwgwQgYDVR0fBDswOTA3oDWgM4YxaHR0cDovL2NybC51c2VydHJ1
# c3QuY29tL1VUTi1VU0VSRmlyc3QtT2JqZWN0LmNybDA1BggrBgEFBQcBAQQpMCcw
# JQYIKwYBBQUHMAGGGWh0dHA6Ly9vY3NwLnVzZXJ0cnVzdC5jb20wDQYJKoZIhvcN
# AQEFBQADggEBAMj7Y/gLdXUsOvHyE6cttqManK0BB9M0jnfgwm6uAl1IT6TSIbY2
# /So1Q3xr34CHCxXwdjIAtM61Z6QvLyAbnFSegz8fXxSVYoIPIkEiH3Cz8/dC3mxR
# zUv4IaybO4yx5eYoj84qivmqUk2MW3e6TVpY27tqBMxSHp3iKDcOu+cOkcf42/GB
# mOvNN7MOq2XTYuw6pXbrE6g1k8kuCgHswOjMPX626+LB7NMUkoJmh1Dc/VCXrLNK
# dnMGxIYROrNfQwRSb+qz0HQ2TMrxG3mEN3BjrXS5qg7zmLCGCOvb4B+MEPI5ZJuu
# TwoskopPGLWR5Y0ak18frvGm8C6X0NL2KzwxggOoMIIDpAIBATBAMCwxKjAoBgNV
# BAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdAIQuz5MB7mTK6tA
# f7h69wy1FzAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZ
# BgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYB
# BAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUKDxqxPEqqEaGvp1dtHTZXVEss5gwDQYJ
# KoZIhvcNAQEBBQAEgYA1YwK0wKR5VesDJ4amhoQtq1WtlkGKZevy+/L6mwbnBsY7
# KyEogsqTEcIVbOlUnfgRhedbSJMbS26ws9sw5PBl5V7qq6IXpoHNLuLvrw57NaYh
# w2j04YAU8DWoetLb0rYsK3cclyKpcBPp1pNCzKWCPBKgbm6nHV2cY3ITbNPoTqGC
# AkQwggJABgkqhkiG9w0BCQYxggIxMIICLQIBADCBqjCBlTELMAkGA1UEBhMCVVMx
# CzAJBgNVBAgTAlVUMRcwFQYDVQQHEw5TYWx0IExha2UgQ2l0eTEeMBwGA1UEChMV
# VGhlIFVTRVJUUlVTVCBOZXR3b3JrMSEwHwYDVQQLExhodHRwOi8vd3d3LnVzZXJ0
# cnVzdC5jb20xHTAbBgNVBAMTFFVUTi1VU0VSRmlyc3QtT2JqZWN0AhBHio77WeHY
# PwzhQtKihwe+MAkGBSsOAwIaBQCgXTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcB
# MBwGCSqGSIb3DQEJBTEPFw0xNDA0MTMxMDU2NTFaMCMGCSqGSIb3DQEJBDEWBBQ7
# oU/VgBvHBH/s9Hq0KnrkQQF/3DANBgkqhkiG9w0BAQEFAASCAQBqVtDd0n9JqD52
# qeONBEGYUlnP7FoJfOavGsE5WMuXvLUSTPObNmc6JHClJY0E9wtWQ65jd5dvUHsr
# GwNwO/SIqCxmqN3QlRKBCQPkOIba6Ijgxf1xlhG1H+igzTbNeeCVcSEPG8cfZ/QY
# QxvRQKvgdUv9hgMD9TbBrurQ6TRErXZTgsgnp++QEwTzh1koh0BMepNJ0lUCXfjs
# GhKzcdZ43zOtijD5jhqitL+mKaa7W8Sz0FFszDE1bzmlDyIPtIcJ4lIyS5NtOsDB
# jkwr1fw7kI23DFo9Sa9jC+AhYtB8pjVJJJyj/obPjf2dUWxraofKa2tYfWj2KhHM
# 36jTEuyQ
# SIG # End signature block
