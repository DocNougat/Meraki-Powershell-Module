function Get-MerakiOrganizationWirelessZigbeeDoorLocks {
    <#
    .SYNOPSIS
    Retrieves wireless Zigbee door lock devices for a specified Meraki organization.

    .DESCRIPTION
    Calls the Meraki REST API to list Zigbee door lock devices associated with an organization.
    Supports pagination and filtering by network IDs or device serial. The function returns
    deserialized JSON as PowerShell objects (typically an array of device objects).

    .PARAMETER AuthToken
    API key for authenticating to the Meraki API. This value is sent in the X-Cisco-Meraki-API-Key header.
    This parameter is mandatory.

    .PARAMETER OrganizationID
    The Meraki organization ID to query. If omitted, the function attempts to resolve the organization ID
    (via Get-OrgID). If multiple organizations are found, the function returns a message asking you to
    specify an organization ID.

    .PARAMETER perPage
    (Optional) Number of items to return per page. This is forwarded to the Meraki API as the perPage query parameter.

    .PARAMETER startingAfter
    (Optional) Pagination token indicating the response should start after the specified item. Sent as startingAfter.

    .PARAMETER endingBefore
    (Optional) Pagination token indicating the response should end before the specified item. Sent as endingBefore.

    .PARAMETER networkIds
    (Optional) Array of network IDs to filter the results. Sent as networkIds[] in the query string to limit devices
    to the specified networks.

    .PARAMETER serial
    (Optional) Device serial number to filter the results to a specific device.

    .EXAMPLE
    # Retrieve all Zigbee door locks for the specified organization
    Get-MerakiOrganizationWirelessZigbeeDoorLocks -AuthToken $token -OrganizationID "123456"

    .NOTES
    - Will throw on HTTP or deserialization errors; use try/catch when calling from scripts to handle errors gracefully.

    .LINK
    https://developer.cisco.com/meraki/api-v1/ (Meraki API documentation)
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
        [string]$serial
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
            If ($serial) { 
                $queryParams["serial"] = $serial
            }
                    
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/wireless/zigbee/doorLocks?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}