function New-MerakiDeviceLiveToolsCableTest {
    <#
    .SYNOPSIS
    Performs a cable test on specified ports of a device.

    .DESCRIPTION
    This function allows you to perform a cable test on specified ports of a device by providing the authentication token, device serial number, and a JSON string with the test details including ports and callback information.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER Serial
    The serial number of the device.

    .PARAMETER CableTestDetails
    A compressed JSON string representing the cable test details including ports and callback information.

    .EXAMPLE
    $CableTestDetails = @{
        ports = @("2", "8")
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
    $CableTestDetailsJson = $CableTestDetails | ConvertTo-Json -Compress -Depth 4
    New-MerakiDeviceLiveToolsCableTest -AuthToken "your-api-token" -Serial "Q2XX-XXXX-XXXX" -CableTestDetails $CableTestDetails

    This example performs a cable test on ports "2" and "8" of the device with serial number "Q2XX-XXXX-XXXX" using the provided callback details.

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
        [string]$CableTestDetails
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $url = "https://api.meraki.com/api/v1/devices/$Serial/liveTools/cableTest"

        $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat" -Body $CableTestDetails
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}