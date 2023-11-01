function Get-MerakiOrganizationInsightApplications {
    <#
    .SYNOPSIS
    Retrieves a list of Insight applications for a specified Meraki organization.

    .DESCRIPTION
    This function retrieves a list of Insight applications for a specified Meraki organization using the Meraki Dashboard API. The authentication token and organization ID are required for this operation.

    .PARAMETER AuthToken
    Specifies the authentication token for the Meraki Dashboard API.

    .PARAMETER OrgId
    Specifies the ID of the Meraki organization. If not specified, the function will use the ID of the first organization returned by Get-MerakiOrganizations.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationInsightApplications -AuthToken "12345" -OrgId "123456"

    Retrieves a list of Insight applications for the organization with ID "123456" using the authentication token "12345".

    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,

        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-MerakiOrganizations -AuthToken $AuthToken).id
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/insight/applications" -Header $header
        return $response
    }
    catch {
        Write-Error $_
    }
}
