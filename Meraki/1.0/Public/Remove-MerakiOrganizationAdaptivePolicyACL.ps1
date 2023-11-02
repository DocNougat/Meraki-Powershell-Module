function Remove-MerakiOrganizationAdaptivePolicyACL {
    <#
    .SYNOPSIS
    Deletes an existing adaptive policy ACL for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The Remove-MerakiOrganizationAdaptivePolicyACL function allows you to delete an existing adaptive policy ACL for a specified Meraki organization by providing the authentication token, organization ID, and ACL ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to delete an adaptive policy ACL.

    .PARAMETER ACLId
    The ID of the adaptive policy ACL you want to delete.

    .EXAMPLE
    Remove-MerakiOrganizationAdaptivePolicyACL -AuthToken "your-api-token" -OrganizationId "1234567890" -ACLId "1234567890"

    This example deletes the adaptive policy ACL with ID "1234567890" for the Meraki organization with ID "1234567890".

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
        [string]$ACLId
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
            
            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/adaptivePolicy/acls/$ACLId"
            
            $response = Invoke-RestMethod -Method Delete -Uri $url -Header $header
            return $response
        }
        catch {
            Write-Host $_
        }
    }
}