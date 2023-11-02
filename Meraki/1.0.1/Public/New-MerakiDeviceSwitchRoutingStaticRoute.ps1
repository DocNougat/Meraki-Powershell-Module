function New-MerakiDeviceSwitchRoutingStaticRoute {
    <#
    .SYNOPSIS
    Creates a device switch routing static route.
    
    .DESCRIPTION
    The New-MerakiDeviceSwitchRoutingStaticRoute function allows you to create a device switch routing static route by providing the authentication token, device serial, and a JSON formatted string of static route configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER DeviceSerial
    The serial number of the device.
    
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
    New-MerakiDeviceSwitchRoutingStaticRoute -AuthToken "your-api-token" -DeviceSerial "1234-5678-9101" -StaticRoute $StaticRoute
    
    This example creates a device switch routing static route with the specified configuration.
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the creation is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$DeviceSerial,
            [parameter(Mandatory=$true)]
            [string]$StaticRoute
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/devices/$DeviceSerial/switch/routing/staticRoutes"
    
            $body = $StaticRoute
    
            $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -Body $body
            return $response
        }
        catch {
            Write-Host $_
        }
    }