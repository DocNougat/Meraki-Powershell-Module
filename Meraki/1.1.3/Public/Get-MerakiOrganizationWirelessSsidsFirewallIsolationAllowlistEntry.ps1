function Get-MerakiOrganizationWirelessSsidsFirewallIsolationAllowlistEntry {
    <#
    .SYNOPSIS
    Retrieves wireless SSID firewall isolation allowlist entries for a Meraki organization.

    .DESCRIPTION
    Calls the Meraki API endpoint to list firewall isolation allowlist entries for wireless SSIDs in an organization.
    Supports pagination and filtering by network IDs and SSIDs. Returns the deserialized JSON objects produced by Invoke-RestMethod.

    .PARAMETER AuthToken
    The Meraki API key to authenticate the request. Required.

    .PARAMETER OrganizationID
    The Meraki organization ID to query. If not provided, the function attempts to obtain it via Get-OrgID -AuthToken $AuthToken.
    If multiple organizations are found by Get-OrgID, the function returns the message "Multiple organizations found. Please specify an organization ID."

    .PARAMETER perPage
    (Optional) Integer specifying the number of items to return per page for paginated responses.

    .PARAMETER startingAfter
    (Optional) Cursor value used to return results after the specified item (pagination).

    .PARAMETER endingBefore
    (Optional) Cursor value used to return results before the specified item (pagination).

    .PARAMETER networkIds
    (Optional) Array of network IDs used to filter results. Sent as networkIds[] query parameters.

    .PARAMETER ssids
    (Optional) Array of SSID identifiers used to filter results. Sent as ssids[] query parameters.

    .EXAMPLE
    # Retrieve all allowlist entries for a specific organization
    Get-MerakiOrganizationWirelessSsidsFirewallIsolationAllowlistEntry -AuthToken 'YOUR_API_KEY' -OrganizationID '123456789'

    .NOTES
    - Uses Meraki API v1 endpoint: /organizations/{organizationId}/wireless/ssids/firewall/isolation/allowlist/entries
    - Requires a valid Meraki API key with appropriate permissions.
    - The function throws a terminating error on HTTP or other failures; use try/catch when calling if you need to handle errors gracefully.

    .LINK
    https://developer.cisco.com/meraki/api-v1/
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$false)]
        [int]$perPage,
        [parameter(Mandatory=$false)]
        [string]$startingAfter,
        [parameter(Mandatory=$false)]
        [string]$endingBefore,
        [parameter(Mandatory=$false)]
        [array]$networkIds,
        [parameter(Mandatory=$false)]
        [array]$ssids
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try { 
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
            }
            $queryParams = @{}
            If ($perPage) { 
                $queryParams["perPage"] = $perPage 
            }
            If ($startingAfter) { 
                $queryParams["startingAfter"] = $startingAfter 
            }
            If ($endingBefore) { 
                $queryParams["endingBefore"] = $endingBefore 
            }
            If ($networkIds) { 
                $queryParams["networkIds[]"] = $networkIds
            }
            If ($ssids) { 
                $queryParams["ssids[]"] = $ssids
            }
                    
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/wireless/ssids/firewall/isolation/allowlist/entries?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}