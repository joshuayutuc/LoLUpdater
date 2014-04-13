. .\Logging.ps1
$dir = Split-Path -parent $MyInvocation.MyCommand.Definition
New-Item -ItemType directory -Path $dir\Backup
$ErrorActionPreference = "SilentlyContinue"

$sScriptVersion = "1.0"
$sLogPath = "$dir"
$sLogName = "LoLUpdater.log"
$sLogFile = $sLogPath + "\" + $sLogName

 
 
Function patch{
Param()
Begin{
Log-Write -LogPath $sLogFile -LineValue "<description of what is going on>..."
}
Process{
Try{
Log-Start -LogPath $sLogPath -LogName $sLogName -ScriptVersion $sScriptVersion
Write-Host "Closing League of Legends..."
stop-process -processname LoLLauncher 
stop-process -processname LoLClient 
stop-process -processname "League of Legends" 


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
cls
Write-Host "Downloading files..."
import-module bitstransfer
Start-BitsTransfer http://developer.download.nvidia.com/cg/Cg_3.1/Cg-3.1_April2012_Setup.exe
cls
Write-Host "Copying files..."
start-process dxwebsetup.exe /q
start-process Cg-3.1_April2012_Setup.exe /silent -wait
Copy-Item "BsSndRpt.exe" "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "BugSplat.dll" "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "dbghelp.dll" "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "tbb.dll" "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "NPSWF32.dll" "$dir\RADS\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0\resources" 
Copy-Item "Adobe AIR.dll" "$dir\RADS\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0" 


if($env:PROCESSOR_ARCHITECTURE -eq "AMD64")
    {
Copy-Item "${env:programfiles(x86)}\NVIDIA Corporation\Cg\bin\cg.dll" "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy" 
Copy-Item "${env:programfiles(x86)}\NVIDIA Corporation\Cg\bin\cgD3D9.dll" "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy" 
Copy-Item "${env:programfiles(x86)}\NVIDIA Corporation\Cg\bin\cggl.dll" "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy" 
Copy-Item "${env:programfiles(x86)}\NVIDIA Corporation\Cg\bin\cg.dll" "$dir\RADS\projects\lol_launcher\releases\$launch\deploy" 
Copy-Item "${env:programfiles(x86)}\NVIDIA Corporation\Cg\bin\cgD3D9.dll" "$dir\RADS\projects\lol_launcher\releases\$launch\deploy" 
Copy-Item "${env:programfiles(x86)}\NVIDIA Corporation\Cg\bin\cggl.dll" "$dir\RADS\projects\lol_launcher\releases\$launch\deploy" 
if ((Test-Path -path $key\uninst.exe))
{start-process "${Env:ProgramFiles(x86)}\NVIDIA Corporation\Cg\unins000.exe" /silent
}
        
    }
    else
    {
Copy-Item "$env:programfiles\NVIDIA Corporation\Cg\bin\cg.dll" "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy" 
Copy-Item "$env:programfiles\NVIDIA Corporation\Cg\bin\cgD3D9.dll" "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy" 
Copy-Item "$env:programfiles\NVIDIA Corporation\Cg\bin\cggl.dll" "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy" 
Copy-Item "$env:programfiles\NVIDIA Corporation\Cg\bin\cg.dll" "$dir\RADS\projects\lol_launcher\releases\$launch\deploy"  
Copy-Item "$env:programfiles\NVIDIA Corporation\Cg\bin\cgD3D9.dll" "$dir\RADS\projects\lol_launcher\releases\$launch\deploy"  
Copy-Item "$env:programfiles\NVIDIA Corporation\Cg\bin\cggl.dll" "$dir\RADS\projects\lol_launcher\releases\$launch\deploy" 
if ((Test-Path -path $key\uninst.exe))
{start-process "${Env:ProgramFiles}\NVIDIA Corporation\Cg\unins000.exe" /silent
}

    }
    cls
Write-Host "Uninstalling PMB..."

$key = (Get-ItemProperty "HKLM:\HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Pando Networks\PMB")."program directory" 

if ((Test-Path -path $key\uninst.exe))
{ start-process "$key\uninst.exe "
}

Copy-Item "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy\dbghelp.dll" Backup
Copy-Item "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy\tbb.dll" Backup
Copy-Item "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy\BsSndRpt.exe" Backup
Copy-Item "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy\BugSplat.dll" Backup
Copy-Item "$dir\RADS\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0\Adobe Air.dll" Backup
Copy-Item "$dir\RADS\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0\resources\NPSWF32.dll" Backup
Copy-Item "$dir\RADS\projects\lol_launcher\releases\$launch\deploy\cg.dll" Backup
Copy-Item "$dir\RADS\projects\lol_launcher\releases\$launch\deploy\cgD3D9.dll" Backup
Copy-Item "$dir\RADS\projects\lol_launcher\releases\$launch\deploy\cggl.dll" Backup


start-process "$dir\lol.launcher.exe"
cls


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
End{
If($?){
Log-Write -LogPath $sLogFile -LineValue "Script finished"
}
}
}

patch
# SIG # Begin signature block
# MIILEgYJKoZIhvcNAQcCoIILAzCCCv8CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUKygh0UxOxml60bOLc9+P+Fwl
# 3QSgggbUMIICOTCCAaagAwIBAgIQGk1tNkJcvJFLL+lw/AbXFTAJBgUrDgMCHQUA
# MCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdDAe
# Fw0xNDA0MTMwMDI4MjNaFw0zOTEyMzEyMzU5NTlaMBoxGDAWBgNVBAMTD1Bvd2Vy
# U2hlbGwgVXNlcjCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEA7V8zWPN3ETMl
# CnHCgjNypAZ0oxyUe0u9Kn2vpKx9pkUtuAfnEg1IWLUYnM3kF+YIYcbnANITiYKu
# n2ZHMW9JzfIH5ycf5p9Ua9tOHYzlBtK2KzCTUwr1+lD7I3Hu5aJfXFCnklkgZAQn
# McUw3HEbwzM5gHbgr6a2K7z9isli5BkCAwEAAaN2MHQwEwYDVR0lBAwwCgYIKwYB
# BQUHAwMwXQYDVR0BBFYwVIAQ5nF8jrl4ebXAMucz3ni5waEuMCwxKjAoBgNVBAMT
# IVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdIIQ+hHXBmGAYYtFxldT
# 4pPrlTAJBgUrDgMCHQUAA4GBAAHb6XfR4lxzq8+Kt5Q2m+0gruH/7tPdv0W4kC1J
# toFaSKF1GMP7lOqQ9KvRrc0+/0mSk1AYjg0Jh85/RQEZSZrGYNKCuTwRArwV1U7M
# o6EDh7Lpum4jvB2xogax8snK8uZeSqgVY9heDNEwCWSw7oRRpFDMM4CsmoKq1NKW
# iuSSMIIEkzCCA3ugAwIBAgIQR4qO+1nh2D8M4ULSoocHvjANBgkqhkiG9w0BAQUF
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
# BAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdAIQGk1tNkJcvJFL
# L+lw/AbXFTAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZ
# BgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYB
# BAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUKvwgzfzf7QtkaarXeoHvIrfk/L8wDQYJ
# KoZIhvcNAQEBBQAEgYCp4kZ+nbMLIB2LoYKXPanDVAB3Gi/KU1MbBjt07q4Qz8rG
# RmcdL6btfWGkqz1/RevEsjGvl5oZ1y++DrfMHRuu+jiIPjaWgX4z8FC5j+HYWx4y
# Eotm9ic8gW6XOUC+0ZcOE1t1TayixWQgOUs27482qZcqQrP0+wPCjuoef6tY1aGC
# AkQwggJABgkqhkiG9w0BCQYxggIxMIICLQIBADCBqjCBlTELMAkGA1UEBhMCVVMx
# CzAJBgNVBAgTAlVUMRcwFQYDVQQHEw5TYWx0IExha2UgQ2l0eTEeMBwGA1UEChMV
# VGhlIFVTRVJUUlVTVCBOZXR3b3JrMSEwHwYDVQQLExhodHRwOi8vd3d3LnVzZXJ0
# cnVzdC5jb20xHTAbBgNVBAMTFFVUTi1VU0VSRmlyc3QtT2JqZWN0AhBHio77WeHY
# PwzhQtKihwe+MAkGBSsOAwIaBQCgXTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcB
# MBwGCSqGSIb3DQEJBTEPFw0xNDA0MTMwMDI5MzRaMCMGCSqGSIb3DQEJBDEWBBT9
# AL3kaxmLYQ1RaPHrQ+gSZrXV3TANBgkqhkiG9w0BAQEFAASCAQAlmon2u20OE/zt
# vk4G12fGxnzfLq4C6hid7wonCK3mfY+BJtOB9AzyOwd+iXvM4NIwmsn5owXxCBNd
# dU+K4BZBUGOe9MUW2kLAoPSpH2xer6M5bletvkWKqqilxKNGNRBZeZgrF3Mds5OM
# 0jt/Q9T5qzba6IIOVPNnrEMbt9XzkHkmYifiv1W6A56z18NK6c8dndSgb14VzIje
# GYoFnNIQTajiEC3eRmbZAc4f0XbvmnCfKzrAMTANdWVh78/Y4iR6BW58ssOXcOB4
# ZbKVZzxF4KAfT06rGUu7fShHmq4vqeVPkZljWppBCENLu4HzP72G5qVxyAGvLnpv
# NTc4SDgh
# SIG # End signature block
