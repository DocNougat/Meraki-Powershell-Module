function New-MerakiOrganizationDevicesPacketCaptureScheduleOrder {
    <#
    .SYNOPSIS
    Reorders packet capture schedules for devices in a Meraki organization.

    .DESCRIPTION
    New-MerakiOrganizationDevicesPacketCaptureScheduleOrder sends a POST request to the Meraki Dashboard API
    endpoint /organizations/{organizationId}/devices/packetCapture/schedules/reorder to update the order of
    packet capture schedules for the specified organization. It requires an API key for authentication and
    accepts a JSON payload describing the desired schedule ordering.

    .PARAMETER AuthToken
    The Meraki API key used to authenticate the request. This value is added to the request header
    "X-Cisco-Meraki-API-Key". Provide a valid API key with sufficient privileges to manage the
    organization.

    .PARAMETER OrganizationID
    The Meraki organization identifier (organizationId) whose packet capture schedule order will be changed.
    If omitted, the function attempts to determine a single organization ID by calling Get-OrgID -AuthToken $AuthToken.
    If multiple organizations are found, the function returns a message asking you to specify an organization ID.

    .PARAMETER ScheduleOrder
    A JSON-formatted string (or object serialized to JSON) specifying the new order for packet capture schedules.
    Typically this will be a JSON array containing schedule identifiers in the desired order, or an object matching
    the API's expected request body. Ensure the payload is valid JSON and matches the API schema for reordering schedules.

    .EXAMPLE
    # Build the payload from PowerShell objects and convert to JSON
    $payload = @{
        order = @(
            @{
                scheduleId = "1234"
                priority   = 1
            },
            @{
                scheduleId = "5678"
                priority   = 2
            },
            @{
                scheduleId = "91011"
                priority   = 3
            }
        )
    } | ConvertTo-Json -Depth 10 -compress
    New-MerakiOrganizationDevicesPacketCaptureScheduleOrder -AuthToken 'YourAuthToken' -ScheduleOrder ($payload | ConvertTo-Json -Compress)

    .NOTES
    - Content-Type: application/json; charset=utf-8 is used for the request body.
    - Ensure the AuthToken has the necessary permissions to modify organization device packet capture schedules.
    - See Meraki Dashboard API documentation for the most up-to-date request schema and behavior:
        https://developer.cisco.com/meraki/api-v1/
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$ScheduleOrder
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/devices/packetCapture/schedules/reorder"

            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $ScheduleOrder
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}