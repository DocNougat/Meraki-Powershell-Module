function New-MerakiNetworkFirmwareUpgradesStagedGroup {
    <#
    .SYNOPSIS
    Creates a new firmware upgrade staged group for a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The New-MerakiNetworkFirmwareUpgradesStagedGroup function allows you to create a new firmware upgrade staged group for a specified Meraki network by providing the authentication token, network ID, and a firmware upgrade staged group configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to create a new firmware upgrade staged group.

    .PARAMETER FirmwareUpgradeStagedGroupConfig
    A string containing the firmware upgrade staged group configuration. The string should be in JSON format and should include the "name", "isDefault", and "assignedDevices" properties.

    .EXAMPLE
    $config = [PSCustomObject]@{
        name = "My Staged Upgrade Group"
        isDefault = $false
        assignedDevices = @{
            devices = @(
                @{
                    name = "My Device"
                    serial = "Q2XX-XXXX-XXXX"
                }
            )
            switchStacks = @(
                @{
                    id = "123456789012345"
                    name = "My Switch Stack"
                }
            )
        }
    }

    $config = $config | ConvertTo-Json -Compress
    New-MerakiNetworkFirmwareUpgradesStagedGroup -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -FirmwareUpgradeStagedGroupConfig $config

    This example creates a new firmware upgrade staged group with the name "My Staged Upgrade Group" for the Meraki network with ID "L_123456789012345678", assigning the device with serial number "Q2XX-XXXX-XXXX" and the switch stack with ID "123456789012345" to the group.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the firmware upgrade staged group creation is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$FirmwareUpgradeStagedGroupConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $FirmwareUpgradeStagedGroupConfig

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/firmwareUpgrades/staged/groups"

        $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Host $_
    }
}