function Remove-MerakiNetworkWirelessAirMarshalRule {
    <#
    .SYNOPSIS
    Deletes an Air Marshal rule for a network.

    .DESCRIPTION
    This function allows you to delete an Air Marshal rule for a network by providing the authentication token, network ID, and rule ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the network.

    .PARAMETER RuleId
    The ID of the rule to delete.

    .EXAMPLE
    Remove-MerakiNetworkWirelessAirMarshalRule -AuthToken "your-api-token" -NetworkId "N_123456789012345678" -RuleId "rule_id"

    This example deletes the Air Marshal rule with ID "rule_id" for the network with ID "N_123456789012345678".
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$RuleId
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/wireless/airMarshal/rules/$RuleId"

        $response = Invoke-RestMethod -Method Delete -Uri $url -Headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
