function New-MerakiNetworkFirmwareUpgradesRollback {
    <#
    .SYNOPSIS
    Creates a firmware upgrade rollback for a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The New-MerakiNetworkFirmwareUpgradesRollback function allows you to create a firmware upgrade rollback for a specified Meraki network by providing the authentication token, network ID, and a firmware rollback configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to create a firmware upgrade rollback.

    .PARAMETER FirmwareRollbackConfig
    A string containing the firmware rollback configuration. The string should be in JSON format and should include the "product", "time", "toVersion", "reasons", "category", and "comment" properties.

    .EXAMPLE
    $config = [PSCustomObject]@{
        "product" = "wireless"
        "time" = "2022-01-01T01:00:00Z"
        "toVersion" = @{
            "MR" = "4.0"
            "MS" = "11.0"
            "MX" = "15.0"
            "MV" = "4.0"
        }
        "reasons" = @("testing")
        "category" = "testing"
        "comment" = "Rolling back to test new firmware"
    }

    $config = $config | ConvertTo-Json -Compress
    New-MerakiNetworkFirmwareUpgradesRollback -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -FirmwareRollbackConfig $config

    This example creates a firmware upgrade rollback for the Meraki network with ID "L_123456789012345678", setting the product to "wireless", the scheduled time to January 1, 2022 at 1:00 AM UTC, the version to downgrade to for MR to "4.0", for MS to "11.0", for MX to "15.0", and for MV to "4.0", the reason for the rollback to "testing", the category to "testing", and an additional comment.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the firmware upgrade rollback creation is successful, otherwise, it displays an error message.
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

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/firmwareUpgrades/rollbacks"

        $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}