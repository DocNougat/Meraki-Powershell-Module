function Set-MerakiOrganizationEarlyAccessFeaturesOptIn {
    <#
    .SYNOPSIS
    Updates an early access feature opt-in in the Meraki Dashboard using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiOrganizationEarlyAccessFeaturesOptIn function allows you to update an early access feature opt-in in the Meraki Dashboard by providing the authentication token, organization ID, opt-in ID, and a limit scope to networks string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization to which the early access feature opt-in belongs.

    .PARAMETER OptInId
    The ID of the early access feature opt-in you want to update.

    .PARAMETER LimitScope
    A string containing the limit scope to networks information. The string should be in JSON format and should include the following property: "LimitScope".

    .EXAMPLE
    $limitScope = [PSCustomObject]@{
        LimitScope = @("N_123456789012345678", "N_234567890123456789")
    }
    $limitScope = ConvertTo-Json -Compress

    Set-MerakiOrganizationEarlyAccessFeaturesOptIn -AuthToken "your-api-token" -OrganizationId "123456" -OptInId "456789" -LimitScope $limitScope
    This example updates the early access feature opt-in with ID "456789" in the Meraki organization with ID "123456" to limit scope to the specified networks.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$OptInId,
        [parameter(Mandatory=$true)]
        [string]$LimitScope
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $body = $LimitScope

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/earlyAccess/features/optIns/$OptInId"

            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}