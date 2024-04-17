function New-MerakiNetworkSwitchRoutingMulticastRendezvousPoint {
    <#
    .SYNOPSIS
    Creates a network switch routing multicast rendezvous point.
    
    .DESCRIPTION
    The New-MerakiNetworkSwitchRoutingMulticastRendezvousPoint function allows you to create a network switch routing multicast rendezvous point by providing the authentication token, network ID, and a JSON formatted string of rendezvous point configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
    .PARAMETER RendezvousPoint
    A JSON formatted string of rendezvous point configuration.
    
    .EXAMPLE
    $RendezvousPoint = [PSCustomObject]@{
        interfaceIp = "192.168.1.2"
        multicastGroup = "192.168.128.0/24"
    }

    $RendezvousPoint = $RendezvousPoint | ConvertTo-Json
    New-MerakiNetworkSwitchRoutingMulticastRendezvousPoint -AuthToken "your-api-token" -NetworkId "N_1234" -RendezvousPoint $RendezvousPoint

    This example creates a network switch routing multicast rendezvous point with the specified configuration.
    
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
            [string]$RendezvousPoint
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/routing/multicast/rendezvousPoints"
    
            $body = $RendezvousPoint
    
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }