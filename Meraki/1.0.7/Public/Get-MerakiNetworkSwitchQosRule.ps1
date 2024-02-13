function Get-MerakiNetworkSwitchQosRule {
    <#
    .SYNOPSIS
        Gets a QoS rule for a Meraki network switch.
    .DESCRIPTION
        This function retrieves a QoS (Quality of Service) rule for a Meraki network switch using the Meraki Dashboard API.
    .PARAMETER AuthToken
        The API authentication token for the Meraki Dashboard.
    .PARAMETER networkId
        The ID of the Meraki network to retrieve the QoS rule for.
    .PARAMETER qosRuleId
        The ID of the QoS rule to retrieve.
    .EXAMPLE
        PS C:\> Get-MerakiNetworkSwitchQosRule -AuthToken "api_token" -networkId "L_123456789" -qosRuleId "123"
        Returns the specified QoS rule for the specified Meraki network switch.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$networkId,
        [Parameter(Mandatory=$true)]
        [string]$qosRuleId
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/switch/qosRules/$qosRuleId" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
