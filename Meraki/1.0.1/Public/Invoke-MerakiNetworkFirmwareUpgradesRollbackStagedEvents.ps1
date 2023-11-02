function Invoke-MerakiNetworkFirmwareUpgradesRollbackStagedEvents {
    <#
    .SYNOPSIS
    Rolls back a staged firmware upgrade event for a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Invoke-MerakiNetworkFirmwareUpgradesRollbackStagedEvents function allows you to roll back a staged firmware upgrade event for a specified Meraki network by providing the authentication token, network ID, and a firmware rollback configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to roll back a staged firmware upgrade event.

    .PARAMETER FirmwareRollbackConfig
    A string containing the firmware rollback configuration. The string should be in JSON format and should include the "reasons", "stages", "group", "id", "milestones", and "scheduledFor" properties.

    .EXAMPLE
    $config = '{
        "reasons": [
            "Rollback due to issues with new firmware"
        ],
        "stages": [
            {
                "group": {
                    "name": "My Upgrade Group",
                    "id": "123456789012345"
                },
                "milestones": {
                    "preStage": {
                        "time": "2022-01-01T01:00:00Z",
                        "version": {
                            "MR": "3.0",
                            "MS": "10.0",
                            "MX": "14.0",
                            "MV": "3.0"
                        }
                    },
                    "postStage": {
                        "time": "2022-01-02T01:00:00Z",
                        "version": {
                            "MR": "4.0",
                            "MS": "11.0",
                            "MX": "15.0",
                            "MV": "4.0"
                        }
                    }
                },
                "scheduledFor": "2022-01-01T01:00:00Z"
            }
        ]
    }'
    $config = $config | ConvertTo-Json -Compress
    Invoke-MerakiNetworkFirmwareUpgradesRollbackStagedEvents -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -FirmwareRollbackConfig $config

    This example rolls back a staged firmware upgrade event for the Meraki network with ID "L_123456789012345678", setting the reasons for the rollback to "Rollback due to issues with new firmware", canceling all pending stages, and setting the upgrade stages to a single stage with a pre-stage milestone to upgrade to "3.0" for MR, "10.0" for MS, "14.0" for MX, and "3.0" for MV, a post-stage milestone to upgrade to "4.0" for MR, "11.0" for MS, "15.0" for MX, and "4.0" for MV, and a scheduled start time of January 1, 2022 at 1:00 AM UTC.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the firmware rollback is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$FirmwareRollbackConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $FirmwareRollbackConfig

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/firmwareUpgrades/staged/events/rollbacks"

        $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -Body $body
        return $response
    }
    catch {
        Write-Host $_
    }
}