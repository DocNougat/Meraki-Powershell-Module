function New-MerakiNetworkPiiRequest {
    <#
    .SYNOPSIS
    Creates a new Meraki network PII request using the Meraki Dashboard API.

    .DESCRIPTION
    The New-MerakiNetworkPiiRequest function allows you to create a new Meraki network PII request by providing the authentication token, network ID, and a JSON configuration for the request.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to create a new PII request.

    .PARAMETER PIIRequest
    The JSON configuration for the PII request to be created. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $PIIRequest = [PSCustomObject]@{
        type = "delete"
        datasets = @("usage", "events")
        mac = "00:77:00:77:00:77"
    }
    $PIIRequest = ConvertTo-Json -Compress

    New-MerakiNetworkPiiRequest -AuthToken "your-api-token" -NetworkId "L_1234567890" -PIIRequest $PIIRequest
    This example creates a new Meraki network PII request for the network with ID "L_1234567890" to delete the datasets "usage" and "events" related to the MAC address "00:77:00:77:00:77".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the creation is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$PIIRequest
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }
        
        $body = $PIIRequest

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/pii/requests"
        
        $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}