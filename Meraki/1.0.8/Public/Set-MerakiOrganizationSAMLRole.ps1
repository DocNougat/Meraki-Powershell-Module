function Set-MerakiOrganizationSAMLRole {
    <#
    .SYNOPSIS
    Updates an existing SAML role for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiOrganizationSAMLRole function allows you to update an existing SAML role for a specified Meraki organization by providing the authentication token, organization ID, SAML role ID, and a JSON configuration for the SAML role.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to update a SAML role.

    .PARAMETER SAMLRoleId
    The ID of the SAML role you want to update.

    .PARAMETER SAMLRoleConfig
    The JSON configuration for the SAML role to be updated. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $SAMLRoleConfig = [PSCustomObject]@{
        role = "myrole"
        orgAccess = "none"
        tags = @(
            @{
                tag = "west"
                access = "read-only"
            }
        )
        networks = @(
            @{
                id = "N_24329156"
                access = "full"
            }
        )
    }

    $SAMLRoleConfig = $SAMLRoleConfig | ConvertTo-Json -Compress

    Set-MerakiOrganizationSAMLRole -AuthToken "your-api-token" -OrganizationId "1234567890" -SAMLRoleId "5678" -SAMLRoleConfig $SAMLRoleConfig

    This example updates the SAML role with ID "5678" for the Meraki organization with ID "1234567890". The SAML role is configured with a role name of "myrole", no organization access, read-only access to the tag with name "west", and full access to the network with ID "N_24329156".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$SAMLRoleId,
        [parameter(Mandatory=$true)]
        [string]$SAMLRoleConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
            
            $body = $SAMLRoleConfig

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/samlRoles/$SAMLRoleId"
            
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}