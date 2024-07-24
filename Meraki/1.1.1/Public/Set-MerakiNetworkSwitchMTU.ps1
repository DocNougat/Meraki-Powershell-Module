function Set-MerakiNetworkSwitchMTU {
    <#
    .SYNOPSIS
    Updates the MTU for a network switch.
    
    .DESCRIPTION
    The Set-MerakiNetworkSwitchMTU function allows you to update the MTU for a specified network switch by providing the authentication token, network ID, and a JSON formatted string of MTU configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network in which the network switch is located.
    
    .PARAMETER MTUConfig
    A JSON formatted string of MTU configuration.
    
    .EXAMPLE
    $MTUConfig = [PSCustomObject]@{
        defaultMtuSize = 9578
        overrides = @(
            @{
                switches = @(
                    "Q234-ABCD-0001",
                    "Q234-ABCD-0002",
                    "Q234-ABCD-0003"
                )
                mtuSize = 1500
            },
            @{
                switchProfiles = @(
                    "1284392014819",
                    "2983092129865"
                )
                mtuSize = 1600
            }
        )
    }

    $MTUConfig = $MTUConfig | ConvertTo-Json -Compress
    Set-MerakiNetworkSwitchMTU -AuthToken "your-api-token" -NetworkId "1234" -MTUConfig $MTUConfig

    This example updates the MTU for the network switch in the Meraki network with ID "1234" with the specified MTU configuration.
    
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
            [string]$MTUConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/mtu"
    
            $body = $MTUConfig
    
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }