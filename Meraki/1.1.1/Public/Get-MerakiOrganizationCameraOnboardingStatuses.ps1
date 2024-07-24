function Get-MerakiOrganizationCameraOnboardingStatuses {
    <#
    .SYNOPSIS
    Retrieves onboarding statuses for cameras in a Meraki organization.

    .DESCRIPTION
    This function retrieves onboarding statuses for cameras in a Meraki organization using the Meraki Dashboard API. It requires an authentication token for the API, the ID of the organization for which the statuses should be retrieved, and optionally an array of serial numbers or network IDs to filter the results.

    .PARAMETER AuthToken
    The authentication token for the Meraki Dashboard API.

    .PARAMETER OrgID
    The ID of the organization for which the onboarding statuses should be retrieved. If not specified, the function will use the ID of the first organization returned by the Get-MerakiOrganizations function.

    .PARAMETER serials
    An array of camera serial numbers to filter the results. If not specified, all cameras in the organization will be included in the results.

    .PARAMETER networkIds
    An array of network IDs to filter the results. If not specified, cameras in all networks in the organization will be included in the results.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationCameraOnboardingStatuses -AuthToken $AuthToken -OrgID $OrganizationID

    Retrieves onboarding statuses for all cameras in the specified organization.

    .NOTES
    This function requires the Get-MerakiOrganizations function.

    .LINK
    https://developer.cisco.com/meraki/api-v1/#!get-organization-camera-onboarding-statuses
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$false)]
        [array]$serials = $null,
        [parameter(Mandatory=$false)]
        [array]$networkIds = $null
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
            }
            $queryParams = @{}
            if ($serials) {
                $queryParams['serials[]'] = $serials
            }
            if ($networkIds) {
                $queryParams['networkIds[]'] = $networkIds
            }

            $queryString = New-MerakiQueryString -queryParams $queryParams

            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/camera/onboarding/statuses?$queryString"

            $URI = [uri]::EscapeUriString($URL)

            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}
