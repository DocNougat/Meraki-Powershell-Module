function Get-MerakiOrganizationConfigurationChanges {
    <#
    .SYNOPSIS
    Retrieves configuration change events for a Meraki organization.

    .DESCRIPTION
    The Get-MerakiOrganizationConfigurationChanges function retrieves configuration change events for a specified Meraki organization. You must provide a Meraki API key using the AuthToken parameter, and can optionally specify various filters using the other parameters.

    .PARAMETER AuthToken
    The Meraki API key to use for authentication.

    .PARAMETER OrgId
    The ID of the Meraki organization to retrieve configuration change events for. If not specified, the function will use the ID of the first organization returned by the Get-MerakiOrganizations function.

    .PARAMETER t0
    The beginning of the timespan for the returned events. If timespan is not provided, this parameter is required. The value should be in ISO 8601 format.

    .PARAMETER t1
    The end of the timespan for the returned events. If timespan is not provided, this parameter is required. The value should be in ISO 8601 format.

    .PARAMETER timespan
    The timespan for the returned events, in seconds. If specified, t0 and t1 parameters will be ignored.

    .PARAMETER perPage
    The number of events to return per page.

    .PARAMETER startingAfter
    A token used to retrieve the next page of results.

    .PARAMETER endingBefore
    A token used to retrieve the previous page of results.

    .PARAMETER networkId
    Filter the results by network ID.

    .PARAMETER adminId
    Filter the results by admin ID.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationConfigurationChanges -AuthToken "12345" -t0 "2022-01-01T00:00:00Z" -t1 "2022-01-02T00:00:00Z"

    Retrieves all configuration change events for the Meraki organization with ID "12345" that occurred between January 1, 2022 and January 2, 2022.

    .NOTES
    For more information about the Meraki API, see https://developer.cisco.com/meraki/api/.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [Parameter(Mandatory=$false)]
        [string]$t0 = $null,
        [Parameter(Mandatory=$false)]
        [string]$t1 = $null,
        [Parameter(Mandatory=$false)]
        [int]$timespan = $null,
        [Parameter(Mandatory=$false)]
        [int]$perPage = $null,
        [Parameter(Mandatory=$false)]
        [string]$startingAfter = $null,
        [Parameter(Mandatory=$false)]
        [string]$endingBefore = $null,
        [Parameter(Mandatory=$false)]
        [string]$networkId = $null,
        [Parameter(Mandatory=$false)]
        [string]$adminId = $null
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
            if ($networkId) {
                $queryParams['networkId'] = $networkId
            }
            if ($adminId) {
                $queryParams['adminId'] = $adminId
            }
        
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/configurationChanges?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
        Write-Debug $_
        Throw $_
    }
    }
}