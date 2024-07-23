function New-MerakiNetworkSwitchQOSRule {
    <#
    .SYNOPSIS
    Creates a network switch QoS rule.
    
    .DESCRIPTION
    The New-MerakiNetworkSwitchQOSRule function allows you to create a network switch QoS rule by providing the authentication token, network ID, and a JSON formatted string of QoS configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
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
    New-MerakiNetworkSwitchQOSRule -AuthToken "your-api-token" -NetworkId "N_1234" -QOSConfig $QOSConfig

    This example creates a network switch QoS rule with the specified QoS configuration.
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the creation is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$NetworkId,
            [parameter(Mandatory=$true)]
            [string]$QOSConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/qosRules"
    
            $body = $QOSConfig
    
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }