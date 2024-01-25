function Set-MerakiNetworkSwitchStackRoutingInterfaceDHCP {
    <#
    .SYNOPSIS
    Updates a network switch stack routing interface DHCP.
    
    .DESCRIPTION
    The Set-MerakiNetworkSwitchStackRoutingInterfaceDHCP function allows you to update a network switch stack routing interface DHCP by providing the authentication token, network ID, switch stack ID, interface ID, and a JSON formatted string of the DHCP configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
    .PARAMETER SwitchStackId
    The ID of the switch stack.
    
    .PARAMETER InterfaceId
    The ID of the interface.
    
    .PARAMETER DHCPConfig
    A JSON formatted string of the DHCP configuration.
    
    .EXAMPLE
    $DHCPConfig = [PSCustomObject]@{
        dhcpMode = "dhcpServer"
        dhcpLeaseTime = "1 day"
        dnsNameserversOption = "custom"
        dnsCustomNameservers = @("8.8.8.8", "8.8.4.4")
        bootOptionsEnabled = $true
        bootNextServer = "1.2.3.4"
        bootFileName = "home_boot_file"
        dhcpOptions = @(
            [PSCustomObject]@{
                code = "5"
                type = "text"
                value = "five"
            }
        )
        reservedIpRanges = @(
            [PSCustomObject]@{
                start = "192.168.1.1"
                end = "192.168.1.10"
                comment = "A reserved IP range"
            }
        )
        fixedIpAssignments = @(
            [PSCustomObject]@{
                mac = "22:33:44:55:66:77"
                name = "Cisco Meraki valued client"
                ip = "192.168.1.12"
            }
        )
    }

    $DHCPConfig = $DHCPConfig | ConvertTo-Json
    Set-MerakiNetworkSwitchStackRoutingInterfaceDHCP -AuthToken "your-api-token" -NetworkId "1234" -SwitchStackId "5678" -InterfaceId "91011" -DHCPConfig $DHCPConfig

    This example updates a network switch stack routing interface DHCP with the specified configuration.
    
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
            [string]$SwitchStackId,
            [parameter(Mandatory=$true)]
            [string]$InterfaceId,
            [parameter(Mandatory=$true)]
            [string]$DHCPConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/stacks/$SwitchStackId/routing/interfaces/$InterfaceId/dhcp"
    
            $body = $DHCPConfig
    
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
            Write-Host $_
        }
    }