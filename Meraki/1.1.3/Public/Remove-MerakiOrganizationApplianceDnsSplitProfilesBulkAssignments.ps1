function Remove-MerakiOrganizationApplianceDnsSplitProfilesBulkAssignments {
<#
.SYNOPSIS
Removes the split DNS profile from networks in the organization.

.DESCRIPTION
Calls the Meraki Dashboard API to remove DNS split profiles from Networks with the specified organization.
The function requires a Meraki API key and will attempt to resolve the OrganizationID via Get-OrgID if none is supplied.
You can optionally restrict results to one or more profile IDs by passing them via the profileIds parameter.
The response is the deserialized JSON returned by the Meraki API.

.PARAMETER AuthToken
String. Mandatory. The Meraki API key used for authentication (sent as X-Cisco-Meraki-API-Key).

.PARAMETER OrganizationID
String. Optional. The organization ID to query. If not supplied, the function attempts to determine it by calling Get-OrgID -AuthToken $AuthToken.
If Get-OrgID returns the text "Multiple organizations found. Please specify an organization ID.", the function will return that message unchanged.

.PARAMETER BulkRemovalConfig
String. Mandatory. A string containing the DNS split profile removals. The string should be in JSON format and should include the necessary properties for the DNS split profile.

.EXAMPLE
# Basic usage with automatic organization resolution
$config = [PSCustomObject]@{
    items = @(
        @{
            assignmentId = "8971234"
        },
        @{ assignmentId = "8974321"
        }
    )
} | ConvertTo-Json -Compress -Depth 4
Remove-MerakiOrganizationApplianceDnsSplitProfilesBulkAssignments -AuthToken 'xxxxxxxxxxxxxxxxxxxx' -BulkRemovalConfig $config
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
        [string]$BulkRemovalConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "Content-Type" = "application/json"
            }

            $body = $BulkRemovalConfig

            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/appliance/dns/split/profiles/assignments/bulkDelete"

            $URI = [uri]::EscapeUriString($URL)

            $response = Invoke-RestMethod -Method Post -Uri $URI -headers $header -body $body -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}