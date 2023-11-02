function Get-MerakiDeviceCameraAnalyticsOverview {
    <#
    .SYNOPSIS
        Gets an overview of analytics data for a specific Cisco Meraki camera by serial number.
    .DESCRIPTION
        This function makes a REST API call to the Meraki dashboard API to retrieve an overview of analytics data for a specific Cisco Meraki camera, based on its serial number. The function returns detailed information about the camera's analytics data over a specified time period, including the number of people detected and the average age and gender of those detected.
    .PARAMETER AuthToken
        The authentication token to use for the API call. This should be a valid API key for the Meraki dashboard.
    .PARAMETER deviceSerial
        The serial number of the Cisco Meraki camera to retrieve analytics data for.
    .PARAMETER ObjectType
        The type of object to retrieve analytics data for. This should be one of the following values: 'person', 'vehicle', 'bicycle', 'animal'.
    .PARAMETER t0
        The start time for the analytics data to retrieve. This should be in ISO 8601 format.
    .PARAMETER t1
        The end time for the analytics data to retrieve. This should be in ISO 8601 format.
    .PARAMETER timespan
        The timespan for the analytics data to retrieve, in seconds. This parameter is mutually exclusive with the `t0` and `t1` parameters.
    .EXAMPLE
        PS C:\> Get-MerakiDeviceCameraAnalyticsOverview -AuthToken "myapikey" -deviceSerial "Q2XX-XXXX-XXXX" -ObjectType "person" -t0 "2022-04-01T00:00:00Z" -t1 "2022-04-02T00:00:00Z"
        Returns an overview of analytics data for the Cisco Meraki camera with the specified serial number, for the specified time period and object type.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$DeviceSerial,
        [parameter(Mandatory=$false)]
        [string]$ObjectType,
        [parameter(Mandatory=$false)]
        [string]$t0 = $null,
        [parameter(Mandatory=$false)]
        [string]$t1 = $null,
        [parameter(Mandatory=$false)]
        [int]$timespan = $null
    )
    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
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
            $queryParams['ObjectType'] = $ObjectType
        }
        $queryString = New-MerakiQueryString -queryParams $queryParams

        $URL = "https://api.meraki.com/api/v1/devices/$DeviceSerial/camera/analytics/overview?$queryString"

        $URI = [uri]::EscapeUriString($URL)

        $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header
        return $response
    }
    catch {
        Write-Error "Failed to retrieve Meraki camera analytics overview data: $_"
    }
}
