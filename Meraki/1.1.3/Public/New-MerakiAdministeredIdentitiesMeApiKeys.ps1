function New-MerakiAdministeredIdentitiesMeApiKeys {  
<#
.SYNOPSIS
Generates a new API key for the calling administered identity in Cisco Meraki.

.DESCRIPTION
Posts to the Meraki Administered Identities endpoint to generate a new API key for the identity associated with the provided Meraki API token. Returns the deserialized JSON response from the Meraki API containing the generated key information and metadata.

.PARAMETER AuthToken
The Meraki API key used to authenticate the request. This value is placed in the X-Cisco-Meraki-API-Key header. Do not hard-code long-lived credentials in source; prefer secure storage.

.EXAMPLE
# Provide token from a secure source or environment variable
$token = "0123456789abcdef0123456789abcdef01234567"
New-MerakiAdministeredIdentitiesMeApiKeys -AuthToken $token

.NOTES
- Ensure the provided API token has the necessary permissions to generate administered-identity API keys.
- Treat the returned API key as sensitive; store it in a secure vault (e.g., Azure Key Vault, Windows Credential Manager).
- Prefer using secure strings or protected storage for AuthToken handling in automation.
#>
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $url = "https://api.meraki.com/api/v1/administered/identities/me/api/keys/generate"

            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }