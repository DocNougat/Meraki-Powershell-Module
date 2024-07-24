function Get-MerakiOrganizationDevicesOverviewByModel {
    <#
    .SYNOPSIS
    Retrieves an overview of devices by model for a specified organization.

    .DESCRIPTION
    This function allows you to retrieve an overview of devices by model for a specified organization by providing the authentication token, organization ID, and optional query parameters.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the organization.

    .PARAMETER Models
    Optional parameter to filter devices by one or more models. All returned devices will have a model that is an exact match.

    .PARAMETER NetworkIds
    Optional parameter to filter devices by network ID.

    .PARAMETER ProductTypes
    Optional parameter to filter devices by product types. Valid types are appliance, camera, cellularGateway, secureConnect, sensor, switch, systemsManager, wireless, wirelessController.

    .EXAMPLE
    Get-MerakiOrganizationDevicesOverviewByModel -AuthToken "your-api-token" -OrganizationId "123456" -Models "MX64" -NetworkIds "N_12345"

    This example retrieves an overview of devices by model "MX64" for the organization with ID "123456" in the network with ID "N_12345".

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$false)]
        [string[]]$Models,
        [parameter(Mandatory=$false)]
        [string[]]$NetworkIds,
        [parameter(Mandatory=$false)]
        [string[]]$ProductTypes
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $queryParams = @{}

            if ($Models) {
                $queryParams['models'] = ($Models -join ",")
            }

            if ($NetworkIds) {
                $queryParams['networkIds'] = ($NetworkIds -join ",")
            }

            if ($ProductTypes) {
                $queryParams['productTypes'] = ($ProductTypes -join ",")
            }

            $queryString = New-MerakiQueryString -QueryParams $queryParams
            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/devices/overview/byModel?$queryString"

            $response = Invoke-RestMethod -Method Get -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}