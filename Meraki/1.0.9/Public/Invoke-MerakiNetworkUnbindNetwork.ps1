function Invoke-MerakiNetworkUnbindNetwork {
    <#
    .SYNOPSIS
    Unbinds a Meraki network from its configuration template using the Meraki Dashboard API.

    .DESCRIPTION
    The Invoke-MerakiNetworkUnbindNetwork function allows you to unbind a Meraki network from its configuration template by providing the authentication token, network ID, and a boolean value indicating whether to retain the network's configuration settings.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network to be unbound from its configuration template.

    .PARAMETER RetainConfigs
    A boolean value indicating whether to retain the network's configuration settings. If set to true, the network's configuration settings will be retained. If set to false, the network's configuration settings will be deleted.

    .EXAMPLE
    Invoke-MerakiNetworkUnbindNetwork -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -RetainConfigs $true

    This example unbinds the Meraki network with ID "L_123456789012345678" from its configuration template and retains the network's configuration settings.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the unbinding is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$false)]
        [bool]$RetainConfigs
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }
        If($RetainConfigs){
            $body = @{
                "retainConfigs" = $RetainConfigs
            } | ConvertTo-JSON -compress
        }
        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/unbind"

        If($body){
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat" -Body $body
        return $response
        } else {
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
        }
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}