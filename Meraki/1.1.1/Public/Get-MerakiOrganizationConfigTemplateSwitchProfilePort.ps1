function Get-MerakiOrganizationConfigTemplateSwitchProfilePort {
    <#
    .SYNOPSIS
    Retrieves a switch profile port configuration from a Meraki organization configuration template.

    .DESCRIPTION
    The Get-MerakiOrganizationConfigTemplateSwitchProfilePort function retrieves a specified switch profile port configuration from a Meraki organization configuration template. You must provide a Meraki API key using the AuthToken parameter, the ID of the configuration template to retrieve the switch profile port configuration from using the configTemplateId parameter, the ID of the switch profile to retrieve the port configuration from using the profileId parameter, and the ID of the port to retrieve the configuration for using the portId parameter.

    .PARAMETER AuthToken
    The Meraki API key to use for authentication.

    .PARAMETER OrgId
    The ID of the Meraki organization to retrieve the switch profile port configuration from. If not specified, the function will use the ID of the first organization returned by the Get-MerakiOrganizations function.

    .PARAMETER configTemplateId
    The ID of the configuration template to retrieve the switch profile port configuration from.

    .PARAMETER profileId
    The ID of the switch profile to retrieve the port configuration from.

    .PARAMETER portId
    The ID of the port to retrieve the configuration for.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationConfigTemplateSwitchProfilePort -AuthToken "12345" -configTemplateId "67890" -profileId "abcdef" -portId "GigabitEthernet1"

    Retrieves the configuration for the port with ID "GigabitEthernet1" in the switch profile with ID "abcdef" in the Meraki organization configuration template with ID "67890" using the API key "12345".

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
        [string]$configTemplateId,
        [Parameter(Mandatory=$true)]
        [string]$profileId,
        [Parameter(Mandatory=$true)]
        [string]$portId
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
            }
            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/configTemplates/$configTemplateId/switch/profiles/$profileId/ports/$portId" -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}
