function Remove-MerakiNetworkApplianceVLAN {
    <#
    .SYNOPSIS
    Deletes an existing VLAN from a Meraki network.
    
    .DESCRIPTION
    This function deletes an existing VLAN from a Meraki network using the Meraki Dashboard API.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network from which you want to delete a VLAN.
    
    .PARAMETER VLANId
    The ID of the VLAN to be deleted.
    
    .EXAMPLE
    Remove-MerakiNetworkApplianceVLAN -AuthToken "your-api-token" -NetworkId "L_9817349871234" -VLANId "1234"
    
    This example deletes an existing VLAN from the specified network.
    
    .NOTES
    For more information about the Meraki Dashboard API, see https://developer.cisco.com/meraki/api-v1/.
    #>
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$NetworkId,
            [parameter(Mandatory=$true)]
            [string]$VLANId
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/vlans/$VLANId"
    
            $response = Invoke-RestMethod -Method Delete -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
            return $response
        }
        catch {
        Write-Host $_
        Throw $_
    }
    }