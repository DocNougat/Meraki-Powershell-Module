function Get-MerakiOrganizationApplianceFirewallMulticastForwardingByNetwork {
<#
.SYNOPSIS
Retrieves all Meraki Appliance firewall multicast forwarding settings for a specific network.

.DESCRIPTION
Calls the Meraki Dashboard API to return firewall multicast forwarding settings associated with the specified network.
The function requires a Meraki API key and will attempt to resolve the OrganizationID and NetworkID via Get-OrgID and Get-NetworkID if none are supplied.
The response is the deserialized JSON returned by the Meraki API.

.PARAMETER AuthToken
String. Mandatory. The Meraki API key used for authentication (sent as X-Cisco-Meraki-API-Key).

.PARAMETER OrganizationID
String. Optional. The organization ID to query. If not supplied, the function attempts to determine it by calling Get-OrgID -AuthToken $AuthToken.

.PARAMETER networkIDs
Array. Optional. An array of network IDs to filter the multicast forwarding settings.

.PARAMETER perPage
Integer. Optional. The number of entries per page returned. Default is 1000, maximum is 1000.

.PARAMETER startingAfter
String. Optional. A token used by the server to indicate the start of the page.

.PARAMETER endingBefore
String. Optional. A token used by the server to indicate the end of the page.

.EXAMPLE

Get-MerakiOrganizationApplianceFirewallMulticastForwardingByNetwork -AuthToken 'xxxxxxxxxxxxxxxxxxxx' -networkIDs @('N_1234', 'N_4321')
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
        [array]$networkIDs,
        [parameter(Mandatory=$false)]
        [int]$perPage = 1000,
        [parameter(Mandatory=$false)]
        [string]$startingAfter,
        [parameter(Mandatory=$false)]
        [string]$endingBefore
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

            if ($networkIDs) {
                $queryParams['networkIds[]'] = $networkIDs
            }

            if ($perPage) {
                $queryParams['perPage'] = $perPage
            }

            if ($startingAfter) {
                $queryParams['startingAfter'] = $startingAfter
            }

            if ($endingBefore) {
                $queryParams['endingBefore'] = $endingBefore
            }
        
            $queryString = New-MerakiQueryString -queryParams $queryParams

            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/appliance/firewall/multicastForwarding/byNetwork?$queryString"

            $URI = [uri]::EscapeUriString($URL)
            
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
        Write-Debug $_
        Throw $_
    }
    }
}
