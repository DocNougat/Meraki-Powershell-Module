function Get-MerakiNetworkWirelessSsidDeviceTypeGroupPolicies {
    <#
    .SYNOPSIS
    Retrieves the device type group policies for a specified SSID in a Meraki network.
    .DESCRIPTION
    This function retrieves the device type group policies for a specified SSID in a Meraki network using the Meraki Dashboard API.
    .PARAMETER AuthToken
    The Meraki API token for the account.
    .PARAMETER networkId
    The ID of the Meraki network for which to retrieve the device type group policies.
    .PARAMETER SSIDNumber
    The number of the SSID for which to retrieve the device type group policies.
    .EXAMPLE
    PS> Get-MerakiNetworkWirelessSsidDeviceTypeGroupPolicies -AuthToken "1234" -networkId "abcd" -SSIDNumber 1
    Retrieves the device type group policies for SSID 1 in network "abcd" using the Meraki API token "1234".
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$networkId,
        [parameter(Mandatory=$true)]
        [string]$SSIDNumber
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }

        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/wireless/ssids/$SSIDNumber/deviceTypeGroupPolicies" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
