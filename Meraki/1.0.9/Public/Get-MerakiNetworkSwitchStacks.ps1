function Get-MerakiNetworkSwitchStacks {
    <#
    .SYNOPSIS
    Retrieves a list of switch stacks in a specified network.

    .DESCRIPTION
    The Get-MerakiNetworkSwitchStacks function retrieves a list of switch stacks in a specified Meraki network.

    .PARAMETER AuthToken
    The authorization token obtained from the Meraki dashboard.

    .PARAMETER NetworkId
    The ID of the network to which the switch stack belongs.

    .EXAMPLE
    PS C:> Get-MerakiNetworkSwitchStacks -AuthToken '1a2b3c4d5e6f' -NetworkId 'L_123456789012345678'

    Retrieves a list of switch stacks in the specified network.

    .NOTES
    For more information on the Meraki API and examples of how to use it, visit the Meraki developer website at https://developer.cisco.com/meraki/.
    #>
    [CmdletBinding()]
    param (
    [parameter(Mandatory=$true)]
    [string]$AuthToken,
    [parameter(Mandatory=$true)]
    [string]$networkId
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/switch/stacks" -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}    