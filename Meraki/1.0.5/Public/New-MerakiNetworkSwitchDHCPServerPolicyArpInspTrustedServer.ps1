function New-MerakiNetworkSwitchDHCPServerPolicyArpInspTrustedServer {
    <#
    .SYNOPSIS
    Creates a new DHCP server policy ARP inspection trusted server for a network switch.
    
    .DESCRIPTION
    The New-MerakiNetworkSwitchDHCPServerPolicyArpInspTrustedServer function allows you to create a new DHCP server policy ARP inspection trusted server for a specified network switch by providing the authentication token, network ID, and a JSON formatted string of policy configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network in which the network switch is located.
    
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
    New-MerakiNetworkSwitchDHCPServerPolicyArpInspTrustedServer -AuthToken "your-api-token" -NetworkId "1234" -PolicyConfig $PolicyConfig

    This example creates a new DHCP server policy ARP inspection trusted server for the network switch in the Meraki network with ID "1234" with the specified policy configuration.
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the creation is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$NetworkId,
            [parameter(Mandatory=$true)]
            [string]$PolicyConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/dhcpServerPolicy/arpInspection/trustedServers"
    
            $body = $PolicyConfig
    
            $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Host $_
        Throw $_
    }
    }