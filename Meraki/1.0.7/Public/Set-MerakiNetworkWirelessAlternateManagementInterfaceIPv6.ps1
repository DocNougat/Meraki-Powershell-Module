function Set-MerakiNetworkWirelessAlternateManagementInterfaceIPv6 {
    <#
    .SYNOPSIS
    Updates a network wireless alternate management interface IPv6 configuration.
    
    .DESCRIPTION
    The Set-MerakiNetworkWirelessAlternateManagementInterfaceIPv6 function allows you to update a network wireless alternate management interface IPv6 configuration by providing the authentication token, network ID, and a JSON formatted string of the management interface IPv6 configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
    .PARAMETER ManagementInterfaceIPv6Config
    A JSON formatted string of the management interface IPv6 configuration.
    
    .EXAMPLE
    $ManagementInterfaceIPv6Config = [PSCustomObject]@{
        addresses = @(
            [PSCustomObject]@{
                protocol = "ipv6"
                assignmentMode = "static"
                address = "2001:db8:3c4d:15::1"
                gateway = "fe80:db8:c15:c0:d0c::10ca:1d02"
                prefix = "2001:db8:3c4d:15::/64"
                nameservers = @{
                    addresses = @(
                        "2001:db8:3c4d:15::1",
                        "2001:db8:3c4d:15::1"
                    )
                }
            }
        )
    }

    $ManagementInterfaceIPv6Config = $ManagementInterfaceIPv6Config | ConvertTo-Json -Compress
    Set-MerakiNetworkWirelessAlternateManagementInterfaceIPv6 -AuthToken "your-api-token" -NetworkId "1234" -ManagementInterfaceIPv6Config $ManagementInterfaceIPv6Config

    This example updates a network wireless alternate management interface IPv6 configuration with the specified configuration.
    
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
            [string]$ManagementInterfaceIPv6Config
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/wireless/alternateManagementInterface/ipv6"
    
            $body = $ManagementInterfaceIPv6Config
    
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }