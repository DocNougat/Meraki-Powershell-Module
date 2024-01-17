function Set-MerakiNetworkSwitchDHCPServerPolicy {
    <#
    .SYNOPSIS
    Updates the DHCP server policy for a network switch.
    
    .DESCRIPTION
    The Set-MerakiNetworkSwitchDHCPServerPolicy function allows you to update the DHCP server policy for a specified network switch by providing the authentication token, network ID, and a JSON formatted string of DHCP server policy.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network in which the network switch is located.
    
    .PARAMETER DHCPServerPolicy
    A JSON formatted string of DHCP server policy.
    
    .EXAMPLE
    $DHCPServerPolicy = [PSCustomObject]@{
        alerts = @{
            email = @{
                enabled = $true
            }
        }
        defaultPolicy = "block"
        blockedServers = @(
            "00:50:56:00:00:03",
            "00:50:56:00:00:04"
        )
        allowedServers = @(
            "00:50:56:00:00:01",
            "00:50:56:00:00:02"
        )
        arpInspection = @{
            enabled = $true
        }
    }

    $DHCPServerPolicy = $DHCPServerPolicy | ConvertTo-Json
    Set-MerakiNetworkSwitchDHCPServerPolicy -AuthToken "your-api-token" -NetworkId "1234" -DHCPServerPolicy $DHCPServerPolicy

    This example updates the DHCP server policy for the network switch in the Meraki network with ID "1234" with the specified DHCP server policy.
    
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
            [string]$DHCPServerPolicy
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/dhcpServerPolicy"
    
            $body = $DHCPServerPolicy
    
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
            Write-Host $_
        }
    }