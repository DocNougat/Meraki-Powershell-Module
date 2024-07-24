function Set-MerakiNetworkSwitchAlternateManagementInterface {
    <#
    .SYNOPSIS
    Updates the alternate management interface for a network switch.
    
    .DESCRIPTION
    The Set-MerakiNetworkSwitchAlternateManagementInterface function allows you to update the alternate management interface for a specified network switch by providing the authentication token, network ID, and a JSON formatted string of alternate management interface configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network in which the network switch is located.
    
    .PARAMETER AltManagementConfig
    A JSON formatted string of alternate management interface configuration.
    
    .EXAMPLE
    $AltManagementConfig = [PSCustomObject]@{
        enabled = $true
        vlanId = 100
        protocols = @("radius", "snmp", "syslog")
        switches = @(
            [PSCustomObject]@{
                serial = "Q234-ABCD-5678"
                alternateManagementIp = "1.2.3.4"
                subnetMask = "255.255.255.0"
                gateway = "1.2.3.5"
            }
        )
    }

    $AltManagementConfig = $AltManagementConfig | ConvertTo-Json
    Set-MerakiNetworkSwitchAlternateManagementInterface -AuthToken "your-api-token" -NetworkId "1234" -AltManagementConfig $AltManagementConfig

    This example updates the alternate management interface for the network switch in the Meraki network with ID "1234" with the specified alternate management interface configuration.
    
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
            [string]$AltManagementConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/alternateManagementInterface"
    
            $body = $AltManagementConfig
    
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }