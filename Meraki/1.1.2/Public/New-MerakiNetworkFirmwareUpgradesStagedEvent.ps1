function New-MerakiNetworkFirmwareUpgradesStagedEvent {
    <#
    .SYNOPSIS
    Creates a staged firmware upgrade event for a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The New-MerakiNetworkFirmwareUpgradesStagedEvent function allows you to create a staged firmware upgrade event for a specified Meraki network by providing the authentication token, network ID, and a firmware upgrade configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to create a staged firmware upgrade event.

    .PARAMETER FirmwareStagedEventConfig
    A string containing the firmware staged event configuration. The string should be in JSON format and should include the "products", "stages", "group", "milestones", and "scheduledFor" properties.

    .EXAMPLE
    $config = [PSCustomObject]@{
        "products" = @{
            "MR" = "4.0"
            "MS" = "11.0"
            "MX" = "15.0"
            "MV" = "4.0"
        }
        "stages" = @(
            @{
                "group" = @{
                    "name" = "My Upgrade Group"
                    "id" = "123456789012345"
                }
                "milestones" = @{
                    "preStage" = @{
                        "time" = "2022-01-01T01:00:00Z"
                        "version" = @{
                            "MR" = "3.0"
                            "MS" = "10.0"
                            "MX" = "14.0"
                            "MV" = "3.0"
                        }
                    }
                    "postStage" = @{
                        "time" = "2022-01-02T01:00:00Z"
                        "version" = @{
                            "MR" = "4.0"
                            "MS" = "11.0"
                            "MX" = "15.0"
                            "MV" = "4.0"
                        }
                    }
                }
                "scheduledFor" = "2022-01-01T01:00:00Z"
            }
        )
    }

    $configJson = $config | ConvertTo-Json -Compress
    New-MerakiNetworkFirmwareUpgradesStagedEvent -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -FirmwareStagedEventConfig $configJson

    This example creates a staged firmware upgrade event for the Meraki network with ID "L_123456789012345678", setting the products to upgrade to "4.0" for MR, "11.0" for MS, "15.0" for MX, and "4.0" for MV, and the upgrade stages to a single stage with a pre-stage milestone to upgrade to "3.0" for MR, "10.0" for MS, "14.0" for MX, and "3.0" for MV, a post-stage milestone to upgrade to "4.0" for MR, "11.0" for MS, "15.0" for MX, and "4.0" for MV, and a scheduled start time of January 1, 2022 at 1:00 AM UTC.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the staged firmware upgrade event creation is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$FirmwareStagedEventConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $FirmwareStagedEventConfig

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/firmwareUpgrades/staged/events"

        $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}