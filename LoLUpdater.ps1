Function Log-Write{

[CmdletBinding()]
Param ([Parameter(Mandatory=$true)][string]$LogPath, [Parameter(Mandatory=$true)][string]$LineValue)
Process{
Add-Content -Path $LogPath -Value $LineValue

Write-Debug $LineValue
}
}
 
Function Log-Error{

[CmdletBinding()]
Param ([Parameter(Mandatory=$true)][string]$LogPath, [Parameter(Mandatory=$true)][string]$ErrorDesc, [Parameter(Mandatory=$true)][boolean]$ExitGracefully)
Process{
Add-Content -Path $LogPath -Value "Error: An error has occurred [$ErrorDesc]."

Write-Debug "Error: An error has occurred [$ErrorDesc]."

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
Add-Content -Path $LogPath -Value ""
Add-Content -Path $LogPath -Value "***************************************************************************************************"
Add-Content -Path $LogPath -Value "Finished processing at [$([DateTime]::Now)]."
Add-Content -Path $LogPath -Value "***************************************************************************************************"

Write-Debug ""
Write-Debug "***************************************************************************************************"
Write-Debug "Finished processing at [$([DateTime]::Now)]."
Write-Debug "***************************************************************************************************"
If(!($NoExit) -or ($NoExit -eq $False)){
Exit
}
}
}
 
Function Log-Email{

[CmdletBinding()]
Param ([Parameter(Mandatory=$true)][string]$LogPath, [Parameter(Mandatory=$true)][string]$EmailFrom, [Parameter(Mandatory=$true)][string]$EmailTo, [Parameter(Mandatory=$true)][string]$EmailSubject)
Process{
Try{
$sBody = (Get-Content $LogPath | out-string)

$sSmtpServer = "smtp.gmail.com"
$oSmtp = new-object Net.Mail.SmtpClient($sSmtpServer)
$oSmtp.Send($EmailFrom, $EmailTo, $EmailSubject, $sBody)
Exit 0
}
Catch{
Exit 1
}
}
}

$dir = Split-Path -parent $MyInvocation.MyCommand.Definition
New-Item -ItemType directory -Path $dir\Backup
Copy-Item "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy\dbghelp.dll" Backup
Copy-Item "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy\tbb.dll" Backup
Copy-Item "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy\BsSndRpt.exe" Backup
Copy-Item "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy\BugSplat.dll" Backup
Copy-Item "$dir\RADS\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0\Adobe Air.dll" Backup
Copy-Item "$dir\RADS\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0\resources\NPSWF32.dll" Backup
Copy-Item "$dir\RADS\projects\lol_launcher\releases\$launch\deploy\cg.dll" Backup
Copy-Item "$dir\RADS\projects\lol_launcher\releases\$launch\deploy\cgD3D9.dll" Backup
Copy-Item "$dir\RADS\projects\lol_launcher\releases\$launch\deploy\cggl.dll" Backup
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
start-process data\dxwebsetup.exe /q
start-process Cg-3.1_April2012_Setup.exe /silent -wait
Copy-Item "data\BsSndRpt.exe" "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "data\BugSplat.dll" "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "data\dbghelp.dll" "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "data\tbb.dll" "$dir\RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "data\NPSWF32.dll" "$dir\RADS\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0\resources" 
Copy-Item "data\Adobe AIR.dll" "$dir\RADS\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0" 


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



Function Log-Start{

[CmdletBinding()]
Param ([Parameter(Mandatory=$true)][string]$LogPath, [Parameter(Mandatory=$true)][string]$LogName, [Parameter(Mandatory=$true)][string]$ScriptVersion)
Process{
$sFullPath = $LogPath + "\" + $LogName
If((Test-Path -Path $sFullPath)){
Remove-Item -Path $sFullPath -Force
}
New-Item -Path $LogPath -Name $LogName –ItemType File
Add-Content -Path $sFullPath -Value "***************************************************************************************************"
Add-Content -Path $sFullPath -Value "Started processing at [$([DateTime]::Now)]."
Add-Content -Path $sFullPath -Value "***************************************************************************************************"
Add-Content -Path $sFullPath -Value ""
Add-Content -Path $sFullPath -Value "Running script version [$ScriptVersion]."
Add-Content -Path $sFullPath -Value ""
Add-Content -Path $sFullPath -Value "***************************************************************************************************"
Add-Content -Path $sFullPath -Value ""
Write-Debug "***************************************************************************************************"
Write-Debug "Started processing at [$([DateTime]::Now)]."
Write-Debug "***************************************************************************************************"
Write-Debug ""
Write-Debug "Running script version [$ScriptVersion]."
Write-Debug ""
Write-Debug "***************************************************************************************************"
Write-Debug ""
}
}
 


