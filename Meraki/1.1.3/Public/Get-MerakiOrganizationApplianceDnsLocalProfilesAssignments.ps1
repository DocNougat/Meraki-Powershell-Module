function Get-MerakiOrganizationApplianceDnsLocalProfilesAssignments {
<#
.SYNOPSIS
Retrieves Meraki Appliance DNS local profile assignments for an organization.

.DESCRIPTION
Calls the Meraki Dashboard API to return DNS local profile assignments associated with the specified organization.
The function requires a Meraki API key and will attempt to resolve the OrganizationID via Get-OrgID if none is supplied.
You can optionally restrict results to one or more profile IDs by passing them via the profileIds parameter.
The response is the deserialized JSON returned by the Meraki API.

.PARAMETER AuthToken
String. Mandatory. The Meraki API key used for authentication (sent as X-Cisco-Meraki-API-Key).

.PARAMETER OrganizationID
String. Optional. The organization ID to query. If not supplied, the function attempts to determine it by calling Get-OrgID -AuthToken $AuthToken.
If Get-OrgID returns the text "Multiple organizations found. Please specify an organization ID.", the function will return that message unchanged.

.PARAMETER profileIds
Array. Optional. One or more DNS local profile IDs used to filter the returned profiles.
When provided, they are included in the query string as profileIds[] parameters.

.PARAMETER networkIds
Array. Optional. One or more network IDs used to filter the returned profiles.
When provided, they are included in the query string as networkIds[] parameters.

.EXAMPLE
# Basic usage with automatic organization resolution
Get-MerakiOrganizationApplianceSecurityEvents -AuthToken 'xxxxxxxxxxxxxxxxxxxx'

.EXAMPLE
# Specify organization and a single profile ID
Get-MerakiOrganizationApplianceSecurityEvents -AuthToken 'xxxxxxxx' -OrganizationID '123456' -profileIds @('profileId1')
#>    
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$false)]
        [array]$profileIds = $null,
        [parameter(Mandatory=$false)]
        [array]$networkIds = $null
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

            if ($networkIds) {
                $queryParams['networkIds[]'] = $networkIds
            }
        
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/appliance/dns/local/profiles/assignments?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
        Write-Debug $_
        Throw $_
    }
    }
}
