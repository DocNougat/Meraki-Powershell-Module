function Set-MerakiNetworkCellularGatewayDHCP {
    <#
    .SYNOPSIS
    Updates the DHCP settings for a Meraki network's cellular gateway.
    
    .DESCRIPTION
    The Set-MerakiNetworkCellularGatewayDHCP function allows you to update the DHCP settings for a specified Meraki network's cellular gateway by providing the authentication token, network ID, and a DHCP configuration string.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to update the DHCP settings.
    
    .PARAMETER DHCPConfig
    A string containing the DHCP configuration. The string should be in JSON format and should include the properties as defined in the schema.
    
    .EXAMPLE
    $DHCPConfig = [PSCustomObject]@{
        dhcpLeaseTime = "1 hour"
        dnsNameservers = "custom"
        dnsCustomNameservers = @(
            "172.16.2.111",
            "172.16.2.30"
        )
    }

    $DHCPConfig = $DHCPConfig | ConvertTo-Json -Compress

    Set-MerakiNetworkCellularGatewayDHCP -AuthToken "your-api-token" -NetworkId "N_1234" -DHCPConfig $DHCPConfig

    This example updates the DHCP settings for the Meraki network with ID "N_1234".
    
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
            [string]$DHCPConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/cellularGateway/dhcp"
    
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $DHCPConfig
            return $response
        }
        catch {
            Write-Host $_
        }
    }