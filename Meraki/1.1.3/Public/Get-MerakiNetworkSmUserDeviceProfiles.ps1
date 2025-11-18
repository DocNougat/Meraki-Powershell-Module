function Get-MerakiNetworkSmUserDeviceProfiles {
    <#
    .SYNOPSIS
    Retrieves the device profiles associated with a Systems Manager user.

    .DESCRIPTION
    This function retrieves the device profiles associated with a Systems Manager user in a given network.

    .PARAMETER AuthToken
    Required. The Meraki Dashboard API authentication token.

    .PARAMETER NetworkId
    Required. The network ID.

    .PARAMETER UserId
    Required. The user ID.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkSmUserDeviceProfiles -AuthToken "12345" -NetworkId "L_1234" -UserId "12345"

    Retrieves the device profiles associated with the user "12345" in the network "L_1234".
    #>
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$networkId,
        [parameter(Mandatory=$true)]
        [string]$userId
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/sm/users/$userId/deviceProfiles" -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    } catch {
        Write-Debug $_
        Throw $_
    }
}
