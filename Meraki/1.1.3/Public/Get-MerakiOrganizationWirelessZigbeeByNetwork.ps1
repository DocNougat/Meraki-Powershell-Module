function Get-MerakiOrganizationWirelessZigbeeByNetwork {
    <#
    .SYNOPSIS
    Retrieves Zigbee device information grouped by network for a specified Meraki organization.

    .DESCRIPTION
    Calls the Meraki API endpoint /organizations/{organizationId}/wireless/zigbee/byNetwork to return Zigbee device data grouped by network. Supports pagination and filtering by one or more network IDs. If OrganizationID is not supplied, the function attempts to resolve it by calling Get-OrgID -AuthToken <token>. The API key is sent using the X-Cisco-Meraki-API-Key header.

    .PARAMETER AuthToken
    The Cisco Meraki API key to authenticate the request. Required.

    .PARAMETER OrganizationID
    The Meraki organization ID to query. If omitted, the function attempts to determine the organization ID by calling Get-OrgID -AuthToken <AuthToken>. If multiple organizations are found, the function returns a message instructing the caller to specify an OrganizationID.

    .PARAMETER perPage
    (Optional) Integer specifying the number of items to return per page. Passed to the API as the perPage query parameter.

    .PARAMETER startingAfter
    (Optional) Opaque pagination cursor indicating that results should start after this value. Passed to the API as the startingAfter query parameter.

    .PARAMETER endingBefore
    (Optional) Opaque pagination cursor indicating that results should end before this value. Passed to the API as the endingBefore query parameter.

    .PARAMETER networkIds
    (Optional) Array of network ID strings to filter results. Each value is passed to the API as networkIds[] query parameters.

    .EXAMPLE
    Query using only an API key (OrganizationID resolved automatically)

    Get-MerakiOrganizationWirelessZigbeeByNetwork -AuthToken 'abcd1234'

    Retrieves Zigbee device information for the organization associated with the provided API key.
    
    .NOTES
    - The function issues a GET request to the Meraki API and will throw on HTTP or parsing errors.
    - Ensure the provided API key has sufficient permissions to read wireless/zigbee information for the target organization.
    - networkIds is sent as multiple networkIds[] query parameters; supply as an array when filtering by more than one network.

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
        [array]$networkIds
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
                    
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/wireless/zigbee/byNetwork?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}