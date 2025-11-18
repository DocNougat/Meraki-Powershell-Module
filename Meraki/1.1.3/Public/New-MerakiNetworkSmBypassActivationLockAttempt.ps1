function New-MerakiNetworkSmBypassActivationLockAttempt {
<#
.SYNOPSIS
Creates a bypass activation lock attempt for Meraki Systems Manager (SM) on a specified network.

.DESCRIPTION
Sends a POST request to the Cisco Meraki API endpoint for creating a bypass activation lock attempt for devices managed under the provided network ID.
Requires a valid Meraki API key with sufficient privileges.

.PARAMETER AuthToken
The Meraki API key used for authentication. This value is sent in the "X-Cisco-Meraki-API-Key" header.

.PARAMETER NetworkId
The Meraki network identifier (networkId) where the bypass activation lock attempt will be created.

.EXAMPLE
PS> New-MerakiNetworkSmBypassActivationLockAttempt -AuthToken '0123456789abcdef' -NetworkId 'L_1234abcd'
Creates a bypass activation lock attempt in the network L_1234abcd using the provided API key.

.LINK
https://developer.cisco.com/meraki/api-v1/
#>
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$NetworkId
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/sm/bypassActivationLockAttempts"

            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }