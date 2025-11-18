function Get-MerakiOrganizationWirelessClientsOverviewByDevice {
    <#
    .SYNOPSIS
    Retrieves a paginated overview of wireless clients grouped by device for a Meraki organization.

    .DESCRIPTION
    Get-MerakiOrganizationWirelessClientsOverviewByDevice queries the Meraki Dashboard API to return an overview of wireless clients aggregated by device for the specified organization. The function supports pagination and filtering by network IDs, device serials, and campus gateway cluster IDs. Arrays passed to networkIds, serials, or campusGatewayClusterIds are converted to comma-separated query parameters.

    .PARAMETER AuthToken
    The Meraki API key (X-Cisco-Meraki-API-Key). This parameter is required.

    .PARAMETER OrganizationID
    The Meraki organization ID to query. If not provided, the function attempts to resolve the organization ID using Get-OrgID -AuthToken $AuthToken. If multiple organizations are found by Get-OrgID, the function will return the text "Multiple organizations found. Please specify an organization ID." and will not proceed.

    .PARAMETER perPage
    (Optional) The number of entries to return per page. Passed to the API as the perPage query parameter.

    .PARAMETER startingAfter
    (Optional) A cursor for pagination. Used to request the page after the provided cursor. Passed to the API as the startingAfter query parameter.

    .PARAMETER endingBefore
    (Optional) A cursor for pagination. Used to request the page before the provided cursor. Passed to the API as the endingBefore query parameter.

    .PARAMETER networkIds
    (Optional) An array of network IDs to limit results to specific networks. The array is converted to a comma-separated string and passed as the networkIds query parameter.

    .PARAMETER serials
    (Optional) An array of device serial numbers to limit results to specific devices. The array is converted to a comma-separated string and passed as the serials query parameter.

    .PARAMETER campusGatewayClusterIds
    (Optional) An array of campus gateway cluster IDs to filter results. The array is converted to a comma-separated string and passed as the campusGatewayClusterIds query parameter.

    .EXAMPLE
    # Basic usage with API key and explicit organization ID
    Get-MerakiOrganizationWirelessClientsOverviewByDevice -AuthToken 'ABC123' -OrganizationID '123456'

    .NOTES
    - Requires network access to api.meraki.com.
    - Ensure the provided API key has sufficient permissions for the target organization.
    - If Get-OrgID resolves to multiple organizations, supply the OrganizationID explicitly.
    - Query parameter arrays are joined with commas to match Meraki API expectations.
    - This function throws on HTTP or invocation errors; use try/catch when calling if you need to handle errors gracefully.

    .LINK
    https://developer.cisco.com/meraki/api-v1/#!get-organization-wireless-clients-overview-by-device
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$false)]
        [int]$perPage,
        [parameter(Mandatory=$false)]
        [string]$startingAfter,
        [parameter(Mandatory=$false)]
        [string]$endingBefore,
        [parameter(Mandatory=$false)]
        [array]$networkIds,
        [parameter(Mandatory=$false)]
        [array]$serials,
        [parameter(Mandatory=$false)]
        [array]$campusGatewayClusterIds
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try { 
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
            }
            $queryParams = @{}
            
            If ($perPage) { 
                $queryParams.perPage = $perPage 
            }
            If ($startingAfter) { 
                $queryParams.startingAfter = $startingAfter 
            }
            If ($endingBefore) { 
                $queryParams.endingBefore = $endingBefore 
            }
            If ($networkIds) { 
                $queryParams.networkIds = ($networkIds -join ",") 
            }
            If ($serials) { 
                $queryParams.serials = ($serials -join ",") 
            }
            If ($campusGatewayClusterIds) { 
                $queryParams.campusGatewayClusterIds = ($campusGatewayClusterIds -join ",") 
            }

            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/wireless/clients/overview/byDevice?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}