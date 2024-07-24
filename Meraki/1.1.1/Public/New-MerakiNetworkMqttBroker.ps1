function New-MerakiNetworkMqttBroker {
    <#
    .SYNOPSIS
    Creates an MQTT broker for a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The New-MerakiNetworkMqttBroker function allows you to create an MQTT broker for a specified Meraki network by providing the authentication token, network ID, and a MQTT broker configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to create an MQTT broker.

    .PARAMETER MqttBrokerConfig
    A string containing the MQTT broker configuration. The string should be in JSON format and should include the "name", "host", "port", and optionally the "security", "authentication", and "caCertificate" properties.

    .EXAMPLE
    $config = [PSCustomObject]@{
        name = "MQTT_Broker_1"
        host = "1.1.1.1"
        port = 1234
        security = [PSCustomObject]@{
            mode = "tls"
            tls = [PSCustomObject]@{
                verifyHostnames = $true
            }
        }
        authentication = [PSCustomObject]@{
            username = "Username"
        }
    }

    $config = $config | ConvertTo-Json -Compress

    New-MerakiNetworkMqttBroker -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -MqttBrokerConfig $config

    This example creates an MQTT broker for the Meraki network with ID "L_123456789012345678", setting the name to "MQTT_Broker_1", the host to "1.1.1.1", the port to 1234, and the security settings to use TLS with hostname verification enabled and optional authentication settings.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the MQTT broker creation is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$MqttBrokerConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $MqttBrokerConfig

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/mqttBrokers"

        $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}