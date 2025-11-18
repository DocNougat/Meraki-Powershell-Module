function Get-MerakiOrganizationCellularGatewayEsimsServiceProviders {
    <#
    .SYNOPSIS
    Retrieves the list of eSIM service providers available for cellular gateway devices in a Meraki organization.

    .DESCRIPTION
    Get-MerakiOrganizationCellularGatewayEsimsServiceProviders queries the Cisco Meraki API to return service providers for eSIM-enabled cellular gateways within the specified organization. The function requires a valid Meraki API key. If OrganizationID is not supplied, the helper Get-OrgID is used to resolve the organization (may prompt or return an error if multiple organizations are found).

    .PARAMETER AuthToken
    The Meraki API key (X-Cisco-Meraki-API-Key) used to authenticate the request. This parameter is mandatory.

    .PARAMETER OrganizationID
    The Meraki organization ID to query. If omitted, the function attempts to resolve an organization ID via Get-OrgID -AuthToken $AuthToken. If multiple organizations are found, the function returns an error message asking you to specify an organization ID.

    .EXAMPLE
    # Provide an API key and organization ID explicitly
    PS> Get-MerakiOrganizationCellularGatewayEsimsServiceProviders -AuthToken 'abcd1234' -OrganizationID '123456'

    .NOTES
    - Requires network access to api.meraki.com.
    - Ensure the provided API key has sufficient permissions to read organization cellular gateway settings.
    - On failure, the function writes debug information and throws the original error.

    .LINK
    https://developer.cisco.com/meraki/api-v1/ (Refer to the Meraki Dashboard API documentation for endpoint details)
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken)
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "Content-Type" = "application/json"
            }
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/cellularGateway/esims/serviceProviders"

            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
        Write-Debug $_
        Throw $_
    }
    }
}