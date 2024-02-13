function Invoke-MerakiNetworkSplitNetwork {
    <#
    .SYNOPSIS
    Split a combined network into individual networks for each type of device.

    .DESCRIPTION
    The Invoke-MerakiNetworkSplitNetwork function allows you to split a Meraki network into multiple networks by providing the authentication token, network ID, and a JSON string containing the split configuration.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network to be split into multiple networks.

    .EXAMPLE
    Invoke-MerakiNetworkSplitNetwork -AuthToken "your-api-token" -NetworkId "L_123456789012345678"

    This example splits the Meraki network with ID "L_123456789012345678" into a new network with the name "New Network", the time zone "America/Los_Angeles", and the tags "tag1" and "tag2". The new network is copied from the original network with ID "L_123456789012345678".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the split is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/split"

        $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}