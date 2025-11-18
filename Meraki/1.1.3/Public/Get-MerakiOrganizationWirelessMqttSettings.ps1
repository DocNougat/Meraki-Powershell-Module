function Get-MerakiOrganizationWirelessMqttSettings {
    <#
    .SYNOPSIS
    Retrieves the wireless MQTT settings for a Meraki organization.

    .DESCRIPTION
    Calls the Meraki API endpoint to fetch wireless MQTT settings for the specified organization.
    If OrganizationID is not provided, the function attempts to resolve it by calling Get-OrgID -AuthToken <token>.
    If multiple organizations are found during resolution, the function returns the message:
    "Multiple organizations found. Please specify an organization ID."

    .PARAMETER AuthToken
    The Meraki API key used to authenticate the request. This parameter is mandatory.

    .PARAMETER OrganizationID
    The ID of the Meraki organization whose wireless MQTT settings will be retrieved.
    If omitted, Get-OrgID -AuthToken $AuthToken is invoked to auto-resolve the organization ID.

    .PARAMETER perPage
    (Optional) Integer to control the number of results per page returned by the API (pagination).

    .PARAMETER startingAfter
    (Optional) A paging token that indicates the resource ID to start returning results after.

    .PARAMETER endingBefore
    (Optional) A paging token that indicates the resource ID to end returning results before.

    .PARAMETER networkIds
    (Optional) An array of network IDs to filter the results to specific networks. This maps to the query parameter "networkIds[]".

    .EXAMPLE
    # Retrieve MQTT settings for a specific organization using an API key and OrganizationID
    Get-MerakiOrganizationWirelessMqttSettings -AuthToken 'your_api_key' -OrganizationID '123456'

    .NOTES
    - The function sends the API key in the "X-Cisco-Meraki-API-Key" header.
    - Ensure the provided API key has sufficient permissions to read organization wireless settings.
    - The function uses the Meraki REST API v1 endpoint:
        https://api.meraki.com/api/v1/organizations/{organizationId}/wireless/mqtt/settings
    - This function may throw terminating errors on HTTP or invocation failures; use try/catch when calling if you need to handle errors gracefully.

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
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/wireless/mqtt/settings?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}