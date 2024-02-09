function Set-MerakiNetworkWirelessSSIDEAPOverride {
    <#
    .SYNOPSIS
    Updates a network wireless SSID EAP Override.
    
    .DESCRIPTION
    The Set-MerakiNetworkWirelessSSIDEAPOverride function allows you to update a network wireless SSID EAP Override by providing the authentication token, network ID, SSID number, and a JSON formatted string of the EAP Override.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
    .PARAMETER SSIDNumber
    The number of the SSID.
    
    .PARAMETER EAPOverride
    A JSON formatted string of the EAP Override.
    
    .EXAMPLE
    $EAPOverride = [PSCustomObject]@{
        timeout = 5
        identity = @{
            retries = 5
            timeout = 5
        }
        maxRetries = 5
        eapolKey = @{
            retries = 5
            timeoutInMs = 5000
        }
    }
    $EAPOverride = $EAPOverride | ConvertTo-Json -Compress
    Set-MerakiNetworkWirelessSSIDEAPOverride -AuthToken "your-api-token" -NetworkId "1234" -SSIDNumber 0 -EAPOverride $EAPOverride

    This example updates a network wireless SSID EAP Override with the specified configuration.
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the update is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$NetworkId,
            [parameter(Mandatory=$true)]
            [int]$SSIDNumber,
            [parameter(Mandatory=$true)]
            [string]$EAPOverride
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/wireless/ssids/$SSIDNumber/eapOverride"
    
            $body = $EAPOverride
    
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Host $_
        Throw $_
    }
    }