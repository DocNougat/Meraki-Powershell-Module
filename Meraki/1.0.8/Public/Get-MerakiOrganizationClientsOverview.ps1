function Get-MerakiOrganizationClientsOverview {
    <#
    .SYNOPSIS
    Retrieves an overview of clients in a Meraki organization.

    .DESCRIPTION
    The Get-MerakiOrganizationClientsOverview function retrieves an overview of clients in a specified Meraki organization. You must provide a Meraki API key using the AuthToken parameter.

    .PARAMETER AuthToken
    The Meraki API key to use for authentication.

    .PARAMETER OrgId
    The ID of the Meraki organization to retrieve client information for. If not specified, the function will use the ID of the first organization returned by the Get-MerakiOrganizations function.

    .PARAMETER t0
    The beginning of the timespan for which to retrieve client information. This parameter is mutually exclusive with the timespan parameter.

    .PARAMETER t1
    The end of the timespan for which to retrieve client information. This parameter is mutually exclusive with the timespan parameter.

    .PARAMETER timespan
    The timespan for which to retrieve client information, in seconds. This parameter is mutually exclusive with the t0 and t1 parameters.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationClientsOverview -AuthToken "12345" -OrgId "67890"

    Retrieves an overview of clients in the Meraki organization with ID 67890 using the API key "12345".

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationClientsOverview -AuthToken "12345" -timespan 86400

    Retrieves an overview of clients in the first Meraki organization returned by the Get-MerakiOrganizations function using the API key "12345" for the past 24 hours.

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
        [int]$timespan = $null
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
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
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/clients/overview?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}