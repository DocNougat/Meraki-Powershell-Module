function Invoke-MerakiNetworkRefreshSmDevice {
    <#
    .SYNOPSIS
    Refreshes the details of a device in a Meraki network.
    
    .DESCRIPTION
    The Invoke-MerakiNetworkRefreshSmDevice function allows you to refresh the details of a device in a specified Meraki network by providing the authentication token, network ID, and device ID.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network in which the device is located.
    
    .PARAMETER DeviceId
    The ID of the device whose details will be refreshed.
    
    .EXAMPLE
    Invoke-MerakiNetworkRefreshSmDevice -AuthToken "your-api-token" -NetworkId "1234" -DeviceId "5678"
    
    This example refreshes the details of the device with ID "5678" in the Meraki network with ID "1234".
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the refresh is successful, otherwise, it displays an error message.
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
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/sm/devices/$DeviceId/refreshDetails"
    
            $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }