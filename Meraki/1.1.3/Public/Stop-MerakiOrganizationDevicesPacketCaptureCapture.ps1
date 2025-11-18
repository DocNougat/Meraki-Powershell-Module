function Stop-MerakiOrganizationDevicesPacketCaptureCapture {
    <#
    .SYNOPSIS
    Stops packet capture on a specific device within a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The Stop-MerakiOrganizationDevicesPacketCaptureCapture function allows you to stop packet capture on a specific device within a Meraki organization by providing the authentication token, organization ID, and device ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to stop packet capture.

    .PARAMETER CaptureID
    The ID of the packet capture session you want to stop.

    .EXAMPLE
    Stop-MerakiOrganizationDevicesPacketCaptureCapture -AuthToken "your-api-token" -OrganizationId "1234567890" -CaptureID "abcdefg12345"
    This example stops the packet capture session with ID "abcdefg12345" for the Meraki organization with ID "1234567890".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$CaptureID
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
            
            $body = $SAMLRoleConfig

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/devices/packetCapture/captures/$CaptureID/stop"

            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}