function Get-MerakiNetworkSwitchDHCPServerPolicyArpInspWarningsByDevice {
<#
.SYNOPSIS
    Gets the ARP inspection warnings by device for a Meraki network switch.
.DESCRIPTION
    This function retrieves the ARP inspection warnings by device for a Meraki network switch using the Meraki Dashboard API.
.PARAMETER AuthToken
    The API authentication token for the Meraki Dashboard.
.PARAMETER networkId
    The ID of the Meraki network to retrieve the ARP inspection warnings by device for.
.PARAMETER perPage
    The number of entries per page to return. Default is 10.
.PARAMETER startingAfter
    A token used to retrieve the next page of results. This is obtained from the 'nextPage' property in the response of the previous call. Default is null.
.PARAMETER endingBefore
    A token used to retrieve the previous page of results. This is obtained from the 'previousPage' property in the response of the previous call. Default is null.
.EXAMPLE
    PS C:\> Get-MerakiNetworkSwitchDHCPServerPolicyArpInspWarningsByDevice -AuthToken "api_token" -networkId "L_123456789"
    Returns the ARP inspection warnings by device for the specified Meraki network switch.
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
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/switch/dhcpServerPolicy/arpInspection/warnings/byDevice?$queryString"
        $URI = [uri]::EscapeUriString($URL)
        $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    } catch {
        Write-Error "Failed to retrieve ARP inspection warnings by device for network '$networkId'. Error: $_"
    }
}
