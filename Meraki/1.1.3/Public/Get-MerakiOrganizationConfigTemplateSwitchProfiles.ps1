function Get-MerakiOrganizationConfigTemplateSwitchProfiles {
    <#
    .SYNOPSIS
    Retrieves all switch profiles from a Meraki organization configuration template.

    .DESCRIPTION
    The Get-MerakiOrganizationConfigTemplateSwitchProfiles function retrieves all switch profiles from a specified Meraki organization configuration template. You must provide a Meraki API key using the AuthToken parameter, and the ID of the configuration template to retrieve the switch profiles from using the configTemplateId parameter.

    .PARAMETER AuthToken
    The Meraki API key to use for authentication.

    .PARAMETER OrgId
    The ID of the Meraki organization to retrieve the switch profiles from. If not specified, the function will use the ID of the first organization returned by the Get-MerakiOrganizations function.

    .PARAMETER configTemplateId
    The ID of the configuration template to retrieve the switch profiles from.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationConfigTemplateSwitchProfiles -AuthToken "12345" -configTemplateId "67890"

    Retrieves all switch profiles in the Meraki organization configuration template with ID "67890" using the API key "12345".

    .NOTES
    For more information about the Meraki API, see https://developer.cisco.com/meraki/api/.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [Parameter(Mandatory=$true)]
        [string]$configTemplateId
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
            }
            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/configTemplates/$configTemplateId/switch/profiles" -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}
