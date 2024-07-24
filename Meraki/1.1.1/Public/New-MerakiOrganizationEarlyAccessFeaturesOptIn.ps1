function New-MerakiOrganizationEarlyAccessFeaturesOptIn {
    <#
    .SYNOPSIS
    Opt-in to an early access feature in the Meraki Dashboard using the Meraki Dashboard API.

    .DESCRIPTION
    The New-MerakiOrganizationEarlyAccessFeaturesOptIn function allows you to opt-in to an early access feature in the Meraki Dashboard by providing the authentication token, organization ID, and an opt-in string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization to which you want to opt-in to the early access feature.

    .PARAMETER OptIn
    A string containing the opt-in information. The string should be in JSON format and should include the following properties: "shortName" and "limitScopeToNetworks".

    .EXAMPLE
    $optin = [PSCustomObject]@{
        shortName = "my_early_access_feature"
        limitScopeToNetworks = @("N_123456789012345678", "N_234567890123456789")
    }
    $optin = $optin | ConvertTo-Json -Compress
    New-MerakiOrganizationEarlyAccessFeaturesOptIn -AuthToken "your-api-token" -OrganizationId "123456" -OptIn $optin

    This example opts-in to the early access feature with short name "my_early_access_feature" in the Meraki organization with ID "123456".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the opt-in is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$OptIn
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $body = $OptIn

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/earlyAccess/features/optIns"

            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}