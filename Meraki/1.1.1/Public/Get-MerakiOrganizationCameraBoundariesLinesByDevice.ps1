function Get-MerakiOrganizationCameraBoundariesLinesByDevice {
    <#
    .SYNOPSIS
    Retrieves camera boundaries lines by device for an organization.

    .DESCRIPTION
    This function allows you to retrieve camera boundaries lines by device for an organization by providing the authentication token, organization ID, and a list of device serial numbers to filter the results.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the organization.

    .PARAMETER Serials
    A list of serial numbers. The returned cameras will be filtered to only include these serials.

    .EXAMPLE
    $serials = @("Q2XX-XXXX-XXXX", "Q2YY-YYYY-YYYY")
    Get-MerakiOrganizationCameraBoundariesLinesByDevice -AuthToken "your-api-token" -OrganizationId "123456" -Serials $serials

    This example retrieves camera boundaries lines by device for the specified serial numbers in the organization with ID "123456".

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$OrganizationId,
        [parameter(Mandatory=$true)]
        [string[]]$Serials
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $queryParams = @{
            serials = ($Serials -join ",")
        }

        $queryString = $queryParams.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" } -join "&"
        $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/camera/boundaries/lines/byDevice?$queryString"

        $response = Invoke-RestMethod -Method Get -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
