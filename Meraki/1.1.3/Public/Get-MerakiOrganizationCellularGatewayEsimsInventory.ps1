function Get-MerakiOrganizationCellularGatewayEsimsInventory {
    <#
    .SYNOPSIS
    Retrieves the cellular gateway eSIM inventory for a Meraki organization.

    .DESCRIPTION
    Get-MerakiOrganizationCellularGatewayEsimsInventory calls the Meraki Dashboard API to return the eSIM inventory for the specified organization. If OrganizationID is not provided, the function will attempt to determine the organization ID by calling Get-OrgID using the provided AuthToken. Optionally, the call can be filtered to specific eSIM IDs (eids).

    .PARAMETER AuthToken
    The Meraki API key to authenticate the request. This parameter is mandatory.

    .PARAMETER OrganizationID
    The Meraki organization ID to query. If omitted, the function will call Get-OrgID -AuthToken $AuthToken to attempt to determine a single organization ID. If multiple organizations are found, the function returns the message: "Multiple organizations found. Please specify an organization ID."

    .PARAMETER eids
    An array of eSIM IDs to filter the inventory (sent as eids[] query parameters). Provide one or more eIDs as an array or comma-separated list. If omitted, the API returns inventory for all eSIMs in the organization.

    .EXAMPLE
    # Use an explicit organization ID
    Get-MerakiOrganizationCellularGatewayEsimsInventory -AuthToken 'abcd1234' -OrganizationID '123456'

    .EXAMPLE
    # Let the function determine the organization ID, and filter to specific eSIM IDs
    Get-MerakiOrganizationCellularGatewayEsimsInventory -AuthToken 'abcd1234' -eids @('eid1','eid2')

    .NOTES
    - The function sets required HTTP headers (X-Cisco-Meraki-API-Key and Content-Type) and uses Invoke-RestMethod to call the Meraki API endpoint:
        /organizations/{organizationId}/cellularGateway/esims/inventory
    - If the OrganizationID resolution returns the text "Multiple organizations found. Please specify an organization ID.", the function returns that message and does not call the API.
    - HTTP errors or other exceptions from Invoke-RestMethod are written to debug and rethrown.
    - Ensure your AuthToken has the necessary permissions to read organization eSIM inventory data.

    .LINK
    Meraki Dashboard API documentation: https://developer.cisco.com/meraki/api-v1/ (refer to the cellular gateway eSIM inventory endpoint)
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$false)]
        [array]$eids = $null
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
           
            if ($eids) {
                $queryParams['eids[]'] = $eids
            }
        
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/cellularGateway/esims/inventory?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
        Write-Debug $_
        Throw $_
    }
    }
}