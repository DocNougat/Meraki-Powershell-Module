function Get-MerakiDeviceLiveToolsCableTest {
    <#
    .SYNOPSIS
    Retrieves the results of a cable test for a specified device.

    .DESCRIPTION
    This function allows you to retrieve the results of a cable test for a specified device by providing the authentication token, device serial number, and the cable test ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER Serial
    The serial number of the device.

    .PARAMETER TestId
    The ID of the cable test.

    .EXAMPLE
    Get-MerakiDeviceLiveToolsCableTest -AuthToken "your-api-token" -Serial "Q2XX-XXXX-XXXX" -TestId "testId1"

    This example retrieves the results of the cable test with ID "testId1" for the device with serial number "Q2XX-XXXX-XXXX".

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
        [string]$TestId
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $url = "https://api.meraki.com/api/v1/devices/$Serial/liveTools/cableTest/$TestId"

        $response = Invoke-RestMethod -Method Get -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
