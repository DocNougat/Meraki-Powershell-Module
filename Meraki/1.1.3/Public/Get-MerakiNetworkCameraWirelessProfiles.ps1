function Get-MerakiNetworkCameraWirelessProfiles {
    <#
    .SYNOPSIS
    Retrieves a list of wireless profiles for cameras in a given Meraki network.
    
    .DESCRIPTION
    This function retrieves a list of wireless profiles configured for cameras in a specified Meraki network.
    
    .PARAMETER AuthToken
    The Meraki API authorization token.
    
    .PARAMETER NetworkId
    The ID of the Meraki network to retrieve camera wireless profiles for.
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkCameraWirelessProfiles -AuthToken "1234" -NetworkId "N_1234567890"
    
    Retrieves a list of wireless profiles for cameras in the Meraki network with ID "N_1234567890".
    
    .NOTES
    For more information on Meraki API endpoints, see the official documentation: https://developer.cisco.com/meraki/api-v1/
    #>
    
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId
    )
    
    $header = @{
        'X-Cisco-Meraki-API-Key' = $AuthToken
    }
    
    try {
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/camera/wirelessProfiles" -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
