function Remove-MerakiNetworkSwitchLinkAggregation {
    <#
    .SYNOPSIS
    Deletes a link aggregation for a network switch.
    
    .DESCRIPTION
    The Remove-MerakiNetworkSwitchLinkAggregation function allows you to delete a link aggregation for a specified network switch by providing the authentication token, network ID, and link aggregation ID.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network in which the network switch is located.
    
    .PARAMETER LinkAggregationId
    The ID of the link aggregation to be deleted.
    
    .EXAMPLE
    Remove-MerakiNetworkSwitchLinkAggregation -AuthToken "your-api-token" -NetworkId "1234" -LinkAggregationId "NDU2N18yXzM="
    
    This example deletes the link aggregation for the network switch in the Meraki network with ID "1234".
    
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
            [string]$LinkAggregationId
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/linkAggregations/$LinkAggregationId"
    
            $response = Invoke-RestMethod -Method Delete -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
            return $response
        }
        catch {
        Write-Host $_
        Throw $_
    }
    }