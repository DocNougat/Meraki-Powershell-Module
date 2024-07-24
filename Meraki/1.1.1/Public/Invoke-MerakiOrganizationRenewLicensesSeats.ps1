function Invoke-MerakiOrganizationRenewLicensesSeats {
    <#
    .SYNOPSIS
    Renew license seats in the Meraki Dashboard using the Meraki Dashboard API.

    .DESCRIPTION
    The Invoke-MerakiOrganizationRenewLicensesSeats function allows you to renew license seats in the Meraki Dashboard by providing the authentication token, organization ID, license ID to renew, and an unused license ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization in which the licenses are to be renewed.

    .PARAMETER LicenseIdToRenew
    The ID of the license to renew. This license must already be assigned to a network.

    .PARAMETER UnusedLicenseId
    The ID of the unused license to use to renew the seats on the license to renew. This license must have at least as many seats available as there are seats on the license to renew.

    .EXAMPLE
    Invoke-MerakiOrganizationRenewLicensesSeats -AuthToken "your-api-token" -OrganizationId "234567" -LicenseIdToRenew "123" -UnusedLicenseId "1234"

    This example renews the seats on the license with ID "123" in the Meraki organization with ID "234567" using the unused license with ID "1234".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the license renewal is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$LicenseIdToRenew,
        [parameter(Mandatory=$true)]
        [string]$UnusedLicenseId
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
                "licenseIdToRenew" = $LicenseIdToRenew
                "unusedLicenseId" = $UnusedLicenseId
            } | ConvertTo-Json -Compress

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/licenses/renewSeats"

            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}