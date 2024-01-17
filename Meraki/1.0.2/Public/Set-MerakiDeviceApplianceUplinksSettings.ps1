function Set-MerakiDeviceApplianceUplinksSettings {
    <#
    .SYNOPSIS
    Updates the Uplinks Settings for a Meraki device using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiDeviceApplianceUplinksSettings function allows you to update the Uplinks Settings for a specified Meraki device by providing the authentication token, device serial number, and an Uplinks configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER DeviceSerial
    The serial number of the Meraki device for which you want to update the Uplinks Settings.

    .PARAMETER UplinksConfig
    A string containing the Uplinks configuration. The string should be in JSON format and should include the "interfaces" property, as well as the configuration for each interface.

    .EXAMPLE
    $config = [PSCustomObject]@{
        interfaces = @{
            wan1 = @{
                enabled = $true
                vlanTagging = @{
                    enabled = $true
                    vlanId = 1
                }
                svis = @{
                    ipv4 = @{
                        assignmentMode = "static"
                        address = "9.10.11.10/16"
                        gateway = "13.14.15.16"
                        nameservers = @{
                            addresses = @("1.2.3.4")
                        }
                    }
                    ipv6 = @{
                        assignmentMode = "static"
                        address = "1:2:3::4"
                        gateway = "1:2:3::5"
                        nameservers = @{
                            addresses = @("1001:4860:4860::8888", "1001:4860:4860::8844")
                        }
                    }
                }
                pppoe = @{
                    enabled = $true
                    authentication = @{
                        enabled = $true
                        username = "username"
                        password = "password"
                    }
                }
            }
            wan2 = @{
                enabled = $true
                vlanTagging = @{
                    enabled = $true
                    vlanId = 1
                }
                svis = @{
                    ipv4 = @{
                        assignmentMode = "static"
                        address = "9.10.11.10/16"
                        gateway = "13.14.15.16"
                        nameservers = @{
                            addresses = @("1.2.3.4")
                        }
                    }
                    ipv6 = @{
                        assignmentMode = "static"
                        address = "1:2:3::4"
                        gateway = "1:2:3::5"
                        nameservers = @{
                            addresses = @("1001:4860:4860::8888", "1001:4860:4860::8844")
                        }
                    }
                }
                pppoe = @{
                    enabled = $true
                    authentication = @{
                        enabled = $true
                        username = "username"
                        password = "password"
                    }
                }
            }
        }
    }

    $config = $config | ConvertTo-Json -Compress
    Set-MerakiDeviceApplianceUplinksSettings -AuthToken "your-api-token" -DeviceSerial "Q2XX-XXXX-XXXX" -UplinksConfig $config

    This example updates the Uplinks Settings for the Meraki device with serial number "Q2XX-XXXX-XXXX". 

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the configuration is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$DeviceSerial,
        [parameter(Mandatory=$true)]
        [string]$UplinksConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $UplinksConfig

        $url = "https://api.meraki.com/api/v1/devices/$DeviceSerial/appliance/uplinks/settings"

        $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Host $_
    }
}