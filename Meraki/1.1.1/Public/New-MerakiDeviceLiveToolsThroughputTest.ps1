function New-MerakiDeviceLiveToolsThroughputTest {
    <#
    .SYNOPSIS
    Initiates a throughput test for a specified device.

    .DESCRIPTION
    This function allows you to initiate a throughput test for a specified device by providing the authentication token, device serial number, and a JSON string with the callback details.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER Serial
    The serial number of the device.

    .PARAMETER ThroughputTestDetails
    A compressed JSON string representing the callback details.

    .EXAMPLE
    $ThroughputTestDetails = @{
        callback = @{
            url = "https://webhook.site/28efa24e-f830-4d9f-a12b-fbb9e5035031"
            sharedSecret = "secret"
            httpServer = @{
                id = "aHR0cHM6Ly93d3cuZXhhbXBsZS5jb20vd2ViaG9va3M="
            }
            payloadTemplate = @{
                id = "wpt_2100"
            }
        }
    }
    $ThroughputTestDetailsJson = $ThroughputTestDetails | ConvertTo-Json -Compress -Depth 4
    New-MerakiDeviceLiveToolsThroughputTest -AuthToken "your-api-token" -Serial "Q2XX-XXXX-XXXX" -ThroughputTestDetails $ThroughputTestDetailsJson

    This example initiates a throughput test for the device with serial number "Q2XX-XXXX-XXXX" using the provided callback details.

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
        [string]$ThroughputTestDetails
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $url = "https://api.meraki.com/api/v1/devices/$Serial/liveTools/throughputTest"

        $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat" -Body $ThroughputTestDetails
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
