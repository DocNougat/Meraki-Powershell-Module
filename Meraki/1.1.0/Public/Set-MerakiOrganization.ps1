function Set-MerakiOrganization {
    <#
    .SYNOPSIS
    Updates an existing Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiOrganization function allows you to update an existing Meraki organization by providing the authentication token, organization ID, and a JSON configuration for the organization.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization to be updated.

    .PARAMETER OrgConfig
    The JSON configuration for the organization to be updated. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $OrgConfig = [PSCustomObject]@{
        name = "My organization"
        management = @{
            details = @(
                @{
                    name = "MSP ID"
                    value = "123456"
                }
            )
        }
        api = @{
            enabled = $true
        }
    }

    $OrgConfig = $OrgConfig | ConvertTo-Json -Compress

    Set-MerakiOrganization -AuthToken "your-api-token" -OrganizationId "1234567890" -OrgConfig $OrgConfig

    This example updates the Meraki organization with ID "1234567890" with a new name, management details, and API settings.

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
        [string]$OrgConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
            
            $body = $OrgConfig

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId"
            
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}