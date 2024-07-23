function Get-MerakiDeviceCameraWirelessProfiles {
    <#
    .SYNOPSIS
        Gets the wireless profiles configured on a specific Cisco Meraki camera by serial number.
    .DESCRIPTION
        This function makes a REST API call to the Meraki dashboard API to retrieve information about the wireless profiles configured on a specific Cisco Meraki camera, based on its serial number. The function returns detailed information about each wireless profile, including its SSID, encryption mode, and VLAN ID.
    .PARAMETER AuthToken
        The authentication token to use for the API call. This should be a valid API key for the Meraki dashboard.
    .PARAMETER deviceSerial
        The serial number of the Cisco Meraki camera to retrieve wireless profile information for.
    .EXAMPLE
        PS C:\> Get-MerakiDeviceCameraWirelessProfiles -AuthToken "myapikey" -deviceSerial "Q2XX-XXXX-XXXX"
        Returns information about the wireless profiles configured on the Cisco Meraki camera with the specified serial number.
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
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/devices/$DeviceSerial/camera/wirelessProfiles" -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
