function Get-MerakiNetworkClient {
    <#
    .SYNOPSIS
    Retrieves information about a specific client on a Meraki network.

    .DESCRIPTION
    The Get-MerakiNetworkClient function retrieves information about a specific client on a Meraki network.
    
    .PARAMETER AuthToken
    Specifies the API key for the Meraki dashboard.
    
    .PARAMETER networkId
    Specifies the ID of the network that the client is associated with.
    
    .PARAMETER clientId
    Specifies the ID of the client to retrieve information for.
    
    .EXAMPLE
    Get-MerakiNetworkClient -AuthToken "1234" -networkId "N_123456" -clientId "1234"
    Retrieves information about the client with ID "1234" on the network with ID "N_123456" using the API key "1234".
    
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$networkId,
        [parameter(Mandatory=$true)]
        [string]$clientId
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/clients/$clientId" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
