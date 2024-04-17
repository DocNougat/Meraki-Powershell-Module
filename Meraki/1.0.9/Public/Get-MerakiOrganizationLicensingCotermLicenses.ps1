function Get-MerakiOrganizationLicensingCotermLicenses {
    <#
    .SYNOPSIS
        Retrieves a list of co-termination licenses for a Meraki organization.
    .DESCRIPTION
        This function retrieves a list of co-termination licenses for a Meraki organization
        specified by the provided organization ID or the ID of the first organization
        associated with the provided API authentication token.
    .PARAMETER AuthToken
        The Meraki API authentication token to use for the request.
    .PARAMETER OrgId
        The ID of the Meraki organization to retrieve license information for.
        If not specified, the ID of the first organization associated with the provided
        authentication token will be used.
    .PARAMETER perPage
        The number of results per page to return. Default is to return all results.
    .PARAMETER startingAfter
        A pagination parameter that indicates the start of the page to retrieve.
    .PARAMETER endingBefore
        A pagination parameter that indicates the end of the page to retrieve.
    .PARAMETER invalidated
        If set to $true, includes invalidated licenses in the result set.
    .PARAMETER expired
        If set to $true, includes expired licenses in the result set.
    .EXAMPLE
        PS C:\> Get-MerakiOrganizationLicensingCotermLicenses -AuthToken "myAuthToken" -OrgId "123456" -perPage 10
        Returns a list of up to 10 co-termination licenses for the Meraki organization with ID "123456".
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$false)]
        [int]$perPage = $null,
        [parameter(Mandatory=$false)]
        [string]$startingAfter = $null,
        [parameter(Mandatory=$false)]
        [string]$endingBefore = $null,
        [parameter(Mandatory=$false)]
        [bool]$invalidated = $false,
        [parameter(Mandatory=$false)]
        [bool]$expired = $false
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
            if ($perPage) {
                $queryParams['perPage'] = $perPage
            }
            if ($startingAfter) {
                $queryParams['startingAfter'] = $startingAfter
            }
            if ($endingBefore) {
                $queryParams['endingBefore'] = $endingBefore
            }
            if ($invalidated) {
                $queryParams['invalidated'] = $invalidated
            }
            if ($expired) {
                $queryParams['expired'] = $expired
            }
            $queryString = New-MerakiQueryString -queryParams $queryParams

            $URI = "https://api.meraki.com/api/v1/organizations/$OrganizationID/licensing/coterm/licenses?$queryString"
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}
