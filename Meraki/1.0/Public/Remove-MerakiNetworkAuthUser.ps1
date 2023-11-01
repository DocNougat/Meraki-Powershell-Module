function Remove-MerakiNetworkAuthUser {
    <#
    .SYNOPSIS
    Deletes an existing Meraki authentication user for a specified network using the Meraki Dashboard API.

    .DESCRIPTION
    The Remove-MerakiNetworkAuthUser function allows you to delete an existing Meraki authentication user for a specified network by providing the authentication token, network ID, and user ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network from which you want to delete an existing authentication user.

    .PARAMETER MerakiAuthUserId
    The ID of the Meraki authentication user you want to delete.

    .EXAMPLE
    Remove-MerakiNetworkAuthUser -AuthToken "your-api-token" -NetworkId "L_1234567890" -MerakiAuthUserId "1234"

    This example deletes the Meraki authentication user with ID "1234" for the network with ID "L_1234567890".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the authentication user deletion is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$MerakiAuthUserId
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/merakiAuthUsers/$MerakiAuthUserId"

        $response = Invoke-RestMethod -Method Delete -Uri $url -Header $header
        return $response
    }
    catch {
        Write-Host $_
    }
}