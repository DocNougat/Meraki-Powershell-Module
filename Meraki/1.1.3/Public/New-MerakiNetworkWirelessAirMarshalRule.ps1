function New-MerakiNetworkWirelessAirMarshalRule {
    <#
    .SYNOPSIS
    Creates a new Air Marshal rule for a network.

    .DESCRIPTION
    This function allows you to create a new Air Marshal rule for a network by providing the authentication token, network ID, and rule configuration.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the network.

    .PARAMETER RuleConfig
    A string containing the rule configuration in JSON format.

    .EXAMPLE
    $ruleConfig = [PSCustomObject]@{
        type = "block"
        match = @{
            string = "SSID"
            type = "contains"
        }
    } | ConvertTo-Json -Compress -Depth 4

    New-MerakiNetworkWirelessAirMarshalRule -AuthToken "your-api-token" -NetworkId "N_123456789012345678" -RuleConfig $ruleConfig

    This example creates a new Air Marshal rule for the network with ID "N_123456789012345678".
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$RuleConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $RuleConfig

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/wireless/airMarshal/rules"

        $response = Invoke-RestMethod -Method Post -Uri $url -Headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
