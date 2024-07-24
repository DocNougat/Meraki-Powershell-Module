function Remove-MerakiOrganizationConfigTemplate {
    <#
    .SYNOPSIS
    Deletes an existing configuration template for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The Remove-MerakiOrganizationConfigTemplate function allows you to delete an existing configuration template for a specified Meraki organization by providing the authentication token, organization ID, and configuration template ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to delete an existing configuration template.

    .PARAMETER ConfigTemplateId
    The ID of the configuration template you want to delete.

    .EXAMPLE
    Remove-MerakiOrganizationConfigTemplate -AuthToken "your-api-token" -OrganizationId "123456789012345678" -ConfigTemplateId "123456789012345"

    This example deletes the configuration template with ID "123456789012345" for the Meraki organization with ID "123456789012345678".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the configuration template deletion is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$ConfigTemplateId
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
            }

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/configTemplates/$ConfigTemplateId"

            $response = Invoke-RestMethod -Method Delete -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}