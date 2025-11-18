function Get-MerakiOrganizationApplianceSecurityEvents {
    <#
    .SYNOPSIS
    Retrieves a list of security events from the security appliance of a specified Meraki organization.

    .DESCRIPTION
    This function retrieves a list of security events from the security appliance of a specified Meraki organization using the Meraki Dashboard API. It requires an authentication token with the necessary permissions to access the API.

    .PARAMETER AuthToken
    The authentication token required to access the Meraki Dashboard API. You can obtain this token from your Meraki Dashboard account.

    .PARAMETER OrgId
    The ID of the Meraki organization for which to retrieve the security events. If not specified, the function will retrieve the ID of the first organization associated with the authentication token.

    .PARAMETER t0
    The beginning of the timespan for which to retrieve the security events. This parameter is ignored if the 'timespan' parameter is specified.

    .PARAMETER t1
    The end of the timespan for which to retrieve the security events. This parameter is ignored if the 'timespan' parameter is specified.

    .PARAMETER timespan
    The timespan for which to retrieve the security events, in seconds. If specified, the 't0' and 't1' parameters are ignored.

    .PARAMETER perPage
    The number of security events to retrieve per page.

    .PARAMETER startingAfter
    The ID of the last security event from the previous page to use as the starting point for the current page.

    .PARAMETER endingBefore
    The ID of the first security event from the next page to use as the ending point for the current page.

    .PARAMETER sortOrder
    The order in which to sort the security events ('ascending' or 'descending').

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationApplianceSecurityEvents -AuthToken "12345" -OrgId "56789" -timespan 86400 -perPage 50 -sortOrder "descending"
    Retrieves the last 50 security events from the security appliance of the Meraki organization with ID "56789" in the last 24 hours, sorted in descending order.

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
        [string]$sortOrder = $null
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "Content-Type" = "application/json"
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
            if ($sortOrder) {
                $queryParams['sortOrder'] = $sortOrder
            }
        
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/appliance/security/events?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
        Write-Debug $_
        Throw $_
    }
    }
}
