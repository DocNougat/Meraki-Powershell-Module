function Set-MerakiOrganizationBrandingPoliciesPriorities {
    <#
    .SYNOPSIS
    Updates the priorities of branding policies for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiOrganizationBrandingPoliciesPriorities function allows you to update the priorities of branding policies for a specified Meraki organization by providing the authentication token, organization ID, and a list of branding policy IDs in the desired order.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to update the branding policy priorities.

    .PARAMETER PolicyIds
    A list of branding policy IDs in the desired order. The first ID in the list will have the highest priority.

    .EXAMPLE
    Set-MerakiOrganizationBrandingPoliciesPriorities -AuthToken "your-api-token" -OrganizationId "1234567890" -PolicyIds "1234567890","0987654321"

    This example updates the priorities of branding policies for the Meraki organization with ID "1234567890". The branding policy with ID "1234567890" will have the highest priority, followed by the branding policy with ID "0987654321".

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
        [array]$PolicyIds
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
            
            $body = @{
                "brandingPolicyIds" = $PolicyIds
            } | ConvertTo-Json -Depth 3

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/brandingPolicies/priorities"
            
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -Body $body
            return $response
        }
        catch {
            Write-Host $_
        }
    }
}