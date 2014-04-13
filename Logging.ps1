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
# wF+gggbUMIICOTCCAaagAwIBAgIQGk1tNkJcvJFLL+lw/AbXFTAJBgUrDgMCHQUA
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
# BAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQU4NaNit6sfdbW52SW3qNChfvjaYEwDQYJ
# KoZIhvcNAQEBBQAEgYDjLZ2F4vYuOmG2/W4aMc5l109X8MsBqIDBGOhpRWh6lR3M
# lzBzouB/BlFeOKsaNTEq1eay2omgKp/EEK/fwP7T/rmNadt1/gKp6gfMDt/jShtj
# xCXOntKDXP+Nr+zgTHtlLEZbkNduvDRGEbqn2gRd4lMN9gtiA9C0J9BMWIf+36GC
# AkQwggJABgkqhkiG9w0BCQYxggIxMIICLQIBADCBqjCBlTELMAkGA1UEBhMCVVMx
# CzAJBgNVBAgTAlVUMRcwFQYDVQQHEw5TYWx0IExha2UgQ2l0eTEeMBwGA1UEChMV
# VGhlIFVTRVJUUlVTVCBOZXR3b3JrMSEwHwYDVQQLExhodHRwOi8vd3d3LnVzZXJ0
# cnVzdC5jb20xHTAbBgNVBAMTFFVUTi1VU0VSRmlyc3QtT2JqZWN0AhBHio77WeHY
# PwzhQtKihwe+MAkGBSsOAwIaBQCgXTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcB
# MBwGCSqGSIb3DQEJBTEPFw0xNDA0MTMwMDMxMDJaMCMGCSqGSIb3DQEJBDEWBBSM
# sMs3wnzXNNuL/m40rbUQDHKyQzANBgkqhkiG9w0BAQEFAASCAQB+wK7puYqromsP
# ZE53uoS47KBNd6ilYTwnv4oZAbq2Yc0dysiHC4m92dJ1HJUlaliKHcFViuQVGSIf
# blS/m/xn8YLURgFvv9xIj1cAz5NqdCO5B2Zr9PafKkyPgaIJUH0vrYQsi31DI0xG
# hLjMk2lHE4JD06RZKOlZcTuHEuMEUW0WjSoKcmHzGaRUyXqXN7L8Fb48YOUPC7Uf
# SOAFpravvVpxidaPrxHO8Gx4vYP/q5xCIrdYW3smVI2tRuC4Q1uHWwqQclBlS7dB
# 2muOUitMMBJooUjy6+sFNQ98xCHBHWuPn9YJpZcPZYP859a8YBwALQ0gWga8qGPD
# EZ/Wd2+Z
# SIG # End signature block
