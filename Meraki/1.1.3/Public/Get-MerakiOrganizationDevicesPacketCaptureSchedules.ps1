function Get-MerakiOrganizationDevicesPacketCaptureSchedules {
    <#
    .SYNOPSIS
    Retrieves packet capture schedule configurations for devices in a Meraki organization.

    .DESCRIPTION
    Get-MerakiOrganizationDevicesPacketCaptureSchedules calls the Meraki Dashboard API to list packet capture schedules for devices within a specified organization. The function supports optional filtering by schedule IDs, network IDs, and device IDs. When OrganizationID is not supplied, the function attempts to resolve the organization via Get-OrgID using the provided API token.

    .PARAMETER AuthToken
    The Meraki API key used to authenticate the request. This parameter is mandatory.

    .PARAMETER OrganizationID
    The identifier of the Meraki organization to query. If omitted, the function will call Get-OrgID -AuthToken $AuthToken to resolve the organization. If multiple organizations are found and not disambiguated, the function returns the message: "Multiple organizations found. Please specify an organization ID."

    .PARAMETER ScheduleIds
    An array of packet capture schedule IDs to filter the results. When provided, only schedules with matching IDs are returned. Provide a single string or an array of strings.

    .PARAMETER NetworkIds
    An array of network IDs to filter the results. When provided, only schedules for devices in the specified networks are returned. Provide a single string or an array of strings.

    .PARAMETER DeviceIds
    An array of device IDs to filter the results. When provided, only schedules for the specified devices are returned. Provide a single string or an array of strings.

    .EXAMPLE
    # Retrieve schedules filtered by multiple schedule IDs and device IDs
    Get-MerakiOrganizationDevicesPacketCaptureSchedules -AuthToken 'ABCDEF0123456789' -OrganizationID '123456' -ScheduleIds @('sched1','sched2') -DeviceIds @('device1','device2')

    .NOTES
    - Requires network connectivity to api.meraki.com.
    - The function sends the API key in the X-Cisco-Meraki-API-Key header.
    - Query parameters are sent as repeated array parameters (e.g., scheduleIds[]=...).

    .LINK
    Meraki Dashboard API — Devices Packet Capture Schedules: https://developer.cisco.com/meraki/api-v1/ (consult relevant endpoint documentation)
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$false)]
        [array]$ScheduleIds = $null,
        [parameter(Mandatory=$false)]
        [array]$NetworkIds = $null,
        [parameter(Mandatory=$false)]
        [array]$DeviceIds = $null
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        Try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "Content-Type" = "application/json"
            }
            $queryParams = @{}
            if ($ScheduleIds) {
                $queryParams['scheduleIds[]'] = $ScheduleIds
            }
            if ($NetworkIds) {
                $queryParams['networkIds[]'] = $NetworkIds
            }
            if ($DeviceIds) {
                $queryParams['deviceIds[]'] = $DeviceIds
            }
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URI = "https://api.meraki.com/api/v1/organizations/$OrganizationID/devices/packetCapture/schedules?$queryString"
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}