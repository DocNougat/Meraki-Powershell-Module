function Invoke-MerakiOrganizationMoveLicensesSeats {
    <#
    .SYNOPSIS
    Move license seats from one organization to another in the Meraki Dashboard using the Meraki Dashboard API.

    .DESCRIPTION
    The Invoke-MerakiOrganizationMoveLicensesSeats function allows you to move license seats from one organization to another in the Meraki Dashboard by providing the authentication token, source organization ID, destination organization ID, a list of license IDs, and the number of seats to move.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization from which you want to move license seats.

    .PARAMETER LicenseMove
    A string containing the license move configuration. The string should be in JSON format and should include the following properties: "destOrganizationId", "licenseIds", and "seatCount".

    .EXAMPLE
    $licenseMove = '{
        "destOrganizationId": "2930418",
        "licenseIds": [ "123", "456" ],
        "seatCount": 10
    }'
    $licenseMove = $licenseMove | ConvertTo-Json -Compress
    Invoke-MerakiOrganizationMoveLicensesSeats -AuthToken "your-api-token" -OrganizationId "234567" -LicenseMove $licenseMove

    This example moves 10 license seats from the licenses with IDs "123" and "456" from the Meraki organization with ID "234567" to the Meraki organization with ID "2930418".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the license move is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationId = (Get-MerakiOrganizations -AuthToken $AuthToken).id,
        [parameter(Mandatory=$true)]
        [string]$LicenseMove
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $LicenseMove

        $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/licenses/moveSeats"

        $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -Body $body
        return $response
    }
    catch {
        Write-Host $_
    }
}