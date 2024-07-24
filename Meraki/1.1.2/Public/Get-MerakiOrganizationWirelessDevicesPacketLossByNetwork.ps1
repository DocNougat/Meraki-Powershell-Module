function Get-MerakiOrganizationWirelessDevicesPacketLossByNetwork {
    <#
    .SYNOPSIS
    Retrieves packet loss data by network for wireless devices in an organization.

    .DESCRIPTION
    This function allows you to retrieve packet loss data by network for wireless devices in a given organization by providing the authentication token, organization ID, and optional query parameters.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the organization.

    .PARAMETER NetworkIds
    Filter results by network.

    .PARAMETER Serials
    Filter results by device serial numbers.

    .PARAMETER Ssids
    Filter results by SSID number.

    .PARAMETER Bands
    Filter results by band. Valid bands are: 2.4, 5, and 6.

    .PARAMETER PerPage
    The number of entries per page returned. Acceptable range is 3 - 1000. Default is 1000.

    .PARAMETER StartingAfter
    A token used by the server to indicate the start of the page. Should not be defined by client applications.

    .PARAMETER EndingBefore
    A token used by the server to indicate the end of the page. Should not be defined by client applications.

    .PARAMETER t0
    The beginning of the timespan for the data. The maximum lookback period is 90 days from today.

    .PARAMETER t1
    The end of the timespan for the data. t1 can be a maximum of 90 days after t0.

    .PARAMETER Timespan
    The timespan for which the information will be fetched. If specifying timespan, do not specify parameters t0 and t1. The value must be in seconds and be greater than or equal to 5 minutes and be less than or equal to 90 days. The default is 7 days.

    .EXAMPLE
    Get-MerakiOrganizationWirelessDevicesPacketLossByNetwork -AuthToken "your-api-token" -OrganizationId "123456" -NetworkIds @("N_1234", "N_5678") -Timespan 604800

    This example retrieves packet loss data by network for wireless devices in the organization with ID "123456" for the past 7 days, filtered by the specified network IDs.

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationId = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$false)]
        [string[]]$NetworkIds,
        [parameter(Mandatory=$false)]
        [string[]]$Serials,
        [parameter(Mandatory=$false)]
        [int[]]$Ssids,
        [parameter(Mandatory=$false)]
        [string[]]$Bands,
        [parameter(Mandatory=$false)]
        [int]$PerPage = 1000,
        [parameter(Mandatory=$false)]
        [string]$StartingAfter,
        [parameter(Mandatory=$false)]
        [string]$EndingBefore,
        [parameter(Mandatory=$false)]
        [string]$t0,
        [parameter(Mandatory=$false)]
        [string]$t1,
        [parameter(Mandatory=$false)]
        [int]$Timespan
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

            if ($NetworkIds) {
                $queryParams['networkIds'] = $NetworkIds -join ","
            }

            if ($Serials) {
                $queryParams['serials'] = $Serials -join ","
            }

            if ($Ssids) {
                $queryParams['ssids'] = $Ssids -join ","
            }

            if ($Bands) {
                $queryParams['bands'] = $Bands -join ","
            }

            if ($PerPage) {
                $queryParams['perPage'] = $PerPage
            }

            if ($StartingAfter) {
                $queryParams['startingAfter'] = $StartingAfter
            }

            if ($EndingBefore) {
                $queryParams['endingBefore'] = $EndingBefore
            }

            if ($t0) {
                $queryParams['t0'] = $t0
            }

            if ($t1) {
                $queryParams['t1'] = $t1
            }

            if ($Timespan) {
                $queryParams['timespan'] = $Timespan
            }

            $queryString = New-MerakiQueryString -queryParams $queryParams

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/wireless/devices/packetLoss/byNetwork?$queryString"

            $response = Invoke-RestMethod -Method Get -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}