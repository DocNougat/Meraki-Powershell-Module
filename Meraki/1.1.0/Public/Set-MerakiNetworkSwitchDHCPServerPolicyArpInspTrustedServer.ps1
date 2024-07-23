function Set-MerakiNetworkSwitchDHCPServerPolicyArpInspTrustedServer {
    <#
    .SYNOPSIS
    Updates a DHCP server policy ARP inspection trusted server for a network switch.
    
    .DESCRIPTION
    The Set-MerakiNetworkSwitchDHCPServerPolicyArpInspTrustedServer function allows you to update a DHCP server policy ARP inspection trusted server for a specified network switch by providing the authentication token, network ID, trusted server ID, and a JSON formatted string of policy configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network in which the network switch is located.
    
    .PARAMETER TrustedServerId
    The ID of the trusted server to be updated.
    
    .PARAMETER PolicyConfig
    A JSON formatted string of policy configuration.
    
    .EXAMPLE
    $PolicyConfig = [PSCustomObject]@{
        mac = "00:11:22:33:44:55"
        vlan = 100
        ipv4 = @{
            address = "1.2.3.4"
        }
    }

    $PolicyConfig = $PolicyConfig | ConvertTo-Json -Compress
    Set-MerakiNetworkSwitchDHCPServerPolicyArpInspTrustedServer -AuthToken "your-api-token" -NetworkId "1234" -TrustedServerId "5678" -PolicyConfig $PolicyConfig

    This example updates the DHCP server policy ARP inspection trusted server with ID "5678" for the network switch in the Meraki network with ID "1234" with the specified policy configuration.
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the update is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$NetworkId,
            [parameter(Mandatory=$true)]
            [string]$TrustedServerId,
            [parameter(Mandatory=$true)]
            [string]$PolicyConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/dhcpServerPolicy/arpInspection/trustedServers/$TrustedServerId"
    
            $body = $PolicyConfig
    
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }