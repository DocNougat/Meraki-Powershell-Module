function Remove-MerakiOrganizationDevicesPacketCaptureCaptureBulk {
    <#
    .SYNOPSIS
    Deletes existing packet captures in bulk for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The Remove-MerakiOrganizationDevicesPacketCaptureCaptureBulk function allows you to delete existing packet captures for a specified Meraki organization by providing the authentication token, organization ID, and packet capture IDs.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to delete an existing packet capture.

    .PARAMETER CaptureIds
    An JSON object array of packet capture IDs to be deleted.

    .EXAMPLE
    $CaptureIds = @{
        captureIds = @("123456789012345", "123456789012346")
    } | ConvertTo-Json -Depth 10 -Compress
    Remove-MerakiOrganizationDevicesPacketCaptureCaptureBulk -AuthToken "your-api-token" -OrganizationId "123456789012345678" -CaptureIds $CaptureIds

    This example deletes the packet captures with IDs "123456789012345" and "123456789012346" for the Meraki organization with ID "123456789012345678".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    The function returns the response from the API if the packet capture deletion is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$CaptureIds
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
            }

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/devices/packetCapture/captures/bulkDelete"

            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $CaptureIds
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}