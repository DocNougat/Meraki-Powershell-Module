function New-MerakiOrganizationConfigTemplate {
    <#
    .SYNOPSIS
    Creates a new configuration template for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The New-MerakiOrganizationConfigTemplate function allows you to create a new configuration template for a specified Meraki organization by providing the authentication token, organization ID, and a configuration template configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to create a new configuration template.

    .PARAMETER ConfigTemplateConfig
    A string containing the configuration template configuration. The string should be in JSON format and should include the "name" property, as well as the "copyFromNetworkId" and "timeZone" properties if applicable.

    .EXAMPLE
    New-MerakiOrganizationConfigTemplate -AuthToken "your-api-token" -OrganizationId "123456789012345678" -ConfigTemplateConfig '{
        "name": "My Config Template"
    }'

    This example creates a new configuration template with the name "My Config Template" for the Meraki organization with ID "123456789012345678".

    .EXAMPLE
    $config = '{
        "name": "My Config Template",
        "copyFromNetworkId": "N_123456789012345678",
        "timeZone": "America/Los_Angeles"
    }'
    $config = $config | ConvertTo-Json -Compress
    New-MerakiOrganizationConfigTemplate -AuthToken "your-api-token" -OrganizationId "123456789012345678" -ConfigTemplateConfig $config

    This example creates a new configuration template with the name "My Config Template" for the Meraki organization with ID "123456789012345678", copying the configuration from the network with ID "N_123456789012345678" and setting the timezone to "America/Los_Angeles".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the configuration template creation is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$ConfigTemplateConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $body = $ConfigTemplateConfig

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/configTemplates"

            $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
            Write-Host $_
        }
    }
}