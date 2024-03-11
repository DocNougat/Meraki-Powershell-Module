function Set-MerakiNetworkWirelessSSIDSchedules {    
    <#
    .SYNOPSIS
    Updates the schedules for a network's wireless SSID using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkWirelessSSIDSchedules function allows you to update the schedules for a network's wireless SSID by providing the authentication token, network ID, SSID number, and a schedule configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the network for which you want to update the SSID schedules.

    .PARAMETER SSIDNumber
    The number of the SSID to update the schedules for.

    .PARAMETER SSIDSchedule
    A string containing the SSID schedule configuration. The string should be in JSON format and should include the "enabled" property and the "ranges" array, which contains objects with the "startDay", "startTime", "endDay", and "endTime" properties.

    .EXAMPLE
    $schedule = [PSCustomObject]@{
        enabled = $true
        ranges = @(
            @{
                startDay = "Tuesday"
                startTime = "01:00"
                endDay = "Tuesday"
                endTime = "05:00"
            },
            @{
                startDay = "Fri"
                startTime = "19:00"
                endDay = "monday"
                endTime = "05:00"
            }
        )
    }

    $schedule = $schedule | ConvertTo-Json -Compress
    Set-MerakiNetworkWirelessSSIDSchedules -AuthToken "your-api-token" -NetworkId "your-network-id" -SSIDNumber "1" -SSIDSchedule $schedule

    This example updates the schedules for the SSID with number 1 in the network with ID "your-network-id", using the specified schedule configuration.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$SSIDNumber,
        [parameter(Mandatory=$true)]
        [string]$SSIDSchedule
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $SSIDSchedule

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/wireless/ssids/$SSIDNumber/schedules"
        $response = Invoke-RestMethod -Method Put -Uri $uri -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}