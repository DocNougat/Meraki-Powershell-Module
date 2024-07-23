function Invoke-MerakiClaimAdministeredLicensingSubscriptions {
    <#
    .SYNOPSIS
    Claims administered licensing subscription subscriptions.

    .DESCRIPTION
    This function allows you to claim administered licensing subscription subscriptions by providing the authentication token, and the details of the claim configuration as parameters.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER ClaimKey
    The claim key for the subscription.

    .PARAMETER OrganizationId
    The ID of the organization.

    .PARAMETER Name
    The name of the subscription.

    .PARAMETER Description
    The description of the subscription.

    .PARAMETER Validate
    An optional boolean parameter to validate the claim request.

    .EXAMPLE
    Invoke-MerakiClaimAdministeredLicensingSubscriptions -AuthToken "your-api-token" -ClaimKey "S2345-6789A-BCDEF-GHJKM" -OrganizationId "12345678910" -Name "Corporate subscription" -Description "Subscription for all main offices" -Validate $true

    This example claims an administered licensing subscription with the specified configuration.

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$ClaimKey,
        [parameter(Mandatory=$true)]
        [string]$OrganizationId,
        [parameter(Mandatory=$false)]
        [string]$Name,
        [parameter(Mandatory=$false)]
        [string]$Description,
        [parameter(Mandatory=$false)]
        [bool]$Validate = $false
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = @{
            claimKey = $ClaimKey
            organizationId = $OrganizationId
        }

        if ($Name) {
            $body.name = $Name
        }

        if ($Description) {
            $body.description = $Description
        }

        if ($Validate) {
            $body.validate = $true
        }

        $bodyJson = $body | ConvertTo-Json -Compress
        $url = "https://api.meraki.com/api/v1/administered/licensing/subscription/subscriptions/claim"

        $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat" -Body $bodyJson
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}