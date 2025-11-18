function Get-MerakiNetworkHealthAlerts {
    <#
    .SYNOPSIS
    Retrieve the list of all health alerts for a specified network.
    
    .DESCRIPTION
    This function retrieves the list of all health alerts for a specified network in the Meraki dashboard.
    
    .PARAMETER AuthToken
    Specifies the Meraki API token to use for authorization.
    
    .PARAMETER NetworkId
    Specifies the network ID for the network you want to retrieve health alerts for.
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkHealthAlerts -AuthToken "1234" -NetworkId "N_123456"
    
    This example retrieves the list of all health alerts for the network with ID "N_123456" using the API token "1234".
    
    .NOTES
    For more information about the Meraki API and available parameters, see the official documentation:
    https://developer.cisco.com/meraki/api-v1/
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/health/alerts" -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
