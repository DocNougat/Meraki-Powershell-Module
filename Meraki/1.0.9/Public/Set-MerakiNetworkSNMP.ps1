function Set-MerakiNetworkSNMP {
    <#
    .SYNOPSIS
    Updates the SNMP settings of an existing Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkSnmp function allows you to update the SNMP settings of an existing Meraki network by providing the authentication token, network ID, and a JSON configuration for the SNMP settings.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to update the SNMP settings.

    .PARAMETER SNMPConfig
    The JSON configuration for the SNMP settings to be updated. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $SNMPConfig = [PSCustomObject]@{
        access = "users"
        users = @(
            [PSCustomObject]@{
                username = "AzureDiamond"
                passphrase = "hunter2"
            }
        )
    }
    $SNMPConfig = $SNMPConfig | ConvertTo-JSON -Compress

    Set-MerakiNetworkSnmp -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -SNMPConfig $SNMPConfig

    This example updates the SNMP settings of the Meraki network with ID "L_123456789012345678" to enable SNMP access for users and add a user with username "AzureDiamond" and passphrase "hunter2".

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
        [string]$SNMPConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }
        
        $body = $SNMPConfig

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/snmp"
        
        $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}