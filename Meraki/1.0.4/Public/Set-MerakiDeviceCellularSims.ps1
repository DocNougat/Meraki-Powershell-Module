function Set-MerakiDeviceCellularSims {
    <#
    .SYNOPSIS
    Updates the SIMs for a Meraki device using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiDeviceCellularSims function allows you to update the SIMs for a specified Meraki device by providing the authentication token, device serial number, and a SIM configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER SerialNumber
    The serial number of the Meraki device for which you want to update the SIMs.

    .PARAMETER SimConfig
    A string containing the SIM configuration. The string should be in JSON format and should include the "simFailover" and "sims" properties, as well as the configuration for each SIM.

    .EXAMPLE
    $config = [PSCustomObject]@{
        simFailover = @{
            enabled = $true
        }
        sims = @(
            @{
                slot = "sim1"
                isPrimary = $true
                apns = @(
                    @{
                        name = "APN1"
                        allowedIpTypes = @("ipv4")
                        authentication = @{
                            type = "none"
                        }
                    }
                )
            },
            @{
                slot = "sim2"
                isPrimary = $false
                apns = @(
                    @{
                        name = "APN2"
                        allowedIpTypes = @("ipv4", "ipv6")
                        authentication = @{
                            type = "chap"
                            username = "user"
                            password = "pass"
                        }
                    }
                )
            }
        )
    }

    $configJson = $config | ConvertTo-Json -Compress
    Set-MerakiDeviceCellularSims -AuthToken "your-api-token" -SerialNumber "Q2XX-XXXX-XXXX" -SimConfig $configJson
    This example updates the SIMs for the Meraki device with serial number "Q2XX-XXXX-XXXX". The first SIM in the list will be used for boot, and the second SIM will be used for failover. The first SIM has one APN configuration with name "APN1" and allowed IP type "ipv4". The second SIM has one APN configuration with name "APN2", allowed IP types "ipv4" and "ipv6", and authentication type "chap" with username "user" and password "pass".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the configuration is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$SerialNumber,
        [parameter(Mandatory=$true)]
        [string]$SimConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $SimConfig

        $url = "https://api.meraki.com/api/v1/devices/$SerialNumber/cellular/sims"

        $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Host $_
    }
}