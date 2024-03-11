function Invoke-MerakiNetworkAddSwitchToStack {
    <#
    .SYNOPSIS
    Adds a switch to a network switch stack.
    
    .DESCRIPTION
    The Invoke-MerakiNetworkAddSwitchToStack function allows you to add a switch to a network switch stack by providing the authentication token, network ID, switch stack ID, and a JSON formatted string of the device serial.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
    .PARAMETER SwitchStackId
    The ID of the switch stack.
    
    .PARAMETER DeviceSerial
    A string of the device serial.
    
    .EXAMPLE
    Invoke-MerakiNetworkAddSwitchToStack -AuthToken "your-api-token" -NetworkId "1234" -SwitchStackId "5678" -DeviceSerial "QBZY-XWVU-TSRQ"
    
    This example adds a switch with the specified serial to a network switch stack.
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the addition is successful, otherwise, it displays an error message.
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
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/stacks/$SwitchStackId/add"
            $body = @{
                "serial" = $DeviceSerial
            } | ConvertTo-Json -Compress
    
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }