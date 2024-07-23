function Get-MerakiNetworkCameraQualityRetentionProfile {
    <#
    .SYNOPSIS
    Retrieves a specific quality and retention profile for a network's cameras.
    
    .DESCRIPTION
    This API endpoint returns the details of a specific quality and retention profile for cameras in a network. 
    
    .PARAMETER AuthToken
    Specifies the Meraki Dashboard API token to authenticate requests.
    
    .PARAMETER NetworkId
    Specifies the network ID for which to retrieve the quality and retention profile.
    
    .PARAMETER qualityRetentionProfileId
    Specifies the ID of the quality and retention profile to retrieve.
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkCameraQualityRetentionProfile -AuthToken "1234" -NetworkId "L_1234" -qualityRetentionProfileId "abcd"
    
    This example retrieves the details of the quality and retention profile with ID "abcd" for the network with ID "L_1234".
    
    .NOTES
    For more information about the API endpoint, see https://developer.cisco.com/meraki/api-v1/#!get-network-camera-quality-retention-profile.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$qualityRetentionProfileId
    )
    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/camera/qualityRetentionProfiles/$qualityRetentionProfileId" -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}