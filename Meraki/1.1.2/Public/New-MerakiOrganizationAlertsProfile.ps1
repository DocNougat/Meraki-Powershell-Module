function New-MerakiOrganizationAlertsProfile {
    <#
    .SYNOPSIS
    Creates a new alerts profile for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The New-MerakiOrganizationAlertsProfile function allows you to create a new alerts profile for a specified Meraki organization by providing the authentication token, profile name, and alert configuration.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER AlertProfileConfig
    The JSON configuration for the new alerts profile to be created. Refer to the JSON schema for required parameters and their format.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to create a new alerts profile.

    .EXAMPLE
    $AlertProfileConfig = [PSCustomObject]@{
        description = "Example alert profile"
        type = "wanUtilization"
        networkTags = @("tag1", "tag2")
        alertCondition = @{
            bit_rate_bps = 1000000
            duration = 60
            window = 3600
        }
        recipients = @{
            emails = @("alerts@example.com")
            httpServerIds = @()
        }
    }

    $AlertProfileConfig = $AlertProfileConfig | ConvertTo-Json -Compress

    New-MerakiOrganizationAlertsProfile -AuthToken "your-api-token" -AlertProfileConfig $AlertProfileConfig -OrganizationId "1234567890"
    This example creates a new alerts profile with name "New Alerts Profile" for the Meraki organization with ID "1234567890". The alerts profile is configured to monitor networks with tags "tag1" and "tag2" for WAN utilization exceeding 1 Mbps for 60 seconds within a 1-hour window. Alerts will be sent to "alerts@example.com".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the configuration is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
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

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/alerts/profiles"
            
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}