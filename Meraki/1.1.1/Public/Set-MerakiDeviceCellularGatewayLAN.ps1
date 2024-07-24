function Set-MerakiDeviceCellularGatewayLAN {
    <#
    .SYNOPSIS
    Updates the LAN settings for a Meraki device's cellular gateway.
    
    .DESCRIPTION
    The Set-MerakiDeviceCellularGatewayLAN function allows you to update the LAN settings for a specified Meraki device's cellular gateway by providing the authentication token, device serial, and a LAN configuration string.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER Serial
    The serial number of the Meraki device for which you want to update the LAN settings.
    
    .PARAMETER LANConfig
    A string containing the LAN configuration. The string should be in JSON format and should include the properties as defined in the schema.
    
    .EXAMPLE
    $LANConfig = [PSCustomObject]@{
        deviceName = "name of the MG"
        deviceLanIp = "192.168.0.33"
        deviceSubnet = "192.168.0.32/27"
        fixedIpAssignments = @(
            [PSCustomObject]@{
                mac = "0b:00:00:00:00:ac"
                name = "server 1"
                ip = "192.168.0.10"
            },
            [PSCustomObject]@{
                mac = "0b:00:00:00:00:ab"
                name = "server 2"
                ip = "192.168.0.20"
            }
        )
        reservedIpRanges = @(
            [PSCustomObject]@{
                start = "192.168.1.0"
                end = "192.168.1.1"
                comment = "A reserved IP range"
            }
        )
    }

    $LANConfig = $LANConfig | ConvertTo-Json -Compress

    Set-MerakiDeviceCellularGatewayLAN -AuthToken "your-api-token" -Serial "Q2GV-ABCD-1234" -LANConfig $LANConfig

    This example updates the LAN settings for the Meraki device with serial "Q2GV-ABCD-1234".
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the update is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$Serial,
            [parameter(Mandatory=$true)]
            [string]$LANConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/devices/$Serial/cellularGateway/lan"
    
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat" -Body $LANConfig
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }