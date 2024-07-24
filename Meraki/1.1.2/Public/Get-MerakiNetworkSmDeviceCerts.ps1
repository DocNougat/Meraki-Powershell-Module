function Get-MerakiNetworkSmDeviceCerts {
    <#
    .SYNOPSIS
    Retrieve the certificates installed on a device enrolled in Systems Manager.
    
    .DESCRIPTION
    This function retrieves the certificates installed on a device enrolled in Systems Manager.
    
    .PARAMETER AuthToken
    Required. The authorization token for the Meraki dashboard API.
    
    .PARAMETER NetworkId
    Required. The ID of the network that the device is enrolled in.
    
    .PARAMETER DeviceId
    Required. The ID of the device to retrieve the certificates for.
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkSmDeviceCerts -AuthToken "1234" -NetworkId "N_1234" -DeviceId "abcd"
    
    This command retrieves the certificates installed on the device with the ID "abcd" in the network with the ID "N_1234" using the authorization token "1234".
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$DeviceId
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/sm/devices/$deviceId/certs" -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
