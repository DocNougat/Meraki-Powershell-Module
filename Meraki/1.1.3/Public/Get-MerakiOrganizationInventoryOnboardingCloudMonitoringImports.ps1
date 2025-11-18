function Get-MerakiOrganizationInventoryOnboardingCloudMonitoringImports {
    <#
    .SYNOPSIS
    Retrieves a list of the cloud monitoring imports for the given import IDs.

    .DESCRIPTION
    This function retrieves a list of the cloud monitoring imports for the given import IDs. The function requires an authentication token, and can also take an organization ID.

    .PARAMETER AuthToken
    The Meraki Dashboard API token.

    .PARAMETER importIds
    An array of import IDs for which to retrieve the corresponding cloud monitoring imports.

    .PARAMETER OrgID
    The ID of the organization to query. If not provided, the function will use the ID of the first organization associated with the API key.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationInventoryOnboardingCloudMonitoringImports -AuthToken "12345" -importIds @("import1", "import2")

    Retrieves the cloud monitoring imports for the "import1" and "import2" import IDs for the first organization associated with the given authentication token.

    .NOTES
    For more information about the Meraki Dashboard API, please refer to the official documentation:
    https://developer.cisco.com/meraki/api-v1/
    #>

    param (
        [parameter(Mandatory=$true, HelpMessage="The Meraki Dashboard API token.")]
        [string]$AuthToken,
        [parameter(Mandatory=$true, HelpMessage="An array of import IDs for which to retrieve the corresponding cloud monitoring imports.")]
        [array]$importIds,
        [parameter(Mandatory=$false, HelpMessage="The ID of the organization to query. If not provided, the function will use the ID of the first organization associated with the API key.")]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken)
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                'X-Cisco-Meraki-API-Key' = $AuthToken
            }
        
            $queryParams = @{
                'importIds[]' = $importIds
            }
        
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/inventory/onboarding/cloudMonitoring/imports?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
        Write-Debug $_
        Throw $_
    }
    }
}