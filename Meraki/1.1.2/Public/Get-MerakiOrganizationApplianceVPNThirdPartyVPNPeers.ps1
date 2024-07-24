function Get-MerakiOrganizationApplianceVPNThirdPartyVPNPeers {
    <#
    .SYNOPSIS
    Retrieves third-party VPN peers for a Meraki organization's appliances.

    .DESCRIPTION
    This function retrieves third-party VPN peers for a Meraki organization's appliances using the Meraki Dashboard API. It requires an authentication token for the API, and the ID of the organization for which the peers should be retrieved.

    .PARAMETER AuthToken
    The authentication token for the Meraki Dashboard API.

    .PARAMETER OrgId
    The ID of the organization for which the third-party VPN peers should be retrieved. If not specified, the function will use the ID of the first organization returned by the Get-MerakiOrganizations function.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationApplianceVPNThirdPartyVPNPeers -AuthToken $AuthToken -OrgId $OrganizationID

    Retrieves third-party VPN peers for the specified organization.

    .NOTES
    This function requires the Get-MerakiOrganizations function.

    .LINK
    https://developer.cisco.com/meraki/api-v1/#!get-organization-appliance-vpn-third-party-vpn-peers

    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken)
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
            }
            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/appliance/vpn/thirdPartyVPNPeers" -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}
