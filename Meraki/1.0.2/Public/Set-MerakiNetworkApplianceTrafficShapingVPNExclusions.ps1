function Set-MerakiNetworkApplianceTrafficShapingVPNExclusions {
    <#
    .SYNOPSIS
    Updates the VPN exclusions for a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkApplianceTrafficShapingVPNExclusions function allows you to update the VPN exclusions for a specified Meraki network by providing the authentication token, network ID, and VPN exclusion configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to update the VPN exclusions.

    .PARAMETER VPNExclusionsConfig
    A string containing the VPN exclusion configuration. The string should be in JSON format and should include the "custom" and "majorApplications" properties.

    .EXAMPLE
    $config = [PSCustomObject]@{
        custom = @(
            @{
                protocol = "tcp"
                destination = "192.168.3.0/24"
                port = "8000"
            }
        )
        majorApplications = @(
            @{
                id = "meraki:vpnExclusion/application/2"
                name = "Office 365 Sharepoint"
            }
        )
    }

    $config = $config | ConvertTo-Json -Compress
    Set-MerakiNetworkApplianceTrafficShapingVPNExclusions -AuthToken "your-api-token" -NetworkId "your-network-id" -VPNExclusionsConfig $config

    This example updates the VPN exclusions for the Meraki network with ID "your-network-id" using the specified VPN exclusion configuration.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the VPN exclusion update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$VPNExclusionsConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $VPNExclusionsConfig

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/trafficShaping/vpnExclusions"
        $response = Invoke-RestMethod -Method Put -Uri $uri -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Error $_
    }
}