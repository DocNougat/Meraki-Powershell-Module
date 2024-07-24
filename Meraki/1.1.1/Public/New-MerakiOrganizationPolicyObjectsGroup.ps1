function New-MerakiOrganizationPolicyObjectsGroup {
    <#
    .SYNOPSIS
    Creates a new policy object group for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The New-MerakiOrganizationPolicyObjectsGroup function allows you to create a new policy object group for a specified Meraki organization by providing the authentication token, organization ID, and a JSON configuration for the policy object group.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to create a new policy object group.

    .PARAMETER PolicyObjectsGroupConfig
    The JSON configuration for the new policy object group to be created. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $PolicyObjectsGroupConfig = [PSCustomObject]@{
        name = "Web Servers - Datacenter 10"
        objectIds = @()
    }

    $PolicyObjectsGroupConfig = $PolicyObjectsGroupConfig | ConvertTo-JSON -Compress

    New-MerakiOrganizationPolicyObjectsGroup -AuthToken "your-api-token" -OrganizationId "1234567890" -PolicyObjectsGroupConfig $PolicyObjectsGroupConfig

    This example creates a new policy object group with name "Web Servers - Datacenter 10" for the Meraki organization with ID "1234567890". The policy object group is not associated with any policy objects.

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

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/policyObjects/groups"
            
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}