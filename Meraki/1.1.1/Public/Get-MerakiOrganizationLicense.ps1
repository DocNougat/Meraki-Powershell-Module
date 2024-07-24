function Get-MerakiOrganizationLicense {
    <#
    .SYNOPSIS
    Get license information for a specified license ID and organization.

    .DESCRIPTION
    This function retrieves information about a specific license within an organization. The organization is identified by an authentication token. 

    .PARAMETER AuthToken
    Specifies the authentication token to use for API requests.

    .PARAMETER LicenseID
    Specifies the license ID of the license to retrieve information for.

    .PARAMETER OrgID
    Specifies the organization ID of the organization to retrieve license information for. If not specified, the ID of the first organization associated with the specified authentication token will be used.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationLicense -AuthToken "1234567890abcdef" -LicenseID "abcd-efgh-ijkl-mnop"

    Retrieves information about the license with ID "abcd-efgh-ijkl-mnop" in the first organization associated with the specified authentication token.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationLicense -AuthToken "1234567890abcdef" -LicenseID "abcd-efgh-ijkl-mnop" -OrgID "123456"

    Retrieves information about the license with ID "abcd-efgh-ijkl-mnop" in the organization with ID "123456".

    .NOTES
    This function requires the "Get-MerakiOrganizations" and "New-MerakiQueryString" functions to be defined.
    #>
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$LicenseID,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken)
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                'X-Cisco-Meraki-API-Key' = $AuthToken
            }

            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/licenses/$LicenseID" -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}