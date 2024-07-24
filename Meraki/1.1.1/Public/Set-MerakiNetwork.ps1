function Set-MerakiNetwork {
    <#
    .SYNOPSIS
    Updates an existing Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetwork function allows you to update an existing Meraki network by providing the authentication token, network ID, and a JSON configuration for the network.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network to be updated.

    .PARAMETER NetworkConfig
    The JSON configuration for the network to be updated. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $NetworkConfig = [PSCustomObject]@{
        name = "Main Office"
        timeZone = "America/Los_Angeles"
        tags = @("tag1", "tag2")
        enrollmentString = "my-enrollment-string"
        notes = "Additional description of the network"
    }

    $NetworkConfig = $NetworkConfig | ConvertTo-JSON -compress

    Set-MerakiNetwork -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -NetworkConfig $NetworkConfig

    This example updates the Meraki network with ID "L_123456789012345678" with a new name, timezone, tags, enrollment string, and notes.

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
        [string]$NetworkConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }
        
        $body = $NetworkConfig

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId"
        
        $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}