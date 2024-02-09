function Get-MerakiDeviceLiveToolsPing {
        <#
    .SYNOPSIS
    Gets the status of a ping sent to a device.
    .PARAMETER AuthToken
        Meraki API token.
    .PARAMETER pingId
        The pingId returned from the Send-MerakiDeviceLiveToolsPing function.
    .PARAMETER deviceSerial
        The serial number of the Meraki device.
    .EXAMPLE
    Get-MerakiDeviceLiveToolsPing -AuthToken $AuthToken -pingId 1234 -deviceSerial ABC123
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$pingId,
        [parameter(Mandatory=$true)]
        [string]$DeviceSerial
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/devices/$DeviceSerial/liveTools/ping/$pingId" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Host $_
        Throw $_
    }
}
