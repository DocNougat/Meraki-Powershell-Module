function Remove-MerakiNetworkSwitchAccessPolicy {
    <#
    .SYNOPSIS
    Deletes an access policy for a network switch.
    
    .DESCRIPTION
    The Remove-MerakiNetworkSwitchAccessPolicy function allows you to delete an access policy for a specified network switch by providing the authentication token, network ID, and access policy number.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network in which the network switch is located.
    
    .PARAMETER AccessPolicyNumber
    The number of the access policy to be deleted.
    
    .EXAMPLE
    Remove-MerakiNetworkSwitchAccessPolicy -AuthToken "your-api-token" -NetworkId "1234" -AccessPolicyNumber "1"
    
    This example deletes the access policy for the network switch in the Meraki network with ID "1234".
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the deletion is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$NetworkId,
            [parameter(Mandatory=$true)]
            [string]$AccessPolicyNumber
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/accessPolicies/$AccessPolicyNumber"
    
            $response = Invoke-RestMethod -Method Delete -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }