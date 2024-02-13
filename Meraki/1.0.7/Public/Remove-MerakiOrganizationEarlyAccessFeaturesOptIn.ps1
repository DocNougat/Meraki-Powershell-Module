function Remove-MerakiOrganizationEarlyAccessFeaturesOptIn {
    <#
    .SYNOPSIS
    Deletes an early access feature opt-in in the Meraki Dashboard using the Meraki Dashboard API.

    .DESCRIPTION
    The Remove-MerakiOrganizationEarlyAccessFeaturesOptIn function allows you to delete an early access feature opt-in in the Meraki Dashboard by providing the authentication token, organization ID, and opt-in ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization to which the early access feature opt-in belongs.

    .PARAMETER OptInId
    The ID of the early access feature opt-in you want to delete.

    .EXAMPLE
    Remove-MerakiOrganizationEarlyAccessFeaturesOptIn -AuthToken "your-api-token" -OrganizationId "123456" -OptInId "456789"

    This example deletes the early access feature opt-in with ID "456789" in the Meraki organization with ID "123456".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the deletion is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$OptInId
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/earlyAccess/features/optIns/$OptInId"

            $response = Invoke-RestMethod -Method Delete -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}