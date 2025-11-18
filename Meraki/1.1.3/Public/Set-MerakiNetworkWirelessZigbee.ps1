function Set-MerakiNetworkWirelessZigbee {
<#
.SYNOPSIS
Updates Zigbee settings for a Meraki wireless network.

.DESCRIPTION
Set-MerakiNetworkWirelessZigbee sends a POST request to the Meraki Dashboard API to configure Zigbee settings for the specified network.
Provide a valid API key, the target NetworkId, and a JSON payload describing the Zigbee configuration. The function uses Invoke-RestMethod and returns the API response object.

.PARAMETER AuthToken
The Meraki Dashboard API key (X-Cisco-Meraki-API-Key). This parameter is required and should be kept secret.

.PARAMETER NetworkId
The identifier of the Meraki network to update (for example: "N_1234567890"). This parameter is required.

.PARAMETER ZigbeeConfig
A JSON string or PowerShell object representing the Zigbee configuration to be sent in the request body. If supplying a PowerShell object or hashtable, convert it to JSON first (for example: $body = $config | ConvertTo-Json -Depth 5).
Example payload shape depends on Meraki API schema for /networks/{networkId}/wireless/zigbee.

.EXAMPLE
# Using a PowerShell object (convert to JSON before calling)
$config = @{
    enabled  = $true
}
$json = $config | ConvertTo-Json -Depth 5
Set-MerakiNetworkWirelessZigbee -AuthToken $env:MERAKI_API_KEY -NetworkId 'N_123456' -ZigbeeConfig $json

.LINK
https://developer.cisco.com/meraki/api-v1/ (Meraki Dashboard API documentation)
#>
    [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$NetworkId,
            [parameter(Mandatory=$true)]
            [string]$ZigbeeConfig
        )
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/wireless/zigbee"
    
            $body = $ZigbeeConfig
    
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }