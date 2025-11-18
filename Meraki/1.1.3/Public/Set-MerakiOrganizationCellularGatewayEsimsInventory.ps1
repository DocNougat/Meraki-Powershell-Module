function Set-MerakiOrganizationCellularGatewayEsimsInventory {
    <#
    .SYNOPSIS
    Updates the inventory record for a cellular gateway eSIM in a Meraki organization.

    .DESCRIPTION
    Set-MerakiOrganizationCellularGatewayEsimsInventory updates an existing eSIM inventory entry for a given Meraki organization using the Meraki Dashboard API.
    Provide a valid Meraki API key and the eSIM identifier, along with a JSON-formatted body describing the desired inventory state. If OrganizationID is not supplied, the function attempts to resolve it via Get-OrgID -AuthToken <AuthToken>. If Get-OrgID returns a "Multiple organizations found..." message, the function will return that message and will not attempt the API call.

    .PARAMETER AuthToken
    The Meraki Dashboard API key to use for authentication. This parameter is mandatory.

    .PARAMETER OrganizationID
    The Meraki organization ID to target. Optional — if omitted, the function calls Get-OrgID -AuthToken <AuthToken> to determine a single org ID. If multiple organizations are found, the function will return the message "Multiple organizations found. Please specify an organization ID."

    .PARAMETER EsimId
    The identifier of the eSIM inventory record to update. This is required and is appended to the API path.

    .PARAMETER EsimConfig
    The request body to send to the API describing the eSIM inventory update. This must be a JSON-formatted string (for example, '{"status":"active","notes":"Updated via script"}'). The function sends this value as the HTTP request body unchanged.

    .EXAMPLE
    # Provide explicit organization ID and JSON string body
    $apiKey = '0123456789abcdef0123456789abcdef01234567'
    $orgId  = '123456'
    $esimId = 'esim-abcdef'
    $body   = '{"status": "activated"}'

    Set-MerakiOrganizationCellularGatewayEsimsInventory -AuthToken $apiKey -OrganizationID $orgId -EsimId $esimId -EsimConfig $body

    .NOTES
    - Requires network access to api.meraki.com and a valid API key with appropriate permissions to modify organization cellular gateway eSIM inventory.
    - EsimConfig must be valid JSON. The function does not perform JSON serialization; pass a JSON string or ensure you convert objects to JSON before calling.
    - Errors from the REST call are thrown for callers to handle.

    .LINK
    https://developer.cisco.com/meraki/api-v1/
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$EsimId,
        [parameter(Mandatory=$true)]
        [string]$EsimConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/cellularGateway/esims/inventory/$EsimId"

            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $EsimConfig
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}