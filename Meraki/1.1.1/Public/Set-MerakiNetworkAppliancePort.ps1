function Set-MerakiNetworkAppliancePort {
    <#
    .SYNOPSIS
    Updates the configuration of a network appliance port using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkAppliancePort function allows you to update the configuration of a network appliance port by providing the authentication token, network ID, port ID, and a port configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the network for which you want to update the port configuration.

    .PARAMETER PortId
    The ID of the port for which you want to update the configuration.

    .PARAMETER PortConfig
    A string containing the port configuration. The string should be in JSON format and should include the "vlan", "accessPolicy", "allowedVlans", "type", "dropUntaggedTraffic", and "enabled" properties.

    .EXAMPLE
    $config = [PSCustomObject]@{
        enabled = $true
        dropUntaggedTraffic = $false
        type = "access"
        vlan = 3
        allowedVlans = "all"
        accessPolicy = "open"
    }

    $config = $config | ConvertTo-Json -Compress
    Set-MerakiNetworkAppliancePort -AuthToken "your-api-token" -NetworkId "your-network-id" -PortId "your-port-id" -PortConfig $config

    This example updates the configuration of the port with ID "your-port-id" for the network with ID "your-network-id", using the specified port configuration.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$PortId,
        [parameter(Mandatory=$true)]
        [string]$PortConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $PortConfig

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/ports/$PortId"
        $response = Invoke-RestMethod -Method Put -Uri $uri -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}