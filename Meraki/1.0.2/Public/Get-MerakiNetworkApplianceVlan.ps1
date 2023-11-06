function Get-MerakiNetworkApplianceVlan {
    <#
    .SYNOPSIS
    Retrieves a specific VLAN for a Meraki network appliance.
    
    .DESCRIPTION
    This function uses the Meraki Dashboard API to retrieve a specific VLAN for a Meraki network appliance.
    
    .PARAMETER AuthToken
    The API key for the Meraki Dashboard.
    
    .PARAMETER NetworkId
    The ID of the Meraki network that the appliance belongs to.
    
    .PARAMETER VlanId
    The ID of the VLAN to retrieve.
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkApplianceVlan -AuthToken "1234" -NetworkId "abcd" -VlanId "1"
    
    Returns the VLAN with ID "1" for the network with ID "abcd" using the API key "1234".
    
    .NOTES
    For more information on the Meraki Dashboard API, visit https://developer.cisco.com/meraki/api/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$VlanId
    )
    
    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/vlans/$VlanId" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Error "Error retrieving VLAN $VlanId for network '$NetworkId': $_"
    }
}
