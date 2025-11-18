function Get-MerakiDeviceSensorCommands {
    <#
    .SYNOPSIS
    Retrieves the list of sensor commands for a specified device.

    .DESCRIPTION
    This function allows you to retrieve the list of sensor commands for a specified device by providing the authentication token, device serial number, and optional query parameters.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER Serial
    The serial number of the device.

    .PARAMETER Operations
    Optional parameter to filter commands by operation.

    .PARAMETER PerPage
    The number of entries per page returned. Acceptable range is 3 - 1000. Default is 10.

    .PARAMETER StartingAfter
    A token used by the server to indicate the start of the page.

    .PARAMETER EndingBefore
    A token used by the server to indicate the end of the page.

    .PARAMETER SortOrder
    Sorted order of entries. Order options are 'ascending' and 'descending'. Default is 'descending'.

    .PARAMETER T0
    The beginning of the timespan for the data. The maximum lookback period is 30 days from today.

    .PARAMETER T1
    The end of the timespan for the data. t1 can be a maximum of 30 days after t0.

    .PARAMETER Timespan
    The timespan for which the information will be fetched. If specifying timespan, do not specify parameters t0 and t1. The value must be in seconds and be less than or equal to 30 days. The default is 30 days.

    .EXAMPLE
    Get-MerakiDeviceSensorCommands -AuthToken "your-api-token" -Serial "Q2XX-XXXX-XXXX" -Operations @("refreshData") -PerPage 10

    This example retrieves the list of sensor commands for the device with serial number "Q2XX-XXXX-XXXX" filtered by the "refreshData" operation.

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$DeviceSerial,
        [parameter(Mandatory=$false)]
        [string[]]$Operations,
        [parameter(Mandatory=$false)]
        [int]$PerPage = 10,
        [parameter(Mandatory=$false)]
        [string]$StartingAfter,
        [parameter(Mandatory=$false)]
        [string]$EndingBefore,
        [parameter(Mandatory=$false)]
        [string]$SortOrder = "descending",
        [parameter(Mandatory=$false)]
        [string]$T0,
        [parameter(Mandatory=$false)]
        [string]$T1,
        [parameter(Mandatory=$false)]
        [int]$Timespan = 2592000
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $queryParams = @{
            perPage = $PerPage
            sortOrder = $SortOrder
            timespan = $Timespan
        }

        if ($Operations) {
            $queryParams['operations'] = ($Operations -join ",")
        }

        if ($StartingAfter) {
            $queryParams['startingAfter'] = $StartingAfter
        }

        if ($EndingBefore) {
            $queryParams['endingBefore'] = $EndingBefore
        }

        if ($T0) {
            $queryParams['t0'] = $T0
        }

        if ($T1) {
            $queryParams['t1'] = $T1
        }

        $queryString = New-MerakiQueryString -queryParams $queryParams
        $url = "https://api.meraki.com/api/v1/devices/$DeviceSerial/sensor/commands?$queryString"

        $response = Invoke-RestMethod -Method Get -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
