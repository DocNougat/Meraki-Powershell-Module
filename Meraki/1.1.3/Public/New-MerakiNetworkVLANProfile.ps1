function New-MerakiNetworkVLANProfile {
    <#
    .SYNOPSIS
    Creates a new VLAN profile for an existing Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The New-MerakiNetworkVLANProfile function allows you to create a new VLAN profile for an existing Meraki network by providing the authentication token, network ID, and a JSON configuration for the VLAN profile.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to create a VLAN profile.

    .PARAMETER VLANProfileConfig
    The JSON configuration for the VLAN profile to be created. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $VLANProfileConfig = [PSCustomObject]@{
        name = "My VLAN profile name"
        vlanNames = @(
            @{
                name = "named-1"
                vlanId = "1"
            }
        )
        vlanGroups = @(
            @{
                name = "named-group-1"
                vlanIds = "2,5-7"
            }
        )
        iname = "Profile1"
    }

    $VLANProfileConfig = $VLANProfileConfig | ConvertTo-Json -Compress -Depth 4

    New-MerakiNetworkVLANProfile -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -VLANProfileConfig $VLANProfileConfig

    This example creates a new VLAN profile for the Meraki network with ID "L_123456789012345678" with the specified configuration.

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
        [string]$VLANProfileConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }
        
        $body = $VLANProfileConfig

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/vlanProfiles"
        
        $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}