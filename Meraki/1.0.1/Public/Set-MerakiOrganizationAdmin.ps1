function Set-MerakiOrganizationAdmin {
    <#
    .SYNOPSIS
    Updates an existing administrator for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiOrganizationAdmin function allows you to update an existing administrator for a specified Meraki organization by providing the authentication token, administrator ID, and administrator details.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER AdminId
    The ID of the administrator to be updated.

    .PARAMETER AdminInfo
    The JSON configuration for the administrator to be updated. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $adminInfo = '{
        "name": "Updated Admin User",
        "orgAccess": "full"
    }'
    $adminInfo = $adminInfo | ConvertTo-JSON -compress

    Set-MerakiOrganizationAdmin -AuthToken "your-api-token" -AdminId "1234567890" -AdminInfo $adminInfo

    This example updates the administrator with ID "1234567890" to have the name "Updated Admin User" and full access to the organization.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the configuration is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$AdminId,
        [parameter(Mandatory=$true)]
        [string]$AdminInfo,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken)
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
            
            $body = $AdminInfo

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/admins/$AdminId"
            
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -Body $body
            return $response
        }
        catch {
            Write-Host $_
        }
    }
}