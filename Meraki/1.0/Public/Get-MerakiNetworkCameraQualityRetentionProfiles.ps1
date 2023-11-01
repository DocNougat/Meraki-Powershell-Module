function Get-MerakiNetworkCameraQualityRetentionProfiles {
    <#
    .SYNOPSIS
    Retrieves the list of quality retention profiles for a Meraki network.

    .DESCRIPTION
    This function retrieves the list of quality retention profiles for a Meraki network.

    .PARAMETER AuthToken
    The Meraki Dashboard API token.

    .PARAMETER NetworkId
    The ID of the Meraki network.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkCameraQualityRetentionProfiles -AuthToken "1234" -NetworkId "N_1234"

    Retrieves the list of quality retention profiles for the network with ID "N_1234".

    .NOTES
    For more information on quality retention profiles, see the Meraki Dashboard API documentation:
    https://developer.cisco.com/meraki/api-v1/#!get-network-camera-quality-retention-profiles
    #>
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId
    )

    $header = @{
        'X-Cisco-Meraki-API-Key' = $AuthToken
    }

    try {
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/camera/qualityRetentionProfiles" -Header $header
        return $response
    }
    catch {
        Write-Error $_
    }
}