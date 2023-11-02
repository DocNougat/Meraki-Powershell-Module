function Get-MerakiNetworkSwitchAccessPolicy {
    <#
    .SYNOPSIS
    Retrieve a specific access policy for a Meraki network switch.
    
    .DESCRIPTION
    This function retrieves a specific access policy for a Meraki network switch using the Meraki Dashboard API. The function requires an API key, the network ID, and the access policy number.
    
    .PARAMETER AuthToken
    Specifies the API key for the Meraki Dashboard.
    
    .PARAMETER NetworkId
    Specifies the network ID of the Meraki network.
    
    .PARAMETER AccessPolicyNumber
    Specifies the access policy number of the Meraki network switch.
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkSwitchAccessPolicy -AuthToken '1234' -NetworkId 'abcd' -AccessPolicyNumber '1'
    
    Returns the access policy for the Meraki network switch with the access policy number '1' in the network with the ID 'abcd'.
    
    .NOTES
    For more information on the Meraki Dashboard API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$AccessPolicyNumber
    )

    $header = @{
        "X-Cisco-Meraki-API-Key" = $AuthToken
    }

    $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/accessPolicies/$AccessPolicyNumber"

    try {
        $response = Invoke-RestMethod -Method Get -Uri $uri -Header $header -ErrorAction Stop
        return $response
    } catch {
        Write-Error $_
    }
}
