function New-MerakiNetworkSwitchStackRoutingStaticRoute {
    <#
    .SYNOPSIS
    Creates a network switch stack routing static route.
    
    .DESCRIPTION
    The New-MerakiNetworkSwitchStackRoutingStaticRoute function allows you to create a network switch stack routing static route by providing the authentication token, network ID, switch stack ID, and a JSON formatted string of the static route configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
    .PARAMETER SwitchStackId
    The ID of the switch stack.
    
    .PARAMETER StaticRoute
    A JSON formatted string of the static route configuration.
    
    .EXAMPLE
    $StaticRouteConfig = [PSCustomObject]@{
        name = "My route"
        subnet = "192.168.1.0/24"
        nextHopIp = "1.2.3.4"
        advertiseViaOspfEnabled = $false
        preferOverOspfRoutesEnabled = $false
    }

    $StaticRoute = $StaticRouteConfig | ConvertTo-Json -Compress
    New-MerakiNetworkSwitchStackRoutingStaticRoute -AuthToken "your-api-token" -NetworkId "1234" -SwitchStackId "5678" -StaticRoute $StaticRoute

    This example creates a network switch stack routing static route with the specified configuration.
    
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
            [string]$SwitchStackId,
            [parameter(Mandatory=$true)]
            [string]$StaticRoute
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/stacks/$SwitchStackId/routing/staticRoutes"
    
            $body = $StaticRoute
    
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }