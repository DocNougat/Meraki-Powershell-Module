function New-MerakiNetworkCameraQualityRetentionProfile {
    <#
    .SYNOPSIS
    Creates a new camera quality retention profile for a Meraki network using the Meraki Dashboard API.
    
    .DESCRIPTION
    The New-MerakiNetworkCameraQualityRetentionProfile function allows you to create a new camera quality retention profile for a specified Meraki network by providing the authentication token, network ID, and a retention profile configuration string.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to create the new camera quality retention profile.
    
    .PARAMETER RetentionProfileConfig
    A string containing the retention profile configuration. The string should be in JSON format and should include the properties as defined in the schema.
    
    .EXAMPLE
    $RetentionProfileConfig = [PSCustomObject]@{
        maxRetentionDays = 30
        motionDetectorVersion = 2
        name = "My Profile"
        scheduleId = "1234"
        audioRecordingEnabled = $false
        cloudArchiveEnabled = $false
        motionBasedRetentionEnabled = $false
        restrictedBandwidthModeEnabled = $false
        videoSettings = @{
            MV12 = @{
                quality = "Standard"
                resolution = "1280x720"
            }
        }
    }

    $RetentionProfileConfig = $RetentionProfileConfig | ConvertTo-Json -Compress

    New-MerakiNetworkCameraQualityRetentionProfile -AuthToken "your-api-token" -NetworkId "N_1234567890" -RetentionProfileConfig $RetentionProfileConfig

    This example creates a new camera quality retention profile for the Meraki network with ID "N_1234567890".
    
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
            [string]$RetentionProfileConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
            
            $body = $RetentionProfileConfig
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/camera/qualityRetentionProfiles"
    
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat" -Body $body
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }