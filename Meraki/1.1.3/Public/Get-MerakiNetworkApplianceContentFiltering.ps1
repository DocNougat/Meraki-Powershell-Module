function Get-MerakiNetworkApplianceContentFiltering {
    <#
    .SYNOPSIS
    Retrieves the content filtering settings for a given network.

    .DESCRIPTION
    This function retrieves the content filtering settings for a given network in the Meraki dashboard using the API. It requires an API key with organization-level or network-level access.

    .PARAMETER AuthToken
    The Meraki API key used to authenticate and authorize API requests.

    .PARAMETER NetworkId
    The ID of the network for which to retrieve the content filtering settings.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkApplianceContentFiltering -AuthToken "1234" -NetworkId "abcd"
    Returns the content filtering settings for the network with ID "abcd" using the Meraki API key "1234".

    .NOTES
    For more information, see the Meraki API documentation:
    https://developer.cisco.com/meraki/api-v1/#!get-network-appliance-content-filtering
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
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/contentFiltering" -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
