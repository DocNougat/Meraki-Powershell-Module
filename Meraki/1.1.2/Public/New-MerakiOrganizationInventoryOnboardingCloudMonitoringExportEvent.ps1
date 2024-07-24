function New-MerakiOrganizationInventoryOnboardingCloudMonitoringExportEvent {
    <#
    .SYNOPSIS
    Create an inventory onboarding cloud monitoring export event in the Meraki Dashboard using the Meraki Dashboard API.

    .DESCRIPTION
    The New-MerakiOrganizationInventoryOnboardingCloudMonitoringExportEvent function allows you to create an inventory onboarding cloud monitoring export event in the Meraki Dashboard by providing the authentication token, organization ID, and an export configuration.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization to which you want to create the inventory onboarding cloud monitoring export event.

    .PARAMETER ExportConfig
    A string containing the export configuration. The string should be in JSON format and should include the following properties: "timestamp", "logEvent", "request", and "targetOS".

    .EXAMPLE
    $exportConfig = [PSCustomObject]@{
        timestamp = 1627584000
        logEvent = "download"
        request = "redirect"
        targetOS = "Windows"
    }

    $exportConfig = $exportConfig | ConvertTo-Json -Compress
    New-MerakiOrganizationInventoryOnboardingCloudMonitoringExportEvent -AuthToken "your-api-token" -OrganizationId "123456" -ExportConfig $exportConfig

    This example creates an inventory onboarding cloud monitoring export event in the Meraki organization with ID "123456".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the event creation is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$ExportConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $body = $ExportConfig

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/inventory/onboarding/cloudMonitoring/exportEvents"

            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}