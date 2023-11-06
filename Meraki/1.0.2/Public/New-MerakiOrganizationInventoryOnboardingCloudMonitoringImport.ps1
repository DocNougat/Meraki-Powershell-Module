function New-MerakiOrganizationInventoryOnboardingCloudMonitoringImport {
    <#
    .SYNOPSIS
    Create an inventory onboarding cloud monitoring import in the Meraki Dashboard using the Meraki Dashboard API.

    .DESCRIPTION
    The New-MerakiOrganizationInventoryOnboardingCloudMonitoringImport function allows you to create an inventory onboarding cloud monitoring import in the Meraki Dashboard by providing the authentication token, organization ID, and an import configuration.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization to which you want to create the inventory onboarding cloud monitoring import.

    .PARAMETER ImportConfig
    A string containing the import configuration. The string should be in JSON format and should include the following properties: "devices", "deviceId", "networkId", and "udi".

    .EXAMPLE
    $importConfig = '{
        "devices": [
            {
                "deviceId": "1234",
                "networkId": "5678",
                "udi": "ABCD1234"
            }
        ]
    }'
    $importConfig = $importConfig | ConvertTo-Json -Compress
    New-MerakiOrganizationInventoryOnboardingCloudMonitoringImport -AuthToken "your-api-token" -OrganizationId "123456" -ImportConfig $importConfig

    This example creates an inventory onboarding cloud monitoring import in the Meraki organization with ID "123456".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the import creation is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$ImportConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $body = $ImportConfig

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/inventory/onboarding/cloudMonitoring/imports"

            $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
            Write-Host $_
        }
    }
}