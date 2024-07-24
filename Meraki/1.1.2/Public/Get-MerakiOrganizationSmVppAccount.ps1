function Get-MerakiOrganizationSmVppAccount {
    <#
    .SYNOPSIS
    Gets a specific VPP account for a Meraki organization's Systems Manager.
    
    .DESCRIPTION
    This function retrieves a specific VPP account for a Meraki organization's Systems Manager using the Meraki Dashboard API.
    
    .PARAMETER AuthToken
    The API key for the Meraki Dashboard API.
    
    .PARAMETER OrgId
    The ID of the organization containing the Systems Manager. If not specified, the ID of the first organization returned by Get-MerakiOrganizations is used.
    
    .PARAMETER vppAccountId
    The ID of the VPP account to retrieve.
    
    .EXAMPLE
    PS C:\> Get-MerakiOrganizationSmVppAccount -AuthToken "your_api_key" -vppAccountId "1234"
    
    Retrieves the VPP account with ID "1234" for the first organization returned by Get-MerakiOrganizations.
    
    .EXAMPLE
    PS C:\> Get-MerakiOrganizationSmVppAccount -AuthToken "your_api_key" -OrgId "5678" -vppAccountId "1234"
    
    Retrieves the VPP account with ID "1234" for the organization with ID "5678".
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$vppAccountId
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
            }
            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/sm/vppAccounts/$vppAccountId" -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}
