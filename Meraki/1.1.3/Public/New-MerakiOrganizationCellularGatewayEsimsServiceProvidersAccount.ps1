function New-MerakiOrganizationCellularGatewayEsimsServiceProvidersAccount {
    <#
    .SYNOPSIS
        Create a Meraki Organization Cellular Gateway eSIM service provider account.

    .DESCRIPTION
        Sends a POST request to the Meraki Dashboard API to create an eSIM service provider account
        for a specified organization. The function requires a valid Meraki API key and a JSON
        representation of the account configuration to send in the request body. If OrganizationID
        is not provided, the function attempts to resolve it by calling Get-OrgID -AuthToken $AuthToken.
        If multiple organizations are found by Get-OrgID, the function returns an error message
        indicating that an organization ID must be specified.

    .PARAMETER AuthToken
        The Meraki API key used for authentication. This value is placed in the
        "X-Cisco-Meraki-API-Key" header of the request. (string, Mandatory)

    .PARAMETER OrganizationID
        The identifier of the Meraki organization that contains the cellular gateway service
        provider account. If omitted, the function calls Get-OrgID -AuthToken $AuthToken to
        determine the organization. If multiple organizations are found, you must supply this value.
        (string, Optional)

    .PARAMETER AccountConfig
        The request body (JSON) representing the updated account configuration. Provide a JSON
        string or a PowerShell object converted to JSON (for example, using ConvertTo-Json).
        The payload must conform to the Meraki API schema for eSIM service provider accounts.
        (string, Mandatory)

    .EXAMPLE
        $body = @{
            title    = 'ProviderX'
            apiKey   = '1lk2j3-1234jnd-1234lkd0134'
        } | ConvertTo-Json -Depth 10 -Compress

        Set-MerakiOrganizationCellularGatewayEsimsServiceProvidersAccounts -AuthToken '123412341341341' -AccountConfig $body

        Converts a PowerShell object to JSON and updates the account. OrganizationID is resolved automatically.

    .NOTES
        - API endpoint used: POST /organizations/{organizationId}/cellularGateway/esims/serviceProviders/accounts
        - The request includes header "Content-Type: application/json; charset=utf-8" and the API key header.
        - Ensure AccountConfig is valid JSON according to Meraki's API. Use ConvertTo-Json for PowerShell objects.
        - Network or API errors will surface as exceptions from Invoke-RestMethod.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$AccountConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/cellularGateway/esims/serviceProviders/accounts"

            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $AccountConfig
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}