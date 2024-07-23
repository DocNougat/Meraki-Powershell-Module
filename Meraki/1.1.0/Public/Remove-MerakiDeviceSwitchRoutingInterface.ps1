function Remove-MerakiDeviceSwitchRoutingInterface {
    <#
    .SYNOPSIS
    Deletes a device switch routing interface.
    
    .DESCRIPTION
    The Remove-MerakiDeviceSwitchRoutingInterface function allows you to delete a device switch routing interface by providing the authentication token, device serial, and interface ID.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER DeviceSerial
    The serial number of the device.
    
    .PARAMETER InterfaceId
    The ID of the interface to be deleted.
    
    .EXAMPLE
    Remove-MerakiDeviceSwitchRoutingInterface -AuthToken "your-api-token" -DeviceSerial "Q2GV-ABCD-1234" -InterfaceId "123"
    
    This example deletes a device switch routing interface with the specified interface ID.
    
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
            [string]$InterfaceId
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/devices/$DeviceSerial/switch/routing/interfaces/$InterfaceId"
    
            $response = Invoke-RestMethod -Method Delete -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }