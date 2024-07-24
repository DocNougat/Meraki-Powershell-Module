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
    $config = [PSCustomObject]@{
        defaultRulesEnabled = $true
        rules = @(
            [PSCustomObject]@{
                definitions = @(
                    [PSCustomObject]@{
                        type = "host"
                        value = "google.com"
                    },
                    [PSCustomObject]@{
                        type = "port"
                        value = "9090"
                    },
                    [PSCustomObject]@{
                        type = "ipRange"
                        value = "192.1.0.0"
                    },
                    [PSCustomObject]@{
                        type = "ipRange"
                        value = "192.1.0.0/16"
                    },
                    [PSCustomObject]@{
                        type = "ipRange"
                        value = "10.1.0.0/16:80"
                    },
                    [PSCustomObject]@{
                        type = "localNet"
                        value = "192.168.0.0/16"
                    }
                )
                perClientBandwidthLimits = [PSCustomObject]@{
                    settings = "custom"
                    bandwidthLimits = [PSCustomObject]@{
                        limitUp = 1000000
                        limitDown = 1000000
                    }
                }
                dscpTagValue = 0
                priority = "normal"
            }
        )
    }

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
        $response = Invoke-RestMethod -Method Put -Uri $uri -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}