function Remove-MerakiOrganizationWirelessSsidsFirewallIsolationAllowlistEntry {
    <#
    .SYNOPSIS
    Removes an entry from a wireless SSID firewall isolation allowlist for a Meraki organization.

    .DESCRIPTION
    Remove-MerakiOrganizationWirelessSSIDsFirewallIsolationAllowlistEntry deletes a single allowlist entry for SSID firewall isolation in the specified Meraki organization using the Meraki Dashboard API. If OrganizationID is not supplied, the function attempts to determine it by calling Get-OrgID with the provided AuthToken. The function issues an HTTP DELETE request to the corresponding API endpoint and returns the API response (deserialized JSON) or an error.

    .PARAMETER AuthToken
    The Meraki API key used to authenticate the request. This parameter is mandatory.

    .PARAMETER OrganizationID
    The unique identifier (ID) of the Meraki organization that contains the SSID firewall isolation allowlist. If omitted, the function will call Get-OrgID -AuthToken <AuthToken> to attempt to resolve a single organization ID. If multiple organizations are found, the function will return an error string asking the caller to specify an organization ID explicitly.

    .PARAMETER EntryId
    The identifier of the allowlist entry to remove. This parameter is mandatory.

    .EXAMPLE
    # Remove an allowlist entry by specifying API key, organization ID and entry ID
    Remove-MerakiOrganizationWirelessSSIDsFirewallIsolationAllowlistEntry -AuthToken "123abc" -OrganizationID "987654" -EntryId "entry_001"

    .LINK
    https://developer.cisco.com/meraki/api-v1/

    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$EntryId
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/wireless/ssids/firewall/isolation/allowlist/entries/$EntryId"
            
            $response = Invoke-RestMethod -Method Delete -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}