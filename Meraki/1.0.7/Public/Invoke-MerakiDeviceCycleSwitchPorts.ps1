function Invoke-MerakiDeviceCycleSwitchPorts {
    <#
    .SYNOPSIS
    Cycles a device switch ports.
    
    .DESCRIPTION
    The Invoke-MerakiDeviceCycleSwitchPorts function allows you to cycle a device switch ports by providing the authentication token, device serial number, and a JSON formatted string of the ports.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER Serial
    The serial number of the device.
    
    .PARAMETER Ports
    A JSON formatted string of the ports.
    
    .EXAMPLE
    $Ports = [PSCustomObject]@{
        ports = @(
            "1",
            "2-5",
            "1_MA-MOD-8X10G_1",
            "1_MA-MOD-8X10G_2-1_MA-MOD-8X10G_8"
        )
    }
    $Ports = $Ports | ConvertTo-Json -Compress
    Invoke-MerakiDeviceCycleSwitchPorts -AuthToken "your-api-token" -Serial "Q234-ABCD-0001" -Ports $Ports

    This example cycles a device switch ports with the specified ports.
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the operation is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$Serial,
            [parameter(Mandatory=$true)]
            [string]$Ports
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/devices/$Serial/switch/ports/cycle"
    
            $body = $Ports
    
            $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }