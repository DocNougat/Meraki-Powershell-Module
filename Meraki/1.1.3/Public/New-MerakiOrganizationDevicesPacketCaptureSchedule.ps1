function New-MerakiOrganizationDevicesPacketCaptureSchedule {
    <#
    .SYNOPSIS
    Creates a packet capture schedule for devices in a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    Sends a POST request to the Meraki Dashboard endpoint to create a new packet capture schedule for devices in the specified organization.
    The function supplies the API key in the X-Cisco-Meraki-API-Key header and posts the ScheduleConfig payload as JSON.
    If OrganizationID is not provided, the function attempts to resolve it using Get-OrgID -AuthToken $AuthToken.
    On failure the cmdlet writes debug information and throws the underlying error.

    .PARAMETER AuthToken
    The Meraki API key to authenticate the request. Provided as the X-Cisco-Meraki-API-Key header.

    .PARAMETER OrganizationID
    The ID of the Meraki organization where the schedule will be created.
    If omitted, the cmdlet attempts to determine the organization ID by calling Get-OrgID -AuthToken $AuthToken.

    .PARAMETER ScheduleConfig
    The request body for the schedule creation. Must be a JSON-formatted string (or a PowerShell object converted to JSON) matching the Meraki API schema for device packet capture schedules.
    Content-Type: application/json; charset=utf-8

    .EXAMPLE
    $Payload = @{
        devices = @(
            @{
                serial      = "Q234-ABCD-5678"
                switchports = "1, 2"
                interface   = "TenGigabitEthernet0/0/0"
            }
        )
        name             = "daily_capture_for_debugging"
        notes            = "Debugging persistent issue on device"
        duration         = 60
        filterExpression = "(icmp)"
        enabled          = $true
        schedule         = @{
            name     = "Daily at 1pm"
            startTs  = "2021-01-01T13:00:00Z"
            endTs    = "2021-01-01T14:00:00Z"
            frequency= "daily"
            weekdays = @("Monday", "Wednesday", "Friday")
            recurrence= 1
        }
    } | ConvertTo-Json -Depth 10
    New-MerakiOrganizationDevicesPacketCaptureSchedule -AuthToken 'YOUR_API_KEY' -ScheduleConfig $payload

    This example creates a daily packet capture schedule for the specified device and ports using a PowerShell hashtable converted to JSON.

    .NOTES
    Module: MerakiPowerShellModule, version 1.1.3
    API endpoint: POST /organizations/{organizationId}/devices/packetCapture/schedules
    The cmdlet will throw a terminating error on failure; use try/catch around calls to handle errors gracefully.

    .LINK
    Refer to the official Meraki Dashboard API documentation for the most up-to-date schema and examples for packet capture schedules.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$ScheduleConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/devices/packetCapture/schedules"

            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $ScheduleConfig
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}