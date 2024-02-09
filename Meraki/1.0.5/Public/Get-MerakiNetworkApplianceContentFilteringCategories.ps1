function Get-MerakiNetworkApplianceContentFilteringCategories {
    <#
    .SYNOPSIS
    Get the content filtering categories for a Meraki network's appliance.
    
    .DESCRIPTION
    This function retrieves the content filtering categories configured for a Meraki network's appliance.
    
    .PARAMETER AuthToken
    The Meraki API token.
    
    .PARAMETER NetworkId
    The ID of the Meraki network.
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkApplianceContentFilteringCategories -AuthToken '1234' -NetworkId 'L_1234'
    
    Retrieves the content filtering categories for the network with ID 'L_1234'.
    
    .NOTES
    For more information, see: https://developer.cisco.com/meraki/api-v1/#!get-network-appliance-content-filtering-categories
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [string]$AuthToken,
        [parameter(Mandatory = $true)]
        [string]$NetworkId
    )

    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/contentFiltering/categories" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Host $_
        Throw $_
    }
}