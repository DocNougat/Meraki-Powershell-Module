function Get-MerakiNetworkGroupPolicies {
    <#
    .SYNOPSIS
        Retrieves a list of group policies for a Meraki network.

    .PARAMETER AuthToken
        The Meraki API key.

    .PARAMETER NetworkId
        The ID of the Meraki network.

    .EXAMPLE
        Get-MerakiNetworkGroupPolicies -AuthToken "YOUR_API_KEY" -NetworkId "YOUR_NETWORK_ID"

        Retrieves a list of group policies for the specified network.

    .NOTES
        Requires the Invoke-RestMethod cmdlet.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$NetworkId
    )

    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/groupPolicies" -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
