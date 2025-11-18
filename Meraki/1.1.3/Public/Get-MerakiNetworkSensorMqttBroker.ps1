function Get-MerakiNetworkSensorMqttBroker {
<#
.SYNOPSIS
Retrieves MQTT broker configurations for Meraki Sensors in a specified network.

.DESCRIPTION
Get-MerakiNetworkSensorMqttBrokers queries the Meraki Dashboard API to return the MQTT broker definitions associated with a given network's Sensors. The function issues a GET request to the /networks/{networkId}/sensor/mqttBrokers endpoint and returns the parsed JSON response as PowerShell objects.

.PARAMETER AuthToken
The Meraki API key (X-Cisco-Meraki-API-Key) used to authenticate the request. Provide a valid API token with sufficient privileges to read sensor settings for the target network.

.PARAMETER NetworkId
The identifier (ID) of the Meraki network for which MQTT broker configurations will be retrieved. This is the networkId used by the Meraki Dashboard API.

.PARAMETER MqttBrokerID
The identifier (ID) of the specific MQTT broker to retrieve details for.

.EXAMPLE
# Retrieve MQTT brokers for a network
$apiKey = '0123456789abcdef0123456789abcdef01234567'
$networkId = 'L_123456789012345678'
Get-MerakiNetworkSensorMqttBrokers -AuthToken $apiKey -NetworkId $networkId -MqttBrokerID '8765123'

.LINK
https://developer.cisco.com/meraki/api-v1/ (Meraki Dashboard API reference)
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$NetworkId,
        [Parameter(Mandatory=$true)]
        [string]$MqttBrokerID
    )
    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/sensor/mqttBrokers/$MqttBrokerID" -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}