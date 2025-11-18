function Get-MerakiNetworkApplianceFirewallFirewalledServices {
    <#
    .SYNOPSIS
    Retrieves a list of firewalled services for a specified network or details for a specific firewalled service.

    .DESCRIPTION
    Retrieves a list of firewalled services for a specified network or details for a specific firewalled service.
    
    .PARAMETER AuthToken
    Meraki Dashboard API key
    
    .PARAMETER NetworkId
    Network ID of the target Meraki network
    
    .PARAMETER perPage
    The number of entries per page returned
    
    .PARAMETER startingAfter
    A token used by the server to indicate the start of the page
    
    .PARAMETER endingBefore
    A token used by the server to indicate the end of the page
    
    .PARAMETER service
    The ID of a specific firewalled service for which to retrieve details
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkApplianceFirewallFirewalledServices -AuthToken '12345' -NetworkId 'N_12345' -service 'FTP'
    Retrieves details for the FTP firewalled service in the specified Meraki network.
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkApplianceFirewallFirewalledServices -AuthToken '12345' -NetworkId 'N_12345' -perPage 50
    Retrieves the first 50 firewalled services for the specified Meraki network.
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkApplianceFirewallFirewalledServices -AuthToken '12345' -NetworkId 'N_12345' -startingAfter 'FTP'
    Retrieves the list of firewalled services for the specified Meraki network starting after the FTP service.
    
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$AuthToken,
        [Parameter(Mandatory = $true)]
        [string]$NetworkId,
        [Parameter(Mandatory = $false)]
        [int]$perPage,
        [Parameter(Mandatory = $false)]
        [string]$startingAfter,
        [Parameter(Mandatory = $false)]
        [string]$endingBefore,
        [Parameter(Mandatory = $false)]
        [string]$service
    )

    $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/firewall/firewalledServices"
    $queryParams = @{}
    if ($perPage) {
        $queryParams['perPage'] = $perPage
    }
    if ($startingAfter) {
        $queryParams['startingAfter'] = $startingAfter
    }
    if ($endingBefore) {
        $queryParams['endingBefore'] = $endingBefore
    }
    if ($service) {
        $uri += "/$service"
    }

    $queryString = New-MerakiQueryString -queryParams $queryParams

    $header = @{
        'X-Cisco-Meraki-API-Key' = $AuthToken
    }

    try {
        $response = Invoke-RestMethod -Method Get -Uri "$uri$queryString" -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}