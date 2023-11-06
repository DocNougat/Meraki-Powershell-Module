function Get-MerakiNetworkSmDeviceSecurityCenters {
    <#
    .SYNOPSIS
    Retrieves the list of security centers associated with a device in the Systems Manager for a given network.
    .DESCRIPTION
    This function retrieves the list of security centers associated with a device in the Systems Manager for a given network.

    .PARAMETER AuthToken
    Required. The Meraki Dashboard API authentication token.

    .PARAMETER NetworkId
    Required. The network ID.

    .PARAMETER deviceId
    Required. The device ID.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkSmDeviceSecurityCenters -AuthToken "12345" -NetworkId "L_1234" -deviceId "Q2XX-XXXX-XXXX"

    Retrieves the list of security centers associated with a device with ID "Q2XX-XXXX-XXXX" in the network "L_1234".
    #>
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$networkId,
        [parameter(Mandatory=$true)]
        [string]$deviceId
    )
    try{
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }

        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/sm/devices/$deviceId/securityCenters" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    } catch {
        Write-Error $_
    }
}