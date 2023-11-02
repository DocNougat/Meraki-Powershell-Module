function Remove-MerakiNetworkSwitchQOSRule {
    <#
    .SYNOPSIS
    Deletes a network switch QoS rule.
    
    .DESCRIPTION
    The Remove-MerakiNetworkSwitchQOSRule function allows you to delete a network switch QoS rule by providing the authentication token, network ID, and QoS rule ID.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
    .PARAMETER QosRuleId
    The ID of the QoS rule to be deleted.
    
    .EXAMPLE
    Remove-MerakiNetworkSwitchQOSRule -AuthToken "your-api-token" -NetworkId "N_1234" -QosRuleId "QOS_1234"
    
    This example deletes a network switch QoS rule.
    
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
            [string]$QosRuleId
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/qosRules/$QosRuleId"
    
            $response = Invoke-RestMethod -Method Delete -Uri $url -Header $header
            return $response
        }
        catch {
            Write-Host $_
        }
    }