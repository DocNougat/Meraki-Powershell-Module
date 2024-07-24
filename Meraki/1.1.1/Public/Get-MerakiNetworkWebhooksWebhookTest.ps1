function Get-MerakiNetworkWebhooksWebhookTest {
<#
.SYNOPSIS
Retrieves a Meraki network webhook test.

.DESCRIPTION
This function retrieves a Meraki network webhook test using the Meraki Dashboard API.

.PARAMETER AuthToken
The API token generated in the Meraki Dashboard.

.PARAMETER webhookTestId
The ID of the webhook test.

.PARAMETER NetworkId
The ID of the Meraki network.

.EXAMPLE
PS C:> Get-MerakiNetworkWebhooksWebhookTest -AuthToken '12345' -webhookTestId '123' -NetworkId 'N_1234567890'

This command retrieves the webhook test with the ID '123' for the Meraki network with the ID 'N_1234567890' using the API token '12345'.

.INPUTS
None.

.OUTPUTS
The function returns a Meraki network webhook test object.

.NOTES
For more information on the Meraki Dashboard API, please visit https://developer.cisco.com/meraki/api/.

#>
    [CmdletBinding()]
    param (
    [parameter(Mandatory=$true)]
    [string]$AuthToken,
    [parameter(Mandatory=$true)]
    [string]$webhookTestId,
    [parameter(Mandatory=$true)]
    [string]$NetworkId
    )
    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/webhooks/webhookTests/$webhookTestId" -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}    