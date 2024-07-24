function Get-MerakiDeviceLiveToolsThroughputTest {
    <#
    .SYNOPSIS
    Retrieves the details of a throughput test action for a specified device.

    .DESCRIPTION
    This function allows you to retrieve the details of a throughput test action for a specified device by providing the authentication token, device serial number, and the throughput test ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER Serial
    The serial number of the device.

    .PARAMETER ThroughputTestId
    The ID of the throughput test action.

    .EXAMPLE
    Get-MerakiDeviceLiveToolsThroughputTest -AuthToken "your-api-token" -Serial "Q2XX-XXXX-XXXX" -ThroughputTestId "throughputTestId1"

    This example retrieves the details of the throughput test action with ID "throughputTestId1" for the device with serial number "Q2XX-XXXX-XXXX".

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$Serial,
        [parameter(Mandatory=$true)]
        [string]$ThroughputTestId
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $url = "https://api.meraki.com/api/v1/devices/$Serial/liveTools/throughputTest/$ThroughputTestId"

        $response = Invoke-RestMethod -Method Get -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
