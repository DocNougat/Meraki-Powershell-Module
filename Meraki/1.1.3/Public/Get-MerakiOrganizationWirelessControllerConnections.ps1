function Get-MerakiOrganizationWirelessControllerConnections {
    <#
    .SYNOPSIS
    Retrieves wireless controller connection records for a Meraki organization.

    .DESCRIPTION
    Get-MerakiOrganizationWirelessControllerConnections queries the Meraki Dashboard API to return wireless controller connection information for a specified organization. If OrganizationID is not provided, the function attempts to resolve it via Get-OrgID using the supplied AuthToken. The function supports common pagination and filtering parameters (perPage, startingAfter, endingBefore, networkIds, controllerSerials).

    .PARAMETER AuthToken
    The Meraki API key (X-Cisco-Meraki-API-Key). This parameter is required and must have sufficient privileges to read organization wireless controller data.

    .PARAMETER OrganizationID
    The Meraki organization ID to query. If omitted, the function will call Get-OrgID -AuthToken $AuthToken to attempt to resolve a single organization ID. If multiple organizations are found, you must specify OrganizationID explicitly.

    .PARAMETER perPage
    (Optional) The number of records to return per page. Maps to the Meraki API perPage query parameter.

    .PARAMETER startingAfter
    (Optional) Pagination cursor to return results starting after the provided cursor. Maps to the Meraki API startingAfter query parameter.

    .PARAMETER endingBefore
    (Optional) Pagination cursor to return results ending before the provided cursor. Maps to the Meraki API endingBefore query parameter.

    .PARAMETER networkIds
    (Optional) Array of network ID strings to filter results by. Each entry is added as networkIds[] query parameter.

    .PARAMETER controllerSerials
    (Optional) Array of wireless controller serial numbers to filter results by. Each entry is added as controllerSerials[] query parameter.

    .EXAMPLE
    # Retrieve connections for a specific organization
    Get-MerakiOrganizationWirelessControllerConnections -AuthToken 'your_api_key_here' -OrganizationID '123456'

    .LINK
    https://developer.cisco.com/meraki/api-v1/#!get-organization-wireless-controller-connections
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
            If ($controllerSerials) { 
                $queryParams["controllerSerials[]"] = $controllerSerials
            }
                    
            $queryString = New-MerakiQueryString -queryParams $queryParams

            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/wirelessController/connections?$queryString"

            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}