function Remove-MerakiOrganizationAdaptivePolicyGroup {
    <#
    .SYNOPSIS
    Deletes an existing adaptive policy group for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The Remove-MerakiOrganizationAdaptivePolicyGroup function allows you to delete an existing adaptive policy group for a specified Meraki organization by providing the authentication token, organization ID, and group ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to delete an adaptive policy group.

    .PARAMETER GroupId
    The ID of the adaptive policy group you want to delete.

    .EXAMPLE
    Remove-MerakiOrganizationAdaptivePolicyGroup -AuthToken "your-api-token" -OrganizationId "1234567890" -GroupId "1234567890"

    This example deletes the adaptive policy group with ID "1234567890" for the Meraki organization with ID "1234567890".

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
        [string]$GroupId
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/adaptivePolicy/groups/$GroupId"
            
            $response = Invoke-RestMethod -Method Delete -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}