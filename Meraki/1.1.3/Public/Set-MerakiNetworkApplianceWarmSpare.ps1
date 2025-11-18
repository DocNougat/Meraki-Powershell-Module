function Set-MerakiNetworkApplianceWarmSpare {
    <#
    .SYNOPSIS
    Updates the warm spare settings of a Meraki network appliance.
    
    .DESCRIPTION
    The Set-MerakiNetworkApplianceWarmSpare function allows you to update the warm spare settings of a Meraki network appliance by providing the authentication token, network ID, and a JSON configuration for the warm spare settings.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to update the warm spare settings.
    
    .PARAMETER WarmSpareConfig
    The JSON configuration for the warm spare settings to be updated. Refer to the JSON schema for required parameters and their format.
    
    .EXAMPLE
    $WarmSpareConfig = [PSCustomObject]@{
        enabled = $true
        spareSerial = "Q234-ABCD-5678"
        uplinkMode = "virtual"
        virtualIp1 = "1.2.3.4"
        virtualIp2 = "1.2.3.4"
    }

    $WarmSpareConfig = $WarmSpareConfig | ConvertTo-JSON -Compress

    Set-MerakiNetworkApplianceWarmSpare -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -WarmSpareConfig $WarmSpareConfig

    This example updates the warm spare settings of the Meraki network appliance with ID "L_123456789012345678".
    
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
            [string]$WarmSpareConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $body = $WarmSpareConfig
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/warmSpare"
    
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }