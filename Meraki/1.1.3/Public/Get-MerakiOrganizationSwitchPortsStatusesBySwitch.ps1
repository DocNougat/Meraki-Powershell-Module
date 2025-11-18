function Get-MerakiOrganizationSwitchPortsStatusesBySwitch {
    <#
    .SYNOPSIS
    Retrieves switch port statuses grouped by switch for a Meraki organization.

    .DESCRIPTION
    Calls the Meraki Dashboard API endpoint to get switch port statuses by switch for a specified organization. Supports pagination and multiple filtering options (MAC addresses, serial numbers, network IDs, port profile IDs, name, and configuration update time). If OrganizationID is not provided, the function attempts to resolve it using Get-OrgID -AuthToken <AuthToken>. Array parameters are sent as repeated query parameters (e.g., macs[]=...).

    .PARAMETER AuthToken
    The Meraki Dashboard API key used for authentication. This parameter is required.

    .PARAMETER OrganizationID
    The Meraki organization ID to query. If omitted, the function attempts to resolve the organization ID via Get-OrgID. If multiple organizations are found, the function returns a message instructing the caller to specify an organization ID.

    .PARAMETER perPage
    Number of items to return per page (used for pagination).

    .PARAMETER startingAfter
    Pagination cursor; return results starting after this value.

    .PARAMETER endingBefore
    Pagination cursor; return results ending before this value.

    .PARAMETER configurationUpdatedAfter
    Filter to include only ports whose configuration was updated after the specified timestamp (use ISO 8601 format).

    .PARAMETER mac
    Filter results to a single MAC address.

    .PARAMETER macs
    Array of MAC addresses to filter by. Sent as repeated macs[] query parameters.

    .PARAMETER name
    Filter results by switch or port name.

    .PARAMETER networkIds
    Array of network IDs to filter by. Sent as repeated networkIds[] query parameters.

    .PARAMETER portProfileIds
    Array of port profile IDs to filter by. Sent as repeated portProfileIds[] query parameters.

    .PARAMETER serial
    Filter results to a single device serial number.

    .PARAMETER serials
    Array of device serial numbers to filter by. Sent as repeated serials[] query parameters.

    .EXAMPLE
    # Request 100 items per page and filter by multiple networks and serials
    Get-MerakiOrganizationSwitchPortsStatusesBySwitch -AuthToken $apiKey -OrganizationID "123456" -perPage 100 -networkIds @("N_1","N_2") -serials @("Q2XX-XXXX-XXXX","Q2YY-YYYY-YYYY")

    .NOTES
    - The function sets the "X-Cisco-Meraki-API-Key" HTTP header with the provided AuthToken.
    - Ensure your AuthToken has sufficient privileges to query the target organization.
    - Date/time filters should be provided in a format accepted by the Meraki API (ISO 8601 recommended).
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
        [string]$configurationUpdatedAfter = $null,
        [parameter(Mandatory=$false)]
        [string]$mac,
        [parameter(Mandatory=$false)]
        [array]$macs,
        [parameter(Mandatory=$false)]
        [string]$name,
        [parameter(Mandatory=$false)]
        [array]$networkIds,
        [parameter(Mandatory=$false)]
        [array]$portProfileIds,
        [parameter(Mandatory=$false)]
        [string]$serial,
        [parameter(Mandatory=$false)]
        [array]$serials
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try { 
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
            }
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
            if ($configurationUpdatedAfter) {
                $queryParams['configurationUpdatedAfter'] = $configurationUpdatedAfter
            }
            if ($mac) {
                $queryParams['mac'] = $mac
            }
            if ($macs) {
                $queryParams['macs[]'] = $macs
            }
            if ($name) {
                $queryParams['name'] = $name
            }
            if ($networkIds) {
                $queryParams['networkIds[]'] = $networkIds
            }
            if ($portProfileIds) {
                $queryParams['portProfileIds[]'] = $portProfileIds
            }
            if ($serial) {
                $queryParams['serial'] = $serial
            }
            if ($serials) {
                $queryParams['serials[]'] = $serials
            }
        
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/switch/ports/statuses/bySwitch?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}