function Set-MerakiOrganizationWirelessMqttSettings {
    <#
    .SYNOPSIS
    Sets or updates the MQTT settings for a Meraki organization's wireless configuration.

    .DESCRIPTION
    Set-MerakiOrganizationWirelessMqttSettings updates the MQTT configuration for a specified Meraki organization by calling the Meraki Dashboard API.
    The function expects a JSON-formatted MQTT payload (as a string) and issues a PUT request to the organization's wireless MQTT settings endpoint.
    If OrganizationID is omitted, the function attempts to resolve it via Get-OrgID -AuthToken <AuthToken>.

    .PARAMETER AuthToken
    The Meraki Dashboard API key (value sent in the X-Cisco-Meraki-API-Key header). This parameter is required.

    .PARAMETER OrganizationID
    The target Meraki organization ID. If not provided, the function calls Get-OrgID -AuthToken <AuthToken> to determine the organization.
    If multiple organizations are found by Get-OrgID, the function returns the message: "Multiple organizations found. Please specify an organization ID."

    .PARAMETER MqttConfig
    A JSON string containing the MQTT settings to apply. The string will be sent as the request body with Content-Type: application/json; charset=utf-8.
    Example payloads can be read from a file using Get-Content -Raw.

    .EXAMPLE
    # Powershell Object payload
    $MqttConfigJson = @{
        network = @{ id = "L_1234" }
        mqtt = @{
            enabled = $true
            topic = "Test Topic"
            messageFields = @(
                "RSSI",
                "AP MAC address",
                "Client MAC address",
                "Timestamp",
                "Radio",
                "Network ID",
                "Beacon type",
                "Raw payload",
                "Client UUID",
                "Client major value",
                "Client minor value",
                "Signal power",
                "Band",
                "Slot ID"
            )
            publishing = @{ frequency = 1; qos = 1 }
            broker = @{ name = "My Broker" }
        }
        ble = @{
            enabled = $false
            type = "ibeacon"
            flush = @{ frequency = 60 }
            allowLists = @{ uuids = @(); macs = @() }
            hysteresis = @{
                enabled = $true
                threshold = 1
            }
        }
        wifi = @{
            enabled = $false
            type = "associated"
            flush = @{ frequency = 60 }
            allowLists = @{ macs = @() }
            hysteresis = @{
                enabled = $false
                threshold = 1
            }
        }
    } | ConvertTo-Json -Depth 10 -Compress
    Set-MerakiOrganizationWirelessMqttSettings -AuthToken 'abcdef12345' -OrganizationID 123456 -MqttConfig $MqttConfigJson

    .NOTES
    - Endpoint: https://api.meraki.com/api/v1/organizations/{organizationId}/wireless/mqtt/settings
    - Ensure the provided AuthToken has appropriate permissions to modify organization wireless settings.

    .LINK
    https://developer.cisco.com/meraki/api-v1/#!set-organization-wireless-mqtt-settings
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$MqttConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{    
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/wireless/mqtt/settings"

            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $MqttConfig
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}