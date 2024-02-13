function Set-MerakiNetworkWirelessRFProfile {
    <#
    .SYNOPSIS
    Updates a network wireless RF profile.
    
    .DESCRIPTION
    The Set-MerakiNetworkWirelessRFProfile function allows you to update a network wireless RF profile by providing the authentication token, network ID, RF profile ID, and a JSON formatted string of the RF profile settings.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
    .PARAMETER RFProfileId
    The ID of the RF profile to be updated.
    
    .PARAMETER RFProfile
    A JSON formatted string of the RF profile settings.
    
    .EXAMPLE
    $RFProfile = [PSCustomObject]@{
        name = "Main Office"
        clientBalancingEnabled = $true
        minBitrateType = "band"
        bandSelectionType = "ap"
        apBandSettings = @{
            bandOperationMode = "dual"
            bands = @{
                enabled = [ "2.4", "5" ]
            }
            bandSteeringEnabled = $true
        }
        twoFourGhzSettings = @{
            maxPower = 30
            minPower = 5
            minBitrate = 11
            validAutoChannels = [ 1, 6, 11 ]
            axEnabled = $true
            rxsop = -95
        }
        fiveGhzSettings = @{
            maxPower = 30
            minPower = 8
            minBitrate = 12
            validAutoChannels = [ 36, 40, 44, 48, 52, 56, 60 ]
            channelWidth = "auto"
            rxsop = -95
        }
        sixGhzSettings = @{
            maxPower = 30
            minPower = 8
            minBitrate = 12
            validAutoChannels = [ 49, 53, 57, 61, 65, 69, 73, 77, 81, 85, 89, 93 ]
            channelWidth = "auto"
            rxsop = -95
        }
        transmission = @{ enabled = $true }
        perSsidSettings = @{
            0 = @{
                minBitrate = 11
                bandOperationMode = "dual"
                bands = @{
                    enabled = [ "2.4", "5" ]
                }
                bandSteeringEnabled = $true
            }
        }
        flexRadios = @{
            byModel = @(
                @{
                    model = "MR34"
                    bands = [ "5" ]
                }
            )
        }
    }

    $RFProfile = $RFProfile | ConvertTo-Json -Compress
    Set-MerakiNetworkWirelessRFProfile -AuthToken "your-api-token" -NetworkId "1234" -RFProfileId "1001" -RFProfile $RFProfile

    This example updates a network wireless RF profile with the specified configuration.
    
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
            [string]$RFProfileId,
            [parameter(Mandatory=$true)]
            [string]$RFProfile
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/wireless/rfProfiles/$RFProfileId"
    
            $body = $RFProfile
    
            $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }