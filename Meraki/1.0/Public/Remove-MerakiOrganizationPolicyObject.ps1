function Remove-MerakiOrganizationPolicyObject {
    <#
    .SYNOPSIS
    Deletes an existing policy object for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The Remove-MerakiOrganizationPolicyObject function allows you to delete an existing policy object for a specified Meraki organization by providing the authentication token, organization ID, and policy object ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to delete a policy object.

    .PARAMETER PolicyObjectId
    The ID of the policy object you want to delete.

    .EXAMPLE
    Remove-MerakiOrganizationPolicyObject -AuthToken "your-api-token" -OrganizationId "1234567890" -PolicyObjectId "1234"

    This example deletes the policy object with ID "1234" for the Meraki organization with ID "1234567890".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the deletion is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationId = (Get-MerakiOrganizations -AuthToken $AuthToken).id,
        [parameter(Mandatory=$true)]
        [string]$PolicyObjectId
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/policyObjects/$PolicyObjectId"
        
        $response = Invoke-RestMethod -Method Delete -Uri $url -Header $header
        return $response
    }
    catch {
        Write-Host $_
    }
}