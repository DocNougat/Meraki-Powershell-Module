function Set-MerakiNetworkSwitchQOSRule {
    <#
    .SYNOPSIS
    Updates a network switch QoS rule.
    
    .DESCRIPTION
    The Set-MerakiNetworkSwitchQOSRule function allows you to update a network switch QoS rule by providing the authentication token, network ID, QoS rule ID, and a JSON formatted string of QoS configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
    .PARAMETER QosRuleId
    The ID of the QoS rule to be updated.
    
    .PARAMETER QOSConfig
    A JSON formatted string of QoS configuration.
    
    .EXAMPLE
    $QOSConfig = [PSCustomObject]@{
        vlan = 100
        protocol = "TCP"
        srcPort = 2000
        srcPortRange = "70-80"
        dstPort = 3000
        dstPortRange = "3000-3100"
        dscp = 0
    }

    $QOSConfig = $QOSConfig | ConvertTo-Json -Compress
    Set-MerakiNetworkSwitchQOSRule -AuthToken "your-api-token" -NetworkId "N_1234" -QosRuleId "QOS_1234" -QOSConfig $QOSConfig

    This example updates a network switch QoS rule with the specified QoS configuration.
    
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
            [string]$QosRuleId,
            [parameter(Mandatory=$true)]
            [string]$QOSConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/qosRules/$QosRuleId"
    
            $body = $QOSConfig
    
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Host $_
        Throw $_
    }
    }