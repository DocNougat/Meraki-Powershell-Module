function New-MerakiOrganizationAdaptivePolicy {
    <#
    .SYNOPSIS
    Creates a new adaptive policy for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The New-MerakiOrganizationAdaptivePolicy function allows you to create a new adaptive policy for a specified Meraki organization by providing the authentication token, organization ID, and policy configuration.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to create a new adaptive policy.

    .PARAMETER PolicyConfig
    The JSON configuration for the adaptive policy. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $config = '{
        "name": "Test Policy",
        "description": "Test Policy description",
        "lastEntryRule": "default",
        "destinationGroup": {
            "id": "1234567890",
            "name": "Test Destination Group",
            "sgt": 123
        },
        "sourceGroup": {
            "id": "0987654321",
            "name": "Test Source Group",
            "sgt": 456
        },
        "acls": [
            {
                "id": "1111111111",
                "name": "Test ACL 1"
            },
            {
                "id": "2222222222",
                "name": "Test ACL 2"
            }
        ]
    }'
    $config = $config | ConvertTo-JSON -compress
    
    New-MerakiOrganizationAdaptivePolicy -AuthToken "your-api-token" -OrganizationId "1234567890" -PolicyConfig $config

    This example creates a new adaptive policy for the Meraki organization with ID "1234567890" using the provided policy configuration.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the configuration is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationId = (Get-MerakiOrganizations -AuthToken $AuthToken).id,
        [parameter(Mandatory=$true)]
        [string]$PolicyConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }
        
        $body = $PolicyConfig

        $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/adaptivePolicy/policies"
        
        $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -Body $body
        return $response
    }
    catch {
        Write-Host $_
    }
}