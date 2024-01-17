function Invoke-MerakiNetworkWipeSmDevices {
    <#
    .SYNOPSIS
    Wipes devices in a Meraki network.
    
    .DESCRIPTION
    The Invoke-MerakiNetworkWipeSmDevices function allows you to wipe devices in a specified Meraki network by providing the authentication token, network ID, and a JSON formatted string of wipe configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network from which you want to wipe devices.
    
    .PARAMETER WipeConfig
    A JSON formatted string of wipe configuration.
    
    .EXAMPLE
    $config = [PSCustomObject]@{
        wifiMac = "00:11:22:33:44:55"
        id = "1284392014819"
        serial = "Q234-ABCD-5678"
        pin = 123456
    }
    $config = $config | ConvertTo-Json
    Invoke-MerakiNetworkWipeSmDevices -AuthToken "your-api-token" -NetworkId "1234" -WipeConfig $config
    This example wipes devices from the Meraki network with ID "1234" with the specified wipe configuration.
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the wipe is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$NetworkId,
            [parameter(Mandatory=$true)]
            [string]$WipeConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/sm/devices/wipe"
    
            $body = $WipeConfig
    
            $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
            Write-Host $_
        }
    }