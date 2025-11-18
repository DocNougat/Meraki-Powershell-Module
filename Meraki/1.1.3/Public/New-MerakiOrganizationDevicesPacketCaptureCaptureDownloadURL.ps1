function New-MerakiOrganizationDevicesPacketCaptureCaptureDownloadURL {
    <#
    .SYNOPSIS
    Generates a download URL for a packet capture created on a Meraki device.

    .DESCRIPTION
    Calls the Meraki Organizations > Devices > Packet Capture > Generate download URL endpoint to produce a temporary URL that can be used to download a previously created packet capture. The function uses the provided API key for authentication and optionally resolves the organization ID via Get-OrgID when not supplied.

    .PARAMETER AuthToken
    The Meraki API key (X-Cisco-Meraki-API-Key). This parameter is required.

    .PARAMETER OrganizationID
    The Meraki organization ID to operate against. If not specified, the function attempts to resolve it using Get-OrgID with the provided AuthToken. If Get-OrgID returns a "Multiple organizations found. Please specify an organization ID." message, the function will return that message and will not call the API.

    .PARAMETER CaptureID
    The ID of the packet capture to generate the download URL for. This parameter is required.

    .EXAMPLE
    # Let the function resolve the organization ID via Get-OrgID
    $token = 'your-meraki-api-key'
    New-MerakiOrganizationDevicesPacketCaptureCaptureDownloadURL -AuthToken $token -CaptureID 'capture-id-abc123'

    .NOTES
    - Requires network access to api.meraki.com and a valid Meraki API key with permissions to access packet captures for the specified organization.
    - The generated download URL is time-limited and should be used promptly.
    - This function issues an HTTP POST to the Meraki API and will throw on non-successful HTTP responses.
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

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/devices/packetCapture/captures/$captureID/downloadUrl/generate"

            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}