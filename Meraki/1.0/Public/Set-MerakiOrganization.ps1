function Set-MerakiOrganization {
    <#
    .SYNOPSIS
    Updates an existing Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiOrganization function allows you to update an existing Meraki organization by providing the authentication token, organization ID, and a JSON configuration for the organization.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization to be updated.

    .PARAMETER OrgConfig
    The JSON configuration for the organization to be updated. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $OrgConfig = '{
        "name": "My organization",
        "management": {
            "details": [
                {
                    "name": "MSP ID",
                    "value": "123456"
                }
            ]
        },
        "api": { "enabled": true }
    }'
    $OrgConfig = $OrgConfig | ConvertTo-JSON -compress

    Set-MerakiOrganization -AuthToken "your-api-token" -OrganizationId "1234567890" -OrgConfig $OrgConfig

    This example updates the Meraki organization with ID "1234567890" with a new name, management details, and API settings.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationId = (Get-MerakiOrganizations -AuthToken $AuthToken).id,
        [parameter(Mandatory=$true)]
        [string]$OrgConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }
        
        $body = $OrgConfig

        $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId"
        
        $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -Body $body
        return $response
    }
    catch {
        Write-Host $_
    }
}