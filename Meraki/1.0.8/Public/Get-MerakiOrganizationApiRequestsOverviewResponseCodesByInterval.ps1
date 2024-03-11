function Get-MerakiOrganizationApiRequestsOverviewResponseCodesByInterval {
    <#
    .SYNOPSIS
    Retrieves an overview of API request response codes made to a specified Meraki organization, grouped by time interval.

    .DESCRIPTION
    This function retrieves an overview of API request response codes made to a specified Meraki organization, grouped by time interval, using the Meraki Dashboard API. It requires an authentication token with the necessary permissions to access the API.

    .PARAMETER AuthToken
    The authentication token required to access the Meraki Dashboard API. You can obtain this token from your Meraki Dashboard account.

    .PARAMETER OrgId
    The ID of the Meraki organization for which to retrieve the API request response codes overview. If not specified, the function will retrieve the ID of the first organization associated with the authentication token.

    .PARAMETER t0
    The beginning of the timespan for which to retrieve API request response codes overview. This parameter is ignored if the 'timespan' parameter is specified.

    .PARAMETER t1
    The end of the timespan for which to retrieve API request response codes overview. This parameter is ignored if the 'timespan' parameter is specified.

    .PARAMETER timespan
    The timespan for which to retrieve API request response codes overview, in seconds. If specified, the 't0' and 't1' parameters are ignored.

    .PARAMETER interval
    The time interval for grouping the API request response codes overview, in seconds.

    .PARAMETER version
    The version of the API used for the request.

    .PARAMETER operationIds
    An array of operation IDs to retrieve.

    .PARAMETER sourceIps
    An array of source IP addresses to retrieve.

    .PARAMETER adminIds
    An array of administrator IDs to retrieve.

    .PARAMETER userAgent
    The user agent of the API requests to retrieve.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationApiRequestsOverviewResponseCodesByInterval -AuthToken "12345" -OrgId "56789" -timespan 86400 -interval 3600
    Retrieves an overview of API request response codes made to the Meraki organization with ID "56789" in the last 24 hours, grouped by hour.

    .NOTES
    This function requires the Invoke-RestMethod cmdlet to be available in the PowerShell session.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$false)]
        [string]$t0 = $null,
        [parameter(Mandatory=$false)]
        [string]$t1 = $null,
        [parameter(Mandatory=$false)]
        [int]$timespan = $null,
        [parameter(Mandatory=$false)]
        [int]$interval = $null,
        [parameter(Mandatory=$false)]
        [int]$version = $null,
        [parameter(Mandatory=$false)]
        [array]$operationIds = $null,
        [parameter(Mandatory=$false)]
        [array]$sourceIps = $null,
        [parameter(Mandatory=$false)]
        [array]$adminIds = $null,
        [parameter(Mandatory=$false)]
        [string]$userAgent = $null
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                'X-Cisco-Meraki-API-Key' = $AuthToken
            }
        
            $queryParams = @{}
        
            if ($timespan) {
                $queryParams['timespan'] = $timespan
            } else {
                if ($t0) {
                    $queryParams['t0'] = $t0
                }
                if ($t1) {
                    $queryParams['t1'] = $t1
                }
            }
            if ($interval) {
                    $queryParams['interval'] = $interval
                }
            if ($version) {
                    $queryParams['version'] = $version
                }
            if ($operationIds) {
                    $queryParams['operationIds[]'] = $operationIds
                }
            if ($sourceIps) {
                    $queryParams['sourceIps[]'] = $sourceIps
                }
            if ($adminIds) {
                    $queryParams['adminIds[]'] = $adminIds
                }
            if ($userAgent) {
                    $queryParams['userAgent'] = $userAgent
                }
        
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/apiRequests/overview/responseCodes/byInterval?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
            return $response
        } catch {
        Write-Debug $_
        Throw $_
    }
    }
}