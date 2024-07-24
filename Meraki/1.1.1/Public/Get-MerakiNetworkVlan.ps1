function Get-MerakiNetworkVlan {
    <#
    .SYNOPSIS
    Retrieves the VLAN configuration for a specific VLAN ID in a Meraki network.

    .DESCRIPTION
    This function uses the Meraki Dashboard API to retrieve the VLAN configuration for a specific VLAN ID in a Meraki network.

    .PARAMETER AuthToken
    The Meraki Dashboard API token.

    .PARAMETER NetworkId
    The ID of the Meraki network to retrieve the VLAN configuration from.

    .PARAMETER vlanID
    The VLAN ID of the VLAN configuration to retrieve.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkVlan -AuthToken "1234" -NetworkId "5678" -vlanID "10"

    This command retrieves the VLAN configuration for VLAN ID 10 in the Meraki network with ID 5678.

    .NOTES
    For more information on the Meraki Dashboard API, please visit:
    https://developer.cisco.com/meraki/api-v1/
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$vlanID
    )

    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/vlans/$vlanID" -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
