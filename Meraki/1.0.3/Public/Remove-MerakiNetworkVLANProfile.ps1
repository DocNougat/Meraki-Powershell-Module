function Remove-MerakiNetworkVLANProfile {
    <#
    .SYNOPSIS
    Deletes an existing VLAN profile for an existing Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Remove-MerakiNetworkVLANProfile function allows you to delete an existing VLAN profile for an existing Meraki network by providing the authentication token, network ID, and profile name.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to delete a VLAN profile.

    .PARAMETER ProfileName
    The name of the VLAN profile you want to delete.

    .EXAMPLE
    Remove-MerakiNetworkVLANProfile -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -ProfileName "My VLAN profile name"

    This example deletes the VLAN profile with name "My VLAN profile name" for the Meraki network with ID "L_123456789012345678".

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
        [string]$ProfileName
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/vlanProfiles/$ProfileName"

        $response = Invoke-RestMethod -Method Delete -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Host $_
    }
}