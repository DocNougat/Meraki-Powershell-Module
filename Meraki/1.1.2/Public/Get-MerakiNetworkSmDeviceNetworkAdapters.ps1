function Get-MerakiNetworkSmDeviceNetworkAdapters {
    <#
    .SYNOPSIS
    Retrieves the network adapters of a Systems Manager device in a given network.

    .DESCRIPTION
    This function retrieves the network adapters of a Systems Manager device in a given network. It requires an authentication token with read access to the network.

    .PARAMETER AuthToken
    Specifies the Meraki API token to use for authentication.

    .PARAMETER networkId
    Specifies the ID of the network containing the device.

    .PARAMETER deviceId
    Specifies the ID of the device to retrieve network adapters for.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkSmDeviceNetworkAdapters -AuthToken "1234" -networkId "N_12345678" -deviceId "1234"

    Returns the network adapters of the device with ID "1234" in the network with ID "N_12345678".

    .NOTES
    For more information on the Meraki Dashboard API, please refer to https://developer.cisco.com/meraki/api-v1/.
    #>
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$networkId,
        [parameter(Mandatory=$true)]
        [string]$deviceId
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/sm/devices/$deviceId/networkAdapters" -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
