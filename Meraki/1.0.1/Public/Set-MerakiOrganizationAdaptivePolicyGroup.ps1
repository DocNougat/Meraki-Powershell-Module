function Set-MerakiOrganizationAdaptivePolicyGroup {
    <#
    .SYNOPSIS
    Updates an existing adaptive policy group for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiOrganizationAdaptivePolicyGroup function allows you to update an existing adaptive policy group for a specified Meraki organization by providing the authentication token, organization ID, group ID, and group configuration.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to update an adaptive policy group.

    .PARAMETER GroupId
    The ID of the adaptive policy group you want to update.

    .PARAMETER GroupConfig
    The JSON configuration for the adaptive policy group. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $config = '{
        "name": "Test Group",
        "description": "Test Group description",
        "sgt": 123,
        "policyObjects": [
            {
                "id": "1234567890",
                "name": "Test Policy Object"
            }
        ]
    }'
    $config = $config | ConvertTo-JSON -compress
    
    Set-MerakiOrganizationAdaptivePolicyGroup -AuthToken "your-api-token" -OrganizationId "1234567890" -GroupId "1234567890" -GroupConfig $config

    This example updates the adaptive policy group with ID "1234567890" for the Meraki organization with ID "1234567890" using the provided group configuration.

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
        [string]$GroupId,
        [parameter(Mandatory=$true)]
        [string]$GroupConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
            
            $body = $GroupConfig

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/adaptivePolicy/groups/$GroupId"
            
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -Body $body
            return $response
        }
        catch {
            Write-Host $_
        }
    }
}