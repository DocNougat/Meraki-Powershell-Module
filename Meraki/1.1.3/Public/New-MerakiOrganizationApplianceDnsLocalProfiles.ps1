function New-MerakiOrganizationApplianceDnsLocalProfiles {
<#
.SYNOPSIS
Creates a new local DNS profile for Meraki MX appliances in the specified organization.

.DESCRIPTION
Sends a POST request to the Meraki API to create a local DNS profile under an organization.
Requires a valid Meraki API key (AuthToken) and a JSON payload describing the DNS profile.
If OrganizationID is not supplied, the function attempts to resolve it via Get-OrgID -AuthToken <token>.
If Get-OrgID returns the string "Multiple organizations found. Please specify an organization ID.",
the function will return that message and not perform the API call.

.PARAMETER AuthToken
The Meraki API key (X-Cisco-Meraki-API-Key). This parameter is mandatory.

.PARAMETER OrganizationID
The Meraki organization ID to apply the DNS profile to. If omitted, the function calls Get-OrgID -AuthToken <AuthToken>
to resolve a single organization ID. If multiple organizations are found, you must supply this parameter.

.PARAMETER DNSProfileConfig
A JSON string containing the DNS profile configuration to send in the request body.
Can be constructed inline as a JSON string or loaded from a file (e.g. Get-Content -Raw path\to\file.json).
This parameter is mandatory.

.EXAMPLE
# Provide a JSON payload inline
$DNSProfileConfig = '{"name": "Local DNS Profile 1"}'
New-MerakiOrganizationApplianceDnsLocalProfiles -AuthToken $apiKey -DNSProfileConfig $DNSProfileConfig

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
        [string]$DNSProfileConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
            
            $body = $DNSProfileConfig

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/appliance/dns/local/profiles"
            
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}