function Remove-MerakiNetworkSwitchDHCPServerPolicyArpInspTrustedServer {
    <#
    .SYNOPSIS
    Deletes a DHCP server policy ARP inspection trusted server for a network switch.
    
    .DESCRIPTION
    The Remove-MerakiNetworkSwitchDHCPServerPolicyArpInspTrustedServer function allows you to delete a DHCP server policy ARP inspection trusted server for a specified network switch by providing the authentication token, network ID, and trusted server ID.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network in which the network switch is located.
    
    .PARAMETER TrustedServerId
    The ID of the trusted server to be deleted.
    
    .EXAMPLE
    Remove-MerakiNetworkSwitchDHCPServerPolicyArpInspTrustedServer -AuthToken "your-api-token" -NetworkId "1234" -TrustedServerId "5678"
    
    This example deletes the DHCP server policy ARP inspection trusted server with ID "5678" for the network switch in the Meraki network with ID "1234".
    
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
            [string]$TrustedServerId
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/dhcpServerPolicy/arpInspection/trustedServers/$TrustedServerId"
    
            $response = Invoke-RestMethod -Method Delete -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
            return $response
        }
        catch {
        Write-Host $_
        Throw $_
    }
    }