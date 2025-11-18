function Enable-MerakiOrganizationIntegrationsXDRNetworks {
    <#
    .SYNOPSIS
    Enables Cisco Meraki XDR integrations for one or more networks in an organization.

    .DESCRIPTION
    Enable-MerakiOrganizationIntegrationsXDRNetworks calls the Meraki REST API to enable XDR integrations on networks belonging to the specified organization. If -OrganizationID is not provided, the function attempts to resolve the organization ID by calling Get-OrgID -AuthToken <AuthToken>. If multiple organizations are found, the function will return a message asking the caller to explicitly provide an OrganizationID.

    .PARAMETER AuthToken
    The Cisco Meraki API key used to authenticate the request. This parameter is mandatory.

    .PARAMETER OrganizationID
    The ID of the Meraki organization for which XDR integrations should be enabled. If omitted, the function will attempt to resolve the organization ID automatically via Get-OrgID -AuthToken <AuthToken>. If multiple organizations are present, you must supply this value.

    .PARAMETER XDRConfig
    A JSON-formatted string containing the request body for the Meraki API call that configures/enables XDR on target networks. Supply the exact payload expected by the Meraki endpoint (for example, a JSON object listing network IDs and integration options). This parameter is mandatory.

    .EXAMPLE
    # Use a JSON string variable as the request body
    {
    "networks": [
        {
            "networkId": "N_1234567",
            "productTypes": [ "appliance" ]
        }
    ]
}
    $XDRConfig = @{
        networks = @(
            @{
                networkId    = "N_1234567"
                productTypes = @("appliance")
            }
        ) 
    } | ConvertTo-Json -Depth 10 -Compress
    Enable-MerakiOrganizationIntegrationsXDRNetworks -AuthToken 'your_api_key' -OrganizationID '123456' -XDRConfig $XDRConfig

    .NOTES
    - The function targets the Meraki endpoint to enable XDR integrations for networks in an organization.
    - Ensure the AuthToken has sufficient privileges to modify organization integrations.
    - The XDRConfig payload must conform to the Meraki API schema for the integrations/xdr/networks/enable endpoint.

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
        [string]$XDRConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/integrations/xdr/networks/enable"

            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $XDRConfig
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}