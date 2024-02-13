function New-MerakiNetworkAuthUser {
    <#
    .SYNOPSIS
    Creates a new Meraki authentication user for a specified network using the Meraki Dashboard API.

    .DESCRIPTION
    The New-MerakiNetworkAuthUser function allows you to create a new Meraki authentication user for a specified network by providing the authentication token, network ID, and a JSON string containing the user configuration.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network in which the user is to be created.

    .PARAMETER UserConfig
    A JSON string containing the user configuration. The JSON string should conform to the schema definition provided by the Meraki Dashboard API.

    .EXAMPLE
    $UserConfig = [PSCustomObject]@{
        email = "user@example.com"
        name = "John Doe"
        password = "password123"
        isAdmin = $false
        authorizations = @(
            [PSCustomObject]@{
                ssidNumber = 1
                expiresAt = "2022-12-31T23:59:59Z"
            }
        )
    }

    $UserConfig = $UserConfig | ConvertTo-JSON -Compress

    New-MerakiNetworkAuthUser -AuthToken "your-api-token" -NetworkId "L_1234567890" -UserConfig $UserConfig

    This example creates a new Meraki authentication user for the network with ID "L_1234567890" with the specified email, name, password, and authorization details.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the user creation is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$UserConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $UserConfig

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/merakiAuthUsers"

        $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}