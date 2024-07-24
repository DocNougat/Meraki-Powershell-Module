function Invoke-MerakiBindAdministeredLicensingSubscription {
    <#
    .SYNOPSIS
    Binds administered licensing subscription to networks.

    .DESCRIPTION
    This function allows you to bind administered licensing subscription to networks by providing the authentication token, subscription ID, and a list of network IDs.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER SubscriptionId
    The ID of the subscription.

    .PARAMETER NetworkIds
    A list of network IDs to bind to the subscription.

    .PARAMETER Validate
    An optional boolean parameter to validate the bind request.

    .EXAMPLE
    $NetworkIds = @("L_1234", "N_5678")
    Invoke-MerakiBindAdministeredLicensingSubscription -AuthToken "your-api-token" -SubscriptionId "12345678910" -NetworkIds $NetworkIds -Validate $true

    This example binds the subscription with ID "12345678910" to the specified network IDs.

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$SubscriptionId,
        [parameter(Mandatory=$true)]
        [string[]]$NetworkIds,
        [parameter(Mandatory=$false)]
        [bool]$Validate = $false
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = @{
            networkIds = $NetworkIds
        }

        if ($Validate) {
            $body.validate = $true
        }

        $body = $body | ConvertTo-Json -Compress

        $url = "https://api.meraki.com/api/v1/administered/licensing/subscription/subscriptions/$SubscriptionId/bind"

        $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
