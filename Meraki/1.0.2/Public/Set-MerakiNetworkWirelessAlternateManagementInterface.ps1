function Set-MerakiNetworkWirelessAlternateManagementInterface {
    <#
    .SYNOPSIS
    Updates a network wireless alternate management interface.
    
    .DESCRIPTION
    The Set-MerakiNetworkWirelessAlternateManagementInterface function allows you to update a network wireless alternate management interface by providing the authentication token, network ID, and a JSON formatted string of the management interface configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
    .PARAMETER ManagementInterfaceConfig
    A JSON formatted string of the management interface configuration.
    
    .EXAMPLE
    $ManagementInterfaceConfig = '{
        "enabled": true,
        "vlanId": 100,
        "protocols": [
            "radius",
            "snmp",
            "syslog",
            "ldap"
        ],
        "accessPoints": [
            {
                "serial": "Q234-ABCD-5678",
                "alternateManagementIp": "1.2.3.4",
                "subnetMask": "255.255.255.0",
                "gateway": "1.2.3.5",
                "dns1": "8.8.8.8",
                "dns2": "8.8.4.4"
            }
        ]
    }'
    $ManagementInterfaceConfig = $ManagementInterfaceConfig | ConvertTo-Json -Compress
    Set-MerakiNetworkWirelessAlternateManagementInterface -AuthToken "your-api-token" -NetworkId "1234" -ManagementInterfaceConfig $ManagementInterfaceConfig
    
    This example updates a network wireless alternate management interface with the specified configuration.
    
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
            [string]$ManagementInterfaceConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/wireless/alternateManagementInterface"
    
            $body = $ManagementInterfaceConfig
    
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
            Write-Host $_
        }
    }