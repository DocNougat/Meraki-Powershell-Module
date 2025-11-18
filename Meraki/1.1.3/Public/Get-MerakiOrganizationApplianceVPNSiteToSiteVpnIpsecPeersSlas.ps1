function Get-MerakiOrganizationApplianceVPNSiteToSiteIpsecPeersSlas {
    <#
    .SYNOPSIS
    Retrieves IPsec peer SLA configurations for site-to-site VPN peers in a Meraki organization.

    .DESCRIPTION
    Calls the Meraki Dashboard API endpoint to obtain SLA (Service Level Agreement) information for IPsec peers configured under site-to-site VPN for a specified organization. Uses the provided API token for authentication via the X-Cisco-Meraki-API-Key header. If OrganizationID is not supplied, the function attempts to resolve an organization ID via the Get-OrgID helper; if multiple organizations are detected that helper will return an instructional message.

    .PARAMETER AuthToken
    The Meraki Dashboard API key. This value is sent in the X-Cisco-Meraki-API-Key request header. This parameter is mandatory.

    .PARAMETER OrganizationID
    The identifier (ID) of the Meraki organization whose appliance VPN site-to-site IPsec peer SLAs you want to retrieve. If omitted, the function attempts to determine a single organization ID using the Get-OrgID helper. If multiple organizations are present and no OrganizationID is provided, the helper returns a message instructing the caller to specify an organization ID.

    .EXAMPLE
    PS> Get-MerakiOrganizationVpnSiteToSiteIpsecPeersSlas -AuthToken '0123456789abcdef' -OrganizationID '123456'

    Retrieves SLA information for IPsec peers for organization 123456 using the supplied API token.

    .EXAMPLE
    PS> Get-MerakiOrganizationVpnSiteToSiteIpsecPeersSlas -AuthToken '0123456789abcdef'

    Attempts to resolve the organization ID automatically (via Get-OrgID) and then retrieves the SLA information. If multiple organizations are found, an instructional message is returned.

    .NOTES
    - Requires network access to api.meraki.com and a valid API key with sufficient permissions.
    - The function sends a User-Agent header identifying the module as "MerakiPowerShellModule/1.1.3 DocNougat".
    - Errors from the API or network calls are surfaced as terminating errors.

    .LINK
    https://developer.cisco.com/meraki/api-v1/get-organization-appliance-vpn-site-to-site-ipsec-peers-slas
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
            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/appliance/vpn/siteToSite/ipsec/peers/slas" -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}
