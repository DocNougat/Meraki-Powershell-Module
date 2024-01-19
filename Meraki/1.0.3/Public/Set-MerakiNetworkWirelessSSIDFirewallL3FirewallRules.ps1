function Set-MerakiNetworkWirelessSSIDFirewallL3FirewallRules {
    <#
    .SYNOPSIS
    Updates a network wireless SSID Firewall L3 Firewall Rules.
    
    .DESCRIPTION
    The Set-MerakiNetworkWirelessSSIDFirewallL3FirewallRules function allows you to update a network wireless SSID Firewall L3 Firewall Rules by providing the authentication token, network ID, SSID number, and a JSON formatted string of the L3 Firewall Rules.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
    .PARAMETER SSIDNumber
    The number of the SSID.
    
    .PARAMETER L3FirewallRules
    A JSON formatted string of the L3 Firewall Rules.
    
    .EXAMPLE
    $L3FirewallRules = [PSCustomObject]@{
        rules = @(
            [PSCustomObject]@{
                comment = "Allow TCP traffic to subnet with HTTP servers."
                policy = "allow"
                protocol = "tcp"
                destPort = "443"
                destCidr = "192.168.1.0/24"
            }
        )
    }
    $L3FirewallRules = $L3FirewallRules | ConvertTo-Json -Compress
    Set-MerakiNetworkWirelessSSIDFirewallL3FirewallRules -AuthToken "your-api-token" -NetworkId "1234" -Number 0 -L3FirewallRules $L3FirewallRules

    This example updates a network wireless SSID Firewall L3 Firewall Rules with the specified configuration.
    
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
            [int]$SSIDNumber,
            [parameter(Mandatory=$true)]
            [string]$L3FirewallRules
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/wireless/ssids/$SSIDNumber/firewall/l3FirewallRules"
    
            $body = $L3FirewallRules
    
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
            Write-Host $_
        }
    }