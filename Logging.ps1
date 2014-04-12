Function Log-Start{
<#
.SYNOPSIS
Creates log file
 
.DESCRIPTION
Creates log file with path and name that is passed. Checks if log file exists, and if it does deletes it and creates a new one.
Once created, writes initial logging data
 
.PARAMETER LogPath
Mandatory. Path of where log is to be created. Example: C:\Windows\Temp
 
.PARAMETER LogName
Mandatory. Name of log file to be created. Example: Test_Script.log
.PARAMETER ScriptVersion
Mandatory. Version of the running script which will be written in the log. Example: 1.5
 
.INPUTS
Parameters above
 
.OUTPUTS
Log file created
 
.NOTES
Version: 1.0
Author: Luca Sturlese
Creation Date: 10/05/12
Purpose/Change: Initial function development
 
Version: 1.1
Author: Luca Sturlese
Creation Date: 19/05/12
Purpose/Change: Added debug mode support
 
.EXAMPLE
Log-Start -LogPath "C:\Windows\Temp" -LogName "Test_Script.log" -ScriptVersion "1.5"
#>
[CmdletBinding()]
Param ([Parameter(Mandatory=$true)][string]$LogPath, [Parameter(Mandatory=$true)][string]$LogName, [Parameter(Mandatory=$true)][string]$ScriptVersion)
Process{
$sFullPath = $LogPath + "\" + $LogName
#Check if file exists and delete if it does
If((Test-Path -Path $sFullPath)){
Remove-Item -Path $sFullPath -Force
}
#Create file and start logging
New-Item -Path $LogPath -Name $LogName –ItemType File
Add-Content -Path $sFullPath -Value "***************************************************************************************************"
Add-Content -Path $sFullPath -Value "Started processing at [$([DateTime]::Now)]."
Add-Content -Path $sFullPath -Value "***************************************************************************************************"
Add-Content -Path $sFullPath -Value ""
Add-Content -Path $sFullPath -Value "Running script version [$ScriptVersion]."
Add-Content -Path $sFullPath -Value ""
Add-Content -Path $sFullPath -Value "***************************************************************************************************"
Add-Content -Path $sFullPath -Value ""
#Write to screen for debug mode
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
<#
.SYNOPSIS
Writes to a log file
 
.DESCRIPTION
Appends a new line to the end of the specified log file
.PARAMETER LogPath
Mandatory. Full path of the log file you want to write to. Example: C:\Windows\Temp\Test_Script.log
.PARAMETER LineValue
Mandatory. The string that you want to write to the log
.INPUTS
Parameters above
 
.OUTPUTS
None
 
.NOTES
Version: 1.0
Author: Luca Sturlese
Creation Date: 10/05/12
Purpose/Change: Initial function development
Version: 1.1
Author: Luca Sturlese
Creation Date: 19/05/12
Purpose/Change: Added debug mode support
 
.EXAMPLE
Log-Write -LogPath "C:\Windows\Temp\Test_Script.log" -LineValue "This is a new line which I am appending to the end of the log file."
#>
[CmdletBinding()]
Param ([Parameter(Mandatory=$true)][string]$LogPath, [Parameter(Mandatory=$true)][string]$LineValue)
Process{
Add-Content -Path $LogPath -Value $LineValue
#Write to screen for debug mode
Write-Debug $LineValue
}
}
 
Function Log-Error{
<#
.SYNOPSIS
Writes an error to a log file
 
.DESCRIPTION
Writes the passed error to a new line at the end of the specified log file
.PARAMETER LogPath
Mandatory. Full path of the log file you want to write to. Example: C:\Windows\Temp\Test_Script.log
.PARAMETER ErrorDesc
Mandatory. The description of the error you want to pass (use $_.Exception)
.PARAMETER ExitGracefully
Mandatory. Boolean. If set to True, runs Log-Finish and then exits script
 
.INPUTS
Parameters above
 
.OUTPUTS
None
 
.NOTES
Version: 1.0
Author: Luca Sturlese
Creation Date: 10/05/12
Purpose/Change: Initial function development
Version: 1.1
Author: Luca Sturlese
Creation Date: 19/05/12
Purpose/Change: Added debug mode support. Added -ExitGracefully parameter functionality
 
.EXAMPLE
Log-Error -LogPath "C:\Windows\Temp\Test_Script.log" -ErrorDesc $_.Exception -ExitGracefully $True
#>
[CmdletBinding()]
Param ([Parameter(Mandatory=$true)][string]$LogPath, [Parameter(Mandatory=$true)][string]$ErrorDesc, [Parameter(Mandatory=$true)][boolean]$ExitGracefully)
Process{
Add-Content -Path $LogPath -Value "Error: An error has occurred [$ErrorDesc]."
#Write to screen for debug mode
Write-Debug "Error: An error has occurred [$ErrorDesc]."
#If $ExitGracefully = True then run Log-Finish and exit script
If ($ExitGracefully -eq $True){
Log-Finish -LogPath $LogPath
Break
}
}
}
 
Function Log-Finish{
<#
.SYNOPSIS
Write closing logging data & exit
 
.DESCRIPTION
Writes finishing logging data to specified log and then exits the calling script
.PARAMETER LogPath
Mandatory. Full path of the log file you want to write finishing data to. Example: C:\Windows\Temp\Test_Script.log
 
.PARAMETER NoExit
Optional. If this is set to True, then the function will not exit the calling script, so that further execution can occur
.INPUTS
Parameters above
 
.OUTPUTS
None
 
.NOTES
Version: 1.0
Author: Luca Sturlese
Creation Date: 10/05/12
Purpose/Change: Initial function development
Version: 1.1
Author: Luca Sturlese
Creation Date: 19/05/12
Purpose/Change: Added debug mode support
Version: 1.2
Author: Luca Sturlese
Creation Date: 01/08/12
Purpose/Change: Added option to not exit calling script if required (via optional parameter)
 
.EXAMPLE
Log-Finish -LogPath "C:\Windows\Temp\Test_Script.log"
 
.EXAMPLE
Log-Finish -LogPath "C:\Windows\Temp\Test_Script.log" -NoExit $True
#>
[CmdletBinding()]
Param ([Parameter(Mandatory=$true)][string]$LogPath, [Parameter(Mandatory=$false)][string]$NoExit)
Process{
Add-Content -Path $LogPath -Value ""
Add-Content -Path $LogPath -Value "***************************************************************************************************"
Add-Content -Path $LogPath -Value "Finished processing at [$([DateTime]::Now)]."
Add-Content -Path $LogPath -Value "***************************************************************************************************"
#Write to screen for debug mode
Write-Debug ""
Write-Debug "***************************************************************************************************"
Write-Debug "Finished processing at [$([DateTime]::Now)]."
Write-Debug "***************************************************************************************************"
#Exit calling script if NoExit has not been specified or is set to False
If(!($NoExit) -or ($NoExit -eq $False)){
Exit
}
}
}
 
Function Log-Email{
<#
.SYNOPSIS
Emails log file to list of recipients
 
.DESCRIPTION
Emails the contents of the specified log file to a list of recipients
.PARAMETER LogPath
Mandatory. Full path of the log file you want to email. Example: C:\Windows\Temp\Test_Script.log
.PARAMETER EmailFrom
Mandatory. The email addresses of who you want to send the email from. Example: "admin@9to5IT.com"
 
.PARAMETER EmailTo
Mandatory. The email addresses of where to send the email to. Seperate multiple emails by ",". Example: "admin@9to5IT.com, test@test.com"
.PARAMETER EmailSubject
Mandatory. The subject of the email you want to send. Example: "Cool Script - [" + (Get-Date).ToShortDateString() + "]"
 
.INPUTS
Parameters above
 
.OUTPUTS
Email sent to the list of addresses specified
 
.NOTES
Version: 1.0
Author: Luca Sturlese
Creation Date: 05.10.12
Purpose/Change: Initial function development
 
.EXAMPLE
Log-Email -LogPath "C:\Windows\Temp\Test_Script.log" -EmailFrom "admin@9to5IT.com" -EmailTo "admin@9to5IT.com, test@test.com" -EmailSubject "Cool Script - [" + (Get-Date).ToShortDateString() + "]"
#>
[CmdletBinding()]
Param ([Parameter(Mandatory=$true)][string]$LogPath, [Parameter(Mandatory=$true)][string]$EmailFrom, [Parameter(Mandatory=$true)][string]$EmailTo, [Parameter(Mandatory=$true)][string]$EmailSubject)
Process{
Try{
$sBody = (Get-Content $LogPath | out-string)
#Create SMTP object and send email
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
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU8zsnm0HwN3TWxbfKxH2BYVRk
# y6qgggbUMIICOTCCAaagAwIBAgIQ+raG0caX6btAFadzzbDBizAJBgUrDgMCHQUA
# MCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdDAe
# Fw0xNDA0MTIxNDE1NDhaFw0zOTEyMzEyMzU5NTlaMBoxGDAWBgNVBAMTD1Bvd2Vy
# U2hlbGwgVXNlcjCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEA2lSlTwHbroi7
# xFNmBqU/ezaeZQuGCk3lYOAQjSgFqbf8dFF51uZROhPUsF4qCBuk7YoppL5HrXTa
# kMoRGxDlIXYONAN/xB/jHRPdG876eUi9zGEGdwxYWgRRecolgq//WKgC6eUJbrM+
# O1Z9YO2i9PXCbz9oZb45rOGOymhvfZUCAwEAAaN2MHQwEwYDVR0lBAwwCgYIKwYB
# BQUHAwMwXQYDVR0BBFYwVIAQ5nF8jrl4ebXAMucz3ni5waEuMCwxKjAoBgNVBAMT
# IVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdIIQ8sulqHdV/K5OPgII
# u/o2TzAJBgUrDgMCHQUAA4GBADLoplJ0PjNF3ZG+hJ3gP3F39TAM7S/th+Q/t1Nh
# tRAqI8ti8nmzGp/C5ETrgpr+D8GZtakFj5vBw/arMwr1X1ggKwauaKfZeP3k3Ztz
# XRRppdu8/WJuAIR3O/hHpMK/3nrsFMNdoCqWyiIi1NDCIP9cLYotqL8GRAT21rUn
# MQd9MIIEkzCCA3ugAwIBAgIQR4qO+1nh2D8M4ULSoocHvjANBgkqhkiG9w0BAQUF
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
# BAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdAIQ+raG0caX6btA
# FadzzbDBizAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZ
# BgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYB
# BAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUXUJI1GrJtvU6ojZRh7C7tzY7Jj8wDQYJ
# KoZIhvcNAQEBBQAEgYCwB4vsaIZ9q7gqCt3bXrn5OtAP9ZD4MwWhAsCnxZaqHchD
# 7/YpKrPWBYfBsXpSu3aYUATBdxPcoB30F+ZMur9Avhbr3YT/3gWkrnBT+tcVkw2o
# 1SW4lkuZO6th3VGHy27FzTH5R5ZnTlfkyaNJKQM9jTuwsaqfuvU89vGol68EO6GC
# AkQwggJABgkqhkiG9w0BCQYxggIxMIICLQIBADCBqjCBlTELMAkGA1UEBhMCVVMx
# CzAJBgNVBAgTAlVUMRcwFQYDVQQHEw5TYWx0IExha2UgQ2l0eTEeMBwGA1UEChMV
# VGhlIFVTRVJUUlVTVCBOZXR3b3JrMSEwHwYDVQQLExhodHRwOi8vd3d3LnVzZXJ0
# cnVzdC5jb20xHTAbBgNVBAMTFFVUTi1VU0VSRmlyc3QtT2JqZWN0AhBHio77WeHY
# PwzhQtKihwe+MAkGBSsOAwIaBQCgXTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcB
# MBwGCSqGSIb3DQEJBTEPFw0xNDA0MTIyMzMwMTlaMCMGCSqGSIb3DQEJBDEWBBQf
# JmndNdJzoxbl5EYhHncOknd8OTANBgkqhkiG9w0BAQEFAASCAQAWKwauBBfYkrgF
# 772gurk7LArFaJ3JIdbNrQllU33fHot51zOclu967xYBpGyjk0G1PrzKV1bA2rCA
# HUEy6osl+RTlglojdKGz2w5/+C/CL+PD7TiN7zbnkcEtW1qbFuG2G7xyxjufJvjB
# hg8+vChdiqODT3ENNXE6pB3Q4kK7lxCC8lxqHTXRHLGI7/o56IeckVBi6YJUI0jt
# UkoYMCM6d7Dkj53jrYfPJhtx2SRqSWTpjQFIha4mNptb72NuItw5Vnmd0aJ9sMgy
# nt8Nfx6LKeL9JF/oquQRN9UelzyJvIouJ9jpEMf1qLGoCZ/qNZW4U/gH4qvhX8gH
# 4KRIAG21
# SIG # End signature block
