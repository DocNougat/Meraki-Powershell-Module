function Set-MerakiOrganizationWirelessZigbeeDevice {
    <#
    .SYNOPSIS
    Updates the configuration of a Meraki wireless Zigbee device within an organization.

    .DESCRIPTION
    Set-MerakiOrganizationWirelessZigbeeDevice sends an HTTP POST to the Meraki dashboard API to update a Zigbee device's configuration.
    The function requires an API authentication token and the target Zigbee device ID. If OrganizationID is not provided, it will attempt
    to resolve a single organization ID by calling Get-OrgID -AuthToken $AuthToken. If multiple organizations are found, the function
    returns a message instructing the caller to specify an organization ID.

    .PARAMETER AuthToken
    The Meraki API key used to authenticate the request. This is required.

    .PARAMETER OrganizationID
    The ID of the Meraki organization that contains the Zigbee device. If omitted, the function will call Get-OrgID -AuthToken $AuthToken to
    attempt to obtain a single organization ID. If Get-OrgID indicates multiple organizations were found, the function will return that message
    and not perform the API call.

    .PARAMETER ZigbeeDeviceID
    The identifier of the Zigbee device to update. This is required.

    .PARAMETER ZigbeeConfig
    A JSON-formatted string representing the configuration payload to send to the Meraki API for the Zigbee device. This should be valid JSON
    matching the Meraki API schema for Zigbee device configuration. This is required.

    .EXAMPLE
    # Provide AuthToken and allow automatic organization lookup; ZigbeeConfig supplied as a JSON string
    $token = '0123456789abcdef0123456789abcdef01234567'
    $deviceId = 'zigbeeDevice123'
    $config = @{
        enrolled = $true
        channel = "15"
    } | ConvertTo-Json -Depth 10 -Compress
    Set-MerakiOrganizationWirelessZigbeeDevice -AuthToken $token -ZigbeeDeviceID $deviceId -ZigbeeConfig $config

    .Notes
    - The function uses the Meraki API endpoint: POST /organizations/{organizationId}/wireless/zigbee/devices/{deviceId}.
    - Ensure the provided AuthToken has the necessary permissions to modify wireless/Zigbee device settings.
    - ZigbeeConfig must be a valid JSON payload.
    - Errors encountered during the REST call will be thrown to the caller.

    .LINK
    Meraki Dashboard API documentation: https://developer.cisco.com/meraki/api-v1/
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$ZigbeeDeviceID,
        [parameter(Mandatory=$true)]
        [string]$ZigbeeConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/wireless/zigbee/devices/$ZigbeeDeviceID"

            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $ZigbeeConfig
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}