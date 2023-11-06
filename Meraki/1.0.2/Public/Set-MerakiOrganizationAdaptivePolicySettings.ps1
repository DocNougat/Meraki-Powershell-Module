function Set-MerakiOrganizationAdaptivePolicySettings {
    <#
    .SYNOPSIS
    Updates the global adaptive policy settings for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiOrganizationAdaptivePolicySettings function allows you to update the global adaptive policy settings for a specified Meraki organization by providing the authentication token, organization ID, and a list of network IDs with adaptive policy enabled.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to update the global adaptive policy settings.

    .PARAMETER EnabledNetworks
    An array of network IDs with adaptive policy enabled.

    .EXAMPLE
    Set-MerakiOrganizationAdaptivePolicySettings -AuthToken "your-api-token" -OrganizationId "1234567890" -EnabledNetworks @("abcd1234", "efgh5678")

    This example updates the global adaptive policy settings for the Meraki organization with ID "1234567890" to enable adaptive policy on the networks with IDs "abcd1234" and "efgh5678".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the configuration is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [array]$EnabledNetworks
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
                "enabledNetworks" = $EnabledNetworks
            } | ConvertTo-JSON -compress

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/adaptivePolicy/settings"
            
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
            Write-Host $_
        }
    }
}