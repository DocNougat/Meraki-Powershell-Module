function Set-MerakiNetworkAuthUser {
    <#
    .SYNOPSIS
    Updates an existing Meraki authentication user for a specified network using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkAuthUser function allows you to update an existing Meraki authentication user for a specified network by providing the authentication token, network ID, user ID, and a JSON string containing the user configuration.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network in which the user is to be updated.

    .PARAMETER MerakiAuthUserId
    The ID of the Meraki authentication user to be updated.

    .PARAMETER UserConfig
    A JSON string containing the user configuration. The JSON string should conform to the schema definition provided by the Meraki Dashboard API.

    .EXAMPLE
    $UserConfig = [PSCustomObject]@{
        name = "Jane Doe"
        password = "newpassword123"
        authorizations = @(
            [PSCustomObject]@{
                ssidNumber = 2
                expiresAt = "2023-12-31T23:59:59Z"
            }
        )
    }

    $UserConfig = $UserConfig | ConvertTo-Json -Compress -Depth 4

    Set-MerakiNetworkAuthUser -AuthToken "your-api-token" -NetworkId "L_1234567890" -MerakiAuthUserId "1234" -UserConfig $UserConfig

    This example updates the Meraki authentication user with ID "1234" for the network with ID "L_1234567890" with the specified name, password, and authorization details.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the user update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$MerakiAuthUserId,
        [parameter(Mandatory=$true)]
        [string]$UserConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $UserConfig

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/merakiAuthUsers/$MerakiAuthUserId"

        $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}