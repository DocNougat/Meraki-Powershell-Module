function New-MerakiOrganizationPolicyObject {
    <#
    .SYNOPSIS
    Creates a new policy object for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The New-MerakiOrganizationPolicyObject function allows you to create a new policy object for a specified Meraki organization by providing the authentication token, organization ID, and a JSON configuration for the policy object.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to create a new policy object.

    .PARAMETER PIIRequest
    The JSON configuration for the new policy object to be created. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $PolicyObject = '{
        "name": "Web Servers - Datacenter 10",
        "category": "network",
        "type": "cidr",
        "groupIds": []
    }'
    $PolicyObject = $PolicyObject | ConvertTo-JSON -compress

    New-MerakiOrganizationPolicyObject -AuthToken "your-api-token" -OrganizationId "1234567890" -PolicyObject $PolicyObject

    This example creates a new policy object with name "Web Servers - Datacenter 10" for the Meraki organization with ID "1234567890". The policy object is configured to be of type "cidr" and belong to no policy object groups.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the creation is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationId = (Get-MerakiOrganizations -AuthToken $AuthToken).id,
        [parameter(Mandatory=$true)]
        [string]$PolicyObject
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }
        
        $body = $PolicyObject

        $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/policyObjects"
        
        $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -Body $body
        return $response
    }
    catch {
        Write-Host $_
    }
}