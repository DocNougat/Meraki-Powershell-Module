function Set-MerakiNetworkApplianceSettings {
    <#
    .SYNOPSIS
    Updates the appliance settings for a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkApplianceSettings function allows you to update the appliance settings for a specified Meraki network by providing the authentication token, network ID, and an appliance configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to update the appliance settings.

    .PARAMETER ApplianceConfig
    A string containing the appliance configuration. The string should be in JSON format and should include the "clientTrackingMethod", "deploymentMode", and "dynamicDns" properties.

    .EXAMPLE
    $config = [PSCustomObject]@{
        clientTrackingMethod = "MAC address"
        deploymentMode = "routed"
        dynamicDns = @{
            prefix = "test"
            enabled = $true
        }
    }

    $config = $config | ConvertTo-Json -Compress
    Set-MerakiNetworkApplianceSettings -AuthToken "your-api-token" -NetworkId "your-network-id" -ApplianceConfig $config

    This example updates the appliance settings for the Meraki network with ID "your-network-id", using the specified appliance configuration.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the appliance settings update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$ApplianceConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $ApplianceConfig

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/settings"
        $response = Invoke-RestMethod -Method Put -Uri $uri -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}