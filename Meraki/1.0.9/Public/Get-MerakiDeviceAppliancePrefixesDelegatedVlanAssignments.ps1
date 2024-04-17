function Get-MerakiDeviceAppliancePrefixesDelegatedVlanAssignments {
    <#
    .SYNOPSIS
        Gets the VLAN assignments for delegated prefixes configured on a specific Cisco Meraki appliance by serial number.
    .DESCRIPTION
        This function makes a REST API call to the Meraki dashboard API to retrieve information about the VLAN assignments for delegated prefixes configured on a specific Cisco Meraki appliance, based on its serial number. The function returns detailed information about each VLAN assignment, including the VLAN ID and the prefix it is assigned to.
    .PARAMETER AuthToken
        The authentication token to use for the API call. This should be a valid API key for the Meraki dashboard.
    .PARAMETER deviceSerial
        The serial number of the Cisco Meraki appliance to retrieve delegated prefix VLAN assignment information for.
    .EXAMPLE
        PS C:\> Get-MerakiDeviceAppliancePrefixesDelegatedVlanAssignments -AuthToken "myapikey" -deviceSerial "Q2XX-XXXX-XXXX"
        Returns information about the VLAN assignments for delegated prefixes configured on the Cisco Meraki appliance with the specified serial number.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$DeviceSerial
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/devices/$DeviceSerial/appliance/prefixes/delegated/vlanAssignments" -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
