function Get-MerakiOrganizationAssuranceAlertsTaxonomyCategories {
    <#
    .SYNOPSIS
    Retrieves Assurance alert taxonomy categories for a Meraki organization.

    .DESCRIPTION
    Get-MerakiOrganizationAssuranceAlertsTaxonomyCategories queries the Meraki Dashboard API to obtain the list of assurance alert taxonomy categories for the specified organization. The function requires a valid Meraki API key (AuthToken). If OrganizationID is not provided, the function attempts to determine it via Get-OrgID -AuthToken <AuthToken>. If multiple organizations are found by Get-OrgID, the function returns a message indicating an organization ID must be specified.

    .PARAMETER AuthToken
    The Meraki Dashboard API key. This is mandatory and is passed in the X-Cisco-Meraki-API-Key HTTP header. The account associated with this key must have permission to read organization assurance configuration.

    .PARAMETER OrganizationID
    The ID of the Meraki organization for which to retrieve assurance alert taxonomy categories. If omitted, the function calls Get-OrgID -AuthToken <AuthToken> to resolve a single organization ID. If Get-OrgID returns a "Multiple organizations found..." message, the function returns that message and does not call the API.

    .EXAMPLE
    # Retrieve taxonomy categories by providing only an API key; organization ID will be resolved automatically if possible
    Get-MerakiOrganizationAssuranceAlertsTaxonomyCategories -AuthToken 'ABCDEF...'
    #>
    
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken)
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
            }
            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/assurance/alerts/taxonomy/categories" -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}
