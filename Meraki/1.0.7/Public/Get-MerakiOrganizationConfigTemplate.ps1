function Get-MerakiOrganizationConfigTemplate {
    <#
    .SYNOPSIS
    Retrieves a configuration template in a Meraki organization.

    .DESCRIPTION
    The Get-MerakiOrganizationConfigTemplate function retrieves a specified configuration template in a Meraki organization. You must provide a Meraki API key using the AuthToken parameter, and the ID of the configuration template to retrieve using the ConfigID parameter.

    .PARAMETER AuthToken
    The Meraki API key to use for authentication.

    .PARAMETER ConfigID
    The ID of the configuration template to retrieve.

    .PARAMETER OrgId
    The ID of the Meraki organization to retrieve the configuration template from. If not specified, the function will use the ID of the first organization returned by the Get-MerakiOrganizations function.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationConfigTemplate -AuthToken "12345" -ConfigID "67890" -OrgId "12345"

    Retrieves the configuration template with ID "67890" in the Meraki organization with ID "12345" using the API key "12345".

    .NOTES
    For more information about the Meraki API, see https://developer.cisco.com/meraki/api/.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$ConfigID,
        [Parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken)
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
            }
            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/configTemplates/$ConfigID" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}
