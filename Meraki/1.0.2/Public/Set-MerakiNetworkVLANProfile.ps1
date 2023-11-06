function Set-MerakiNetworkVLANProfile {
    <#
    .SYNOPSIS
    Updates an existing VLAN profile for an existing Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkVLANProfile function allows you to update an existing VLAN profile for an existing Meraki network by providing the authentication token, network ID, profile name, and a JSON configuration for the VLAN profile.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to update a VLAN profile.

    .PARAMETER ProfileName
    The name of the VLAN profile to be updated.

    .PARAMETER VLANProfileConfig
    The JSON configuration for the VLAN profile to be updated. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $VLANProfileConfig = '{
        "name": "My VLAN profile name",
        "vlanNames": [
            {
                "name": "named-1",
                "vlanId": "1"
            }
        ],
        "vlanGroups": [
            {
                "name": "named-group-1",
                "vlanIds": "2,5-7"
            }
        ]
    }'
    $VLANProfileConfig = $VLANProfileConfig | ConvertTo-JSON -compress

    Set-MerakiNetworkVLANProfile -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -ProfileName "My VLAN profile name" -VLANProfileConfig $VLANProfileConfig

    This example updates the VLAN profile with name "My VLAN profile name" for the Meraki network with ID "L_123456789012345678" with the specified configuration.

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
        [string]$ProfileName,
        [parameter(Mandatory=$true)]
        [string]$VLANProfileConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }
        
        $body = $VLANProfileConfig

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/vlanProfiles/$ProfileName"
        
        $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Host $_
    }
}