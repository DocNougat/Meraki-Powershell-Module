function Get-MerakiOrganizationApplianceVPNStatuses {
    <#
    .SYNOPSIS
    Retrieves VPN statuses for a Meraki organization's appliances.

    .DESCRIPTION
    This function retrieves VPN statuses for a Meraki organization's appliances using the Meraki Dashboard API. It requires an authentication token for the API, and the ID of the organization for which the statuses should be retrieved. The function can also filter the results by specifying various optional parameters.

    .PARAMETER AuthToken
    The authentication token for the Meraki Dashboard API.

    .PARAMETER OrgId
    The ID of the organization for which the VPN statuses should be retrieved. If not specified, the function will use the ID of the first organization returned by the Get-MerakiOrganizations function.

    .PARAMETER perPage
    The number of entries per page to include in the result set. If not specified, all entries will be returned.

    .PARAMETER startingAfter
    Returns entries after the specified startingAfter parameter, sorted ascendingly by time.

    .PARAMETER endingBefore
    Returns entries before the specified endingBefore parameter, sorted ascendingly by time.

    .PARAMETER networkIds
    An array of network IDs to include in the result set. If not specified, statuses for all networks will be included.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationApplianceVPNStatuses -AuthToken $AuthToken -OrgId $OrganizationID -networkIds @("N_1234567890")

    Retrieves VPN statuses for the specified organization and network ID.

    .NOTES
    This function requires the Get-MerakiOrganizations and New-MerakiQueryString functions.

    .LINK
    https://developer.cisco.com/meraki/api-v1/#!get-organization-appliance-vpn-statuses

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
        [array]$networkIds = $null
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
            if ($networkIds) {
                $queryParams['networkIds[]'] = $networkIds
            }    
            $queryString = New-MerakiQueryString -queryParams $queryParams    
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/appliance/vpn/statuses?$queryString"    
            $URI = [uri]::EscapeUriString($URL)    
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}
