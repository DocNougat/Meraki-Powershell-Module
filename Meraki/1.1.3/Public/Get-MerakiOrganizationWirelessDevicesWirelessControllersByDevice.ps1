function Get-MerakiOrganizationWirelessDevicesWirelessControllersByDevice {
    <#
    .SYNOPSIS
    Retrieves CPU load history for wireless devices acting as controllers in a Meraki organization.

    .DESCRIPTION
    Get-MerakiOrganizationWirelessDevicesWirelessControllersByDevice calls the Meraki Dashboard API to fetch historical CPU load data for wireless devices that are controllers within a specified organization. The function constructs query parameters (pagination and filters), builds the request URL, escapes the URI, and issues a GET request with the provided Meraki API key in the X-Cisco-Meraki-API-Key header. The function returns the deserialized response from Invoke-RestMethod or throws on error.

    .PARAMETER AuthToken
    The Meraki API key used for authentication. This value is required and is sent in the X-Cisco-Meraki-API-Key request header.

    .PARAMETER OrganizationID
    The Meraki organization ID to query. If not provided, the function attempts to determine the organization ID using Get-OrgID -AuthToken $AuthToken. If multiple organizations are found by Get-OrgID, the function returns an instruction to explicitly specify an organization ID.

    .PARAMETER perPage
    (Optional) The maximum number of items to return per page in a paginated response. When provided, it is sent as the perPage query parameter.

    .PARAMETER startingAfter
    (Optional) A pagination cursor that specifies to start the page after the provided cursor value. Sent as the startingAfter query parameter.

    .PARAMETER endingBefore
    (Optional) A pagination cursor that specifies to end the page before the provided cursor value. Sent as the endingBefore query parameter.

    .PARAMETER networkIds
    (Optional) An array of network IDs to filter results to specific networks. Each element is sent as networkIds[] in the query string.

    .PARAMETER serials
    (Optional) An array of device serial numbers to filter the results. Each element is sent as serials[] in the query string.

    .PARAMETER controllerSerials
    (Optional) An array of controller serial numbers to filter the results. Each element is sent as controllerSerials[] in the query string.

    .EXAMPLE
    # Use explicit AuthToken and OrganizationID to retrieve CPU load history
    Get-MerakiOrganizationWirelessDevicesWirelessControllersByDevice -AuthToken 'ABC123' -OrganizationID '123456' -perPage 50

    .NOTES
    - Requires network access to api.meraki.com and a valid Meraki API key with permission to read the organization's devices/monitoring data.
    - The function uses a custom query-string helper (New-MerakiQueryString) to serialize arrays and parameters.
    - Any errors during the request are emitted as exceptions; debug information is written when -Debug is enabled.
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
        [array]$serials,
        [parameter(Mandatory=$false)]
        [array]$controllerSerials
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
            If ($serials) { 
                $queryParams["serials[]"] = $serials
            }
            If ($controllerSerials) { 
                $queryParams["controllerSerials[]"] = $controllerSerials
            }
                    
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/wireless/devices/system/cpu/load/history?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}