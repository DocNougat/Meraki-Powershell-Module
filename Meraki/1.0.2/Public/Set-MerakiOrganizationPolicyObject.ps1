function Set-MerakiOrganizationPolicyObject {
    <#
    .SYNOPSIS
    Updates an existing policy object for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiOrganizationPolicyObject function allows you to update an existing policy object for a specified Meraki organization by providing the authentication token, organization ID, policy object ID, and a JSON configuration for the policy object.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to update a policy object.

    .PARAMETER PolicyObjectId
    The ID of the policy object you want to update.

    .PARAMETER PolicyObjectConfig
    The JSON configuration for the policy object to be updated. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $PolicyObjectConfig = [PSCustomObject]@{
        name = "Web Servers - Datacenter 10"
        type = "cidr"
        groupIds = @()
    }

    $PolicyObjectConfig = $PolicyObjectConfig | ConvertTo-JSON -Compress

    Set-MerakiOrganizationPolicyObject -AuthToken "your-api-token" -OrganizationId "1234567890" -PolicyObjectId "1234" -PolicyObjectConfig $PolicyObjectConfig

    This example updates the policy object with ID "1234" for the Meraki organization with ID "1234567890". The policy object is configured to have name "Web Servers - Datacenter 10", type "cidr", and belong to no policy object groups.

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
        [string]$PolicyObjectId,
        [parameter(Mandatory=$true)]
        [string]$PolicyObjectConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
            
            $body = $PolicyObjectConfig

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/policyObjects/$PolicyObjectId"
            
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
            Write-Host $_
        }
    }
}