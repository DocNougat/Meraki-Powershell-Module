function Invoke-MerakiDeviceReboot {
    <#
    .SYNOPSIS
    Reboot a device in Meraki dashboard.

    .DESCRIPTION
    This function allows you to reboot a device in Meraki dashboard.

    .PARAMETER AuthToken
    The authentication token for the Meraki API.

    .PARAMETER Serial
    The serial number of the device.

    .EXAMPLE
    Invoke-MerakiDeviceReboot -AuthToken "1234" -Serial "Q2HP-XXXX-XXXX"

    This example reboots the device with serial number 'Q2HP-XXXX-XXXX'.

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.

    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$Serial
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $uri = "https://api.meraki.com/api/v1/devices/$Serial/reboot"
        $response = Invoke-RestMethod -Method Post -Uri $uri -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}