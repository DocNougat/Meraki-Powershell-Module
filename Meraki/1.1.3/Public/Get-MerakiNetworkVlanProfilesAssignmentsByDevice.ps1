function Get-MerakiNetworkVlanProfilesAssignmentsByDevice {
<#
.SYNOPSIS
Retrieves VLAN profile assignments by device for a specified Meraki network.

.DESCRIPTION
Calls the Meraki Dashboard API endpoint to list VLAN profile assignments grouped by device for a given network. Supports pagination and filtering by device serials, product types, and stack IDs. Uses the provided API key for authentication via the X-Cisco-Meraki-API-Key header.

.PARAMETER AuthToken
The Meraki API key used to authenticate the request. This parameter is mandatory.

.PARAMETER NetworkId
The identifier (ID) of the Meraki network to query. This parameter is mandatory.

.PARAMETER perPage
(Optional) Maximum number of entries to return per page. If omitted, the API default is used.

.PARAMETER startingAfter
(Optional) A pagination cursor. Return entries after this cursor.

.PARAMETER endingBefore
(Optional) A pagination cursor. Return entries before this cursor.

.PARAMETER deviceSerials
(Optional) Array of device serial numbers to filter the results. When specified, only assignments for these device serials are returned.

.PARAMETER productTypes
(Optional) Array of product types to filter the results (e.g., "ap", "switch", "camera"). When specified, only assignments matching these product types are returned.

.PARAMETER stackIds
(Optional) Array of stack IDs to filter the results. When specified, only assignments for devices in these stacks are returned.

.EXAMPLE
Get-MerakiNetworkVlanProfilesAssignmentsByDevice -AuthToken $env:MERAKI_KEY -NetworkId "L_123456789012345" -perPage 100

Retrieves up to 100 VLAN profile assignments for the specified network using the API key stored in the MERAKI_KEY environment variable.

.EXAMPLE
Get-MerakiNetworkVlanProfilesAssignmentsByDevice -AuthToken $token -NetworkId "L_987654321098765" -deviceSerials @("Q2XX-XXXX-XXXX","Q2YY-YYYY-YYYY") -productTypes @("switch")

Retrieves VLAN profile assignments for the provided device serials, filtered to product type "switch".

.LINK
https://developer.cisco.com/meraki/api-v1/ (Meraki Dashboard API documentation)
#>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$false)]
        [int]$perPage = $null,
        [parameter(Mandatory=$false)]
        [string]$startingAfter = $null,
        [parameter(Mandatory=$false)]
        [string]$endingBefore = $null,
        [parameter(Mandatory=$false)]
        [array]$deviceSerials = $null,        
        [parameter(Mandatory=$false)]
        [array]$productTypes = $null,
        [parameter(Mandatory=$false)]
        [array]$stackIds = $null
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $queryParams = @{}
        if ($perPage) {
            $queryParams['perPage'] = $perPage
        }
        if ($startingAfter) {
            $queryParams['startingAfter'] = $startingAfter
        }
        if ($endingBefore) {
            $queryParams['endingBefore'] = $endingBefore
        }
        if ($deviceSerials) {
            $queryParams['deviceSerials[]'] = $deviceSerials
        }
        if ($productTypes) {
            $queryParams['productTypes[]'] = $productTypes
        }
        if ($stackIds) {
            $queryParams['stackIds[]'] = $stackIds
        }

        $queryString = New-MerakiQueryString -queryParams $queryParams
    
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/vlanProfiles/assignments/byDevice?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response

    } catch {
        Write-Debug $_
        Throw $_
    }
}