function Get-MerakiNetworkCameraWirelessProfile {
    <#
    .SYNOPSIS
    Gets the details of a wireless profile for cameras in a Meraki network.
    
    .DESCRIPTION
    This function retrieves the details of a wireless profile for cameras in a specified Meraki network.
    
    .PARAMETER AuthToken
    The Meraki API token.
    
    .PARAMETER NetworkId
    The Meraki network ID.
    
    .PARAMETER wirelessProfileId
    The ID of the wireless profile.
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkCameraWirelessProfile -AuthToken "1234" -NetworkId "abcd" -wirelessProfileId "5678"
    
    This example retrieves the details of the wireless profile with ID "5678" in the Meraki network with ID "abcd".
    
    .NOTES
    For more information on wireless profiles for Meraki cameras, see the Meraki API documentation:
    https://developer.cisco.com/meraki/api-v1/#!get-network-camera-wireless-profile
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true, HelpMessage="The Meraki API token.")]
        [string]$AuthToken,
        [parameter(Mandatory=$true, HelpMessage="The Meraki network ID.")]
        [string]$NetworkId,
        [parameter(Mandatory=$true, HelpMessage="The ID of the wireless profile.")]
        [string]$wirelessProfileId
    )
    
    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/camera/wirelessProfiles/$wirelessProfileId" -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
