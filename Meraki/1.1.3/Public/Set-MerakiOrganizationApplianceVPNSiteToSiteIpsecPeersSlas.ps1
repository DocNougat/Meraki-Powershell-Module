function Set-MerakiOrganizationApplianceVPNSiteToSiteIpsecPeersSlas {
    <#
    .SYNOPSIS
    Sets SLA policy configuration for site-to-site IPsec peers in a Meraki organization.

    .DESCRIPTION
    Sends a PUT request to the Meraki Dashboard API to update Service Level Agreement (SLA) policies for IPsec site-to-site peers within the specified organization. The function requires an API key and a JSON-formatted SLA policy configuration. If OrganizationID is not provided, the function attempts to resolve it via Get-OrgID -AuthToken $AuthToken. If multiple organizations are found, the function returns an instruction to specify an organization ID and does not proceed.

    .PARAMETER AuthToken
    The Meraki API key used to authenticate requests (sent as X-Cisco-Meraki-API-Key). This parameter is mandatory.

    .PARAMETER OrganizationID
    The target Meraki organization identifier. If omitted, the function will attempt to determine the organization ID by calling Get-OrgID with the provided AuthToken. If multiple organizations are returned by the helper, the caller must provide an explicit OrganizationID.

    .PARAMETER SLAPolicyConfig
    A string containing the SLA policy configuration to apply. This should be valid JSON that conforms to the Meraki API schema for site-to-site IPsec peer SLAs. It is sent as the request body with content-type application/json; charset=utf-8. This parameter is mandatory.

    .EXAMPLE
    # Provide explicit organization ID and JSON payload variable
    $json = @{
        items = @(
            @{
                name = "sla policy"
                uri = "http://checkthisendpoint.com"
            }
        )  
    } | ConvertTo-Json -Compress -Depth 4
    Set-MerakiOrganizationApplianceVPNSiteToSiteIpsecPeersSlas -AuthToken $token -OrganizationID "123456" -SLAPolicyConfig $json

    # Updates SLA policies for the specified organization's IPsec peers.

    .NOTES
    - Ensure the AuthToken has sufficient privileges to modify appliance VPN settings.
    - SLAPolicyConfig must be valid JSON and appropriate for the Meraki API endpoint.
    - The function issues an HTTP PUT request and sets the User-Agent to MerakiPowerShellModule/1.1.3 DocNougat.

    .LINK
    Meraki Dashboard API documentation: https://developer.cisco.com/meraki/api-v1/
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [Parameter(Mandatory = $true)]
        [string]$SLAPolicyConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $body = $SLAPolicyConfig

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/appliance/vpn/siteToSite/ipsec/peers/slas"

            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}