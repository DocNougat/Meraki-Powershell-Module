function New-MerakiOrganizationAdaptivePolicyACL {
    <#
    .SYNOPSIS
    Creates a new adaptive policy ACL for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The New-MerakiOrganizationAdaptivePolicyACL function allows you to create a new adaptive policy ACL for a specified Meraki organization by providing the authentication token, organization ID, and ACL configuration.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to create a new adaptive policy ACL.

    .PARAMETER ACLConfig
    The JSON configuration for the adaptive policy ACL. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $config = '{
        "name": "Test ACL",
        "description": "Test ACL description",
        "ipVersion": "ipv4",
        "rules": [
            {
                "policy": "allow"
                "protocol": "tcp",
                "dstPort": "80",
                "srcPort": "any",
            }
        ]
    }'
    $config = $config | ConvertTo-JSON -compress
    
    New-MerakiOrganizationAdaptivePolicyACL -AuthToken "your-api-token" -OrganizationId "1234567890" -ACLConfig $config

    This example creates a new adaptive policy ACL for the Meraki organization with ID "1234567890" using the provided ACL configuration.

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
        [string]$ACLConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }
        
        $body = $ACLConfig

        $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/adaptivePolicy/ACLs"
        
        $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -Body $body
        return $response
    }
    catch {
        Write-Host $_
    }
}