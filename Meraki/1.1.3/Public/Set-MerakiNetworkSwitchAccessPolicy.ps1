function Set-MerakiNetworkSwitchAccessPolicy {
    <#
    .SYNOPSIS
    Updates the access policy for a network switch.
    
    .DESCRIPTION
    The Set-MerakiNetworkSwitchAccessPolicy function allows you to update the access policy for a specified network switch by providing the authentication token, network ID, access policy number, and a JSON formatted string of policy configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network in which the network switch is located.
    
    .PARAMETER AccessPolicyNumber
    The number of the access policy to be updated.
    
    .PARAMETER AccessPolicy
    A JSON formatted string of policy configuration.
    
    .EXAMPLE
    $AccessPolicy = [PSCustomObject]@{
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

    $AccessPolicy = $AccessPolicy | ConvertTo-Json
    Set-MerakiNetworkSwitchAccessPolicy -AuthToken "your-api-token" -NetworkId "1234" -AccessPolicyNumber "1" -AccessPolicy $AccessPolicy

    This example updates the access policy for the network switch in the Meraki network with ID "1234" with the specified policy configuration.
    
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
            [string]$AccessPolicyNumber,
            [parameter(Mandatory=$true)]
            [string]$AccessPolicy
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/accessPolicies/$AccessPolicyNumber"
    
            $body = $AccessPolicy
    
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }