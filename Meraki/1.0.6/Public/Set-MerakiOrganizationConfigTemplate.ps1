function Set-MerakiOrganizationConfigTemplate {
    <#
    .SYNOPSIS
    Updates an existing configuration template for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiOrganizationConfigTemplate function allows you to update an existing configuration template for a specified Meraki organization by providing the authentication token, organization ID, configuration template ID, and a configuration template configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to update an existing configuration template.

    .PARAMETER ConfigTemplateId
    The ID of the configuration template you want to update.

    .PARAMETER ConfigTemplateConfig
    A string containing the configuration template configuration. The string should be in JSON format and should include the "name" and "timeZone" properties.

    .EXAMPLE
    $config = [PSCustomObject]@{
        name = "My Updated Config Template"
        timeZone = "America/Los_Angeles"
    }

    $config = $config | ConvertTo-Json -Compress
    Set-MerakiOrganizationConfigTemplate -AuthToken "your-api-token" -OrganizationId "123456789012345678" -ConfigTemplateId "123456789012345" -ConfigTemplateConfig $config

    This example updates the configuration template with ID "123456789012345" for the Meraki organization with ID "123456789012345678", setting the name to "My Updated Config Template" and the timezone to "America/Los_Angeles".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the configuration template update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$ConfigTemplateId,
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

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/configTemplates/$ConfigTemplateId"

            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Host $_
        Throw $_
    }
    }
}