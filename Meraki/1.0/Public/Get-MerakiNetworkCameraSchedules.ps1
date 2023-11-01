function Get-MerakiNetworkCameraSchedules {
    <#
    .SYNOPSIS
    Gets the camera schedules for a network.
    
    .DESCRIPTION
    This function retrieves the camera schedules for a specified network.
    
    .PARAMETER AuthToken
    The Meraki Dashboard API authentication token.
    
    .PARAMETER NetworkId
    The Meraki network ID.
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkCameraSchedules -AuthToken "1234" -NetworkId "abcd"
    
    Gets the camera schedules for the network with ID "abcd".
    
    .NOTES
    For more information on the API endpoint, please see: 
    https://developer.cisco.com/meraki/api-v1/#!get-network-camera-schedules
    #>
    
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId
    )
    
    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/camera/Schedules" -Header $header
        return $response
    }
    catch {
        Write-Error "Error retrieving camera schedules: $_"
    }
}
