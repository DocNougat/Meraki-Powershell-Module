function Get-MerakiNetworkGroupPolicy {
    <#
    .SYNOPSIS
        Retrieves a specific group policy for a Meraki network.

    .PARAMETER AuthToken
        The Meraki API key.

    .PARAMETER NetworkId
        The ID of the Meraki network.

    .PARAMETER GroupPolicyID
        The ID of the group policy to retrieve.

    .EXAMPLE
        Get-MerakiNetworkGroupPolicy -AuthToken "YOUR_API_KEY" -NetworkId "YOUR_NETWORK_ID" -GroupPolicyID "YOUR_GROUP_POLICY_ID"

        Retrieves the specified group policy for the specified network.

    .NOTES
        Requires the Invoke-RestMethod cmdlet.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$NetworkId,
        [Parameter(Mandatory=$true)]
        [string]$GroupPolicyID
    )

    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/groupPolicies/$GroupPolicyID" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
