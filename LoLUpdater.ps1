. .\data\Logging.ps1
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