function Set-MerakiNetworkCameraQualityRetentionProfile {
    <#
    .SYNOPSIS
    Updates a camera quality retention profile for a Meraki network using the Meraki Dashboard API.
    
    .DESCRIPTION
    The Set-MerakiNetworkCameraQualityRetentionProfile function allows you to update a camera quality retention profile for a specified Meraki network by providing the authentication token, network ID, quality retention profile ID, and a retention profile configuration string.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to update the camera quality retention profile.
    
    .PARAMETER QualityRetentionProfileId
    The ID of the camera quality retention profile that you want to update.
    
    .PARAMETER RetentionProfileConfig
    A string containing the retention profile configuration. The string should be in JSON format and should include the properties as defined in the schema.
    
    .EXAMPLE
    $RetentionProfileConfig = '{
        "maxRetentionDays": 30,
        "motionDetectorVersion": 2,
        "name": "My Profile",
        "scheduleId": "1234",
        "audioRecordingEnabled": false,
        "cloudArchiveEnabled": false,
        "motionBasedRetentionEnabled": false,
        "restrictedBandwidthModeEnabled": false,
        "videoSettings": {
            "MV12": {
                "quality": "Standard",
                "resolution": "1280x720"
            }
        }
    }'
    $RetentionProfileConfig = $RetentionProfileConfig | ConvertTo-Json -Compress
    
    Set-MerakiNetworkCameraQualityRetentionProfile -AuthToken "your-api-token" -NetworkId "N_1234567890" -QualityRetentionProfileId "P_1234567890" -RetentionProfileConfig $RetentionProfileConfig
    
    This example updates a camera quality retention profile for the Meraki network with ID "N_1234567890".
    
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
            [string]$QualityRetentionProfileId,
            [parameter(Mandatory=$true)]
            [string]$RetentionProfileConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/camera/qualityRetentionProfiles/$QualityRetentionProfileId"
            $body = $RetentionProfileConfig
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -Body $body
            return $response
        }
        catch {
            Write-Host $_
        }
    }