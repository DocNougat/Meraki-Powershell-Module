function Invoke-MerakiNetworkBindNetwork {
    <#
    .SYNOPSIS
    Binds a Meraki network to a configuration template using the Meraki Dashboard API.

    .DESCRIPTION
    The Invoke-MerakiNetworkBindNetwork function allows you to bind a Meraki network to a configuration template by providing the authentication token, network ID, and a JSON string containing the bind configuration.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network to be bound to a configuration template.

    .PARAMETER BindConfig
    A JSON string containing the bind configuration. The JSON string should conform to the schema definition provided by the Meraki Dashboard API.

    .EXAMPLE
    $BindConfig = [PSCustomObject]@{
        configTemplateId = "N_123456789012345678"
        autoBind = $true
    }

    $BindConfig = $BindConfig | ConvertTo-Json -Compress

    Invoke-MerakiNetworkBindNetwork -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -BindConfig $BindConfig

    This example binds the Meraki network with ID "L_123456789012345678" to the configuration template with ID "N_123456789012345678" and enables auto-bind for switch networks and switch templates.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the binding is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$BindConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $BindConfig

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/bind"

        $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Host $_
        Throw $_
    }
}