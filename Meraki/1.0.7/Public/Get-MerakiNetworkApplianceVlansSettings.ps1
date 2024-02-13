function Get-MerakiNetworkApplianceVlansSettings {
    <#
    .SYNOPSIS
    Retrieves the VLAN settings for a Meraki network's appliance.
    
    .DESCRIPTION
    This function uses the Meraki Dashboard API to retrieve the VLAN settings for a Meraki network's appliance. It requires an API key with the necessary permissions to access the Dashboard API, as well as the ID of the target network.
    
    .PARAMETER AuthToken
    The API key for the Meraki Dashboard API. This key must have the necessary permissions to access the API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network for which to retrieve the VLAN settings.
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkApplianceVlansSettings -AuthToken "1234" -NetworkId "5678"
    
    Retrieves the VLAN settings for the Meraki network with ID "5678", using the API key "1234".
    
    .NOTES
     For more information on using the Meraki Dashboard API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/vlans/settings" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}