function Set-MerakiNetworkSensorMQTTBroker {
    <#
    .SYNOPSIS
    Updates the MQTT broker profile for a Meraki network.
    
    .DESCRIPTION
    The Set-MerakiNetworkSensorMQTTBroker function allows you to update the MQTT broker profile for a specified Meraki network by providing the authentication token, network ID, broker ID, and a boolean value to enable or disable the MQTT broker.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The network ID of the Meraki network for which you want to update the MQTT broker profile.
    
    .PARAMETER BrokerId
    The ID of the MQTT broker profile that you want to update.
    
    .PARAMETER MQTTEnabled
    A boolean value to enable or disable the MQTT broker.
    
    .EXAMPLE
    Set-MerakiNetworkSensorMQTTBroker -AuthToken "your-api-token" -NetworkId "1234" -BrokerId "5678" -MQTTEnabled $true
    
    This example updates the MQTT broker profile with ID "5678" for the Meraki network with ID "1234" and enables the MQTT broker.
    
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
            [string]$BrokerId,
            [parameter(Mandatory=$true)]
            [bool]$MQTTEnabled
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/sensor/mqttBrokers/$BrokerId"
    
            $body = @{
                "enabled" = $MQTTEnabled
            } | ConvertTo-Json
    
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Host $_
        Throw $_
    }
    }