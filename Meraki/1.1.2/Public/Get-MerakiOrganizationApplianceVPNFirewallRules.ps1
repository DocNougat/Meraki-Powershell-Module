function Get-MerakiOrganizationApplianceVPNFirewallRules {
    <#
    .SYNOPSIS
    Retrieves VPN firewall rules for a Meraki organization's appliances.

    .DESCRIPTION
    This function retrieves VPN firewall rules for a Meraki organization's appliances using the Meraki Dashboard API. It requires an authentication token for the API, and the ID of the organization for which the rules should be retrieved.

    .PARAMETER AuthToken
    The authentication token for the Meraki Dashboard API.

    .PARAMETER OrgId
    The ID of the organization for which the VPN firewall rules should be retrieved. If not specified, the function will use the ID of the first organization returned by the Get-MerakiOrganizations function.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationApplianceVPNFirewallRules -AuthToken $AuthToken -OrgId $OrganizationID

    Retrieves VPN firewall rules for the specified organization.

    .NOTES
    This function requires the Get-MerakiOrganizations function.

    .LINK
    https://developer.cisco.com/meraki/api-v1/#!get-organization-appliance-vpn-vpn-firewall-rules

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
            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/appliance/vpn/vpnFirewallRules" -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}
