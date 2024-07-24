function New-MerakiDeviceLiveToolsWakeOnLan {
    <#
    .SYNOPSIS
    Sends a Wake-on-LAN packet to a specified device.

    .DESCRIPTION
    This function allows you to send a Wake-on-LAN packet to a specified device by providing the authentication token, device serial number, and a JSON string with the Wake-on-LAN details including VLAN ID, MAC address, and callback information.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER Serial
    The serial number of the device.

    .PARAMETER WakeOnLanDetails
    A compressed JSON string representing the Wake-on-LAN details including VLAN ID, MAC address, and callback information.

    .EXAMPLE
    $WakeOnLanDetails = @{
        vlanId = 1
        mac = "00:11:22:33:44:55"
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
    $WakeOnLanDetailsJson = $WakeOnLanDetails | ConvertTo-Json -Compress -Depth 4
    New-MerakiDeviceLiveToolsWakeOnLan -AuthToken "your-api-token" -Serial "Q2XX-XXXX-XXXX" -WakeOnLanDetails $WakeOnLanDetailsJson

    This example sends a Wake-on-LAN packet to the device with serial number "Q2XX-XXXX-XXXX" using the provided details.

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
        [string]$WakeOnLanDetails
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $url = "https://api.meraki.com/api/v1/devices/$Serial/liveTools/wakeOnLan"

        $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat" -Body $WakeOnLanDetails
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
