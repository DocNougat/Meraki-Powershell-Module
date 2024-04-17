function Get-MerakiDeviceSwitchRoutingInterfaces {
    <#
    .SYNOPSIS
    Gets the list of layer 3 interfaces of a switch.
    
    .DESCRIPTION
    Use this API to get the list of layer 3 interfaces for a switch. If the switch does not support layer 3 routing, returns an empty array. 
    
    .PARAMETER AuthToken
    Meraki Dashboard API token
    
    .PARAMETER deviceSerial
    The serial number of the switch to which the layer 3 interfaces belong
    
    .EXAMPLE
    PS C:\> Get-MerakiDeviceSwitchRoutingInterfaces -AuthToken "12345" -deviceSerial "Q2HP-XXXX-XXXX"
    
    This command returns the list of layer 3 interfaces of the specified switch.
    
    .NOTES
    For more information about this API, please refer to:
    https://developer.cisco.com/meraki/api-v1/#!get-device-switch-routing-interfaces
    
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$DeviceSerial
    )

    $header = @{
        "X-Cisco-Meraki-API-Key" = $AuthToken
    }

    try {
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/devices/$DeviceSerial/switch/routing/interfaces" -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
