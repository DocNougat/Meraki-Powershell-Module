function Invoke-MerakiNetworkClaimDevices {
    <#
    .SYNOPSIS
    Claims devices for a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Invoke-MerakiNetworkClaimDevices function allows you to claim devices for a specified Meraki network by providing the authentication token, network ID, and a list of device serial numbers.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to claim devices.

    .PARAMETER DeviceSerials
    A string containing a JSON array of device serial numbers to claim.

    .EXAMPLE
    $serials = [PSCustomObject]@{
        serials = @(
            "Q2HP-XXXX-XXXX",
            "Q2HP-YYYY-YYYY"
        )
    } | ConvertTo-Json -Compress

    Invoke-MerakiNetworkClaimDevices -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -DeviceSerials $serials
    This example claims two devices with serial numbers "Q2HP-XXXX-XXXX" and "Q2HP-YYYY-YYYY" for the Meraki network with ID "L_123456789012345678".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the claiming is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$DeviceSerials
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $DeviceSerials

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/devices/claim"

        $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}