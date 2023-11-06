function Set-MerakiNetworkSwitchRoutingMulticast {
    <#
    .SYNOPSIS
    Updates a network switch routing multicast.
    
    .DESCRIPTION
    The Set-MerakiNetworkSwitchRoutingMulticast function allows you to update a network switch routing multicast by providing the authentication token, network ID, and a JSON formatted string of multicast configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
    .PARAMETER MulticastConfig
    A JSON formatted string of multicast configuration.
    
    .EXAMPLE
    $MulticastConfig = '{
        "defaultSettings": {
            "igmpSnoopingEnabled": true,
            "floodUnknownMulticastTrafficEnabled": true
        },
        "overrides": [
            {
                "switches": [
                    "Q234-ABCD-0001",
                    "Q234-ABCD-0002",
                    "Q234-ABCD-0003"
                ],
                "igmpSnoopingEnabled": true,
                "floodUnknownMulticastTrafficEnabled": true
            },
            {
                "stacks": [
                    "789102",
                    "123456",
                    "129102"
                ],
                "igmpSnoopingEnabled": true,
                "floodUnknownMulticastTrafficEnabled": true
            },
            {
                "switchProfiles": [ "1234", "4567" ],
                "igmpSnoopingEnabled": true,
                "floodUnknownMulticastTrafficEnabled": true
            }
        ]
    }'
    $MulticastConfig = $MulticastConfig | ConvertTo-Json
    Set-MerakiNetworkSwitchRoutingMulticast -AuthToken "your-api-token" -NetworkId "N_1234" -MulticastConfig $MulticastConfig
    
    This example updates a network switch routing multicast with the specified configuration.
    
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
            [string]$MulticastConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/routing/multicast"
    
            $body = $MulticastConfig
    
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
            Write-Host $_
        }
    }