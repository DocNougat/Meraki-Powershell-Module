function Get-MerakiNetworkApplianceVlans {
    <#
    .SYNOPSIS
    Retrieves the list of VLANs for a Meraki network's appliance.
    
    .DESCRIPTION
    This function retrieves the list of VLANs configured on the specified Meraki network's appliance.
    
    .PARAMETER AuthToken
    The Meraki API authentication token.
    
    .PARAMETER NetworkId
    The Meraki network ID.
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkApplianceVlans -AuthToken "1234" -NetworkId "L_1234"

    This example retrieves the list of VLANs configured on the Meraki network with the ID "L_1234", using the Meraki API authentication token "1234".
    
    .NOTES
    For more information on using the Meraki Dashboard API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId
    )

    $header = @{
        'X-Cisco-Meraki-API-Key' = $AuthToken
    }

    try {
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/vlans" -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}