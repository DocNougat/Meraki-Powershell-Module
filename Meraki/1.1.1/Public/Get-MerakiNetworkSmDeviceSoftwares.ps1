function Get-MerakiNetworkSmDeviceSoftwares {
    <#
    .SYNOPSIS
    Retrieves the list of installed software on a Systems Manager device.

    .DESCRIPTION
    This function retrieves the list of installed software on a Systems Manager device.
    
    .PARAMETER AuthToken
    Required. The Meraki Dashboard API authentication token.
    
    .PARAMETER NetworkId
    Required. The network ID.
    
    .PARAMETER DeviceId
    Required. The device ID.
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkSmDeviceSoftwares -AuthToken "12345" -NetworkId "L_1234" -DeviceId "ABC123"
    
    Retrieves the list of installed software on device "ABC123" in the network "L_1234".
    #>
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$networkId,
        [parameter(Mandatory=$true)]
        [string]$deviceId
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/sm/devices/$deviceId/softwares" -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