patch
# SIG # Begin signature block
# MIILEgYJKoZIhvcNAQcCoIILAzCCCv8CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUwD10iJSCM0kkLDiNwdT6OpWj
# QFSgggbUMIICOTCCAaagAwIBAgIQv1RyTowzq4RB1+dREMrv1jAJBgUrDgMCHQUA
# MCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdDAe
# Fw0xNDA0MTMwMjQ1MDVaFw0zOTEyMzEyMzU5NTlaMBoxGDAWBgNVBAMTD1Bvd2Vy
# U2hlbGwgVXNlcjCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAphAas5fefSJP
# cvdszx/Din1IzAQ6O2bXksHie3OATxgv16/OFYo3uzT6Jg5tOwSgb1m5ftYMZF1P
# ru0SCWjd17UmJUGN0+oFG5i95CM9ohu9qP7SB8BTj21ca6sxcpXow/nYJ3gIwWtY
# E2M4xKj7LbMzR87EJtQY6ICUrSyZTqECAwEAAaN2MHQwEwYDVR0lBAwwCgYIKwYB
# BQUHAwMwXQYDVR0BBFYwVIAQ5nF8jrl4ebXAMucz3ni5waEuMCwxKjAoBgNVBAMT
# IVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdIIQQi98cagnAJNBOKt4
# CHSVbzAJBgUrDgMCHQUAA4GBAHy/+zKPtNm0MjezUcaei2DEokLMH1vfZq/8gjl8
# MGvf9dGLxbhfv9Z23vR/kOfwZhBNk3by+ACTsEaqSlFOX5ShzbBbkUQ6mHnt+UA5
# TtGLq6Wu8RyVBlBMK/vSQuTD5jvrN/sduHKp0A8MqbRClZNR+/bSq3+lTqwv48+B
# WcZjMIIEkzCCA3ugAwIBAgIQR4qO+1nh2D8M4ULSoocHvjANBgkqhkiG9w0BAQUF
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
# BAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdAIQv1RyTowzq4RB
# 1+dREMrv1jAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZ
# BgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYB
# BAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUOTLNutp+aTYDKkyeZaPZ10JCXEswDQYJ
# KoZIhvcNAQEBBQAEgYA9x6s3dzHk9Zb/zSYv53TYWgZv5qbVV+6PkSwErCL7BcXf
# NLkL4/Y1728vN5XUyzGBdob2UcnynpR5dAjMC+NvcIlj6drpCYKCOqfk/x3w8GW7
# 1olKCb5eBb/QRfBfw3YF0VNSJO+EP8FQL/GTM2J4YOfviCu0Kld9MqIFgvqBOqGC
# AkQwggJABgkqhkiG9w0BCQYxggIxMIICLQIBADCBqjCBlTELMAkGA1UEBhMCVVMx
# CzAJBgNVBAgTAlVUMRcwFQYDVQQHEw5TYWx0IExha2UgQ2l0eTEeMBwGA1UEChMV
# VGhlIFVTRVJUUlVTVCBOZXR3b3JrMSEwHwYDVQQLExhodHRwOi8vd3d3LnVzZXJ0
# cnVzdC5jb20xHTAbBgNVBAMTFFVUTi1VU0VSRmlyc3QtT2JqZWN0AhBHio77WeHY
# PwzhQtKihwe+MAkGBSsOAwIaBQCgXTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcB
# MBwGCSqGSIb3DQEJBTEPFw0xNDA0MTMwMjQ1MjBaMCMGCSqGSIb3DQEJBDEWBBSD
# kVgj4/ty4JCP5kJWajnJJNyP7jANBgkqhkiG9w0BAQEFAASCAQCwGYK+vPT2peQ0
# Fud82srjjMvjL3oPw5NHC6UGOvnEDxA0mRAgt7aO64zZOJx4vTSLlu2/8zCiLp0J
# BU5qoIcnjrUX+Nh2JqG42m7GlR4AoWsYc16kTkXdV15IECuwqR02Zv7sGpJGbYyt
# Lj0bbPhWWY7YQjjoWl2252rUMBBLTueD1DC7z2UbxHPuVxyJco8+IyS49JAmcDp0
# iDiGELIn9Xv2ZG8ArDTSSYnTrnlcfviZN0FBpls8l4Vdc5k7XsnTMfOQLaW7wB5H
# Ic5hJQOW/7lya5QLpnUyJnbSgawnZlLw1cHaVaNVVFZu1xzPWeKsZo43zGsQPg3S
# ECnFbDcV
# SIG # End signature block
