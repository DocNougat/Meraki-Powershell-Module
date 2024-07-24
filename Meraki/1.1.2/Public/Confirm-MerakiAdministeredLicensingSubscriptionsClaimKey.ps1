function Confirm-MerakiAdministeredLicensingSubscriptionsClaimKey {
    <#
    .SYNOPSIS
    Validates a subscription's claim key.

    .DESCRIPTION
    This function allows you to validate a subscription's claim key by providing the authentication token and the claim key.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER ClaimKey
    The subscription's claim key.

    .EXAMPLE
    Confirm-MerakiAdministeredLicensingSubscriptionsClaimKey -AuthToken "your-api-token" -ClaimKey "S2345-6789A-BCDEF-GHJKM"

    This example validates the subscription's claim key "S2345-6789A-BCDEF-GHJKM".

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$ClaimKey
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = @{
            claimKey = $ClaimKey
        }

        $bodyJson = $body | ConvertTo-Json -Compress -Depth 4

        $url = "https://api.meraki.com/api/v1/administered/licensing/subscription/subscriptions/claimKey/validate"

        $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat" -Body $bodyJson
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
