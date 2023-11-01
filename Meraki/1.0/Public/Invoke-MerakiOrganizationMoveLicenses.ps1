function Invoke-MerakiOrganizationMoveLicenses {
    <#
    .SYNOPSIS
    Move licenses from one organization to another in the Meraki Dashboard using the Meraki Dashboard API.

    .DESCRIPTION
    The Invoke-MerakiOrganizationMoveLicenses function allows you to move licenses from one organization to another in the Meraki Dashboard by providing the authentication token, source organization ID, destination organization ID, and a list of license IDs.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization from which you want to move licenses.

    .PARAMETER LicenseMove
    A string containing the license move configuration. The string should be in JSON format and should include the following properties: "destOrganizationId" and "licenseIds".

    .EXAMPLE
    $licenseMove = '{
        "destOrganizationId": "2930418",
        "licenseIds": [ "123", "456" ]
    }'
    $licenseMove = $licenseMove | ConvertTo-Json -Compress
    Invoke-MerakiOrganizationMoveLicenses -AuthToken "your-api-token" -OrganizationId "234567" -LicenseMove $licenseMove

    This example moves the licenses with IDs "123" and "456" from the Meraki organization with ID "234567" to the Meraki organization with ID "2930418".

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

        $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/licenses/move"

        $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -Body $body
        return $response
    }
    catch {
        Write-Host $_
    }
}