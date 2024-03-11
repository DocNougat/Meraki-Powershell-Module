function Remove-MerakiDeviceSwitchRoutingStaticRoute {
    <#
    .SYNOPSIS
    Deletes a device switch routing static route.
    
    .DESCRIPTION
    The Remove-MerakiDeviceSwitchRoutingStaticRoute function allows you to delete a device switch routing static route by providing the authentication token, device serial, and static route ID.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER DeviceSerial
    The serial number of the device.
    
    .PARAMETER StaticRouteId
    The ID of the static route.
    
    .EXAMPLE
    Remove-MerakiDeviceSwitchRoutingStaticRoute -AuthToken "your-api-token" -DeviceSerial "1234-5678-9101" -StaticRouteId "1"
    
    This example deletes a device switch routing static route with the specified ID.
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the deletion is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$DeviceSerial,
            [parameter(Mandatory=$true)]
            [string]$StaticRouteId
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/devices/$DeviceSerial/switch/routing/staticRoutes/$StaticRouteId"
    
            $response = Invoke-RestMethod -Method Delete -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }