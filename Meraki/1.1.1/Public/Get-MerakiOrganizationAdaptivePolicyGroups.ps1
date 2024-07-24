function Get-MerakiOrganizationAdaptivePolicyGroups {
    <#
    .SYNOPSIS
    Retrieves a list of adaptive policy groups in the Meraki dashboard.

    .DESCRIPTION
    The Get-MerakiOrganizationAdaptivePolicyGroups function retrieves a list of adaptive policy groups in the Meraki dashboard using the Meraki Dashboard API. You must provide an API key. You can optionally provide the ID of the organization that the groups belong to.

    .PARAMETER AuthToken
    The Meraki Dashboard API key.

    .PARAMETER OrgID
    The ID of the organization that the groups belong to. If not provided, the ID of the first organization returned by Get-MerakiOrganizations will be used.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationAdaptivePolicyGroups -AuthToken "your_api_key"

    Retrieves a list of all adaptive policy groups in the organization.

    .NOTES
    For more information on the Meraki Dashboard API, see https://developer.cisco.com/meraki/api/.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
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
            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/adaptivePolicy/groups" -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
            return $response
        } catch {
        Write-Debug $_
        Throw $_
    }
    }
}
