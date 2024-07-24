function Get-MerakiOrganizationApplianceTrafficShapingVpnExclusionsByNet {
    <#
    .SYNOPSIS
    Retrieves VPN exclusions for a specified Meraki organization.

    .DESCRIPTION
    The Get-MerakiOrganizationApplianceTrafficShapingVpnExclusionsByNet function retrieves VPN exclusions for a specified Meraki organization using the Meraki API. You must provide an API authentication token and the organization ID as parameters.

    .PARAMETER AuthToken
    The Meraki API authentication token.

    .PARAMETER OrganizationID
    The ID of the organization to retrieve VPN exclusions for.

    .PARAMETER perPage
    The number of entries per page. Default is 50.

    .PARAMETER startingAfter
    A token used to retrieve the next page of results.

    .PARAMETER endingBefore
    A token used to retrieve the previous page of results.

    .PARAMETER networkIds
    Optional parameter to filter the results by network IDs.

    .EXAMPLE
    Get-MerakiOrganizationApplianceTrafficShapingVpnExclusionsByNet -AuthToken '12345' -OrganizationID 'L_123456789'

    This example retrieves VPN exclusions for the Meraki organization with ID 'L_123456789' using the Meraki API authentication token '12345'.

    .NOTES
    For more information about the Meraki API, see https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [Parameter(Mandatory=$false)]
        [int]$perPage = 50,
        [Parameter(Mandatory=$false)]
        [string]$startingAfter,
        [Parameter(Mandatory=$false)]
        [string]$endingBefore,
        [Parameter(Mandatory=$false)]
        [string]$networkIds
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                'X-Cisco-Meraki-API-Key' = $AuthToken
            }

            $queryParams = @{}

            if ($perPage) {
                $queryParams['perPage'] = $perPage
            }
            if ($perPage) {
                $queryParams['startingAfter'] = $startingAfter
            }
            if ($perPage) {
                $queryParams['endingBefore'] = $endingBefore
            }
            if ($perPage) {
                $queryParams['networkIds'] = $networkIds
            }

            $queryString = New-MerakiQueryString -queryParams $queryParams

            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/appliance/trafficShaping/vpnExclusions/byNetwork?$queryString"

            $URI = [uri]::EscapeUriString($URL)

            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}