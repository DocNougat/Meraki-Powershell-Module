function Get-MerakiOrganizationApiRequestsOverview {
    <#
    .SYNOPSIS
    Retrieves an overview of API requests made to a specified Meraki organization.

    .DESCRIPTION
    This function retrieves an overview of API requests made to a specified Meraki organization using the Meraki Dashboard API. It requires an authentication token with the necessary permissions to access the API.

    .PARAMETER AuthToken
    The authentication token required to access the Meraki Dashboard API. You can obtain this token from your Meraki Dashboard account.

    .PARAMETER OrgId
    The ID of the Meraki organization for which to retrieve the API request overview. If not specified, the function will retrieve the ID of the first organization associated with the authentication token.

    .PARAMETER t0
    The beginning of the timespan for which to retrieve API request overview. This parameter is ignored if the 'timespan' parameter is specified.

    .PARAMETER t1
    The end of the timespan for which to retrieve API request overview. This parameter is ignored if the 'timespan' parameter is specified.

    .PARAMETER timespan
    The timespan for which to retrieve API request overview, in seconds. If specified, the 't0' and 't1' parameters are ignored.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationApiRequestsOverview -AuthToken "12345" -OrgId "56789" -timespan 86400
    Retrieves an overview of API requests made to the Meraki organization with ID "56789" in the last 24 hours.

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
        [int]$timespan = $null
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
        
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/apiRequests/overview?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
            return $response
        } catch {
        Write-Debug $_
        Throw $_
    }
    }
}
