function Set-MerakiNetworkWirelessAirMarshalRule {
    <#
    .SYNOPSIS
    Updates an Air Marshal rule for a network.

    .DESCRIPTION
    This function allows you to update an Air Marshal rule for a network by providing the authentication token, network ID, rule ID, and rule configuration.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the network.

    .PARAMETER RuleId
    The ID of the rule to update.

    .PARAMETER RuleConfig
    A string containing the rule configuration in JSON format.

    .EXAMPLE
    $ruleConfig = [PSCustomObject]@{
        type = "alert"
        match = @{
            string = "BSSID"
            type = "exact"
        }
    } | ConvertTo-Json -Compress

    Set-MerakiNetworkWirelessAirMarshalRule -AuthToken "your-api-token" -NetworkId "N_123456789012345678" -RuleId "rule_id" -RuleConfig $ruleConfig

    This example updates the Air Marshal rule with ID "rule_id" for the network with ID "N_123456789012345678".
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$RuleId,
        [parameter(Mandatory=$true)]
        [string]$RuleConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $RuleConfig

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/wireless/airMarshal/rules/$RuleId"

        $response = Invoke-RestMethod -Method Put -Uri $url -Headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
