function Get-MerakiOrganizationEarlyAccessFeatures {
    <#
    .SYNOPSIS
    Retrieves the list of early access features for a specified Meraki organization.

    .DESCRIPTION
    This function retrieves the list of early access features for a specified Meraki organization using the Meraki Dashboard API. The authentication token is required for this operation.

    .PARAMETER AuthToken
    Specifies the authentication token for the Meraki Dashboard API.

    .PARAMETER OrgID
    Specifies the ID of the Meraki organization. If not specified, the function will use the ID of the first organization returned by Get-MerakiOrganizations.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationEarlyAccessFeatures -AuthToken "12345" -OrgID "123456"

    Retrieves the list of early access features for the organization with ID "123456" using the authentication token "12345".
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
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }

        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/earlyAccess/features" -Header $header

        return $response
    }
    catch {
        Write-Error $_
    }
}