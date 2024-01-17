function Remove-MerakiNetworkGroupPolicy {
    <#
    .SYNOPSIS
    Creates a new group policy for a Meraki network.
    
    .DESCRIPTION
    This function creates a new group policy for a Meraki network using the Meraki Dashboard API. The function takes a JSON-formatted string as input and sends it to the API endpoint to create the new group policy.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to create a floor plan.

    .PARAMETER GroupPolicyID
    A String representing the ID of the group policy to remove.
    
    .EXAMPLE
    Remove-MerakiNetworkGroupPolicy -AuthToken "your-api-token" -NetworkId "L_9817349871234" GroupPolicyID "G_098123409815"
    
    This example Removes a group policy with the specified id.
    
    .NOTES
    For more information about the Meraki Dashboard API, see https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [Parameter(Mandatory = $true)]
        [string]$GroupPolicyID
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/groupPolicies/$GroupPolicyID"
    
            $response = Invoke-RestMethod -Method Delete -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
            return $response
        }
        catch {
            Write-Host $_
        }
    }