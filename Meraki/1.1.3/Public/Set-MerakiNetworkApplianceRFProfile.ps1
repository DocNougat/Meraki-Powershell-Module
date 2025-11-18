function Set-MerakiNetworkApplianceRFProfile {
    <#
    .SYNOPSIS
    Updates an RF profile for a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkApplianceRFProfile function allows you to update an RF profile for a specified Meraki network by providing the authentication token, network ID, RF profile ID, and an RF profile configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to update the RF profile.

    .PARAMETER RFProfileId
    The ID of the RF profile you want to update.

    .PARAMETER RFProfileConfig
    A string containing the RF profile configuration. The string should be in JSON format and should include the "name", "twoFourGhzSettings", "fiveGhzSettings", and "perSsidSettings" properties.

    .EXAMPLE
    $config = [PSCustomObject]@{
        name = "MX RF Profile"
        twoFourGhzSettings = @{
            minBitrate = 12
            axEnabled = $true
        }
        fiveGhzSettings = @{
            minBitrate = 48
            axEnabled = $true
        }
        perSsidSettings = @{
            1 = @{
                bandOperationMode = "dual"
                bandSteeringEnabled = $true
            }
            2 = @{
                bandOperationMode = "dual"
                bandSteeringEnabled = $true
            }
            3 = @{
                bandOperationMode = "dual"
                bandSteeringEnabled = $true
            }
            4 = @{
                bandOperationMode = "dual"
                bandSteeringEnabled = $true
            }
        }
    }

    $config = $config | ConvertTo-Json -Compress -Depth 4
    Set-MerakiNetworkApplianceRFProfile -AuthToken "your-api-token" -NetworkId "your-network-id" -RFProfileId "your-rf-profile-id" -RFProfileConfig $config

    This example updates the RF profile with ID "your-rf-profile-id" for the Meraki network with ID "your-network-id", using the specified RF profile configuration.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the RF profile update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$RFProfileId,
        [parameter(Mandatory=$true)]
        [string]$RFProfileConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $RFProfileConfig

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/rfProfiles/$RFProfileId"
        $response = Invoke-RestMethod -Method Put -Uri $uri -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}