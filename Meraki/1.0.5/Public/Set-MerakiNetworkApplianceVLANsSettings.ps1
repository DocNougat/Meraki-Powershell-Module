function Set-MerakiNetworkApplianceVLANsSettings {
    <#
    .SYNOPSIS
    Updates the VLAN settings for a Meraki network.
    
    .DESCRIPTION
    This function updates the VLAN settings for a Meraki network using the Meraki Dashboard API. The function takes a boolean value as input and sends it to the API endpoint to update the VLAN settings.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to update the VLAN settings.
    
    .PARAMETER VlansEnabled
    Boolean indicating whether to enable (true) or disable (false) VLANs for the network.
    
    .EXAMPLE
    Set-MerakiNetworkApplianceVLANsSettings -AuthToken "your-api-token" -NetworkId "L_9817349871234" -VlansEnabled $true
    
    This example enables VLANs for the specified network.
    
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
            [bool]$VlansEnabled
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $body = @{
                "vlansEnabled" = $VlansEnabled
            } | ConvertTo-Json
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/vlans/settings"
    
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Host $_
        Throw $_
    }
    }