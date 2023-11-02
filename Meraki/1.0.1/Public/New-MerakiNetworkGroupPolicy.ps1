function New-MerakiNetworkGroupPolicy {
<#
.SYNOPSIS
Creates a new group policy for a Meraki network.

.DESCRIPTION
This function creates a new group policy for a Meraki network using the Meraki Dashboard API. The function takes a JSON-formatted string as input and sends it to the API endpoint to create the new group policy.

.PARAMETER AuthToken
The authentication token (API key) required to access the Meraki Dashboard API.

.PARAMETER NetworkId
    The ID of the Meraki network for which you want to create a floor plan.

.PARAMETER GroupPolicyConfig
The JSON-formatted string representing the configuration of the new group policy.

.EXAMPLE
$config = '{
    "name": "No video streaming",
    "scheduling": {
        "enabled": true,
        "monday": {
            "active": true,
            "from": "9:00",
            "to": "17:00"
        },
        "tuesday": {
            "active": true,
            "from": "9:00",
            "to": "17:00"
        },
        "wednesday": {
            "active": true,
            "from": "9:00",
            "to": "17:00"
        },
        "thursday": {
            "active": true,
            "from": "9:00",
            "to": "17:00"
        },
        "friday": {
            "active": true,
            "from": "9:00",
            "to": "17:00"
        },
        "saturday": {
            "active": false,
            "from": "0:00",
            "to": "24:00"
        },
        "sunday": {
            "active": false,
            "from": "0:00",
            "to": "24:00"
        }
    },
    "bandwidth": {
        "settings": "custom",
        "bandwidthLimits": {
            "limitUp": 1000000,
            "limitDown": 1000000
        }
    },
    "firewallAndTrafficShaping": {
        "settings": "custom",
        "trafficShapingRules": [
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
                "pcpTagValue": 0
            }
        ],
        "l3FirewallRules": [
            {
                "comment": "Allow TCP traffic to subnet with HTTP servers.",
                "policy": "allow",
                "protocol": "tcp",
                "destPort": "443",
                "destCidr": "192.168.1.0/24"
            }
        ],
        "l7FirewallRules": [
            {
                "policy": "deny",
                "type": "host",
                "value": "google.com"
            },
            {
                "policy": "deny",
                "type": "port",
                "value": "23"
            },
            {
                "policy": "deny",
                "type": "ipRange",
                "value": "10.11.12.00/24"
            },
            {
                "policy": "deny",
                "type": "ipRange",
                "value": "10.11.12.00/24:5555"
            }
        ]
    },
    "contentFiltering": {
        "allowedUrlPatterns": {
            "settings": "network default",
            "patterns": []
        },
        "blockedUrlPatterns": {
            "settings": "append",
            "patterns": [
                "http://www.example.com",
                "http://www.betting.com"
            ]
        },
        "blockedUrlCategories": {
            "settings": "override",
            "categories": [
                "meraki:contentFiltering/category/1",
                "meraki:contentFiltering/category/7"
            ]
        }
    },
    "splashAuthSettings": "bypass",
    "vlanTagging": {
        "settings": "custom",
        "vlanId": "1"
    },
    "bonjourForwarding": {
        "settings": "custom",
        "rules": [
            {
                "description": "A simple bonjour rule",
                "vlanId": "1",
                "services": [ "All Services" ]
            }
        ]
    }
}'
$config = $config | ConvertTo-Json
New-MerakiNetworkGroupPolicy -AuthToken "your-api-token" -NetworkId "L_9817349871234" -GroupPolicyConfig $config

This example creates a new group policy with the specified configuration.

.NOTES
For more information about the Meraki Dashboard API, see https://developer.cisco.com/meraki/api-v1/.
#>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [Parameter(Mandatory = $true)]
        [string]$GroupPolicyConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $GroupPolicyConfig

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/groupPolicies"

        $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -Body $body
        return $response
    }
    catch {
        Write-Host $_
    }
}