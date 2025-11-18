function Revoke-MerakiAdministeredIdentitiesMeApiKeys {  
<#
.SYNOPSIS
Revokes a specific API key for the current administered identity in Cisco Meraki.

.DESCRIPTION
Calls the Meraki API to revoke (delete) a single API key associated with the authenticated administered identity.
This cmdlet performs an authenticated DELETE request to the endpoint:
https://api.meraki.com/api/v1/administered/identities/me/api/keys/{suffix}/revoke
and returns the API response. Errors from the API are thrown as exceptions.

.PARAMETER AuthToken
The Cisco Meraki API key used to authenticate the request. Required. Provide a valid API token with sufficient privileges to manage administered identities.

.PARAMETER Suffix
The identifier (suffix) of the API key to revoke. Required. This value is appended to the API path to target the specific key.

.EXAMPLE
# Revoke a key with suffix "abcd1234" using a literal token
Revoke-MerakiAdministeredIdentitiesMeApiKeys -AuthToken 'abcd...token' -Suffix 'abcd1234'

.LINK
https://developer.cisco.com/meraki/api-v1/ - Cisco Meraki API documentation
#>
    [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$Suffix
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $url = "https://api.meraki.com/api/v1/administered/identities/me/api/keys/$Suffix/revoke"

            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }