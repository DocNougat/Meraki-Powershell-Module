function Set-MerakiNetworkApplianceFirewallMulticastForwarding {
<#
.SYNOPSIS
Sets the multicast forwarding configuration for a Meraki network appliance.

.DESCRIPTION
Set-MerakiNetworkApplianceFirewallMulticastForwarding sends a PUT request to the Cisco Meraki Dashboard API to update the multicast forwarding (IGMP/Multicast) configuration for the specified network appliance. The function expects a JSON payload describing the multicast forwarding settings.

PARAMETER AuthToken
The Cisco Meraki Dashboard API key (string). This key is sent in the X-Cisco-Meraki-API-Key header and must have appropriate permissions to modify network appliance settings.

.PARAMETER NetworkId
The Meraki Network ID (string) for the target network where the appliance multicast forwarding settings will be updated. Example: "L_1234abcd".

.PARAMETER MulticastForwardingConfig
A JSON string representing the multicast forwarding configuration to apply. You may provide a raw JSON string or build a PowerShell object/hashtable and pipe it through ConvertTo-Json before passing. The API expects a valid JSON body that conforms to the Meraki endpoint schema for multicast forwarding.

.EXAMPLE
# Build the payload as a PowerShell object/hashtable and convert to JSON
$config = @{
    rules = @(
        @{
            address     = "192.0.2.10"
            description = "Video server"
            vlanIds     = @("10","20")
        },
        @{
            address     = "198.51.100.5"
            description = "Telemetry stream"
            vlanIds     = @("30")
        }
    )
}
$json = $config | ConvertTo-Json -Depth 5
Set-MerakiNetworkApplianceFirewallMulticastForwarding -AuthToken $env:MERAKI_API_KEY -NetworkId 'L_123456789' -MulticastForwardingConfig $json

.NOTES
- The function issues a PUT to: https://api.meraki.com/api/v1/networks/{networkId}/appliance/firewall/multicastForwarding
- Ensure the AuthToken has write permissions for the specified network.
- The MulticastForwardingConfig parameter must be valid JSON; use ConvertTo-Json when passing PowerShell objects.
- HTTP or API errors will be thrown as exceptions; consider using try/catch when calling this function to handle failures gracefully.

.LINK
https://developer.cisco.com/meraki/api-v1/ (Refer to the Meraki Dashboard API documentation for the multicast forwarding schema and additional details.)
#>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$MulticastForwardingConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $multicastForwardingConfig

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/firewall/multicastForwarding"
        $response = Invoke-RestMethod -Method Put -Uri $uri -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}