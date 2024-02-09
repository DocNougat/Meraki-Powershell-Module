function Get-MerakiDeviceCellularGatewayPortForwardingRules {
    <#
    .SYNOPSIS
    Gets the port forwarding rules configured on a Meraki cellular gateway.

    .DESCRIPTION
    The Get-MerakiDeviceCellularGatewayPortForwardingRules function retrieves the port forwarding rules configured on a Meraki cellular gateway using the Meraki Dashboard API.

    .PARAMETER AuthToken
    The API key used to authenticate with the Meraki Dashboard API.

    .PARAMETER deviceSerial
    The serial number of the Meraki cellular gateway.

    .EXAMPLE
    PS C:\> Get-MerakiDeviceCellularGatewayPortForwardingRules -AuthToken "1234" -deviceSerial "ABCD-1234-EFGH-5678"
    Returns the port forwarding rules configured on the Meraki cellular gateway with serial number "ABCD-1234-EFGH-5678" using the API key "1234".

    .NOTES
    For more information on the Meraki Dashboard API and available endpoints, visit https://developer.cisco.com/meraki/api-v1/.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [string]$AuthToken,
        [parameter(Mandatory = $true)]
        [string]$DeviceSerial
    )

    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/devices/$DeviceSerial/cellularGateway/portForwardingRules" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    } catch {
        Write-Host $_
        Throw $_
    }
}
