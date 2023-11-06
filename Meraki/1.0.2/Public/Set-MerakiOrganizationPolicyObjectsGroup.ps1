function Set-MerakiOrganizationPolicyObjectsGroup {
    <#
    .SYNOPSIS
    Updates an existing policy object group for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiOrganizationPolicyObjectsGroup function allows you to update an existing policy object group for a specified Meraki organization by providing the authentication token, organization ID, policy object group ID, and a JSON configuration for the policy object group.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to update a policy object group.

    .PARAMETER PolicyObjectGroupId
    The ID of the policy object group you want to update.

    .PARAMETER PolicyObjectsGroupConfig
    The JSON configuration for the policy object group to be updated. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $PolicyObjectsGroupConfig = '{
        "name": "Web Servers - Datacenter 10",
        "objectIds": []
    }'
    $PolicyObjectsGroupConfig = $PolicyObjectsGroupConfig | ConvertTo-JSON -compress

    Set-MerakiOrganizationPolicyObjectsGroup -AuthToken "your-api-token" -OrganizationId "1234567890" -PolicyObjectGroupId "1234" -PolicyObjectsGroupConfig $PolicyObjectsGroupConfig

    This example updates the policy object group with ID "1234" for the Meraki organization with ID "1234567890". The policy object group is configured to have name "Web Servers - Datacenter 10" and not be associated with any policy objects.

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
        [string]$PolicyObjectGroupId,
        [parameter(Mandatory=$true)]
        [string]$PolicyObjectsGroupConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
            
            $body = $PolicyObjectsGroupConfig

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/policyObjects/groups/$PolicyObjectGroupId"
            
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
            Write-Host $_
        }
    }
}