function Remove-MerakiOrganizationApplianceDnsSplitProfile {
<#
.SYNOPSIS
Removes a Meraki Appliance DNS split profile for an organization.

.DESCRIPTION
Calls the Meraki Dashboard API to remove a DNS split profile associated with the specified organization.
The function requires a Meraki API key and will attempt to resolve the OrganizationID via Get-OrgID if none is supplied.
The response is the deserialized JSON returned by the Meraki API.

.PARAMETER AuthToken
String. Mandatory. The Meraki API key used for authentication (sent as X-Cisco-Meraki-API-Key).

.PARAMETER OrganizationID
String. Optional. The organization ID to query. If not supplied, the function attempts to determine it by calling Get-OrgID -AuthToken $AuthToken.
If Get-OrgID returns the text "Multiple organizations found. Please specify an organization ID.", the function will return that message unchanged.

.PARAMETER profileId
String. Mandatory. The profile ID to remove. If not supplied, the function attempts to remove all profiles.

.EXAMPLE
Remove-MerakiOrganizationApplianceDnsSplitProfile -AuthToken 'xxxxxxxxxxxxxxxxxxxx' -profileId '11234'

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
        [string]$profileId
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "Content-Type" = "application/json"
            }

            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/appliance/dns/split/profiles/$profileId"

            $URI = [uri]::EscapeUriString($URL)
            
            $response = Invoke-RestMethod -Method Delete -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
        Write-Debug $_
        Throw $_
    }
    }
}
