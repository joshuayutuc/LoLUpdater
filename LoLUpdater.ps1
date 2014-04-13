function Set-WindowTitle($text)

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
# ZJigggbUMIICOTCCAaagAwIBAgIQiwcB01J83rxHjUY4efdQ2TAJBgUrDgMCHQUA
# MCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdDAe
# Fw0xNDA0MTMxMjQzMThaFw0zOTEyMzEyMzU5NTlaMBoxGDAWBgNVBAMTD1Bvd2Vy
# U2hlbGwgVXNlcjCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAyPsNvkcv/OeR
# atd5it7H7CdTOfYOFhIo0YAlNxd5tKiNhTVClAUkao/aVvsRyAK+XgtSqm9l18Ip
# nPh9MB5cs1xmt0sga9qebBhNAaMvAcgIozDuFjRGSJ/cQnO63fEfnL5l1gacskEe
# 6DDQLgZkjTbYg5Oytua1fQQcUYtoSxkCAwEAAaN2MHQwEwYDVR0lBAwwCgYIKwYB
# BQUHAwMwXQYDVR0BBFYwVIAQjiKqMvKEYtquplcCwIVyE6EuMCwxKjAoBgNVBAMT
# IVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdIIQePWvYxuTS6FKdh6l
# mNLIgjAJBgUrDgMCHQUAA4GBAJLTMi6Mv0o84rXNxtckZxq8jI5g+bZ6DZLVEoqe
# lrPGNUtDtyLcsl3uEfYurl5RoDKNoHs6ldf49JxusttYr9nkBNeEwCGdHpsaISgh
# Nti2bL94TPDf0spt6UMdrJ0ktLL3VNpymnxqXHoa6KNClqH4yZmAfvi8ElNqp1pT
# GzY3MIIEkzCCA3ugAwIBAgIQR4qO+1nh2D8M4ULSoocHvjANBgkqhkiG9w0BAQUF
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
# BAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdAIQiwcB01J83rxH
# jUY4efdQ2TAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZ
# BgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYB
# BAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUKDxqxPEqqEaGvp1dtHTZXVEss5gwDQYJ
# KoZIhvcNAQEBBQAEgYAscDwy7j8BDyBNVppnhZJ7W0E0hddEtNfqIPsff9r2csO/
# RbTVGj6Il5XEK3/95n4hEErWd5+Fer+5gX7VFOie94zZjorUkrSuo9ioTvhBUSia
# gQrv6/XuDoFqkWKTUPrRc1xtWIy/BqU9OvZ8htf785i/6gMi1a8I7qHP1EDMTKGC
# AkQwggJABgkqhkiG9w0BCQYxggIxMIICLQIBADCBqjCBlTELMAkGA1UEBhMCVVMx
# CzAJBgNVBAgTAlVUMRcwFQYDVQQHEw5TYWx0IExha2UgQ2l0eTEeMBwGA1UEChMV
# VGhlIFVTRVJUUlVTVCBOZXR3b3JrMSEwHwYDVQQLExhodHRwOi8vd3d3LnVzZXJ0
# cnVzdC5jb20xHTAbBgNVBAMTFFVUTi1VU0VSRmlyc3QtT2JqZWN0AhBHio77WeHY
# PwzhQtKihwe+MAkGBSsOAwIaBQCgXTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcB
# MBwGCSqGSIb3DQEJBTEPFw0xNDA0MTMxMjU4MDhaMCMGCSqGSIb3DQEJBDEWBBQu
# xtURIN27M5lnFBT7KcIhPjszvTANBgkqhkiG9w0BAQEFAASCAQCUQCYEcTI+79Rx
# 4GaGL2z7Yq2zuDVwUeIUnuVbUMqBEORy5XAE3t1zLep6C9PNBX2UNYcNlMo9WImF
# M+T3ykd08LPXYlMSqaiWBcNbMHAdjRNjx5Tj9lUaeljqJpulkYlWT9im4+wKSIfC
# dndGKFC769lVkWC59RCyWGZ6sW7u1U1lr1M4kV3sUKoXi12gQF9Kd1SsJ5L2s5AX
# fQNeLUJnV34+Z/K5shF5N3w81lUBFI7KwKhxGMrKvoLdH0WvCNyuz+yb6Tvs7wn2
# 94KaLh26a1He5fGWsHm+CO83yPnXCWqxIpC2sQ8tNl8iDeLX0B8plXDLhdHtm/+7
# iFVLvyC8
# SIG # End signature block
