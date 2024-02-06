#------------Functions---------------------------------------------------------------------------------
function Log([string]$LogString) 
{
    Write-Host "$(Get-Date -Format "dd.MM.yyyy HH:mm:ss,ff") $($LogString)"
    Add-Content -Path $logFile -Value "$(Get-Date -Format "dd.MM.yyyy HH:mm:ss,ff") $($LogString)"
}
function Test-RegistryValue 
{
    param (
     [parameter(Mandatory=$true)][ValidateNotNullOrEmpty()]$Path,
     [parameter(Mandatory=$true)] [ValidateNotNullOrEmpty()]$Value
    )
    try {
     Get-ItemProperty -Path $Path -Name $Value -EA Stop
     return $true
    }  catch {
     return $false
    }
}

function TestPendingReboot
{
    Log "Checking if a reboot is pending"
    [bool]$PendingReboot = $false

    #Check for Keys
    If ((Test-Path -Path "Reboot pending, HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired") -eq $true)
    {
        Log "Reboot pending, HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired"
        $PendingReboot = $true
    }

    If ((Test-Path -Path "Reboot pending, HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\PostRebootReporting") -eq $true)
    {
        Log "Reboot pending, HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\PostRebootReporting"
        $PendingReboot = $true
    }

    If ((Test-Path -Path "Reboot pending, HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired") -eq $true)
    {
        Log "Reboot pending, HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired"
        $PendingReboot = $true
    }

    If ((Test-Path -Path "Reboot pending, HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending") -eq $true)
    {
        Log "Reboot pending, HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending"
        $PendingReboot = $true
    }

    If ((Test-Path -Path "Reboot pending, HKLM:\SOFTWARE\Microsoft\ServerManager\CurrentRebootAttempts") -eq $true)
    {
        Log "Reboot pending, HKLM:\SOFTWARE\Microsoft\ServerManager\CurrentRebootAttempts"
        $PendingReboot = $true
    }

    #Check for Values
    If ((Test-RegistryValue -Path "Reboot pending, HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing" -Value "RebootInProgress") -eq $true)
    {
        Log "Reboot pending, HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing > RebootInProgress"
        $PendingReboot = $true
    }

    If ((Test-RegistryValue -Path "Reboot pending, HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing" -Value "PackagesPending") -eq $true)
    {
        Log "Reboot pending, HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing > PackagesPending"
        $PendingReboot = $true
    }

    If ((Test-RegistryValue -Path "Reboot pending, HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Value "PendingFileRenameOperations") -eq $true)
    {
        Log "Reboot pending, HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager > PendingFileRenameOperations"
        $PendingReboot = $true
    }

    If ((Test-RegistryValue -Path "Reboot pending, HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Value "PendingFileRenameOperations2") -eq $true)
    {
        Log "Reboot pending, HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager > PendingFileRenameOperations2"
        $PendingReboot = $true
    }

    If ((Test-RegistryValue -Path "Reboot pending, HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" -Value "DVDRebootSignal") -eq $true)
    {
        Log "Reboot pending, HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce > DVDRebootSignal"
        $PendingReboot = $true
    }

    If ((Test-RegistryValue -Path "Reboot pending, HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon" -Value "JoinDomain") -eq $true)
    {
        Log "Reboot pending, HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon > JoinDomain"
        $PendingReboot = $true
    }

    If ((Test-RegistryValue -Path "Reboot pending, HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon" -Value "AvoidSpnSet") -eq $true)
    {
        Log "Reboot pending, HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon > AvoidSpnSet"
        $PendingReboot = $true
    }

return $PendingReboot
}#------------End Functions-----------------------------------------------------------------------------#------------Parameters--------------------------------------------------------------------------------# List of software GUIDs to uninstall$SoftwareRemovalGuids = @(    "{21B0BA9E-8CF4-4D45-9FAC-FAF5D654B1A1}"
    "{332D5844-1273-4577-8499-4C05E177B6C6}"
    "{0448BA3E-5449-4D27-B692-A79390CC58BC}"
    "{EC4F448F-FCEA-4210-BE1C-6B7B13C0A3CC}"
    "{37BCC6E3-8A50-48F1-A9E8-75D26630A175}"
    "{C158BDA1-9F0E-4586-8E35-FFF2CA8D2642}"
    "{C2E88233-FB28-485F-92C3-3DBE65E8FEB0}"
    "{F59B8BCD-544B-48DE-82CA-67EBB0F2BA7B}"
    "{F799027A-E09E-4686-A0FA-4D0436047D39}"
    "{15679F6B-2022-4038-897D-957C459D1BD6}"
    "{251563BA-936C-4372-BB3E-D74B16FC4527}"
    "{E98CF33C-E605-4C79-B639-164062122C6C}"    "{78CE99D0-EFA4-4D2A-85D4-25196DF64243}")$AppName = "d.3_Smart_Explorer"# Define temporary destination paths$destinationPath = "C:\ProgramData\ccmtemp"$InstallParameters = '"d.3 smart explorer.msi" /q TRANSFORMS=1031.mst /l*v c:\windows\logs\d.3_Smart_ExplorerMSIInstall.log'$InstallParametersSched = '"C:\ProgramData\ccmtemp\d.3 smart explorer.msi" /q TRANSFORMS=1031.mst /l*v c:\windows\logs\d.3_Smart_ExplorerMSIInstall.log'$logFile = "c:\Windows\Logs\Install$AppName.log"#------------End Parameters----------------------------------------------------------------------------Log "Starting installation of $AppName"Log "Step 1: Searching and removing old applications"Start-Process taskkill.exe -ArgumentList "dvinstall.exe" -Wait# Loop through each software GUID and uninstall if installedforeach ($guid in $SoftwareRemovalGuids) {    $UninstallParameters = "/x $guid /qn /l*v c:\windows\logs\d.3_Smart_ExplorerMSIUninstall.log"        # Check if the software is installed (32 bit)    $installed = ((Test-Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\$guid") -or (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$guid"))    if ($installed) {        # Uninstall the software silently        Log "Uninstalling software with GUID: $guid"        $process = Start-Process "msiexec.exe" -ArgumentList $UninstallParameters -PassThru -Wait        if($process.ExitCode -eq '3010') {            $rebootRequired = $true        }        else{        # Check for reboot prompt            $rebootRequired = TestPendingReboot        }    }    else {        Log "Software with GUID $guid is not installed."    }}Start-Process taskkill.exe -ArgumentList "dvinstall.exe" -Wait# Create if ($rebootRequired) {    # Step 2: Copy sources    # Check if the destination path exists, and create it if it doesn't    if (-not (Test-Path $destinationPath)) {        New-Item -Path $destinationPath -ItemType Directory -Force    }    Log "Contents copyin to $destinationPath"    # Copy the contents of the current location to the destination    Copy-Item -Path "$PSScriptRoot\*" -Destination $destinationPath -Recurse -Force    Log Prompting user to reboot and wait for user input    Log "Reboot is required. Please reboot your machine. Press 'R' to reboot now or any other key to skip."    $choice = $null    $startTime = Get-Date    $Trigger= New-ScheduledTaskTrigger -AtStartup    $User= "NT AUTHORITY\SYSTEM"    $Action= New-ScheduledTaskAction -Execute "$destinationPath\Installd3.cmd"    Register-ScheduledTask -TaskName "Install d3" -Trigger $Trigger -User $User -Action $Action -RunLevel Highest –Force    'SCHTASKS /DELETE /TN "Install d3" /F' | Out-File "$destinationPath\Installd3.cmd" -Encoding ascii    $InstallParametersSched | Out-File "$destinationPath\Installd3.cmd" -Append -Encoding ascii    "del $destinationPath\*.* /q /F" | Out-File "$destinationPath\Installd3.cmd" -Append -Encoding ascii    Log "Displaying a dialog with the prompt 'Do you want to restart now' and buttons Yes/No"

    Add-Type -AssemblyName System.Windows.Forms

    # Display the MessageBox
    $result = [System.Windows.Forms.MessageBox]::Show(
        "Die d.3 Smart Explorer installation benötigt einen Neustart. Möchten Sie jetzt neu starten?",
        "d.3 Neustart erforderlich",
        [System.Windows.Forms.MessageBoxButtons]::YesNo,
        [System.Windows.Forms.MessageBoxIcon]::Question
    )

    # Check the result
    if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
        Log "User selected Yes. Performing restart..."
        # Reboot the machine        Log "Rebooting the machine..."        Restart-Computer -Force
    } else {
        Log "User selected No. Initiating soft reboot."
        exit 3010
    }}else{    Start-Process "msiexec.exe" -ArgumentList "/i $InstallParameters" -Wait -PassThru    Log "Finished"}