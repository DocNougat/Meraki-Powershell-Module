function New-MerakiOrganizationDevicesPacketCaptureCapture {
    <#
    .SYNOPSIS
    Creates a packet capture session on devices in a Meraki organization by calling the Meraki Dashboard API.

    .DESCRIPTION
    New-MerakiOrganizationDevicesPacketCaptureCapture posts a packet capture request to the Meraki Dashboard for the specified organization. If OrganizationID is not provided, the function attempts to resolve it via Get-OrgID using the provided API token. If multiple organizations are found, the function returns an informative message and does not call the API. The function constructs the necessary request headers and body, calls Invoke-RestMethod to create the capture, and returns the parsed API response. On failure the underlying exception is written to debug stream and re-thrown.

    .PARAMETER AuthToken
    The Meraki API key (X-Cisco-Meraki-API-Key). This parameter is required.

    .PARAMETER OrganizationID
    The Meraki organization ID to target. If omitted, the function will attempt to determine the organization using Get-OrgID -AuthToken $AuthToken. If multiple organizations are detected by Get-OrgID, the function will return the text "Multiple organizations found. Please specify an organization ID." and will not proceed.

    .PARAMETER PacketCaptureConfig
    A JSON string that contains the packet capture configuration to post to the API. This should match the expected structure for the "Create a packet capture" endpoint (for example: target, filters, interfaces, duration, etc.). This parameter is required.

    .EXAMPLE
    # Provide an API key, organization id, and a JSON body stored in a variable.
    $packetCaptureConfig = @{
        serials = @("Q234-ABCD-5678")
        name = "Capture no. 3"
        outputType = "upload_to_cloud"
        destination = "upload_to_cloud"
        ports = "1, 3"
        notes = "Debugging connectivity issue..."
        duration = 3
        filterExpression = "host 10.1.27.253"
        interface = "wireless"
    } | ConvertTo-Json -Depth 10 -Compress
    New-MerakiOrganizationDevicesPacketCaptureCapture -AuthToken $env:MERAKI_API_KEY -OrganizationID "123456" -PacketCaptureConfig $packetCaptureConfig

    .NOTES
    - Requires network connectivity to api.meraki.com and a valid API key with appropriate permissions.
    - The PacketCaptureConfig must be valid JSON matching Meraki's packet capture schema.
    - The function issues a POST to:
        https://api.meraki.com/api/v1/organizations/{organizationId}/devices/packetCapture/captures
    - Errors from the REST call are written to the debug stream and then re-thrown to allow calling code to handle them.

    .LINK
    https://developer.cisco.com/meraki/api-v1/ (Meraki Dashboard API documentation)
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$PacketCaptureConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/devices/packetCapture/captures"

            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $PacketCaptureConfig
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}