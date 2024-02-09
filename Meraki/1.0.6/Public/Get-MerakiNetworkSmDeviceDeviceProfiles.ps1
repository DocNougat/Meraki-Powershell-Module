function Get-MerakiNetworkSmDeviceDeviceProfiles {
    <#
    .SYNOPSIS
    Retrieves a list of device profiles associated with a specified device in a Meraki SM network.

    .DESCRIPTION
    This function uses the Meraki Dashboard API to retrieve a list of device profiles associated with a specified device in a Meraki SM network.

    .PARAMETER AuthToken
    The Meraki Dashboard API token.

    .PARAMETER NetworkId
    The Meraki network ID.

    .PARAMETER DeviceId
    The ID of the device for which to retrieve the list of profiles.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkSmDeviceDeviceProfiles -AuthToken '1234' -NetworkId 'N_123456' -DeviceId 'M_123456'

    Retrieves a list of device profiles associated with the device with ID 'M_123456' in the Meraki network with ID 'N_123456'.

    .NOTES
    For more information on the Meraki Dashboard API, see https://developer.cisco.com/meraki/api-v1/.
    #>

    param (
        [parameter(Mandatory = $true)]
        [string] $AuthToken,
        [parameter(Mandatory = $true)]
        [string] $NetworkId,
        [parameter(Mandatory = $true)]
        [string] $DeviceId
    )

    $header = @{
        "X-Cisco-Meraki-API-Key" = $AuthToken
    }
    
    try {
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/sm/devices/$deviceId/deviceProfiles" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Host $_
        Throw $_
    }
}
