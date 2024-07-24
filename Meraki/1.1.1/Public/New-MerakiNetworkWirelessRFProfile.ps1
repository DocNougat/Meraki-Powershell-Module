function New-MerakiNetworkWirelessRFProfile {
    <#
    .SYNOPSIS
    Creates a network wireless RF profile.
    
    .DESCRIPTION
    The New-MerakiNetworkWirelessRFProfile function allows you to create a network wireless RF profile by providing the authentication token, network ID, and a JSON formatted string of the RF profile.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
    .PARAMETER RFProfile
    A JSON formatted string of the RF profile.
    
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

    $RFProfileJson = $RFProfile | ConvertTo-Json
    New-MerakiNetworkWirelessRFProfile -AuthToken "your-api-token" -NetworkId "1234" -RFProfile $RFProfileJson

    This example creates a network wireless RF profile with the specified configuration.
    
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
            [string]$RFProfile
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/wireless/rfProfiles"
    
            $body = $RFProfile
    
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }