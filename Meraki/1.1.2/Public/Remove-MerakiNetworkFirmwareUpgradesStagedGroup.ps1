function Remove-MerakiNetworkFirmwareUpgradesStagedGroup {
    <#
    .SYNOPSIS
    Deletes a firmware upgrade staged group for a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Remove-MerakiNetworkFirmwareUpgradesStagedGroup function allows you to delete a firmware upgrade staged group for a specified Meraki network by providing the authentication token, network ID, and group ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to delete the firmware upgrade staged group.

    .PARAMETER GroupId
    The ID of the firmware upgrade staged group you want to delete.

    .EXAMPLE
    Remove-MerakiNetworkFirmwareUpgradesStagedGroup -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -GroupId "1234"

    This example deletes the firmware upgrade staged group with ID "1234" for the Meraki network with ID "L_123456789012345678".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the firmware upgrade staged group deletion is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$GroupId
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/firmwareUpgrades/staged/groups/$GroupId"

        $response = Invoke-RestMethod -Method Delete -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}