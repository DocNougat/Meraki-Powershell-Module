function Get-MerakiOrganizationCameraDetectionsHistoryByBoundaryByInterval {
    <#
    .SYNOPSIS
    Retrieves the detection history by boundary by interval for an organization.

    .DESCRIPTION
    This function allows you to retrieve the detection history by boundary by interval for an organization by providing the authentication token, organization ID, boundary IDs, and time ranges with intervals.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the organization.

    .PARAMETER BoundaryIds
    A list of boundary IDs. The returned cameras will be filtered to only include these IDs.

    .PARAMETER Ranges
    A list of time ranges with intervals. Each range is an object containing interval, endTime, and startTime.

    .PARAMETER Duration
    The minimum time, in seconds, that the person or car remains in the area to be counted. Defaults to boundary configuration or 60.

    .PARAMETER PerPage
    The number of entries per page returned. Acceptable range is 1 - 1000. Defaults to 1000.

    .PARAMETER BoundaryTypes
    The detection types. Defaults to 'person'. Acceptable values are "person" and "vehicle".

    .EXAMPLE
    $boundaryIds = @("boundaryId1", "boundaryId2")
    $ranges = @(
        @{interval = 300; endTime = "2023-07-21T23:59:59Z"; startTime = "2023-07-21T00:00:00Z"},
        @{interval = 600; endTime = "2023-07-22T23:59:59Z"; startTime = "2023-07-22T00:00:00Z"}
    )
    Get-MerakiOrganizationCameraDetectionsHistoryByBoundaryByInterval -AuthToken "your-api-token" -OrganizationId "123456" -BoundaryIds $boundaryIds -Ranges $ranges -Duration 60 -PerPage 1000 -BoundaryTypes @("person", "vehicle")

    This example retrieves the detection history by boundary by interval for the specified boundary IDs and time ranges in the organization with ID "123456".

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string[]]$BoundaryIds,
        [parameter(Mandatory=$true)]
        [pscustomobject[]]$Ranges,
        [parameter(Mandatory=$false)]
        [int]$Duration = 60,
        [parameter(Mandatory=$false)]
        [int]$PerPage = 1000,
        [parameter(Mandatory=$false)]
        [string[]]$BoundaryTypes = @("person")
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $queryParams = @{
                boundaryIds = ($BoundaryIds -join ",")
                ranges = ($Ranges | ConvertTo-Json -Compress)
            }
    
            if ($Duration) {
                $queryParams['duration'] = $Duration
            }
    
            if ($PerPage) {
                $queryParams['perPage'] = $PerPage
            }
    
            if ($BoundaryTypes) {
                $queryParams['boundaryTypes'] = ($BoundaryTypes -join ",")
            }
            
            $queryString = New-MerakiQueryString -queryParams $queryParams
            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/camera/detections/history/byBoundary/byInterval?$queryString"

            $response = Invoke-RestMethod -Method Get -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}