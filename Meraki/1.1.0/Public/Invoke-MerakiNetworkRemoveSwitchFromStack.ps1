function Invoke-MerakiNetworkRemoveSwitchFromStack {
    <#
    .SYNOPSIS
    Removes a switch from a network switch stack.
    
    .DESCRIPTION
    The Invoke-MerakiNetworkRemoveSwitchFromStack function allows you to remove a switch from a network switch stack by providing the authentication token, network ID, switch stack ID, and a device serial.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
    .PARAMETER SwitchStackId
    The ID of the switch stack.
    
    .PARAMETER DeviceSerial
    The serial of the device to be removed.
    
    .EXAMPLE
    Invoke-MerakiNetworkRemoveSwitchFromStack -AuthToken "your-api-token" -NetworkId "1234" -SwitchStackId "5678" -DeviceSerial "QBZY-XWVU-TSRQ"
    
    This example removes a switch with the specified serial from a network switch stack.
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the removal is successful, otherwise, it displays an error message.
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
            [string]$DeviceSerial
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/stacks/$SwitchStackId/remove"
            $body = @{
                "serial" = $DeviceSerial
            } | ConvertTo-Json -Compress
    
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }