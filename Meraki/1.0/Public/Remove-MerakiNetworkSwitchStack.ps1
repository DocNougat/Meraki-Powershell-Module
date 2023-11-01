function Remove-MerakiNetworkSwitchStack {
    <#
    .SYNOPSIS
    Deletes a network switch stack.
    
    .DESCRIPTION
    The Remove-MerakiNetworkSwitchStack function allows you to delete a network switch stack by providing the authentication token, network ID, and switch stack ID.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
    .PARAMETER SwitchStackId
    The ID of the switch stack.
    
    .EXAMPLE
    Remove-MerakiNetworkSwitchStack -AuthToken "your-api-token" -NetworkId "1234" -SwitchStackId "5678"
    
    This example deletes a network switch stack.
    
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
            [string]$SwitchStackId
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/stacks/$SwitchStackId"
    
            $response = Invoke-RestMethod -Method Delete -Uri $url -Header $header
            return $response
        }
        catch {
            Write-Host $_
        }
    }