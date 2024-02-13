function Get-MerakiNetwork {
    <#
    .SYNOPSIS
    Retrieves details of a specific Meraki network.
    
    .DESCRIPTION
    This function retrieves the details of a specific Meraki network using the Meraki Dashboard API. You must have the network ID and a valid API key with the "read-only" privilege to execute this function.
    
    .PARAMETER AuthToken
    The Meraki Dashboard API key with the "read-only" privilege.
    
    .PARAMETER NetworkId
    The ID of the Meraki network you want to retrieve.
    
    .EXAMPLE
    PS C:\> Get-MerakiNetwork -AuthToken "12345" -NetworkId "L_123456789012345678"
    
    This example retrieves the details of the Meraki network with ID "L_123456789012345678" using the API key "12345".
    
    .NOTES
    For more information about the Meraki Dashboard API, see the official documentation at https://developer.cisco.com/meraki/api/.
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    } 
    catch {
        Write-Debug $_
        Throw $_
    }
}
