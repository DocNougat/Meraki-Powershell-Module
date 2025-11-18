function Get-MerakiOrganizationApplianceDnsSplitProfiles {
<#
.SYNOPSIS
Retrieves all Meraki Appliance DNS split profiles for an organization.

.DESCRIPTION
Calls the Meraki Dashboard API to return DNS split profiles associated with the specified organization.
The function requires a Meraki API key and will attempt to resolve the OrganizationID via Get-OrgID if none is supplied.
You can optionally restrict results to one or more profile IDs by passing them via the profileIds parameter.
The response is the deserialized JSON returned by the Meraki API.

.PARAMETER AuthToken
String. Mandatory. The Meraki API key used for authentication (sent as X-Cisco-Meraki-API-Key).

.PARAMETER OrganizationID
String. Optional. The organization ID to query. If not supplied, the function attempts to determine it by calling Get-OrgID -AuthToken $AuthToken.
If Get-OrgID returns the text "Multiple organizations found. Please specify an organization ID.", the function will return that message unchanged.

.PARAMETER profileIds
Array. Optional. An array of profile IDs to filter the DNS records.

.EXAMPLE

Get-MerakiOrganizationApplianceDnsSplitProfiles -AuthToken 'xxxxxxxxxxxxxxxxxxxx' -profileIds @('11234', '21432')
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
        [array]$profileIds
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "Content-Type" = "application/json"
            }
            $queryParams = @{}
            
            if ($profileIds) {
                $queryParams['profileIds[]'] = $profileIds
            }
        
            $queryString = New-MerakiQueryString -queryParams $queryParams

            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/appliance/dns/split/profiles?$queryString"

            $URI = [uri]::EscapeUriString($URL)
            
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
        Write-Debug $_
        Throw $_
    }
    }
}
