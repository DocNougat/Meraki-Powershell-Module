function Get-MerakiOrganizationEarlyAccessFeaturesOptIn {
    <#
    .SYNOPSIS
    Retrieves details of an early access feature opt-in for a specified Meraki organization.

    .DESCRIPTION
    This function retrieves details of an early access feature opt-in for a specified Meraki organization using the Meraki Dashboard API. The authentication token and opt-in ID are required for this operation.

    .PARAMETER AuthToken
    Specifies the authentication token for the Meraki Dashboard API.

    .PARAMETER optInId
    Specifies the ID of the opt-in feature.

    .PARAMETER OrgID
    Specifies the ID of the Meraki organization. If not specified, the function will use the ID of the first organization returned by Get-MerakiOrganizations.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationEarlyAccessFeaturesOptIn -AuthToken "12345" -optInId "123456" -OrgID "123456"

    Retrieves details of the early access feature opt-in with ID "123456" for the organization with ID "123456" using the authentication token "12345".
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$optInId,
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

            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/earlyAccess/features/optIns/$optInId" -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"

            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}