function Get-MerakiNetworkAuthUser {
    <#
    .SYNOPSIS
    Retrieves information about a specific Meraki authentication user.

    .DESCRIPTION
    This function retrieves information about a specific Meraki authentication user for a specified network.

    .PARAMETER AuthToken
    The Meraki API key to use for authentication.

    .PARAMETER MerakiAuthUserId
    The unique identifier of the Meraki authentication user.

    .PARAMETER NetworkId
    The unique identifier of the network to which the Meraki authentication user belongs.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkAuthUser -AuthToken "1234" -MerakiAuthUserId "5678" -NetworkId "abcd"
    Retrieves information about the Meraki authentication user with ID "5678" in the network with ID "abcd", using the API key "1234".

    .NOTES
    For more information, see the Meraki API documentation: https://developer.cisco.com/meraki/api-v1/#!get-network-meraki-auth-user
    #>

    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$MerakiAuthUserId,
        [parameter(Mandatory=$true)]
        [string]$NetworkId
    )

    $header = @{
        'X-Cisco-Meraki-API-Key' = $AuthToken
    }
    $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/merakiAuthUsers/$MerakiAuthUserId"
    try {
        $response = Invoke-RestMethod -Method Get -Uri $uri -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    } catch {
        Write-Host $_
        Throw $_
    }
}
