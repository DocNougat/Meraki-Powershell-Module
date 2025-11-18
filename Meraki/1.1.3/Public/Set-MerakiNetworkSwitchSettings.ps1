function Set-MerakiNetworkSwitchSettings {
    <#
    .SYNOPSIS
    Updates network switch settings.
    
    .DESCRIPTION
    The Set-MerakiNetworkSwitchSettings function allows you to update network switch settings by providing the authentication token, network ID, and a JSON formatted string of switch settings configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
    .PARAMETER SwitchSettings
    A JSON formatted string of switch settings configuration.
    
    .EXAMPLE
    $SwitchSettings = [PSCustomObject]@{
        "uplinkClientSampling" = @{
            "enabled" = $true
        }
        "macBlocklist" = @{
            "enabled" = $true
        }
        "vlan" = 100
        "useCombinedPower" = $true
        "powerExceptions" = @(
            @{
                "powerType" = "redundant"
                "serial" = "qwert-12345-qwert"
            }
        )
    }

    $SwitchSettings = $SwitchSettings | ConvertTo-Json
    Set-MerakiNetworkSwitchSettings -AuthToken "your-api-token" -NetworkId "1234" -SwitchSettings $SwitchSettings

    This example updates network switch settings with the specified configuration.
    
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
            [string]$SwitchSettings
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/settings"
    
            $body = $SwitchSettings
    
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }