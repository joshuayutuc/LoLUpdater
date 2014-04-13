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
Write-Host "Backing up..."
Copy-Item "RADS\solutions\lol_game_client_sln\releases\$sln\deploy\dbghelp.dll" "Backup"
Copy-Item "RADS\solutions\lol_game_client_sln\releases\$sln\deploy\tbb.dll" "Backup"
Copy-Item "RADS\solutions\lol_game_client_sln\releases\$sln\deploy\BsSndRpt.exe" "Backup"
Copy-Item "RADS\solutions\lol_game_client_sln\releases\$sln\deploy\BugSplat.dll" "Backup"
Copy-Item "RADS\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0\Adobe Air.dll" "Backup"
Copy-Item "RADS\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0\resources\NPSWF32.dll" "Backup"
Copy-Item "RADS\projects\lol_launcher\releases\$launch\deploy\cg.dll" "Backup"
Copy-Item "RADS\projects\lol_launcher\releases\$launch\deploy\cgD3D9.dll" "Backup"
Copy-Item "RADS\projects\lol_launcher\releases\$launch\deploy\cggl.dll" "Backup"

Function Log-Start{

[CmdletBinding()]
Param ([Parameter(Mandatory=$true)][string]$LogPath, [Parameter(Mandatory=$true)][string]$LogName, [Parameter(Mandatory=$true)][string]$ScriptVersion)
Process{
$sFullPath = $LogPath + "\" + $LogName
If((Test-Path -Path $sFullPath)){
Remove-Item -Path $sFullPath -Force
}
New-Item -Path $LogPath -Name $LogName –ItemType File
Add-Content  $sFullPath "***************************************************************************************************"
Add-Content  $sFullPath "Started processing at [$([DateTime]::Now)]."
Add-Content  $sFullPath "***************************************************************************************************"
Add-Content  $sFullPath ""
Add-Content  $sFullPath "Running script version [$ScriptVersion]."
Add-Content  $sFullPath ""
Add-Content  $sFullPath "***************************************************************************************************"
Add-Content  $sFullPath ""
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
Copy-Item "backup\dbghelp.dll" "RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "backup\cg.dll" "RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "backup\cgD3D9.dll" "RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "backup\cggl.dll" "RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "backup\tbb.dll" "RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "backup\BsSndRpt.exe" "RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "backup\BugSplat.dll" "RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "backup\Adobe Air.dll" "RADS\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0"
Copy-Item "backup\NPSWF32.dll" "RADS\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0\resources"
Copy-Item "backup\cg.dll" "RADS\projects\lol_launcher\releases\$launch\deploy"
Copy-Item "backup\cgD3D9.dll" "RADS\projects\lol_launcher\releases\$launch\deploy"
Copy-Item "backup\cggl.dll" "RADS\projects\lol_launcher\releases\$launch\deploy"
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
start-process .\data\dxwebsetup.exe /q
start-process .\Cg-3.1_April2012_Setup.exe /silent -wait
Copy-Item "data\BsSndRpt.exe" "RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "data\BugSplat.dll" "RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "data\dbghelp.dll" "RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "data\tbb.dll" "RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "data\NPSWF32.dll" "RADS\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0\resources" 
Copy-Item "data\Adobe AIR.dll" "RADS\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0" 


if($env:PROCESSOR_ARCHITECTURE -eq "AMD64")
    {
Copy-Item "${env:programfiles(x86)}\NVIDIA Corporation\Cg\bin\cg.dll" "RADS\solutions\lol_game_client_sln\releases\$sln\deploy" 
Copy-Item "${env:programfiles(x86)}\NVIDIA Corporation\Cg\bin\cgD3D9.dll" "RADS\solutions\lol_game_client_sln\releases\$sln\deploy" 
Copy-Item "${env:programfiles(x86)}\NVIDIA Corporation\Cg\bin\cggl.dll" "RADS\solutions\lol_game_client_sln\releases\$sln\deploy" 
Copy-Item "${env:programfiles(x86)}\NVIDIA Corporation\Cg\bin\cg.dll" "RADS\projects\lol_launcher\releases\$launch\deploy" 
Copy-Item "${env:programfiles(x86)}\NVIDIA Corporation\Cg\bin\cgD3D9.dll" "RADS\projects\lol_launcher\releases\$launch\deploy" 
Copy-Item "${env:programfiles(x86)}\NVIDIA Corporation\Cg\bin\cggl.dll" "RADS\projects\lol_launcher\releases\$launch\deploy" 
    }
    else
    {
Copy-Item "$env:programfiles\NVIDIA Corporation\Cg\bin\cg.dll" "RADS\solutions\lol_game_client_sln\releases\$sln\deploy" 
Copy-Item "$env:programfiles\NVIDIA Corporation\Cg\bin\cgD3D9.dll" "RADS\solutions\lol_game_client_sln\releases\$sln\deploy" 
Copy-Item "$env:programfiles\NVIDIA Corporation\Cg\bin\cggl.dll" "RADS\solutions\lol_game_client_sln\releases\$sln\deploy" 
Copy-Item "$env:programfiles\NVIDIA Corporation\Cg\bin\cg.dll" "RADS\projects\lol_launcher\releases\$launch\deploy"  
Copy-Item "$env:programfiles\NVIDIA Corporation\Cg\bin\cgD3D9.dll" "RADS\projects\lol_launcher\releases\$launch\deploy"  
Copy-Item "$env:programfiles\NVIDIA Corporation\Cg\bin\cggl.dll" "RADS\projects\lol_launcher\releases\$launch\deploy" 

    }
    cls
Write-Host "Cleaning up..."
if ((Test-Path -path "${Env:ProgramFiles(x86)}\NVIDIA Corporation\Cg\unins000.exe"))
{ start-process "${Env:ProgramFiles(x86)}\NVIDIA Corporation\Cg\unins000.exe" /silent
} 
if ((Test-Path -path "${Env:ProgramFiles}\NVIDIA Corporation\Cg\unins000.exe"))
{ start-process "${Env:ProgramFiles}\NVIDIA Corporation\Cg\unins000.exe" /silent
} 
$key = (Get-ItemProperty "HKLM:\HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Pando Networks\PMB")."program directory" 

if ((Test-Path -path $key\uninst.exe))
{ start-process "$key\uninst.exe"
}

Write-Host "Starting LoL-Launcher..."
start-process lol.launcher.exe
cls
Write-Host ""
Write-Host "#              #       #######"                                   
Write-Host "#        ####  #          #    #    # ######   ##   #    #  #### "
Write-Host "#       #    # #          #    #    # #       #  #  #   #  #    " 
Write-Host "#       #    # #          #    #    # #####  #    # ####    #### "
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
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUgBs0JMEdRGbPVzdQMgN0qHFQ
# a9OgggbUMIICOTCCAaagAwIBAgIQXAthJ5hykaRJeUI8kMiLQDAJBgUrDgMCHQUA
# MCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdDAe
# Fw0xNDA0MTMwNTE4MjVaFw0zOTEyMzEyMzU5NTlaMBoxGDAWBgNVBAMTD1Bvd2Vy
# U2hlbGwgVXNlcjCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAsCyZqFcRzjkh
# XBhHXhR4G2q0rck5OXU9j7ncGKu0n0lL7NG7R9bCB5J3MAT3DUojws+XMech6LkJ
# UmdoLAbLaePQguowiAAYvlgpzjz/EV+1MVeauIIiwFMcmjctppRFve3gJh+Rv8Bs
# jWkecRxhgBXM1pAFkrpFDwpQxozO7vUCAwEAAaN2MHQwEwYDVR0lBAwwCgYIKwYB
# BQUHAwMwXQYDVR0BBFYwVIAQ5nF8jrl4ebXAMucz3ni5waEuMCwxKjAoBgNVBAMT
# IVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdIIQeZL6qsoR9apCoaX7
# og9/QDAJBgUrDgMCHQUAA4GBAGbWwnMU+mYAIkrYA1245xfxz849gDYtAd+zXhaW
# JHJpC10ac0Ybe0YhRtYPTHhIsRCC+1qitKHrlzymLRIB0DrxASfGiuoMtyBLmAFG
# a8v8rmdsEEKEQFo2sWS4A3yvA8q3MtsCuwnlnO6eW3eTqboZo5e2FmgQmYmcs6th
# GeMBMIIEkzCCA3ugAwIBAgIQR4qO+1nh2D8M4ULSoocHvjANBgkqhkiG9w0BAQUF
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
# BAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdAIQXAthJ5hykaRJ
# eUI8kMiLQDAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZ
# BgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYB
# BAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUzSBCStKTVTmGmRa3rw0Kir8HBhwwDQYJ
# KoZIhvcNAQEBBQAEgYCM2uBbpUKq0uXzLMqNOFtIAnPvaHumqwXWsElOKXjcGSmo
# us5NGC8gTlDUPhRv0VqbgUEBy/bT8cD18A11QZbVYR/eih3Q3cOFfw2itVahSpus
# DdOP8W/Ys/N84c7hPITETRxZMSrD+830DLg8HL2ve14xMnQCmcGY8W7fusHWnaGC
# AkQwggJABgkqhkiG9w0BCQYxggIxMIICLQIBADCBqjCBlTELMAkGA1UEBhMCVVMx
# CzAJBgNVBAgTAlVUMRcwFQYDVQQHEw5TYWx0IExha2UgQ2l0eTEeMBwGA1UEChMV
# VGhlIFVTRVJUUlVTVCBOZXR3b3JrMSEwHwYDVQQLExhodHRwOi8vd3d3LnVzZXJ0
# cnVzdC5jb20xHTAbBgNVBAMTFFVUTi1VU0VSRmlyc3QtT2JqZWN0AhBHio77WeHY
# PwzhQtKihwe+MAkGBSsOAwIaBQCgXTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcB
# MBwGCSqGSIb3DQEJBTEPFw0xNDA0MTMwOTIyNTZaMCMGCSqGSIb3DQEJBDEWBBRI
# t6CD0hmy6gv+bLBc0Nsc79czyzANBgkqhkiG9w0BAQEFAASCAQASkDOPqwZ3xXGu
# WSM7GlhsbgNIIx6YGzi+LarDyCE2BhRaAhHpPQ/xQktPRIkL08N9NUlICENEAieP
# ZiBh9i6F2YUMFxSzWXc83I1wc+Qt43e8O/mOSEVtg10+rBqrbLIP+bOU9h014qLQ
# Pqg+j5AAFwrLQjWSnUtvUI8yDqC8a77LPPa8tW6u3qGrvG2qBVolDlHa7abTry5O
# SbL/J/xqsIrgH9SzEsvNxBmNVNyhAQCjzdjOL5ZwxKopdQ4PAKcZv/5ro322VLK8
# YoidrTAOUnE5vaB66z7AbuverP4noJEeZbmA73ADI8eoiMSADNXblaLJcjbEvMMc
# UUe8B8QY
# SIG # End signature block
