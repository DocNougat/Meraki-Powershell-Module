function Get-MerakiNetworkSmDeviceCellularUsageHistory {
    <#
    .SYNOPSIS
    Retrieves the cellular usage history for a device in a Meraki network using the Cisco Meraki API.

    .DESCRIPTION
    This function retrieves the cellular usage history for a device in a Meraki network using the Cisco Meraki API.

    .PARAMETER AuthToken
    The Cisco Meraki API key for the dashboard. Required.

    .PARAMETER NetworkId
    The ID of the Meraki network to retrieve the cellular usage history for. Required.

    .PARAMETER DeviceId
    The ID of the Meraki device to retrieve the cellular usage history for. Required.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkSmDeviceCellularUsageHistory -AuthToken '1234' -NetworkId 'N_12345678' -DeviceId 'Q_12345678'

    Retrieves the cellular usage history for the Meraki device with ID 'Q_12345678' in the Meraki network with ID 'N_12345678', using the API key '1234'.

    .NOTES
    For more information on the Cisco Meraki API, see the documentation at https://developer.cisco.com/meraki/api-v1/.
    #>
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$DeviceId
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/sm/devices/$deviceId/cellularUsageHistory" -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}