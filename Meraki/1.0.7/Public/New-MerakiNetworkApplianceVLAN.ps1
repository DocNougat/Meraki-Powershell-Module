function New-MerakiNetworkApplianceVLAN {
    <#
    .SYNOPSIS
    Creates a new VLAN for a Meraki network appliance.

    .DESCRIPTION
    The New-MerakiNetworkApplianceVLAN function allows you to create a new VLAN for a Meraki network appliance by providing the authentication token, network ID, and a VLAN configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the network for which you want to create a new VLAN.

    .PARAMETER VLANConfig
    A string containing the VLAN configuration. The string should be in JSON format and should include the properties as defined in the schema.

    .EXAMPLE
    $vlanConfig = [PSCustomObject]@{
        id = "1234"
        name = "My VLAN"
        subnet = "192.168.1.0/24"
        applianceIp = "192.168.1.2"
        groupPolicyId = "101"
        templateVlanType = "same"
        cidr = "192.168.1.0/24"
        mask = 28
        ipv6 = @{
            enabled = $true
            prefixAssignments = @(
                @{
                    autonomous = $false
                    staticPrefix = "2001:db8:3c4d:15::/64"
                    staticApplianceIp6 = "2001:db8:3c4d:15::1"
                    origin = @{
                        type = "internet"
                        interfaces = @("wan0")
                    }
                }
            )
        }
        mandatoryDhcp = @{
            enabled = $true
        }
    }

    $vlanConfigJson = $vlanConfig | ConvertTo-Json -Compress
    New-MerakiNetworkApplianceVLAN -AuthToken "your-api-token" -NetworkId "your-network-id" -VLANConfig $vlanConfigJson

    This example creates a new VLAN for the network with ID "your-network-id", using the specified VLAN configuration.

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
        [string]$VLANConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $VLANConfig

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/vlans"
        $response = Invoke-RestMethod -Method Post -Uri $uri -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}