function Remove-MerakiNetworkSwitchRoutingMulticastRendezvousPoint {
    <#
    .SYNOPSIS
    Deletes a network switch routing multicast rendezvous point.
    
    .DESCRIPTION
    The Remove-MerakiNetworkSwitchRoutingMulticastRendezvousPoint function allows you to delete a network switch routing multicast rendezvous point by providing the authentication token, network ID, and rendezvous point ID.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
    .PARAMETER RendezvousPointId
    The ID of the rendezvous point.
    
    .EXAMPLE
    Remove-MerakiNetworkSwitchRoutingMulticastRendezvousPoint -AuthToken "your-api-token" -NetworkId "N_1234" -RendezvousPointId "RP_1234"
    
    This example deletes a network switch routing multicast rendezvous point with the specified ID.
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the deletion is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$NetworkId,
            [parameter(Mandatory=$true)]
            [string]$RendezvousPointId
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/routing/multicast/rendezvousPoints/$RendezvousPointId"
    
            $response = Invoke-RestMethod -Method Delete -Uri $url -Header $header
            return $response
        }
        catch {
            Write-Host $_
        }
    }