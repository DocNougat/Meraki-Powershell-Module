function Remove-MerakiNetworkDevice {
    <#
    .SYNOPSIS
    Removes a device from a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Remove-MerakiNetworkDevice function allows you to remove a device from a specified Meraki network by providing the authentication token, network ID, and the serial number of the device.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network from which you want to remove a device.

    .PARAMETER DeviceSerial
    The serial number of the device you want to remove.

    .EXAMPLE
    Remove-MerakiNetworkDevice -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -DeviceSerial "Q2HP-XXXX-XXXX"

    This example removes the device with serial number "Q2HP-XXXX-XXXX" from the Meraki network with ID "L_123456789012345678".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the removal is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$DeviceSerial
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = @{
            "serial" = $DeviceSerial
        } | ConvertTo-Json -Depth 3 -Compress

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/devices/remove"

        $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Host $_
        Throw $_
    }
}