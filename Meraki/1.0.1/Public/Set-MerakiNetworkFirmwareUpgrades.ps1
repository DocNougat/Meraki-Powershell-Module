function Set-MerakiNetworkFirmwareUpgrades {
    <#
    .SYNOPSIS
    Updates the firmware upgrade settings for a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkFirmwareUpgrades function allows you to update the firmware upgrade settings for a specified Meraki network by providing the authentication token, network ID, and a firmware upgrade configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to update the firmware upgrade settings.

    .PARAMETER FirmwareUpgradeConfig
    A string containing the firmware upgrade configuration. The string should be in JSON format and should include the "timezone", "products", and "upgradeWindow" properties.

    .EXAMPLE
    $config = '{
        "timezone": "America/Los_Angeles",
        "products": {
            "MR": "wireless",
            "MS": "switch",
            "MX": "appliance",
            "MV": "camera"
        },
        "upgradeWindow": {
            "dayOfWeek": "monday",
            "hourOfDay": "1:00"
        }
    }'
    $config = $config | ConvertTo-Json -Compress
    Set-MerakiNetworkFirmwareUpgrades -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -FirmwareUpgradeConfig $config

    This example updates the firmware upgrade settings for the Meraki network with ID "L_123456789012345678", setting the timezone to "America/Los_Angeles", the products to upgrade to "wireless" for MR, "switch" for MS, "appliance" for MX, and "camera" for MV, and the upgrade window to every Monday at 1:00 AM.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the firmware upgrade settings update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$FirmwareUpgradeConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $FirmwareUpgradeConfig

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/firmwareUpgrades"

        $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -Body $body
        return $response
    }
    catch {
        Write-Host $_
    }
}