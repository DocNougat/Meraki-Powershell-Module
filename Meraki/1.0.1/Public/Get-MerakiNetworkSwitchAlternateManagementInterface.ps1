function Get-MerakiNetworkSwitchAlternateManagementInterface {
    <#
    .SYNOPSIS
    Retrieves the alternate management interface configuration for a network's switch devices.

    .DESCRIPTION
    This function retrieves the alternate management interface configuration for all switch devices in a network. If the configuration is the same across all devices, the returned dictionary will only have one entry.

    .PARAMETER AuthToken
    The Meraki API token.

    .PARAMETER NetworkId
    The ID of the network to retrieve the alternate management interface configuration for.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkSwitchAlternateManagementInterface -AuthToken "1234" -NetworkId "N_1234"

    This command retrieves the alternate management interface configuration for all switch devices in the network with ID "N_1234".

    .NOTES
    For more information on the API endpoint, please see:
    https://developer.cisco.com/meraki/api-v1/#!get-network-switch-alternate-management-interface
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/switch/alternateManagementInterface" -Header $header
        return $response
    }
    catch {
        Write-Error "Error retrieving alternate management interface configuration: $_"
    }
}
