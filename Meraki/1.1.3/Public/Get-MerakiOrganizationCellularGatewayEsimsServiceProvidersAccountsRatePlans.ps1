function Get-MerakiOrganizationCellularGatewayEsimsServiceProvidersAccountsRatePlans {
    <#
    .SYNOPSIS
    Retrieves eSIM service provider rate plans for accounts within a Meraki organization.

    .DESCRIPTION
    Get-MerakiOrganizationCellularGatewayEsimsServiceProvidersAccountsRatePlans queries the Cisco Meraki API to return rate plans available from eSIM service providers for one or more accounts under a specified organization. The function builds a request including the provided API key, optional organization ID (resolved via Get-OrgID if not supplied), and optional account ID filters, then returns the parsed JSON response as PowerShell objects.

    .PARAMETER AuthToken
    The Cisco Meraki API key. This value is sent in the X-Cisco-Meraki-API-Key request header. This parameter is required.

    .PARAMETER OrganizationID
    The Meraki organization ID to query. If omitted, the function attempts to resolve the organization ID by calling Get-OrgID -AuthToken <AuthToken>. If Get-OrgID returns the string "Multiple organizations found. Please specify an organization ID.", that string is returned and the request is not performed. This parameter is optional.

    .PARAMETER AccountIDs
    An array of account IDs to filter the rate plans. When provided, the request includes each account ID as a repeated query parameter (accountIds[]). Provide one or more account ID strings. This parameter is required by the function signature.

    .EXAMPLE
    # Using an API key and a single account ID (array with one element)
    $token = '0123456789abcdef'
    Get-MerakiOrganizationCellularGatewayEsimsServiceProvidersAccountsRatePlans -AuthToken $token -AccountIDs @('123456')

    .NOTES
    - The function uses New-MerakiQueryString to build query parameters and Invoke-RestMethod to call the Meraki API.
    - The User-Agent is set to "MerakiPowerShellModule/1.1.3 DocNougat".
    - Ensure the provided API key has sufficient permissions to read eSIM service provider and rate plan information.
    - HTTP errors or other exceptions raised by Invoke-RestMethod are re-thrown to the caller for handling.

    .LINK
    https://developer.cisco.com/meraki/api/ (Cisco Meraki API Documentation)
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
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

            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/cellularGateway/esims/serviceProviders/accounts/ratePlans?$queryString"

            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}