function Set-MerakiNetworkFirmwareUpgradesStagedGroup {
    <#
    .SYNOPSIS
    Updates a firmware upgrade staged group for a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkFirmwareUpgradesStagedGroup function allows you to update a firmware upgrade staged group for a specified Meraki network by providing the authentication token, network ID, group ID, and a firmware upgrade staged group configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to update the firmware upgrade staged group.

    .PARAMETER GroupId
    The ID of the firmware upgrade staged group you want to update.

    .PARAMETER FirmwareUpgradeStagedGroupConfig
    A string containing the firmware upgrade staged group configuration. The string should be in JSON format and should include the "name", "isDefault", and "assignedDevices" properties.

    .EXAMPLE
    $config = [PSCustomObject]@{
        name = "My Updated Staged Upgrade Group"
        isDefault = $false
        assignedDevices = [PSCustomObject]@{
            devices = @(
                [PSCustomObject]@{
                    name = "My Device"
                    serial = "Q2XX-XXXX-XXXX"
                }
            )
            switchStacks = @(
                [PSCustomObject]@{
                    id = "123456789012345"
                    name = "My Switch Stack"
                }
            )
        }
    }
    $config = $config | ConvertTo-Json -Compress
    Set-MerakiNetworkFirmwareUpgradesStagedGroup -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -GroupId "1234" -FirmwareUpgradeStagedGroupConfig $config
    This example updates the firmware upgrade staged group with ID "1234" for the Meraki network with ID "L_123456789012345678", changing the name to "My Updated Staged Upgrade Group", setting the group as non-default, and assigning the device with serial number "Q2XX-XXXX-XXXX" and the switch stack with ID "123456789012345" to the group.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the firmware upgrade staged group update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$GroupId,
        [parameter(Mandatory=$true)]
        [string]$FirmwareUpgradeStagedGroupConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $FirmwareUpgradeStagedGroupConfig

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/firmwareUpgrades/staged/groups/$GroupId"

        $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Host $_
        Throw $_
    }
}