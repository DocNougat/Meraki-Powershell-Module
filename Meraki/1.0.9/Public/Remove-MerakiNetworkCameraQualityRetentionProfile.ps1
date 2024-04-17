function Remove-MerakiNetworkCameraQualityRetentionProfile {
    <#
    .SYNOPSIS
    Deletes a camera quality retention profile for a Meraki network using the Meraki Dashboard API.
    
    .DESCRIPTION
    The Remove-MerakiNetworkCameraQualityRetentionProfile function allows you to delete a camera quality retention profile for a specified Meraki network by providing the authentication token, network ID, and quality retention profile ID.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to delete the camera quality retention profile.
    
    .PARAMETER QualityRetentionProfileId
    The ID of the camera quality retention profile that you want to delete.
    
    .EXAMPLE
    Remove-MerakiNetworkCameraQualityRetentionProfile -AuthToken "your-api-token" -NetworkId "N_1234567890" -QualityRetentionProfileId "P_1234567890"
    
    This example deletes a camera quality retention profile for the Meraki network with ID "N_1234567890".
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the deletion is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$NetworkId,
            [parameter(Mandatory=$true)]
            [string]$QualityRetentionProfileId
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/camera/qualityRetentionProfiles/$QualityRetentionProfileId"
    
            $response = Invoke-RestMethod -Method Delete -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }