function Remove-MerakiNetworkApplianceRfProfile {
    <#
    .SYNOPSIS
    Deletes an RF profile for a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Remove-MerakiNetworkApplianceRfProfile function allows you to delete an RF profile for a specified Meraki network by providing the authentication token, network ID, and RF profile ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to delete the RF profile.

    .PARAMETER RFProfileId
    The ID of the RF profile you want to delete.

    .EXAMPLE
    Remove-MerakiNetworkApplianceRfProfile -AuthToken "your-api-token" -NetworkId "your-network-id" -RFProfileId "your-rf-profile-id"

    This example deletes the RF profile with ID "your-rf-profile-id" for the Meraki network with ID "your-network-id".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the RF profile deletion is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$RFProfileId
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/rfProfiles/$RFProfileId"
        $response = Invoke-RestMethod -Method Delete -Uri $uri -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}