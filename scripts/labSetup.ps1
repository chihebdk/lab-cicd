

$vw_installed = ( Get-ChildItem "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\App Paths" | where Name -like "*vmware*").Length -gt 0;
$install_cmd = "..\vSphere-Installers\VMware-workstation-full-12.5.8-7098237.exe"
$arguments = '/s /v/qn EULAS_AGREED=1 SERIALNUMBER="142AH-ZKH91-68E9A-0A2UH-1HY6M" AUTOSOFTWAREUPDATE=1'
$lab_esxi = "LAB_ESXi_6_5"
$lab_esxi_dir = "..\vms\$lab_esxi"
$lab_esxi_ova = "..\vSphere-Installers\$lab_esxi.ova"

if (-Not $vw_installed) {
    Write-Host "Installing VMware Workstation ..."
    Start-Process -FilePath $install_cmd -Verb runAs -ArgumentList $arguments -Wait
    Write-Output "Done!"
}

$path = (Get-ChildItem "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\App Paths" | where Name -like "*vmware*" | Get-ItemProperty).Path
$ENV:Path = $ENV:Path + ";$Path" + ";$PATH\OVFTool"

if (-Not (Test-Path $lab_esxi_dir)) {
    ovftool.exe "$lab_esxi_ova" "$lab_esxi_dir.vmx"
}

if (Test-Path $lab_esxi_dir\*.*.lck) {
    #vmrun.exe reset ..\vms\LAB_ESXi_6_5\LAB_ESXi_6_5.vmx nogui
} else {
    vmrun.exe start ..\vms\LAB_ESXi_6_5\LAB_ESXi_6_5.vmx nogui
}

vmrun.exe list

vmrun.exe -gu root -gp p@ssw0rd copyFileFromGuestToHost ..\vms\LAB_ESXi_6_5\LAB_ESXi_6_5.vmx /etc/dhclient-vmk0.leases  .\dhcp-lease

(Get-Content .\dhcp-lease | select-string -pattern 'fixed' | select -last 1) -match "(\b\d*\.\d*\.\d*\.\d*\b)"

$esxi_ip = $Matches[0]

Write-Host $esxi_ip