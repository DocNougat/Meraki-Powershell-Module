function Remove-MerakiNetworkSwitchStackRoutingStaticRoute {
    <#
    .SYNOPSIS
    Deletes a network switch stack routing static route.
    
    .DESCRIPTION
    The Remove-MerakiNetworkSwitchStackRoutingStaticRoute function allows you to delete a network switch stack routing static route by providing the authentication token, network ID, switch stack ID, and static route ID.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
    .PARAMETER SwitchStackId
    The ID of the switch stack.
    
    .PARAMETER StaticRouteId
    The ID of the static route.
    
    .EXAMPLE
    Remove-MerakiNetworkSwitchStackRoutingStaticRoute -AuthToken "your-api-token" -NetworkId "1234" -SwitchStackId "5678" -StaticRouteId "91011"
    
    This example deletes a network switch stack routing static route.
    
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
            [string]$SwitchStackId,
            [parameter(Mandatory=$true)]
            [string]$StaticRouteId
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/stacks/$SwitchStackId/routing/staticRoutes/$StaticRouteId"
    
            $response = Invoke-RestMethod -Method Delete -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }