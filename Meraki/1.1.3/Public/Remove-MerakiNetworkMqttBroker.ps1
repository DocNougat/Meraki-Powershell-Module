function Remove-MerakiNetworkMqttBroker {
    <#
    .SYNOPSIS
    Deletes an existing MQTT broker for a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Remove-MerakiNetworkMqttBroker function allows you to delete an existing MQTT broker for a specified Meraki network by providing the authentication token, network ID, and MQTT broker ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to delete an MQTT broker.

    .PARAMETER MqttBrokerId
    The ID of the MQTT broker you want to delete.

    .EXAMPLE
    Remove-MerakiNetworkMqttBroker -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -MqttBrokerId "1234"

    This example deletes the MQTT broker with ID "1234" for the Meraki network with ID "L_123456789012345678".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the MQTT broker deletion is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$MqttBrokerId
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/mqttBrokers/$MqttBrokerId"

        $response = Invoke-RestMethod -Method Delete -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}