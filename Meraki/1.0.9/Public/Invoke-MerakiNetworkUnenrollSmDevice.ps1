function Invoke-MerakiNetworkUnenrollSmDevice {
    <#
    .SYNOPSIS
    Unenrolls a device from a Meraki network.
    
    .DESCRIPTION
    The Invoke-MerakiNetworkUnenrollSmDevice function allows you to unenroll a device from a specified Meraki network by providing the authentication token, network ID, and device ID.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network from which the device will be unenrolled.
    
    .PARAMETER DeviceId
    The ID of the device to be unenrolled.
    
    .EXAMPLE
    Invoke-MerakiNetworkUnenrollSmDevice -AuthToken "your-api-token" -NetworkId "1234" -DeviceId "5678"
    
    This example unenrolls the device with ID "5678" from the Meraki network with ID "1234".
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the unenrollment is successful, otherwise, it displays an error message.
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
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/sm/devices/$DeviceId/unenroll"
    
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }