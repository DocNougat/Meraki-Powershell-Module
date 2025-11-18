function Get-MerakiOrganizationCellularGatewayEsimsServiceProvidersAccounts {
    <#
    .SYNOPSIS
    Retrieves eSIM service provider accounts for a Meraki organization.

    .DESCRIPTION
    Get-MerakiOrganizationCellularGatewayEsimsServiceProvidersAccounts queries the Meraki Dashboard API to list eSIM (embedded SIM) service provider accounts associated with a specified organization. The function constructs the appropriate API request, supports optional filtering by account IDs, and returns the deserialized API response.

    .PARAMETER AuthToken
    String. The Meraki API key (X-Cisco-Meraki-API-Key). This parameter is mandatory.

    .PARAMETER OrganizationID
    String. The Meraki organization ID to query. If not supplied, the function attempts to resolve the organization ID by calling Get-OrgID -AuthToken <AuthToken>. If multiple organizations are found by that helper, the function will return a message instructing the caller to specify an organization ID explicitly.

    .PARAMETER AccountIDs
    Array. Optional list (array) of account ID strings to filter the results. When provided, the request will include the accountIds[] query parameter for each element in the array to limit the returned service provider accounts.

    .EXAMPLE
    PS> Get-MerakiOrganizationCellularGatewayEsimsServiceProvidersAccounts -AuthToken '0123456789abcdef'

    Retrieves all eSIM service provider accounts for the organization resolved by the Get-OrgID helper using the provided API key.

    .EXAMPLE
    PS> Get-MerakiOrganizationCellularGatewayEsimsServiceProvidersAccounts -AuthToken $token -OrganizationID '123456' -AccountIDs @('acct-1','acct-2')

    Retrieves eSIM service provider accounts for organization 123456 filtered to only the specified account IDs.

    .NOTES
    - Requires network connectivity to api.meraki.com and a valid Meraki API key with permissions to read organization cellularGateway resources.
    - The function uses Invoke-RestMethod and will throw on HTTP or deserialization errors; callers can catch exceptions as needed.
    - API documentation reference: Cisco Meraki Dashboard API (API v1) — endpoint: /organizations/{organizationId}/cellularGateway/esims/serviceProviders/accounts

    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$false)]
        [array]$AccountIDs = $null
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
            if ($AccountIDs) {
                $queryParams['accountIds[]'] = $AccountIDs
            }
            $queryString = New-MerakiQueryString -queryParams $queryParams

            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/cellularGateway/esims/serviceProviders/accounts?$queryString"

            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
        Write-Debug $_
        Throw $_
    }
    }
}