function Remove-MerakiNetworkCameraWirelessProfile {
    <#
    .SYNOPSIS
    Deletes the camera wireless profile for a Meraki network.
    
    .DESCRIPTION
    The Remove-MerakiNetworkCameraWirelessProfile function allows you to delete the camera wireless profile for a specified Meraki network by providing the authentication token, network ID, and wireless profile ID.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to delete the camera wireless profile.
    
    .PARAMETER WirelessProfileId
    The ID of the wireless profile that you want to delete.
    
    .EXAMPLE
    Remove-MerakiNetworkCameraWirelessProfile -AuthToken "your-api-token" -NetworkId "N_1234" -WirelessProfileId "3"
    
    This example deletes the camera wireless profile for the Meraki network with ID "N_1234".
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the deletion is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$NetworkId,
            [parameter(Mandatory=$true)]
            [string]$WirelessProfileId
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/camera/wirelessProfiles/$WirelessProfileId"
    
            $response = Invoke-RestMethod -Method Delete -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }