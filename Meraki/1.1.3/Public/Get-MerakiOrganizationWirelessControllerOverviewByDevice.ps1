function Get-MerakiOrganizationWirelessControllerOverviewByDevice {
    <#
    .SYNOPSIS
    Retrieves a wireless controller overview by device for a Meraki organization.

    .DESCRIPTION
    Get-MerakiOrganizationWirelessControllerOverviewByDevice queries the Cisco Meraki Dashboard API to return an overview of wireless controller data broken down by device for the specified organization. The function supports optional filtering by device serial numbers and network IDs and supports pagination parameters (perPage, startingAfter, endingBefore). If OrganizationID is not supplied, the function attempts to resolve it via Get-OrgID -AuthToken $AuthToken. If multiple organizations are found, the function will return an error instructing the caller to specify an organization ID.

    .PARAMETER AuthToken
    The Cisco Meraki API key (X-Cisco-Meraki-API-Key). This parameter is mandatory.

    .PARAMETER OrganizationID
    The Meraki organization ID to query. If omitted, the function calls Get-OrgID -AuthToken $AuthToken to determine the organization ID. If multiple organizations are returned by Get-OrgID, the function will return an error asking the user to specify the organization ID explicitly.

    .PARAMETER perPage
    (Optional) Integer indicating the number of items to return per page. Passed to the API as the perPage query parameter.

    .PARAMETER startingAfter
    (Optional) Pagination cursor. Passes startingAfter to the API to return entries after the specified cursor.

    .PARAMETER endingBefore
    (Optional) Pagination cursor. Passes endingBefore to the API to return entries before the specified cursor.

    .PARAMETER serials
    (Optional) Array of device serial numbers to filter the results. Sent as serials[] query parameters.

    .PARAMETER networkIds
    (Optional) Array of network IDs to filter the results. Sent as networkIds[] query parameters.

    .EXAMPLE
    # Basic usage with API key (OrganizationID resolved automatically)
    $results = Get-MerakiOrganizationWirelessControllerOverviewByDevice -AuthToken 'REDACTED_API_KEY'

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
        [array]$serials,
        [parameter(Mandatory=$false)]
        [array]$networkIds
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
                $queryParams["perPage"] = $perPage 
            }
            If ($startingAfter) { 
                $queryParams["startingAfter"] = $startingAfter 
            }
            If ($endingBefore) { 
                $queryParams["endingBefore"] = $endingBefore 
            }
            If ($serials) { 
                $queryParams["serials[]"] = $serials
            }
            If ($networkIds) { 
                $queryParams["networkIds[]"] = $networkIds
            }
                    
            $queryString = New-MerakiQueryString -queryParams $queryParams

            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/wirelessController/overview/byDevice?$queryString"

            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}