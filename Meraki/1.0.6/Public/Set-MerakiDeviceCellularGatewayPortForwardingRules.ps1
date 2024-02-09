function Set-MerakiDeviceCellularGatewayPortForwardingRules {
    <#
    .SYNOPSIS
    Updates the port forwarding rules for a Meraki device's cellular gateway.
    
    .DESCRIPTION
    The Set-MerakiDeviceCellularGatewayPortForwardingRules function allows you to update the port forwarding rules for a specified Meraki device's cellular gateway by providing the authentication token, device serial, and a port forwarding rules configuration string.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER Serial
    The serial number of the Meraki device for which you want to update the port forwarding rules.
    
    .PARAMETER PortForwardingRules
    A string containing the port forwarding rules configuration. The string should be in JSON format and should include the properties as defined in the schema.
    
    .EXAMPLE
    $PortForwardingRules = [PSCustomObject]@{
        rules = @(
            [PSCustomObject]@{
                lanIp = "172.31.128.5"
                name = "test"
                access = "any"
                publicPort = "11-12"
                localPort = "4"
                uplink = "both"
                protocol = "tcp"
            },
            [PSCustomObject]@{
                lanIp = "172.31.128.5"
                name = "test 2"
                access = "restricted"
                allowedIps = @("10.10.10.10", "10.10.10.11")
                publicPort = "99"
                localPort = "5"
                uplink = "both"
                protocol = "tcp"
            }
        )
    }

    $PortForwardingRules = $PortForwardingRules | ConvertTo-Json -Compress

    Set-MerakiDeviceCellularGatewayPortForwardingRules -AuthToken "your-api-token" -Serial "Q2GV-ABCD-1234" -PortForwardingRules $PortForwardingRules

    This example updates the port forwarding rules for the Meraki device with serial "Q2GV-ABCD-1234".
    
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
            [string]$PortForwardingRules
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/devices/$Serial/cellularGateway/portForwardingRules"
            $body = $PortForwardingRules
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Host $_
        Throw $_
    }
    }