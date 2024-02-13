function Set-MerakiNetworkSwitchQOSRulesOrder {
    <#
    .SYNOPSIS
    Updates the order of network switch QoS rules.
    
    .DESCRIPTION
    The Set-MerakiNetworkSwitchQOSRulesOrder function allows you to update the order of network switch QoS rules by providing the authentication token, network ID, and a JSON formatted string of QoS rules order.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
    .PARAMETER QOSOrder
    A JSON formatted string of QoS rules order.
    
    .EXAMPLE
    $QOSOrder = [PSCustomObject]@{
        ruleIds = @(
            "1284392014819",
            "2983092129865"
        )
    }

    $QOSOrder = $QOSOrder | ConvertTo-Json -Compress
    Set-MerakiNetworkSwitchQOSRulesOrder -AuthToken "your-api-token" -NetworkId "N_1234" -QOSOrder $QOSOrder

    This example updates the order of network switch QoS rules with the specified order.
    
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
            [string]$QOSOrder
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/qosRules/order"
    
            $body = $QOSOrder
    
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }