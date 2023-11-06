function Set-MerakiNetworkMqttBroker {
    <#
    .SYNOPSIS
    Updates an existing MQTT broker for a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkMqttBroker function allows you to update an existing MQTT broker for a specified Meraki network by providing the authentication token, network ID, MQTT broker ID, and a MQTT broker configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to update an MQTT broker.

    .PARAMETER MqttBrokerId
    The ID of the MQTT broker you want to update.

    .PARAMETER MqttBrokerConfig
    A string containing the MQTT broker configuration. The string should be in JSON format and should include the "name", "host", "port", and optionally the "security", "authentication", and "caCertificate" properties.

    .EXAMPLE
    $config = @{
        "id" = "1234"
        "name" = "MQTT_Broker_1"
        "host" = "1.1.1.1"
        "port" = 1234
        "security" = @{
            "mode" = "tls"
            "tls" = @{
                "verifyHostnames" = $true
            }
        }
        "authentication" = @{
            "username" = "Username"
        }
    } | ConvertTo-Json -Compress

    Set-MerakiNetworkMqttBroker -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -MqttBrokerId "1234" -MqttBrokerConfig $config

    This example updates the MQTT broker with ID "1234" for the Meraki network with ID "L_123456789012345678", setting the name to "MQTT_Broker_1", the host to "1.1.1.1", the port to 1234, and the security settings to use TLS with hostname verification enabled and optional authentication settings.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the MQTT broker update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$MqttBrokerId,
        [parameter(Mandatory=$true)]
        [string]$MqttBrokerConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $MqttBrokerConfig

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/mqttBrokers/$MqttBrokerId"

        $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Host $_
    }
}