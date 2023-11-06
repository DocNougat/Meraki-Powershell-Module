function Set-MerakiOrganizationApplianceSecurityIntrusion {
    <#
    .SYNOPSIS
    Updates the security intrusion settings for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiOrganizationApplianceSecurityIntrusion function allows you to update the security intrusion settings for a specified Meraki organization by providing the authentication token, organization ID, and a security intrusion configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to update the security intrusion settings.

    .PARAMETER SecurityIntrusionConfig
    A string containing the security intrusion configuration. The string should be in JSON format and should include the "allowedRules" property.

    .EXAMPLE
    $config = '{
        "allowedRules": [
            {
                "ruleId": "meraki:intrusion/snort/GID/01/SID/688",
                "message": "SQL sa login failed"
            },
            {
                "ruleId": "meraki:intrusion/snort/GID/01/SID/5805",
                "message": "MALWARE-OTHER Trackware myway speedbar runtime detection - switch engines"
            }
        ]
    }'
    $config = $config | ConvertTo-Json -Compress
    Set-MerakiOrganizationApplianceSecurityIntrusion -AuthToken "your-api-token" -OrganizationId "your-organization-id" -SecurityIntrusionConfig $config

    This example updates the security intrusion settings for the Meraki organization with ID "your-organization-id", using the specified security intrusion configuration.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the security intrusion settings update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$SecurityIntrusionConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $body = $SecurityIntrusionConfig

            $uri = "https://api.meraki.com/api/v1/organizations/$OrganizationId/appliance/security/intrusion"
            $response = Invoke-RestMethod -Method Put -Uri $uri -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
            Write-Error $_
        }
    }
}