function Remove-MerakiOrganization {
    <#
    .SYNOPSIS
    Deletes an existing Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The Remove-MerakiOrganization function allows you to delete an existing Meraki organization by providing the authentication token and organization ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization you want to delete.

    .EXAMPLE
    Remove-MerakiOrganization -AuthToken "your-api-token" -OrganizationId "1234567890"

    This example deletes the Meraki organization with ID "1234567890".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the deletion is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$OrganizationId
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId"
        
        $response = Invoke-RestMethod -Method Delete -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}