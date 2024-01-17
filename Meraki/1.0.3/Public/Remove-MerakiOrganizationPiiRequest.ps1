function Remove-MerakiOrganizationPiiRequest {
    <#
    .SYNOPSIS
    Deletes an existing Meraki organization PII request using the Meraki Dashboard API.

    .DESCRIPTION
    The Remove-MerakiOrganizationPiiRequest function allows you to delete an existing Meraki organization PII request by providing the authentication token, organization ID, and request ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to delete a PII request.

    .PARAMETER RequestId
    The ID of the PII request you want to delete.

    .EXAMPLE
    Remove-MerakiOrganizationPiiRequest -AuthToken "your-api-token" -OrganizationId "1234567890" -RequestId "1234"

    This example deletes the Meraki organization PII request with ID "1234" for the organization with ID "1234567890".

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
        [string]$RequestId
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/pii/requests/$RequestId"
            
            $response = Invoke-RestMethod -Method Delete -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
            return $response
        }
        catch {
            Write-Host $_
        }
    }
}