function Set-MerakiNetworkApplianceSdwanInternetPolicies {
    <#
    .SYNOPSIS
    Sets SD-WAN Internet Policies for a specified network.

    .DESCRIPTION
    This function allows you to set SD-WAN Internet Policies for a specified network by providing the authentication token, network ID, and a JSON string with the policy details.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the network.

    .PARAMETER SdwanInternetPolicies
    A compressed JSON string representing the SD-WAN Internet Policies.

    .EXAMPLE
    $policyDetails = @{
        wanTrafficUplinkPreferences = @(
            @{
                failOverCriterion = "poorPerformance"
                preferredUplink = "wan1"
                performanceClass = @{
                    type = "builtin"
                    builtinPerformanceClassName = "VoIP"
                }
                trafficFilters = @(
                    @{
                        type = "custom"
                        value = @{
                            protocol = "tcp"
                            destination = @{
                                cidr = "192.168.10.0/24"
                                port = "8080"
                            }
                            source = @{
                                cidr = "10.0.0.0/24"
                                port = "any"
                            }
                        }
                    }
                )
            }
        )
    }
    $policyDetailsJson = $policyDetails | ConvertTo-Json -Compress -Depth 4
    Set-MerakiNetworkApplianceSdwanInternetPolicies -AuthToken "your-api-token" -NetworkId "N_123456" -SdwanInternetPolicies $policyDetailsJson

    This example sets SD-WAN Internet Policies for the network with ID "N_123456" using the provided policy details.

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$SdwanInternetPolicies
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/sdwan/internetPolicies"

        $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat" -Body $SdwanInternetPolicies
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
