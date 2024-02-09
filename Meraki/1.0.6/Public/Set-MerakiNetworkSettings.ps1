function Set-MerakiNetworkSettings {
    <#
    .SYNOPSIS
    Updates the settings of an existing Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkSettings function allows you to update the settings of an existing Meraki network by providing the authentication token, network ID, and a JSON configuration for the network settings.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to update the settings.

    .PARAMETER NetworkConfig
    The JSON configuration for the network settings to be updated. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $NetworkConfig = [PSCustomObject]@{
        localStatusPageEnabled = $true
        remoteStatusPageEnabled = $true
        localStatusPage = @{
            authentication = @{
                password = "mypassword"
                enabled = $true
            }
        }
        namedVlans = @{
            enabled = $true
        }
        securePort = @{
            enabled = $true
        }
    }
    $NetworkConfig = $NetworkConfig | ConvertTo-JSON -Compress

    Set-MerakiNetworkSettings -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -NetworkConfig $NetworkConfig

    This example updates the settings of the Meraki network with ID "L_123456789012345678" to enable local and remote status pages, set a password for local status pages, enable named VLANs, and enable SecureConnect.

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
        [string]$NetworkConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }
        
        $body = $NetworkConfig

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/settings"
        
        $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Host $_
        Throw $_
    }
}