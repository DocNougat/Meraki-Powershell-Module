function Set-MerakiDeviceWirelessAlternateManagementInterfaceIPv6 {
    <#
    .SYNOPSIS
    Updates the IPv6 configuration of the alternate management interface for a Meraki device.

    .DESCRIPTION
    Set-MerakiDeviceWirelessAlternateManagementInterfaceIPv6 sends a PUT request to the Meraki API to configure IPv6 settings for a device's alternate management interface. Provide a valid API key, the device serial, and the IPv6 configuration payload as a JSON string.

    .PARAMETER AuthToken
    The Cisco Meraki API key used for authorization. This value is sent in the X-Cisco-Meraki-API-Key header.

    .PARAMETER DeviceSerial
    The serial number of the Meraki device to update.

    .PARAMETER ManagementInterfaceIPv6Config
    A JSON-formatted string containing the IPv6 configuration for the alternate management interface. Example payload structure depends on Meraki API schema (e.g. enablement flags, addresses, prefixes, DHCP settings).

    .EXAMPLE
    $cfg = @{
        addresses = @(
            @{
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
    } | ConvertTo-Json -Compress -Depth 10
    Set-MerakiDeviceWirelessAlternateManagementInterfaceIPv6 -AuthToken $env:MERAKI_KEY -DeviceSerial 'Q2XX-XXXX-XXXX' -ManagementInterfaceIPv6Config $cfg

    .NOTES
    - Requires network access to api.meraki.com.
    - Ensure the AuthToken has sufficient permissions to modify device configuration.
    - The ManagementInterfaceIPv6Config must be a valid JSON string matching the Meraki API schema for alternate management interface IPv6 settings.

    #>
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$DeviceSerial,
            [parameter(Mandatory=$true)]
            [string]$ManagementInterfaceIPv6Config
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/devices/$DeviceSerial/wireless/alternateManagementInterface/ipv6"
    
            $body = $ManagementInterfaceIPv6Config
    
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }