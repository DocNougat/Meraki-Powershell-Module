function Get-MerakiNetworkSwitchStack {
    <#
    .SYNOPSIS
    Retrieves a specific switch stack in a network.

    .DESCRIPTION
    This function retrieves the details of a specific switch stack in a network using the Meraki Dashboard API.
    
    .PARAMETER AuthToken
    The Meraki Dashboard API token for your organization.

    .PARAMETER networkId
    The network ID for the network containing the switch stack.

    .PARAMETER switchStackId
    The ID of the switch stack to retrieve.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkSwitchStack -AuthToken "1234" -networkId "L_1234" -switchStackId "1234"
    
    This command retrieves the details of the switch stack with ID "1234" in the network with ID "L_1234" using the API token "1234".

    .NOTES
    For more information on the Meraki Dashboard API, see https://developer.cisco.com/meraki/api-v1/.
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/switch/stacks/$switchStackId" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Host $_
        Throw $_
    }
}