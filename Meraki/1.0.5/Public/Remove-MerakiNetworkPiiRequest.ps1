function Remove-MerakiNetworkPiiRequest {
    <#
    .SYNOPSIS
    Deletes an existing Meraki network PII request using the Meraki Dashboard API.

    .DESCRIPTION
    The Remove-MerakiNetworkPiiRequest function allows you to delete an existing Meraki network PII request by providing the authentication token, network ID, and request ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to delete a PII request.

    .PARAMETER RequestId
    The ID of the PII request you want to delete.

    .EXAMPLE
    Remove-MerakiNetworkPiiRequest -AuthToken "your-api-token" -NetworkId "L_1234567890" -RequestId "1234"

    This example deletes the Meraki network PII request with ID "1234" for the network with ID "L_1234567890".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the deletion is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$RequestId
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/pii/requests/$RequestId"
        
        $response = Invoke-RestMethod -Method Delete -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Host $_
        Throw $_
    }
}