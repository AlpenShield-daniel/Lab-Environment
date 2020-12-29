#Requires -Version 5

function Install-DSC-Modules
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet("DC","ADFS",'Endpoint')]
        [string]$SetupType,

        [Parameter(Mandatory=$false)]
        [ValidateSet('TrustedSigned','SelfSigned')]
        [string]$CertificateType

    )
    Set-ExecutionPolicy Unrestricted -Force

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

    Install-Module -Name ActiveDirectoryDsc -RequiredVersion 6.0.1
    Install-Module -Name NetworkingDsc -RequiredVersion 8.2.0
    Install-Module -Name xPSDesiredStateConfiguration -RequiredVersion 9.1.0
    Install-Module -Name ComputerManagementDsc -RequiredVersion 8.4.0

    if ($SetupType -eq 'DC')
    {
        Install-Module -Name xDnsServer -RequiredVersion 1.16.0.0
        Install-Module -Name xSmbShare -Force
        Install-Module -Name MSOnline -Force
        Install-Module -Name AzureAD -Force

        if ($CertificateType -eq 'SelfSigned')
        {
            Install-Module -Name ActiveDirectoryCSDsc -RequiredVersion 5.0.0
            Install-Module -Name CertificateDsc -RequiredVersion 5.0.0
        }
    }
}