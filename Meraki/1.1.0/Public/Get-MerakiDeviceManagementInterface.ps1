function Get-MerakiDeviceManagementInterface {
<#
.SYNOPSIS
    Retrieve the management interface of a Cisco Meraki device.

.DESCRIPTION
    This function retrieves the management interface of a Cisco Meraki device.

.PARAMETER AuthToken
    The authentication token used for accessing the Meraki API.
    
.PARAMETER deviceSerial
    The serial number of the device.

.EXAMPLE
    PS> Get-MerakiDeviceManagementInterface -AuthToken $AuthToken -deviceSerial ABC123
    
    Returns the management interface of the device with serial number ABC123.

.NOTES
    For more information about the API endpoint, please refer to the Meraki documentation:
    https://developer.cisco.com/meraki/api-v1/#!get-device-management-interface
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/devices/$DeviceSerial/managementInterface" -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
