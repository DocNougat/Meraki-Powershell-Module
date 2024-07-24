function New-MerakiNetworkApplianceRFProfile {
    <#
    .SYNOPSIS
    Creates a new RF profile for a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The New-MerakiNetworkApplianceRFProfile function allows you to create a new RF profile for a specified Meraki network by providing the authentication token, network ID, and an RF profile configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to create the RF profile.

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
            "1" = @{
                bandOperationMode = "dual"
                bandSteeringEnabled = $true
            }
            "2" = @{
                bandOperationMode = "dual"
                bandSteeringEnabled = $true
            }
            "3" = @{
                bandOperationMode = "dual"
                bandSteeringEnabled = $true
            }
            "4" = @{
                bandOperationMode = "dual"
                bandSteeringEnabled = $true
            }
        }
    }

    $config = $config | ConvertTo-Json -Compress
    New-MerakiNetworkApplianceRFProfile -AuthToken "your-api-token" -NetworkId "your-network-id" -RFProfileConfig $config

    This example creates a new RF profile for the Meraki network with ID "your-network-id", using the specified RF profile configuration.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the RF profile creation is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$RFProfileConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $RFProfileConfig

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/rfProfiles"
        $response = Invoke-RestMethod -Method Post -Uri $uri -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}