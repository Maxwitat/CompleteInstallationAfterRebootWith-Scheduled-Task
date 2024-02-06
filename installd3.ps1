﻿#------------Functions---------------------------------------------------------------------------------
function Log([string]$LogString) 
{
    Write-Host "$(Get-Date -Format "dd.MM.yyyy HH:mm:ss,ff") $($LogString)"
    Add-Content -Path $logFile -Value "$(Get-Date -Format "dd.MM.yyyy HH:mm:ss,ff") $($LogString)"
}

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
}
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
    "{E98CF33C-E605-4C79-B639-164062122C6C}"

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
        # Reboot the machine
    } else {
        Log "User selected No. Initiating soft reboot."
        exit 3010
    }