function Set-MerakiNetworkSwitchRoutingOSPF {
    <#
    .SYNOPSIS
    Updates a network switch routing OSPF.
    
    .DESCRIPTION
    The Set-MerakiNetworkSwitchRoutingOSPF function allows you to update a network switch routing OSPF by providing the authentication token, network ID, and a JSON formatted string of OSPF configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
    .PARAMETER OSPFConfig
    A JSON formatted string of OSPF configuration.
    
    .EXAMPLE
    $OSPFConfig = [PSCustomObject]@{
        enabled = $true
        helloTimerInSeconds = 10
        deadTimerInSeconds = 40
        areas = @(
            [PSCustomObject]@{
                areaId = "1284392014819"
                areaName = "Backbone"
                areaType = "normal"
            }
        )
        v3 = [PSCustomObject]@{
            enabled = $true
            helloTimerInSeconds = 10
            deadTimerInSeconds = 40
            areas = @(
                [PSCustomObject]@{
                    areaId = "1284392014819"
                    areaName = "V3 Backbone"
                    areaType = "normal"
                }
            )
        }
        md5AuthenticationEnabled = $true
        md5AuthenticationKey = [PSCustomObject]@{
            id = 1234
            passphrase = "abc1234"
        }
    }

    $OSPFConfig = $OSPFConfig | ConvertTo-Json
    Set-MerakiNetworkSwitchRoutingOSPF -AuthToken "your-api-token" -NetworkId "N_1234" -OSPFConfig $OSPFConfig

    This example updates a network switch routing OSPF with the specified configuration.
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the update is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$NetworkId,
            [parameter(Mandatory=$true)]
            [string]$OSPFConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/routing/ospf"
    
            $body = $OSPFConfig
    
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }