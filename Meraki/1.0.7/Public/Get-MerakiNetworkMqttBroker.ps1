function Get-MerakiNetworkMqttBroker {
    <#
    .SYNOPSIS
        Gets details for a specific MQTT broker in a Meraki network.
        
    .DESCRIPTION
        This function retrieves details for a specific MQTT broker in a Meraki network, including its ID, name, host, port, username, and password.
        
    .PARAMETER AuthToken
        The Meraki API token to use for authentication.
        
    .PARAMETER NetworkId
        The ID of the Meraki network to retrieve the MQTT broker from.
        
    .PARAMETER mqttBrokerId
        The ID of the MQTT broker to retrieve.
        
    .EXAMPLE
        PS C:\> Get-MerakiNetworkMqttBroker -AuthToken "1234" -NetworkId "N_1234" -mqttBrokerId "1234"
        
        This command retrieves details for the MQTT broker with ID "1234" in the Meraki network with ID "N_1234" using the Meraki API token "1234".
    
    .NOTES
        For more information, see https://developer.cisco.com/meraki/api/#!get-network-mqtt-broker.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$mqttBrokerId
    )
    Try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/mqttBrokers/$mqttBrokerId" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    } catch {
        Write-Debug $_
        Throw $_
    }
}