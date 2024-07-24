function Set-MerakiNetworkSyslogServers {
    <#
    .SYNOPSIS
    Updates the syslog server settings of an existing Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkSyslogServers function allows you to update the syslog server settings of an existing Meraki network by providing the authentication token, network ID, and a JSON configuration for the syslog server settings.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to update the syslog server settings.

    .PARAMETER SyslogServerConfig
    The JSON configuration for the syslog server settings to be updated. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $SyslogServerConfig = [PSCustomObject]@{
        servers = @(
            [PSCustomObject]@{
                host = "1.2.3.4"
                port = 443
                roles = @(
                    "Wireless event log",
                    "URLs"
                )
            }
        )
    }

    $SyslogServerConfig = $SyslogServerConfig | ConvertTo-Json -Compress

    Set-MerakiNetworkSyslogServers -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -SyslogServerConfig $SyslogServerConfig

    This example updates the syslog server settings of the Meraki network with ID "L_123456789012345678" to add a syslog server with IP address "1.2.3.4", port 443, and roles "Wireless event log" and "URLs".

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
        [string]$SyslogServerConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }
        
        $body = $SyslogServerConfig

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/syslogServers"
        
        $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}