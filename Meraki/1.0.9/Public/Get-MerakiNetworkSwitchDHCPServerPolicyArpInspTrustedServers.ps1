function Get-MerakiNetworkSwitchDHCPServerPolicyArpInspTrustedServers {
    <#
    .SYNOPSIS
        Gets the list of trusted ARP inspection DHCP servers for a Meraki network switch.
    .DESCRIPTION
        This function retrieves the list of trusted ARP inspection DHCP servers for a Meraki network switch using the Meraki Dashboard API.
    .PARAMETER AuthToken
        The API authentication token for the Meraki Dashboard.
    .PARAMETER networkId
        The ID of the Meraki network to retrieve the list of trusted ARP inspection DHCP servers for.
    .PARAMETER perPage
        The number of entries per page to return. Default is 10.
    .PARAMETER startingAfter
        A token used to retrieve the next page of results. This is obtained from the 'nextPage' property in the response of the previous call. Default is null.
    .PARAMETER endingBefore
        A token used to retrieve the previous page of results. This is obtained from the 'previousPage' property in the response of the previous call. Default is null.
    .EXAMPLE
        PS C:\> Get-MerakiNetworkSwitchDHCPServerPolicyArpInspTrustedServers -AuthToken "api_token" -networkId "L_123456789"
        Returns the list of trusted ARP inspection DHCP servers for the specified Meraki network switch.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$networkId,
        [Parameter(Mandatory=$false)]
        [int]$perPage = 10,
        [Parameter(Mandatory=$false)]
        [string]$startingAfter = $null,
        [Parameter(Mandatory=$false)]
        [string]$endingBefore = $null
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $queryParams = @{
            "perPage" = $perPage
            "startingAfter" = $startingAfter
            "endingBefore" = $endingBefore
        }
        $queryString = New-MerakiQueryString -queryParams $queryParams
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/switch/dhcpServerPolicy/arpInspection/trustedServers?$queryString"
        $URI = [uri]::EscapeUriString($URL)
        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
