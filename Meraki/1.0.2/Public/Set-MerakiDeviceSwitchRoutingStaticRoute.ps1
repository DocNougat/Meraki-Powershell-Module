function Set-MerakiDeviceSwitchRoutingStaticRoute {
    <#
    .SYNOPSIS
    Updates a device switch routing static route.
    
    .DESCRIPTION
    The Set-MerakiDeviceSwitchRoutingStaticRoute function allows you to update a device switch routing static route by providing the authentication token, device serial, static route ID, and a JSON formatted string of static route configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER DeviceSerial
    The serial number of the device.
    
    .PARAMETER StaticRouteId
    The ID of the static route.
    
    .PARAMETER StaticRoute
    A JSON formatted string of static route configuration.
    
    .EXAMPLE
    $StaticRoute = '{
        "name": "My route",
        "subnet": "192.168.1.0/24",
        "nextHopIp": "1.2.3.4",
        "advertiseViaOspfEnabled": false,
        "preferOverOspfRoutesEnabled": false
    }'
    $StaticRoute = $StaticRoute | ConvertTo-Json
    Set-MerakiDeviceSwitchRoutingStaticRoute -AuthToken "your-api-token" -DeviceSerial "1234-5678-9101" -StaticRouteId "1" -StaticRoute $StaticRoute
    
    This example updates a device switch routing static route with the specified configuration.
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the update is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$DeviceSerial,
            [parameter(Mandatory=$true)]
            [string]$StaticRouteId,
            [parameter(Mandatory=$true)]
            [string]$StaticRoute
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/devices/$DeviceSerial/switch/routing/staticRoutes/$StaticRouteId"
    
            $body = $StaticRoute
    
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
            Write-Host $_
        }
    }