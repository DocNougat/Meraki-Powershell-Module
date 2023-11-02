function Set-MerakiNetworkApplianceTrafficShapingRules {
    <#
    .SYNOPSIS
    Updates the traffic shaping rules for a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkApplianceTrafficShapingRules function allows you to update the traffic shaping rules for a specified Meraki network by providing the authentication token, network ID, and a traffic shaping rule configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to update the traffic shaping rules.

    .PARAMETER RuleConfig
    A string containing the traffic shaping rule configuration. The string should be in JSON format and should include the "defaultRulesEnabled", "rules", and "definitions" properties.

    .EXAMPLE
    $config = '{
        "defaultRulesEnabled": true,
        "rules": [
            {
                "definitions": [
                    {
                        "type": "host",
                        "value": "google.com"
                    },
                    {
                        "type": "port",
                        "value": "9090"
                    },
                    {
                        "type": "ipRange",
                        "value": "192.1.0.0"
                    },
                    {
                        "type": "ipRange",
                        "value": "192.1.0.0/16"
                    },
                    {
                        "type": "ipRange",
                        "value": "10.1.0.0/16:80"
                    },
                    {
                        "type": "localNet",
                        "value": "192.168.0.0/16"
                    }
                ],
                "perClientBandwidthLimits": {
                    "settings": "custom",
                    "bandwidthLimits": {
                        "limitUp": 1000000,
                        "limitDown": 1000000
                    }
                },
                "dscpTagValue": 0,
                "priority": "normal"
            }
        ]
    }'
    $config = $config | ConvertTo-Json -Compress
    Set-MerakiNetworkApplianceTrafficShapingRules -AuthToken "your-api-token" -NetworkId "your-network-id" -RuleConfig $config

    This example updates the traffic shaping rules for the Meraki network with ID "your-network-id" using the specified traffic shaping rule configuration.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the traffic shaping rule update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$RuleConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $RuleConfig

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/trafficShaping/rules"
        $response = Invoke-RestMethod -Method Put -Uri $uri -Header $header -Body $body
        return $response
    }
    catch {
        Write-Error $_
    }
}