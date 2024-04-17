function Remove-MerakiNetworkWebhooksPayloadTemplate {
    <#
    .SYNOPSIS
    Deletes an existing payload template for webhooks for a network using the Meraki Dashboard API.

    .DESCRIPTION
    The Remove-MerakiNetworkWebhooksPayloadTemplate function allows you to delete an existing payload template for webhooks for a network by providing the authentication token, network ID, and payload template ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to delete an existing payload template for webhooks.

    .PARAMETER PayloadTemplateId
    The ID of the payload template you want to delete.

    .EXAMPLE
    Remove-MerakiNetworkWebhooksPayloadTemplate -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -PayloadTemplateId "wpt_00001"

    This example deletes the payload template with ID "wpt_00001" for the Meraki network with ID "L_123456789012345678".

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
        [string]$PayloadTemplateId
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }
        
        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/webhooks/payloadTemplates/$PayloadTemplateId"
        
        $response = Invoke-RestMethod -Method Delete -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}