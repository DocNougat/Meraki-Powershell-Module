function Set-MerakiNetworkApplianceTrafficShapingUplinkSelection {
    <#
    .SYNOPSIS
    Updates the uplink selection settings for a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkApplianceTrafficShapingUplinkSelection function allows you to update the uplink selection settings for a specified Meraki network by providing the uplink selection configuration string.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to update the uplink bandwidth settings.

    .PARAMETER UplinkSelectionConfig
    A string containing the uplink selection configuration. The string should be in JSON format and should include the "defaultUplink", "activeActiveAutoVPNEnabled", "loadBalancingEnabled", "failoverAndFailback", "wanTrafficUplinkPreferences", and "vpnTrafficUplinkPreferences" properties.

    .EXAMPLE
    $config = [PSCustomObject]@{
        activeActiveAutoVPNEnabled = $true
        defaultUplink = "wan1"
        loadBalancingEnabled = $true
        failoverAndFailback = @{
            immediate = @{
                enabled = $true
            }
        }
        wanTrafficUplinkPreferences = @(
            @{
                trafficFilters = @(
                    @{
                        type = "custom"
                        value = @{
                            protocol = "tcp"
                            source = @{
                                port = "1-1024"
                                cidr = "192.168.1.0/24"
                                vlan = 10
                                host = 254
                            }
                            destination = @{
                                port = "any"
                                cidr = "any"
                            }
                        }
                    }
                )
                preferredUplink = "wan1"
            }
        )
        vpnTrafficUplinkPreferences = @(
            @{
                trafficFilters = @(
                    @{
                        type = "applicationCategory"
                        value = @{
                            id = "meraki:layer7/category/1"
                            protocol = "tcp"
                            source = @{
                                port = "any"
                                cidr = "192.168.1.0/24"
                                network = "L_23456789"
                                vlan = 20
                                host = 200
                            }
                            destination = @{
                                port = "1-1024"
                                cidr = "any"
                                network = "L_12345678"
                                vlan = 10
                                host = 254
                                fqdn = "www.google.com"
                            }
                        }
                    }
                )
                preferredUplink = "bestForVoIP"
                failOverCriterion = "poorPerformance"
                performanceClass = @{
                    type = "custom"
                    builtinPerformanceClassName = "VoIP"
                    customPerformanceClassId = "123456"
                }
            }
        )
    }

    $config = $config | ConvertTo-Json -Compress
    Set-MerakiNetworkApplianceTrafficShapingUplinkSelection -AuthToken "your-api-token" -NetworkId "your-network-id" -UplinkSelectionConfig $config

    This example updates the uplink selection settings for the Meraki network using the specified uplink selection configuration.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the uplink selection update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$UplinkSelectionConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $UplinkSelectionConfig

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/trafficShaping/uplinkSelection"
        $response = Invoke-RestMethod -Method Put -Uri $uri -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}