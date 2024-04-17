function Set-MerakiDeviceManagementInterface {
    <#
    .SYNOPSIS
    Updates the management interface settings for a Meraki device using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiDeviceManagementInterface function allows you to update the management interface settings for a specified Meraki device by providing the authentication token, device serial number, and a JSON string containing the management interface configuration.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER SerialNumber
    The serial number of the Meraki device in which the management interface settings are to be updated.

    .PARAMETER InterfaceConfig
    A JSON string containing the management interface configuration. The JSON string should conform to the schema definition provided by the Meraki Dashboard API.

    .EXAMPLE
    $InterfaceConfig = [PSCustomObject]@{
        wan1 = [PSCustomObject]@{
            usingStaticIp = $true
            staticIp = "192.168.1.100"
            staticSubnetMask = "255.255.255.0"
            staticGatewayIp = "192.168.1.1"
            vlan = 1
            staticDns = @("8.8.8.8", "8.8.4.4")
            wanEnabled = "enabled"
        }
        wan2 = [PSCustomObject]@{
            usingStaticIp = $true
            staticIp = "192.168.2.100"
            staticSubnetMask = "255.255.255.0"
            staticGatewayIp = "192.168.2.1"
            vlan = 2
            staticDns = @("8.8.8.8", "8.8.4.4")
            wanEnabled = "enabled"
        }
    }

    $InterfaceConfig = $InterfaceConfig | ConvertTo-Json -Compress

    Set-MerakiDeviceManagementInterface -AuthToken "your-api-token" -SerialNumber "Q2XX-XXXX-XXXX" -InterfaceConfig $InterfaceConfig

    This example updates the management interface settings for the Meraki device with serial number "Q2XX-XXXX-XXXX" by configuring the WAN 1 and WAN 2 interfaces with static IP settings.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the management interface settings update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$SerialNumber,
        [parameter(Mandatory=$true)]
        [string]$InterfaceConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $InterfaceConfig

        $url = "https://api.meraki.com/api/v1/devices/$SerialNumber/managementInterface"

        $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}