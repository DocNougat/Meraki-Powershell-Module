function New-MerakiOrganizationSAMLRole {
    <#
    .SYNOPSIS
    Creates a new SAML role for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The New-MerakiOrganizationSAMLRole function allows you to create a new SAML role for a specified Meraki organization by providing the authentication token, organization ID, and a JSON configuration for the SAML role.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to create a new SAML role.

    .PARAMETER SAMLRoleConfig
    The JSON configuration for the SAML role to be created. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $SAMLRoleConfig = [PSCustomObject]@{
        role = "myrole"
        orgAccess = "none"
        networks = @(
            @{
                id = "N_24329156"
                access = "full"
            }
        )
        tags = @(
            @{
                tag = "west"
                access = "read-only"
            }
        )
    }

    $SAMLRoleConfig = $SAMLRoleConfig | ConvertTo-Json -Compress

    New-MerakiOrganizationSAMLRole -AuthToken "your-api-token" -OrganizationId "1234567890" -SAMLRoleConfig $SAMLRoleConfig

    This example creates a new SAML role for the Meraki organization with ID "1234567890". The SAML role is configured with a role name of "myrole", no organization access, full access to the network with ID "N_24329156", and read-only access to the tag with name "west".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the creation is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
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

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/samlRoles"
            
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}