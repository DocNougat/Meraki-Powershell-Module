function New-MerakiOrganizationBrandingPolicy {
    <#
    .SYNOPSIS
    Creates a new branding policy for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The New-MerakiOrganizationBrandingPolicy function allows you to create a new branding policy for a specified Meraki organization by providing the authentication token, policy name, and policy configuration.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER PolicyConfig
    The JSON configuration for the new branding policy to be created. Refer to the JSON schema for required parameters and their format.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to create a new branding policy.

    .EXAMPLE
    $PolicyConfig = '{
        "name": "Example branding policy",
        "enabled": true,
        "adminSettings": {
            "appliesTo": "All organization admins",
            "values": []
        },
        "customLogo": {
            "enabled": true,
            "image": {
                "contents": "base64-encoded-image-contents",
                "format": "png"
            }
        },
        "helpSettings": {
            "apiDocsSubtab": "default or inherit",
            "casesSubtab": "default or inherit",
            "ciscoMerakiProductDocumentation": "default or inherit",
            "communitySubtab": "default or inherit",
            "dataProtectionRequestsSubtab": "default or inherit",
            "firewallInfoSubtab": "default or inherit",
            "getHelpSubtab": "default or inherit",
            "getHelpSubtabKnowledgeBaseSearch": "default or inherit",
            "hardwareReplacementsSubtab": "default or inherit",
            "helpTab": "default or inherit",
            "helpWidget": "default or inherit",
            "newFeaturesSubtab": "default or inherit",
            "smForums": "default or inherit",
            "supportContactInfo": "default or inherit",
            "universalSearchKnowledgeBaseSearch": "default or inherit"
        }
    }'
    $PolicyConfig = $PolicyConfig | ConvertTo-JSON -compress

    New-MerakiOrganizationBrandingPolicy -AuthToken "your-api-token" -PolicyName "New Branding Policy" -PolicyConfig $PolicyConfig -OrganizationId "1234567890"

    This example creates a new branding policy with name "New Branding Policy" for the Meraki organization with ID "1234567890". The branding policy is configured to enable a custom logo and modify various Help page features.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the configuration is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$PolicyConfig,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken)
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
            
            $body = $PolicyConfig

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/brandingPolicies"
            
            $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -Body $body
            return $response
        }
        catch {
            Write-Host $_
        }
    }
}