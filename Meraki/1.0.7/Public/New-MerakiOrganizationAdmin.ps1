function New-MerakiOrganizationAdmin {
    <#
    .SYNOPSIS
    Creates a new administrator for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The New-MerakiOrganizationAdmin function allows you to create a new administrator for a specified Meraki organization by providing the authentication token, administrator details, and optionally, network and tag privileges.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER AdminInfo
    The JSON configuration for the new administrator to be created. Refer to the JSON schema for required parameters and their format.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to create a new administrator.

    .EXAMPLE
    $adminInfo = [PSCustomObject]@{
        email = "miles@meraki.com"
        name = "Miles Meraki"
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
        authenticationMethod = "Email"
    }

    $adminInfo = $adminInfo | ConvertTo-Json -Compress

    New-MerakiOrganizationAdmin -AuthToken "your-api-token" -AdminInfo $adminInfo -OrganizationId "1234567890"

    This example creates a new administrator with email "miles@meraki.com", name "Miles Meraki", and no access to the Meraki organization with ID "1234567890". The administrator has read-only access to the tag "west" and full access to the network with ID "N_24329156". The authentication method used is email.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the configuration is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
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

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/admins"
            
            $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}