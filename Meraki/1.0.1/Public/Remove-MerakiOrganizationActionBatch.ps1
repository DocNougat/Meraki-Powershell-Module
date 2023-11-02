function Remove-MerakiOrganizationActionBatch {
    <#
    .SYNOPSIS
    Deletes an existing action batch for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The Remove-MerakiOrganizationActionBatch function allows you to delete an existing action batch for a specified Meraki organization by providing the authentication token, organization ID, and action batch ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to delete an action batch.

    .PARAMETER ActionBatchId
    The ID of the action batch you want to delete.

    .EXAMPLE
    Remove-MerakiOrganizationActionBatch -AuthToken "your-api-token" -OrganizationId "1234567890" -ActionBatchId "AB_1234567890"

    This example deletes the action batch with ID "AB_1234567890" for the Meraki organization with ID "1234567890".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the configuration is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$ActionBatchId
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
            
            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/actionBatches/$ActionBatchId"
            
            $response = Invoke-RestMethod -Method Delete -Uri $url -Header $header
            return $response
        }
        catch {
            Write-Host $_
        }
    }
}