function Get-MerakiOrganizationApiRequests {
    <#
    .SYNOPSIS
    Retrieves the list of API requests made to a specified Meraki organization.

    .DESCRIPTION
    This function retrieves the list of API requests made to a specified Meraki organization using the Meraki Dashboard API. It requires an authentication token with the necessary permissions to access the API.

    .PARAMETER AuthToken
    The authentication token required to access the Meraki Dashboard API. You can obtain this token from your Meraki Dashboard account.

    .PARAMETER OrgId
    The ID of the Meraki organization for which to retrieve the list of API requests. If not specified, the function will retrieve the ID of the first organization associated with the authentication token.

    .PARAMETER t0
    The beginning of the timespan for which to retrieve API requests. This parameter is ignored if the 'timespan' parameter is specified.

    .PARAMETER t1
    The end of the timespan for which to retrieve API requests. This parameter is ignored if the 'timespan' parameter is specified.

    .PARAMETER timespan
    The timespan for which to retrieve API requests, in seconds. If specified, the 't0' and 't1' parameters are ignored.

    .PARAMETER perPage
    The number of API requests to retrieve per page.

    .PARAMETER startingAfter
    The ID of the last API request from the previous page. Used for pagination.

    .PARAMETER endingBefore
    The ID of the first API request from the next page. Used for pagination.

    .PARAMETER adminId
    The ID of the administrator who made the API request.

    .PARAMETER path
    The path of the API request.

    .PARAMETER method
    The HTTP method of the API request.

    .PARAMETER responseCode
    The response code of the API request.

    .PARAMETER sourceIp
    The source IP address of the API request.

    .PARAMETER userAgent
    The user agent of the API request.

    .PARAMETER version
    The version of the API used for the request.

    .PARAMETER operationIds
    An array of operation IDs to retrieve.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationApiRequests -AuthToken "12345" -OrgId "56789" -perPage 100 -adminId "9999"
    Retrieves the list of API requests made by the administrator with ID "9999" to the Meraki organization with ID "56789", with 100 requests per page.

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
        [int]$perPage = $null,
        [parameter(Mandatory=$false)]
        [string]$startingAfter = $null,
        [parameter(Mandatory=$false)]
        [string]$endingBefore = $null,
        [parameter(Mandatory=$false)]
        [string]$adminId = $null,
        [parameter(Mandatory=$false)]
        [string]$path = $null,
        [parameter(Mandatory=$false)]
        [string]$method = $null,
        [parameter(Mandatory=$false)]
        [int]$responseCode = $null,
        [parameter(Mandatory=$false)]
        [string]$sourceIp = $null,
        [parameter(Mandatory=$false)]
        [string]$userAgent = $null,
        [parameter(Mandatory=$false)]
        [int]$version = $null,
        [parameter(Mandatory=$false)]
        [array]$operationIds = $null
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
        
            if ($perPage) {
                    $queryParams['perPage'] = $perPage
                }
            if ($startingAfter) {
                    $queryParams['startingAfter'] = $startingAfter
                }
            if ($endingBefore) {
                    $queryParams['endingBefore'] = $endingBefore
                }
            if ($adminId) {
                    $queryParams['adminId'] = $adminId
                }
            if ($path) {
                    $queryParams['path'] = $path
                }
            if ($method) {
                    $queryParams['method'] = $method
                }
            if ($responseCode) {
                    $queryParams['responseCode'] = $responseCode
                }
            if ($sourceIp) {
                    $queryParams['sourceIp'] = $sourceIp
                }
            if ($userAgent) {
                    $queryParams['userAgent'] = $userAgent
                }
            if ($version) {
                    $queryParams['version'] = $version
                }
            if ($operationIds) {
                    $queryParams['operationIds[]'] = $operationIds
                }
        
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/apiRequests?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
            return $response
        } catch {
            Write-Error $_
        }
    }
}