function Set-MerakiNetworkApplianceVLAN {
    <#
    .SYNOPSIS
    Updates an existing VLAN for a Meraki network.
    
    .DESCRIPTION
    This function updates an existing VLAN for a Meraki network using the Meraki Dashboard API. The function takes a JSON-formatted string as input and sends it to the API endpoint to update the VLAN.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to update a VLAN.
    
    .PARAMETER VLANId
    The ID of the VLAN to be updated.
    
    .PARAMETER VLANConfig
    The JSON-formatted string representing the configuration of the VLAN to be updated.
    
    .EXAMPLE
    $config = [PSCustomObject]@{
        name = "My VLAN"
        applianceIp = "192.168.1.2"
        subnet = "192.168.1.0/24"
        groupPolicyId = "101"
        templateVlanType = "same"
        cidr = "192.168.1.0/24"
        mask = 28
        fixedIpAssignments = @{
            "22:33:44:55:66:77" = @{
                ip = "1.2.3.4"
                name = "Some client name"
            }
        }
        reservedIpRanges = @(
            @{
                start = "192.168.1.0"
                end = "192.168.1.1"
                comment = "A reserved IP range"
            }
        )
        dnsNameservers = "google_dns"
        dhcpHandling = "Run a DHCP server"
        dhcpLeaseTime = "1 day"
        dhcpBootOptionsEnabled = $false
        dhcpBootNextServer = "1.2.3.4"
        dhcpBootFilename = "sample.file"
        dhcpOptions = @(
            @{
                code = "5"
                type = "text"
                value = "five"
            }
        )
        ipv6 = @{
            enabled = $true
            prefixAssignments = @(
                @{
                    autonomous = $false
                    staticPrefix = "2001:db8:3c4d:15::/64"
                    staticApplianceIp6 = "2001:db8:3c4d:15::1"
                    origin = @{
                        type = "internet"
                        interfaces = [ "wan0" ]
                    }
                }
            )
        }
        mandatoryDHCP = @{ enabled = $true }
        adaptivePolicyGroupId = "1234"
        dhcpRelayServerIps = @(
            "192.168.1.0/24",
            "192.168.128.0/24"
        )
        vpnNatSubnet = "192.168.1.0/24"
    }

    $config = $config | ConvertTo-Json
    Set-MerakiNetworkApplianceVLAN -AuthToken "your-api-token" -NetworkId "L_9817349871234" -VLANId "1234" -VLANConfig $config

    This example updates an existing VLAN with the specified configuration.
    
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
            [string]$VLANId,
            [Parameter(Mandatory = $true)]
            [string]$VLANConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $body = $VLANConfig
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/vlans/$VLANId"
    
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
            Write-Host $_
        }
    }