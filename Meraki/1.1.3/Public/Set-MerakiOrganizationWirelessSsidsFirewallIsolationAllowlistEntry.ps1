function Set-MerakiOrganizationWirelessSsidsFirewallIsolationAllowlistEntry {
    <#
    .SYNOPSIS
    Updates a wireless SSID firewall isolation allowlist entry for a Meraki organization.

    .DESCRIPTION
    Set-MerakiOrganizationWirelessSSIDsFirewallIsolationAllowlistEntry modifies an existing allowlist entry in the wireless SSIDs firewall isolation allowlist for the specified Meraki organization by calling the Meraki Dashboard API.
    The function requires a valid Meraki API key and a JSON payload describing the allowlist entry. If OrganizationID is not supplied, the function attempts to determine the organization ID by calling Get-OrgID -AuthToken <token>. If multiple organizations are found by Get-OrgID, the function will return the string "Multiple organizations found. Please specify an organization ID.".

    .PARAMETER AuthToken
    The Meraki Dashboard API key (X-Cisco-Meraki-API-Key). This parameter is required.

    .PARAMETER OrganizationID
    The Meraki organization ID to target. If not provided, Get-OrgID -AuthToken $AuthToken is used to determine a single organization ID automatically. If Get-OrgID returns the message indicating multiple organizations, the function will return that message and will not attempt the API call.

    .PARAMETER EntryID
    The unique identifier for the allowlist entry to modify. This parameter is required.

    .PARAMETER AllowlistEntryConfig
    A JSON-formatted string that represents the allowlist entry payload expected by the Meraki API. Example payloads should follow the Meraki API schema for wireless SSID firewall isolation allowlist entries. It is recommended to build a PowerShell object and convert it using ConvertTo-Json before passing if creating the payload programmatically.

    .EXAMPLE
    # Provide all parameters explicitly (JSON string for payload)
    $token = "0123456789abcdef"
    $orgId = "123456"
    $payload = @{
        description = "Allowlist Entry Example"
        client = @{
            mac = "00:11:22:33:44:55"
        }
        ssid = @{
            number = 1
        }
        network = @{
            id = "N_123456789012345678"
        }
    } | ConvertTo-Json -Depth 10 -Compress
    Set-MerakiOrganizationWirelessSSIDsFirewallIsolationAllowlistEntry -AuthToken $token -OrganizationID $orgId -EntryID "1234" -AllowlistEntryConfig $payload

    .NOTES
    - The function issues an HTTP POST to the Meraki API endpoint:
        https://api.meraki.com/api/v1/organizations/{organizationId}/wireless/ssids/firewall/isolation/allowlist/entries/{entryId}
        and sets the Content-Type to application/json; charset=utf-8.
    - Ensure the API key provided in AuthToken has sufficient privileges to modify organization firewall/SSID settings.
    - The function emits debug information when an exception occurs; exceptions are re-thrown for caller handling.

    .LINK
    Meraki Dashboard API documentation: https://developer.cisco.com/meraki/api-v1/
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$EntryID,
        [parameter(Mandatory=$true)]
        [string]$AllowlistEntryConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/wireless/ssids/firewall/isolation/allowlist/entries/$EntryID"

            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $AllowlistEntryConfig
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}