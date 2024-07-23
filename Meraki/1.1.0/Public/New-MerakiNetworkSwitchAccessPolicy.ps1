function New-MerakiNetworkSwitchAccessPolicy {
    <#
    .SYNOPSIS
    Creates a new access policy for a network switch.
    
    .DESCRIPTION
    The New-MerakiNetworkSwitchAccessPolicy function allows you to create a new access policy for a specified network switch by providing the authentication token, network ID, and a JSON formatted string of policy configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network in which the network switch is located.
    
    .PARAMETER PolicyConfig
    A JSON formatted string of policy configuration.
    
    .EXAMPLE
    $PolicyConfig = [PSCustomObject]@{
        name = "Access policy #1"
        radiusServers = @(
            @{
                host = "1.2.3.4"
                port = 22
                secret = "secret"
            }
        )
        radius = @{
            criticalAuth = @{
                dataVlanId = 100
                voiceVlanId = 100
                suspendPortBounce = $true
            }
            failedAuthVlanId = 100
            reAuthenticationInterval = 120
        }
        guestPortBouncing = $false
        radiusTestingEnabled = $false
        radiusCoaSupportEnabled = $false
        radiusAccountingEnabled = $true
        radiusAccountingServers = @(
            @{
                host = "1.2.3.4"
                port = 22
                secret = "secret"
            }
        )
        radiusGroupAttribute = "11"
        hostMode = "Single-Host"
        accessPolicyType = "Hybrid authentication"
        increaseAccessSpeed = $false
        guestVlanId = 100
        dot1x = @{
            controlDirection = "inbound"
        }
        voiceVlanClients = $true
        urlRedirectWalledGardenEnabled = $true
        urlRedirectWalledGardenRanges = @("192.168.1.0/24")
    }

    $PolicyConfig = $PolicyConfig | ConvertTo-Json
    New-MerakiNetworkSwitchAccessPolicy -AuthToken "your-api-token" -NetworkId "1234" -PolicyConfig $PolicyConfig

    This example creates a new access policy for the network switch in the Meraki network with ID "1234" with the specified policy configuration.
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the creation is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$NetworkId,
            [parameter(Mandatory=$true)]
            [string]$PolicyConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/accessPolicies"
    
            $body = $PolicyConfig
    
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat" -Body $body
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }