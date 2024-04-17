function Copy-MerakiOrganization {
    <#
    .SYNOPSIS
    Clones an existing Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The Copy-MerakiOrganization function allows you to clone an existing Meraki organization by providing the authentication token, organization ID, and a name for the cloned organization.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization to be cloned.

    .PARAMETER ClonedOrgName
    The name of the cloned organization to be created.

    .EXAMPLE
    Copy-MerakiOrganization -AuthToken "your-api-token" -OrganizationId "1234567890" -ClonedOrgName "My cloned organization"

    This example clones the Meraki organization with ID "1234567890" and creates a new organization with name "My cloned organization".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the cloning is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$OrganizationId,
        [parameter(Mandatory=$true)]
        [string]$ClonedOrgName
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }
        
        $body = @{
            "name" = $ClonedOrgName
        } | ConvertTo-JSON -compress

        $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/clone"
        
        $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}