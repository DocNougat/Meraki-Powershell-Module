function Get-MerakiDeviceCameraAnalyticsZoneHistory {
    <#
    .SYNOPSIS
        Gets the analytics history for a specific zone on a Cisco Meraki camera.
    .DESCRIPTION
        This function makes a REST API call to the Meraki dashboard API to retrieve analytics data for a specific zone on a Cisco Meraki camera, based on the camera's serial number and the zone's ID. The function returns data such as motion, person, and vehicle counts for the specified zone, over a specified time range and resolution.
    .PARAMETER AuthToken
        The authentication token to use for the API call. This should be a valid API key for the Meraki dashboard.
    .PARAMETER deviceSerial
        The serial number of the Cisco Meraki camera to retrieve analytics data for.
    .PARAMETER zoneId
        The ID of the zone on the camera to retrieve analytics data for.
    .PARAMETER ObjectType
        The type of object to retrieve analytics data for (e.g. 'person', 'vehicle', 'bicycle', etc.).
    .PARAMETER t0
        The start time of the time range to retrieve analytics data for, in Unix timestamp format (e.g. '1617302400').
    .PARAMETER t1
        The end time of the time range to retrieve analytics data for, in Unix timestamp format.
    .PARAMETER timespan
        The duration of the time range to retrieve analytics data for, in seconds.
    .PARAMETER resolution
        The time interval to aggregate analytics data over, in seconds.
    .EXAMPLE
        PS C:\> Get-MerakiDeviceCameraAnalyticsZoneHistory -AuthToken "myapikey" -deviceSerial "Q2XX-XXXX-XXXX" -zoneId "1" -ObjectType "person" -t0 "1617302400" -t1 "1619894399"
        Returns analytics data for the specified zone on the specified camera, for the specified time range and object type.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$DeviceSerial,
        [parameter(Mandatory=$true)]
        [string]$zoneId,
        [parameter(Mandatory=$false)]
        [string]$ObjectType,
        [parameter(Mandatory=$false)]
        [string]$t0 = $null,
        [parameter(Mandatory=$false)]
        [string]$t1 = $null,
        [parameter(Mandatory=$false)]
        [int]$timespan = $null,
        [parameter(Mandatory=$false)]
        [int]$resolution = $null
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }

        $queryParams = @{}

        if ($timespan) {
            $queryParams['timespan'] = $timespan
        } else {
            if ($t0) {
                $queryParams['t0'] = $t0
            }
            if ($t1) {
                $queryParams['t1'] = $t1
            }
        }
        if ($ObjectType) {
            $queryParams['objectType'] = $ObjectType
        }
        if ($resolution) {
            $queryParams['resolution'] = $resolution
        }
        $queryString = New-MerakiQueryString -queryParams $queryParams

        $URL = "https://api.meraki.com/api/v1/devices/$DeviceSerial/camera/analytics/zones/$zoneId/history?$queryString"

        $URI = [uri]::EscapeUriString($URL)

        $response = Invoke-RestMethod -Method Get -Uri $URI-Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
