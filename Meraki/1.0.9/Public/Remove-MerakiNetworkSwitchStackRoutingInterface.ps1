function Remove-MerakiNetworkSwitchStackRoutingInterface {
    <#
    .SYNOPSIS
    Deletes a network switch stack routing interface.
    
    .DESCRIPTION
    The Remove-MerakiNetworkSwitchStackRoutingInterface function allows you to delete a network switch stack routing interface by providing the authentication token, network ID, switch stack ID, and interface ID.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
    .PARAMETER SwitchStackId
    The ID of the switch stack.
    
    .PARAMETER InterfaceId
    The ID of the interface.
    
    .EXAMPLE
    Remove-MerakiNetworkSwitchStackRoutingInterface -AuthToken "your-api-token" -NetworkId "1234" -SwitchStackId "5678" -InterfaceId "91011"
    
    This example deletes a network switch stack routing interface.
    
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
            [string]$SwitchStackId,
            [parameter(Mandatory=$true)]
            [string]$InterfaceId
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/stacks/$SwitchStackId/routing/interfaces/$InterfaceId"
    
            $response = Invoke-RestMethod -Method Delete -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }