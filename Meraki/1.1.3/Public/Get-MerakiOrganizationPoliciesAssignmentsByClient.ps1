function Get-MerakiOrganizationPoliciesAssignmentsByClient {
    <#
    .SYNOPSIS
    Retrieves Meraki policy assignments grouped by client for one or more networks in an organization.

    .DESCRIPTION
    Get-MerakiOrganizationPoliciesAssignmentsByClient queries the Meraki Dashboard API to return policy assignment information by client for specified network(s) within an organization. The function supports pagination, time-range filtering, and an option to include undetected clients. If OrganizationID is not provided, it will attempt to resolve it using Get-OrgID -AuthToken $AuthToken.

    .PARAMETER AuthToken
    The Meraki API key used for authentication. This parameter is mandatory.

    .PARAMETER OrganizationID
    The Meraki Organization ID to query. If omitted, the function attempts to determine the organization using Get-OrgID -AuthToken $AuthToken. If multiple organizations are found, the function will return a message asking the user to explicitly provide an Organization ID.

    .PARAMETER perPage
    (Optional) Number of items to return per page for paginated responses. Integer value with an allowed range of 3 to 1000. If not specified, the API default is used.

    .PARAMETER startingAfter
    (Optional) A pagination cursor. Return results starting after this value.

    .PARAMETER endingBefore
    (Optional) A pagination cursor. Return results ending before this value.

    .PARAMETER t0
    (Optional) The beginning of the timespan for the query in ISO 8601 format (e.g., 2020-01-01T00:00:00Z). If omitted, the API defaults apply.

    .PARAMETER timespan
    (Optional) A duration in seconds for the timespan for which the data will be returned. If omitted, the API defaults apply.

    .PARAMETER includeUndetectedClients
    (Optional) Switch to include clients that are not currently detected by the network. Default is $false.

    .PARAMETER networkIds
    (Required) An array of network IDs to include in the query. Multiple network IDs may be provided; they will be sent as repeated 'networkIds[]' query parameters.

    .EXAMPLE
    PS> Get-MerakiOrganizationPoliciesAssignmentsByClient -AuthToken '<YourApiKey>' -networkIds @('N_123','N_456')
    Retrieves policy assignments for the specified networks using the default or auto-resolved OrganizationID.

    .EXAMPLE
    PS> Get-MerakiOrganizationPoliciesAssignmentsByClient -AuthToken '<YourApiKey>' -OrganizationID '123456' -perPage 100 -timespan 86400 -includeUndetectedClients $true -networkIds @('N_123')
    Retrieves up to 100 items per page for the last 24 hours, including undetected clients, for network N_123 in organization 123456.

    .NOTES
    - Requires network connectivity to api.meraki.com and a valid API key with appropriate permissions.
    - This function builds and URL-encodes query parameters and performs a GET request to:
        https://api.meraki.com/api/v1/organizations/{organizationId}/policies/assignments/byClient

    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$false)]
        [ValidateRange(3, 1000)]
        [int]$perPage = $null,
        [parameter(Mandatory=$false)]
        [string]$startingAfter = $null,
        [parameter(Mandatory=$false)]
        [string]$endingBefore = $null,
        [parameter(Mandatory=$false)]
        [string]$t0 = $null,
        [parameter(Mandatory=$false)]
        [string]$timespan = $null,
        [parameter(Mandatory=$false)]
        [bool]$includeUndetectedClients = $false,
        [parameter(Mandatory=$true)]
        [array]$networkIds
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
            if ($startingAfter) {
                $queryParams['startingAfter'] = $startingAfter
            }
            if ($endingBefore) {
                $queryParams['endingBefore'] = $endingBefore
            }
            if ($t0) {
                $queryParams['t0'] = $t0
            }
            if ($timespan) {
                $queryParams['timespan'] = $timespan
            }
            if ($includeUndetectedClients) {
                $queryParams['includeUndetectedClients'] = $includeUndetectedClients
            }
            if ($networkIds) {
                $queryParams['networkIds[]'] = $networkIds
            }

            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/policies/assignments/byClient?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}