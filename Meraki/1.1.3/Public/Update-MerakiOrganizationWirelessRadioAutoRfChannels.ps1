function Update-MerakiOrganizationWirelessRadioAutoRfChannels {
    <#
    .SYNOPSIS
    Recalculates auto RF channel assignments for wireless radios across one or more networks in a Meraki organization.

    .DESCRIPTION
    Update-MerakiOrganizationWirelessRadioAutoRfChannels triggers a server-side recalculation of automatic RF channel assignments for the specified networks within a Meraki organization. It issues a POST to the Meraki API endpoint for autoRf channel recalculation. The function requires a valid Meraki API key and one or more network IDs. If an organization ID is not supplied, the function attempts to resolve it via Get-OrgID using the provided API token.

    .PARAMETER AuthToken
    The Meraki API key (X-Cisco-Meraki-API-Key) used to authenticate the request. This parameter is mandatory.

    .PARAMETER OrganizationID
    The Meraki organization ID that contains the target networks. If omitted, the function will call Get-OrgID -AuthToken $AuthToken to determine the organization. If multiple organizations are found, the function will return an error message advising explicit specification of the OrganizationID.

    .PARAMETER networkIds
    An array of network ID strings for which the auto RF channel recalculation should be performed. This parameter is mandatory and accepts a collection of one or more network IDs.

    .EXAMPLE
    # Recalculate RF channels for a single network
    Update-MerakiOrganizationWirelessRadioAutoRfChannels -AuthToken 'xxxxxxx' -OrganizationID '123456' -networkIds @('N_abc123')

    .EXAMPLE
    # Recalculate RF channels for multiple networks (OrganizationID resolved automatically)
    Update-MerakiOrganizationWirelessRadioAutoRfChannels -AuthToken 'xxxxxxx' -networkIds @('N_abc123','N_def456')

    .NOTES
    - The function sets the HTTP header "X-Cisco-Meraki-API-Key" with the provided AuthToken and sends JSON content.
    - The API endpoint invoked is: POST /organizations/{organizationId}/wireless/radio/autoRf/channels/recalculate
    - Ensure the AuthToken has sufficient permissions to manage the specified organization and networks.

    .LINK
    https://developer.cisco.com/meraki/api-v1/ (Refer to the Meraki API documentation for endpoint-specific details and response formats.)
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [array]$networkIds
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $body = @{
                "networkIds" = $networkIds
            } | ConvertTo-Json

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationID/wireless/radio/autoRf/channels/recalculate"

            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $body
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}