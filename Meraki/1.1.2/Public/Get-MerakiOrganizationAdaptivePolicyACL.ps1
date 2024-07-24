function Get-MerakiOrganizationAdaptivePolicyACL {
    <#
    .SYNOPSIS
    Retrieves an adaptive policy ACL for an organization in the Meraki dashboard.

    .DESCRIPTION
    The Get-MerakiOrganizationAdaptivePolicyACL function retrieves an adaptive policy ACL for an organization in the Meraki dashboard using the Meraki Dashboard API. You must provide an API key and the ID of the adaptive policy ACL. You can optionally provide the ID of the organization that the adaptive policy ACL belongs to.

    .PARAMETER AuthToken
    The Meraki Dashboard API key.

    .PARAMETER aclID
    The ID of the adaptive policy ACL to retrieve.

    .PARAMETER OrgID
    The ID of the organization that the adaptive policy ACL belongs to. If not provided, the ID of the first organization returned by Get-MerakiOrganizations will be used.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationAdaptivePolicyACL -AuthToken "your_api_key" -aclID "your_acl_id"

    Retrieves the specified adaptive policy ACL in the first organization returned by Get-MerakiOrganizations.

    .NOTES
    For more information on the Meraki Dashboard API, see https://developer.cisco.com/meraki/api/.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$aclID,
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
            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/adaptivePolicy/acls/$aclID" -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
            return $response
        } catch {
        Write-Debug $_
        Throw $_
    }
    }
}
