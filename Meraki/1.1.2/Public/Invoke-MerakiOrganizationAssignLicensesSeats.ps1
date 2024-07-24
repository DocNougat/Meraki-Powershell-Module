function Invoke-MerakiOrganizationAssignLicensesSeats {
    <#
    .SYNOPSIS
    Assign licenses seats to a network in the Meraki Dashboard using the Meraki Dashboard API.

    .DESCRIPTION
    The Invoke-MerakiOrganizationAssignLicensesSeats function allows you to assign licenses seats to a network in the Meraki Dashboard by providing the authentication token, organization ID, and a license assignment configuration.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization to which you want to assign licenses seats.

    .PARAMETER LicenseAssignmentConfig
    A string containing the license assignment configuration. The string should be in JSON format and should include the following properties: "seatCount", "licenseId", and "networkId".

    .EXAMPLE
    $licenseAssignmentConfig = [PSCustomObject]@{
        seatCount = 10
        licenseId = "N_123456789012345678"
        networkId = "N_123456789012345678"
    }

    $licenseAssignmentConfig = $licenseAssignmentConfig | ConvertTo-Json -Compress
    Invoke-MerakiOrganizationAssignLicensesSeats -AuthToken "your-api-token" -OrganizationId "123456" -LicenseAssignmentConfig $licenseAssignmentConfig

    This example assigns 10 license seats to the network with ID "N_123456789012345678" in the Meraki organization with ID "123456".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the license assignment is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$LicenseAssignmentConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $body = $LicenseAssignmentConfig

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/licenses/assignSeats"

            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}