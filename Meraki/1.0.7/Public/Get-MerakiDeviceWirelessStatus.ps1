function Get-MerakiDeviceWirelessStatus {
    <#
    .SYNOPSIS
    Retrieves the wireless status of a Meraki device.

    .DESCRIPTION
    This function retrieves the wireless status of a Meraki device with the specified serial number.

    .PARAMETER AuthToken
    The API token generated in the Meraki dashboard.

    .PARAMETER deviceSerial
    The serial number of the Meraki device.

    .EXAMPLE
    PS C:\> Get-MerakiDeviceWirelessStatus -AuthToken "1234" -deviceSerial "Q2XX-XXXX-XXXX"

    This example retrieves the wireless status of the Meraki device with the specified serial number.

    .NOTES
    For more information on the Meraki API and available parameters, visit https://developer.cisco.com/meraki/api-v1/.
    #>

    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$DeviceSerial
    )

    $header = @{
        "X-Cisco-Meraki-API-Key" = $AuthToken
    }

    $URL = "https://api.meraki.com/api/v1/devices/$DeviceSerial/wireless/status"

    $URI = [uri]::EscapeUriString($URL)

    try {
        $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    } catch {
        Write-Debug $_
        Throw $_
    }
}
