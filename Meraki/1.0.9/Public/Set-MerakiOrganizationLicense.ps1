function Set-MerakiOrganizationLicense {
    <#
    .SYNOPSIS
    Update a license in the Meraki Dashboard using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiOrganizationLicense function allows you to update a license in the Meraki Dashboard by providing the authentication token, organization ID, license ID, and device serial number.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization in which the license is to be updated.

    .PARAMETER LicenseId
    The ID of the license to update.

    .PARAMETER DeviceSerial
    The serial number of the device to assign this license to. Set this to null to unassign the license. If a different license is already active on the device, this parameter will control queueing/dequeuing this license.

    .EXAMPLE
    Set-MerakiOrganizationLicense -AuthToken "your-api-token" -OrganizationId "234567" -LicenseId "123" -DeviceSerial "Q234-ABCD-5678"

    This example updates the license with ID "123" in the Meraki organization with ID "234567" by assigning it to the device with serial number "Q234-ABCD-5678".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the license update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$LicenseId,
        [parameter(Mandatory=$true)]
        [string]$DeviceSerial
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
                "deviceSerial" = $DeviceSerial
            } | ConvertTo-Json -Compress

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/licenses/$LicenseId"

            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}