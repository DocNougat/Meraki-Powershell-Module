function Set-MerakiOrganizationAlertsProfile {
    <#
    .SYNOPSIS
    Updates an alerts profile for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiOrganizationAlertsProfile function allows you to update an alerts profile for a specified Meraki organization by providing the authentication token, profile ID, and alert configuration.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER AlertProfileId
    The ID of the alerts profile to be updated.

    .PARAMETER AlertProfileConfig
    The JSON configuration for the alerts profile to be updated. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $AlertProfileConfig = '{
        "description": "Updated alert profile",
        "type": "wanUtilization",
        "networkTags": ["tag1", "tag2"],
        "alertCondition": {
            "bit_rate_bps": 2000000,
            "duration": 120,
            "window": 7200
        },
        "recipients": {
            "emails": ["alerts@example.com", "alerts2@example.com"],
            "httpServerIds": []
        }
    }'
    $AlertProfileConfig = $AlertProfileConfig | ConvertTo-JSON -compress

    Set-MerakiOrganizationAlertsProfile -AuthToken "your-api-token" -AlertProfileId "1234567890" -AlertProfileConfig $AlertProfileConfig

    This example updates the alerts profile with ID "1234567890" to have the description "Updated alert profile" and monitor networks with tags "tag1" and "tag2" for WAN utilization exceeding 2 Mbps for 120 seconds within a 2-hour window. Alerts will be sent to "alerts@example.com" and "alerts2@example.com".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the configuration is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$AlertProfileId,
        [parameter(Mandatory=$true)]
        [string]$AlertProfileConfig,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken)
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
            
            $body = $AlertProfileConfig

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/alerts/profiles/$AlertProfileId"
            
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
            Write-Host $_
        }
    }
}