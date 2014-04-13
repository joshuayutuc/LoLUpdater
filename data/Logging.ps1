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
# SIG # Begin signature block
# MIILEgYJKoZIhvcNAQcCoIILAzCCCv8CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUNLsuGwWv4J3GfjFaxCbFaD0y
# wF+gggbUMIICOTCCAaagAwIBAgIQGqStUKicZL1I4FKrOsxRFTAJBgUrDgMCHQUA
# MCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdDAe
# Fw0xNDA0MTMwMjMxMDdaFw0zOTEyMzEyMzU5NTlaMBoxGDAWBgNVBAMTD1Bvd2Vy
# U2hlbGwgVXNlcjCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEA1UPURMnlvJjm
# FQLmBzt2BnUBbSPN5OI40UpO+6FaKkrvgzID6JDy1IZ4kW7sVNzkBkdSWFELnIJR
# 7JkQtNfSEAEwEgnQRH6lkXfHvKEsGZxweO2pgwmuvbZGnNCHjM17S/TY3Qg4u2Hd
# UWTGuOoX6W5B7YbDZDsAhYt22sjAOI0CAwEAAaN2MHQwEwYDVR0lBAwwCgYIKwYB
# BQUHAwMwXQYDVR0BBFYwVIAQ5nF8jrl4ebXAMucz3ni5waEuMCwxKjAoBgNVBAMT
# IVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdIIQq2qprVetx6NGMBaj
# o11nuTAJBgUrDgMCHQUAA4GBADJIfdTzjShF0NfhHByaRK+RfFVRXcNX6i3Pt2TA
# T6Bb1gLTgXBzbmfuA8n8rExzxoZgr6HXHgRayXITehWf7Cd9H1hDx1gIjKfX/arg
# yhSqclBkDUewotgO/Khni7ARydPQwTKP5Rptg3nj2CnFd3guR2ExSK1anMUn5DLg
# XvXbMIIEkzCCA3ugAwIBAgIQR4qO+1nh2D8M4ULSoocHvjANBgkqhkiG9w0BAQUF
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
# BAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdAIQGqStUKicZL1I
# 4FKrOsxRFTAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZ
# BgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYB
# BAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQU4NaNit6sfdbW52SW3qNChfvjaYEwDQYJ
# KoZIhvcNAQEBBQAEgYBilze/kJwcpjPD/+m7tIqeirv6bdPYIu3HfekdwYRllM9c
# CtHT+mvBLDTH4KJniFsxk2DdSBBNVQJrO6DTEvzPqf68XGqgYFdGPy20abyNiJ+n
# Z/Uc2DFXBWAPvJ4DxNKOUo/ucEQk3Wt2t/0lcPfjRh8utWrswe1X7uZylhC8QaGC
# AkQwggJABgkqhkiG9w0BCQYxggIxMIICLQIBADCBqjCBlTELMAkGA1UEBhMCVVMx
# CzAJBgNVBAgTAlVUMRcwFQYDVQQHEw5TYWx0IExha2UgQ2l0eTEeMBwGA1UEChMV
# VGhlIFVTRVJUUlVTVCBOZXR3b3JrMSEwHwYDVQQLExhodHRwOi8vd3d3LnVzZXJ0
# cnVzdC5jb20xHTAbBgNVBAMTFFVUTi1VU0VSRmlyc3QtT2JqZWN0AhBHio77WeHY
# PwzhQtKihwe+MAkGBSsOAwIaBQCgXTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcB
# MBwGCSqGSIb3DQEJBTEPFw0xNDA0MTMwMjM1NDRaMCMGCSqGSIb3DQEJBDEWBBQW
# xQgpUJ8gjUv2F4iJQEuz9iKz1DANBgkqhkiG9w0BAQEFAASCAQCzrR5MF8ZOVj8j
# 8V1FjHOdqDL64jUNDRBugVvQbTDfCHUggyXveTo96z6OWZhmUTsvzXFYhoBau7lW
# pFw6dYEbCGbxgYhp2wCEeu7PvaHq5kyTunf4mmTAzJsXblVo7BG1tJ6XmOFzBsHB
# KEywFXi91uoYuTnDPF3cXnKzcLiE08ul4q1pnNa2Px2C8zD+8cE+DMhROJciSv/O
# Ef8ADZLYlA31WgZ1fv7phEaOxtLDvviUSJN8oNsLX0v8VEVMSjA0P86aLU4q1BZc
# IyfOriHCuKwpKv87TCS4ZmySwSWxhBYNNR6x7gnKsrOTkPPUjmK2CaxdL7rTNNnm
# wBN7fy7L
# SIG # End signature block
