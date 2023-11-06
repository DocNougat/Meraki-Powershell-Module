function Invoke-MerakiNetworkApplianceSwapWarmSpare {
    <#
    .SYNOPSIS
    Swaps the network appliance warm spare.
    
    .DESCRIPTION
    The Invoke-MerakiNetworkApplianceSwapWarmSpare function allows you to swap the network appliance warm spare by providing the authentication token and network ID.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network where the appliance warm spare is to be swapped.
    
    .EXAMPLE
    Invoke-MerakiNetworkApplianceSwapWarmSpare -AuthToken "your-api-token" -NetworkId "L_123456789012345678"
    
    This example swaps the network appliance warm spare in the Meraki network with ID "L_123456789012345678".
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the swap is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$NetworkId
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/warmSpare/swap"
    
            $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
            return $response
        }
        catch {
            Write-Host $_
        }
    }