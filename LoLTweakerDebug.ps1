$dir = Split-Path -parent $MyInvocation.MyCommand.Definition
$ErrorActionPreference = "SilentlyContinue"

$sLogPath = "$dir"
$sLogName = "errorlog.log"
$sLogFile = $sLogPath + "\" + $sLogName

pop-location
push-location "RADS\solutions\lol_game_client_sln\releases"
$sln = gci | ? { $_.PSIsContainer } | sort CreationTime -desc | select -f 1

pop-location
push-location "RADS\projects\lol_launcher\releases"
$launch = gci | ? { $_.PSIsContainer } | sort CreationTime -desc | select -f 1

pop-location
push-location "RADS\projects\lol_air_client\releases"
$air = gci | ? { $_.PSIsContainer } | sort CreationTime -desc | select -f 1

cd $dir

New-Item -ItemType directory -Path Backup
Write-Host "Backing up and updating..."
Copy-Item "RADS\solutions\lol_game_client_sln\releases\$sln\deploy\dbghelp.dll" "Backup"
Copy-Item "RADS\solutions\lol_game_client_sln\releases\$sln\deploy\tbb.dll" "Backup"
Copy-Item "RADS\solutions\lol_game_client_sln\releases\$sln\deploy\BsSndRpt.exe" "Backup"
Copy-Item "RADS\solutions\lol_game_client_sln\releases\$sln\deploy\BugSplat.dll" "Backup"
Copy-Item "RADS\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0\Adobe Air.dll" "Backup"
Copy-Item "RADS\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0\resources\NPSWF32.dll" "Backup"
Copy-Item "RADS\projects\lol_launcher\releases\$launch\deploy\cg.dll" "Backup"
Copy-Item "RADS\projects\lol_launcher\releases\$launch\deploy\cgD3D9.dll" "Backup"
Copy-Item "RADS\projects\lol_launcher\releases\$launch\deploy\cggl.dll" "Backup"
start-process dxwsetup.exe /q

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
start-process .\Cg-3.1_April2012_Setup.exe /silent -Windowstyle Hidden -wait
Copy-Item "BsSndRpt.exe" "RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "BugSplat.dll" "RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "dbghelp.dll" "RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "tbb.dll" "RADS\solutions\lol_game_client_sln\releases\$sln\deploy"
Copy-Item "NPSWF32.dll" "RADS\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0\Resources"
Copy-Item "Adobe AIR.dll" "RADS\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0"


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