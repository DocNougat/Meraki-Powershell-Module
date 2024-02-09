function Get-MerakiOrganizationSmApnsCert {
    <#
    .SYNOPSIS
    Gets the APNS certificate for a Meraki organization's Systems Manager.
    
    .DESCRIPTION
    This function retrieves the APNS certificate for a Meraki organization's Systems Manager using the Meraki Dashboard API.
    
    .PARAMETER AuthToken
    The API key for the Meraki Dashboard API.
    
    .PARAMETER OrgId
    The ID of the organization containing the Systems Manager. If not specified, the ID of the first organization returned by Get-MerakiOrganizations is used.
    
    .EXAMPLE
    PS C:\> Get-MerakiOrganizationSmApnsCert -AuthToken "your_api_key"
    
    Retrieves the APNS certificate for the first organization returned by Get-MerakiOrganizations.
    
    .EXAMPLE
    PS C:\> Get-MerakiOrganizationSmApnsCert -AuthToken "your_api_key" -OrgId "1234"
    
    Retrieves the APNS certificate for the organization with ID "1234".
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
            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/sm/apnsCert" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
            return $response
        }
        catch {
        Write-Host $_
        Throw $_
    }
    }
}
