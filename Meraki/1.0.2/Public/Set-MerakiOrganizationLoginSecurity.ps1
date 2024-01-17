function Set-MerakiOrganizationLoginSecurity {
    <#
    .SYNOPSIS
    Updates the login security settings for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiOrganizationLoginSecurity function allows you to update the login security settings for a specified Meraki organization by providing the authentication token, organization ID, and a JSON string containing the login security configuration.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization in which the login security settings are to be updated.

    .PARAMETER SecurityConfig
    A JSON string containing the login security configuration. The JSON string should conform to the schema definition provided by the Meraki Dashboard API.

    .EXAMPLE
    $SecurityConfig = [PSCustomObject]@{
        accountLockoutAttempts = 5
        idleTimeoutMinutes = 30
        numDifferentPasswords = 5
        passwordExpirationDays = 90
        enforceAccountLockout = $true
        enforceDifferentPasswords = $true
        enforceIdleTimeout = $true
        enforceLoginIpRanges = $true
        enforcePasswordExpiration = $true
        enforceStrongPasswords = $true
        enforceTwoFactorAuth = $true
        loginIpRanges = @("192.168.1.0/24", "10.0.0.0/8")
        apiAuthentication = @{
            enabled = $true
            ipRestrictionsForKeys = @{
                enabled = $true
                ranges = @("192.168.1.0/24", "10.0.0.0/8")
            }
        }
    }

    $SecurityConfig = $SecurityConfig | ConvertTo-JSON -Compress

    Set-MerakiOrganizationLoginSecurity -AuthToken "your-api-token" -OrganizationId "1234567890" -SecurityConfig $SecurityConfig

    This example updates the login security settings for the Meraki organization with ID "1234567890" by enforcing various security policies and restricting access to certain IP addresses.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the login security settings update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$SecurityConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $body = $SecurityConfig

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/loginSecurity"

            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
            Write-Host $_
        }
    }
}