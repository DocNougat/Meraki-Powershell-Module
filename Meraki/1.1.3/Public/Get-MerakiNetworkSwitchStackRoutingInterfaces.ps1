function Get-MerakiNetworkSwitchStackRoutingInterfaces {
    <#
    .SYNOPSIS
    Retrieves a list of routing interfaces for a specified switch stack in a Meraki network.

    .DESCRIPTION
    This function retrieves a list of routing interfaces for a specified switch stack in a Meraki network using the Meraki Dashboard API.
    
    .PARAMETER AuthToken
    The Meraki Dashboard API token for the Meraki organization to which the network belongs.
    
    .PARAMETER networkId
    The ID of the Meraki network containing the switch stack.
    
    .PARAMETER switchStackId
    The ID of the switch stack for which to retrieve routing interfaces.
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkSwitchStackRoutingInterfaces -AuthToken "1234" -networkId "L_1234" -switchStackId "1234"
    
    Retrieves a list of routing interfaces for the switch stack with ID "1234" in the network with ID "L_1234" using the Meraki Dashboard API and API token "1234".
    
    .NOTES
    For more information about the Meraki Dashboard API, see https://developer.cisco.com/meraki/api/.
    #>
    
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$networkId,
        [parameter(Mandatory=$true)]
        [string]$switchStackId
    )
    
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/switch/stacks/$switchStackId/routing/interfaces" -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}