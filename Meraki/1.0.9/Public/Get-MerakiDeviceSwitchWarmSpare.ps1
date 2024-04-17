function Get-MerakiDeviceSwitchWarmSpare {
    <#
    .SYNOPSIS
    Gets the warm spare configuration for a switch device.
    
    .DESCRIPTION
    The Get-MerakiDeviceSwitchWarmSpare function retrieves the warm spare configuration of the specified switch device.
    
    .PARAMETER AuthToken
    Specifies the Meraki Dashboard API key to use for authentication.
    
    .PARAMETER deviceSerial
    Specifies the serial number of the switch device.
    
    .EXAMPLE
    PS C:\> Get-MerakiDeviceSwitchWarmSpare -AuthToken "1234" -deviceSerial "Q234-ABCD-5678"
    
    Retrieves the warm spare configuration for the switch device with serial number "Q234-ABCD-5678" using the API key "1234".
    
    .NOTES
    For more information about warm spare, see: https://documentation.meraki.com/MS/Deployment_Guides/MS_Switch_Warm_Spare_Deployment_Guide
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$DeviceSerial
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/devices/$DeviceSerial/switch/warmSpare" -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}