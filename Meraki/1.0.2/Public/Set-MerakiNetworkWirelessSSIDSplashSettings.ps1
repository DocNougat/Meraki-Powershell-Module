function Set-MerakiNetworkWirelessSSIDSplashSettings {
    <#
    .SYNOPSIS
    Updates the splash settings for a network's wireless SSID using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkWirelessSSIDSplashSettings function allows you to update the splash settings for a network's wireless SSID by providing the authentication token, network ID, SSID number, and a splash settings configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the network for which you want to update the SSID splash settings.

    .PARAMETER SSIDNumber
    The number of the SSID to update the splash settings for.

    .PARAMETER SSIDSplashSettings
    A string containing the SSID splash settings configuration. The string should be in JSON format and should include the properties as defined in the schema.

    .EXAMPLE
    $splashSettings = [PSCustomObject]@{
        splashUrl = "https://www.custom_splash_url.com"
        useSplashUrl = $true
        splashTimeout = 1440
        redirectUrl = "https://example.com"
        useRedirectUrl = $true
        welcomeMessage = "Welcome!"
        splashLogo = @{
            md5 = "abcd1234"
            extension = "jpg"
            image = @{
                format = "jpg"
                contents = "Q2lzY28gTWVyYWtp"
            }
        }
        splashImage = @{
            md5 = "542cccac8d7dedee0f185311d154d194"
            extension = "jpg"
            image = @{
                format = "jpg"
                contents = "Q2lzY28gTWVyYWtp"
            }
        }
        splashPrepaidFront = @{
            md5 = "542cccac8d7dedee0f185311d154d194"
            extension = "jpg"
            image = @{
                format = "jpg"
                contents = "Q2lzY28gTWVyYWtp"
            }
        }
        blockAllTrafficBeforeSignOn = $false
        controllerDisconnectionBehavior = "default"
        allowSimultaneousLogins = $false
        guestSponsorship = @{
            durationInMinutes = 30
            guestCanRequestTimeframe = $false
        }
        billing = @{
            freeAccess = @{
                enabled = $true
                durationInMinutes = 120
            }
            prepaidAccessFastLoginEnabled = $true
            replyToEmailAddress = "user@email.com"
        }
        sentryEnrollment = @{
            systemsManagerNetwork = @{ id = "N_1234" }
            strength = "focused"
            enforcedSystems = @("iOS")
        }
    }

    $splashSettingsJson = $splashSettings | ConvertTo-Json -Compress
    Set-MerakiNetworkWirelessSSIDSplashSettings -AuthToken "your-api-token" -NetworkId "your-network-id" -SSIDNumber "1" -SSIDSplashSettings $splashSettingsJson

    This example updates the splash settings for the SSID with number 1 in the network with ID "your-network-id", using the specified splash settings configuration.

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
        [string]$SSIDNumber,
        [parameter(Mandatory=$true)]
        [string]$SSIDSplashSettings
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $SSIDSplashSettings

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/wireless/ssids/$SSIDNumber/splash/settings"
        $response = Invoke-RestMethod -Method Put -Uri $uri -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Error $_
    }
}