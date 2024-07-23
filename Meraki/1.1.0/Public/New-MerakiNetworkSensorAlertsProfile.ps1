function New-MerakiNetworkSensorAlertsProfile {
    <#
    .SYNOPSIS
    Creates a sensor alerts profile for a Meraki network.
    
    .DESCRIPTION
    The New-MerakiNetworkSensorAlertsProfile function allows you to create a sensor alerts profile for a specified Meraki network by providing the authentication token, network ID, and a JSON configuration for the alerts profile.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The network ID of the Meraki network for which you want to create the sensor alerts profile.
    
    .PARAMETER AlertsProfileConfig
    A string containing the alerts profile configuration. The string should be in JSON format and should include the properties as defined in the schema.
    
    .EXAMPLE
    $AlertsProfileConfig = [PSCustomObject]@{
        name = "My Sensor Alert Profile"
        schedule = @{ id = "5" }
        conditions = @(
            @{
                metric = "temperature"
                threshold = @{
                    temperature = @{
                        celsius = 20.5
                        fahrenheit = 70
                        quality = "good"
                    }
                    humidity = @{
                        relativePercentage = 65
                        quality = "inadequate"
                    }
                    water = @{ present = $true }
                    door = @{ open = $true }
                    tvoc = @{
                        concentration = 400
                        quality = "poor"
                    }
                    pm25 = @{
                        concentration = 90
                        quality = "fair"
                    }
                    noise = @{
                        ambient = @{
                            level = 120
                            quality = "poor"
                        }
                    }
                    indoorAirQuality = @{
                        score = 80
                        quality = "fair"
                    }
                }
                direction = "above"
                duration = 60
            }
        )
        recipients = @{
            emails = @("miles@meraki.com")
            smsNumbers = @("+15555555555")
            httpServerIds = @("aHR0cHM6Ly93d3cuZXhhbXBsZS5jb20vd2ViaG9va3M=")
        }
        serials = @(
            "Q234-ABCD-0001",
            "Q234-ABCD-0002",
            "Q234-ABCD-0003"
        )
    }

    $AlertsProfileConfig = $AlertsProfileConfig | ConvertTo-Json -Compress

    New-MerakiNetworkSensorAlertsProfile -AuthToken "your-api-token" -NetworkId "1234" -AlertsProfileConfig $AlertsProfileConfig

    This example creates a sensor alerts profile for the Meraki network with ID "1234".
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the creation is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$NetworkId,
            [parameter(Mandatory=$true)]
            [string]$AlertsProfileConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/sensor/alerts/profiles"
    
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat" -Body $AlertsProfileConfig
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }