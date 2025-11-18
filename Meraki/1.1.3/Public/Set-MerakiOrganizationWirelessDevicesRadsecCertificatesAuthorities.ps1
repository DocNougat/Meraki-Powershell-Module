function Set-MerakiOrganizationWirelessDevicesRadsecCertificatesAuthorities {
    <#
    .SYNOPSIS
    Sets the RadSec certificate authorities configuration for wireless devices in a Meraki organization.

    .DESCRIPTION
    Sends a PUT request to the Meraki Dashboard API to replace the RadSec certificate authorities configuration for all wireless devices in the specified organization. The function accepts an API key, an organization identifier (optional — will be resolved when not supplied), and a JSON payload representing the certificate authorities configuration as expected by the Meraki API.

    .PARAMETER AuthToken
    The Meraki API key used to authenticate the request. This parameter is mandatory.

    .PARAMETER OrganizationID
    The Meraki organization ID to target. If omitted, the function attempts to resolve the organization ID via Get-OrgID using the provided AuthToken. If multiple organizations are found, the function will indicate that a specific organization ID must be supplied.

    .PARAMETER CertificateAuthoritiesConfig
    A JSON-formatted string (or literal JSON content) containing the certificate authorities configuration to be applied. This should conform to the payload structure required by the Meraki API endpoint for RadSec certificate authorities.

    .EXAMPLE
    # Provide JSON payload directly and specify organization
    $CertificateAuthoritiesConfig = @{
        status = "trusted"
        certificateAuthorityId = "1234"
    } | ConvertTo-Json -Depth 10 -Compress
    Set-MerakiOrganizationWirelessDevicesRadsecCertificatesAuthorities -AuthToken 'AKIA...' -OrganizationID '123456' -CertificateAuthoritiesConfig $CertificateAuthoritiesConfig

    .NOTES
    - Requires network access to api.meraki.com and a valid Meraki API key.
    - Ensure the JSON payload matches the Meraki API schema for wireless devices RadSec certificate authorities.
    - This function replaces the existing certificate authorities configuration for the organization's wireless devices.
    - Module: Meraki PowerShell Module (1.1.3); UserAgent string identifies the module when calling the API.

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
        [string]$CertificateAuthoritiesConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
            
            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/wireless/devices/radsec/certificates/authorities"

            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $CertificateAuthoritiesConfig
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}