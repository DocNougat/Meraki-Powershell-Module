function Get-MerakiOrganizationSensorReadingsHistory {
    <#
    .SYNOPSIS
    Gets historical sensor readings for a Meraki organization.
    
    .DESCRIPTION
    This function retrieves historical sensor readings for a Meraki organization using the Meraki Dashboard API.
    
    .PARAMETER AuthToken
    The API key for the Meraki Dashboard API.
    
    .PARAMETER OrgId
    The ID of the organization containing the sensor readings. If not specified, the ID of the first organization returned by Get-MerakiOrganizations is used.
    
    .PARAMETER perPage
    The number of entries per page to return. If not specified, the default value is used.
    
    .PARAMETER startingAfter
    A token used to retrieve the next page of results. If not specified, the first page of results is returned.
    
    .PARAMETER endingBefore
    A token used to retrieve the previous page of results. If not specified, the last page of results is returned.
    
    .PARAMETER t0
    The beginning of the time range for the sensor readings. If timespan is not specified, this parameter is required.
    
    .PARAMETER t1
    The end of the time range for the sensor readings. If timespan is not specified, this parameter is required.
    
    .PARAMETER timespan
    The timespan for the sensor readings. If specified, t0 and t1 are ignored.
    
    .PARAMETER networkIds
    An array of network IDs to filter the results by.
    
    .PARAMETER serials
    An array of serial numbers to filter the results by.
    
    .PARAMETER metrics
    An array of metrics to retrieve. If not specified, all available metrics are retrieved.
    
    .EXAMPLE
    PS C:\> Get-MerakiOrganizationSensorReadingsHistory -AuthToken "your_api_key"
    
    Retrieves historical sensor readings for the first organization returned by Get-MerakiOrganizations.
    
    .EXAMPLE
    PS C:\> Get-MerakiOrganizationSensorReadingsHistory -AuthToken "your_api_key" -OrgId "1234" -t0 "2022-01-01T00:00:00Z" -t1 "2022-01-07T23:59:59Z" -metrics @("temperature", "humidity") -perPage 100
    
    Retrieves historical sensor readings for the organization with ID "1234" between January 1, 2022 and January 7, 2022, for the "temperature" and "humidity" metrics, with 100 entries per page.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$false)]
        [int]$perPage = $null,
        [parameter(Mandatory=$false)]
        [string]$startingAfter = $null,
        [parameter(Mandatory=$false)]
        [string]$endingBefore = $null,
        [parameter(Mandatory=$false)]
        [string]$t0 = $null,
        [parameter(Mandatory=$false)]
        [string]$t1 = $null,
        [parameter(Mandatory=$false)]
        [int]$timespan = $null,
        [parameter(Mandatory=$false)]
        [array]$networkIds = $null,
        [parameter(Mandatory=$false)]
        [array]$serials = $null,
        [parameter(Mandatory=$false)]
        [array]$metrics = $null
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "Content-Type" = "application/json"
            }
            $queryParams = @{}
            if ($timespan) {
                $queryParams['timespan'] = $timespan
            } else {
                if ($t0) {
                    $queryParams['t0'] = $t0
                }
                if ($t1) {
                    $queryParams['t1'] = $t1
                }
            }
            if ($perPage) {
                $queryParams['perPage'] = $perPage
            }
            if ($startingAfter) {
                $queryParams['startingAfter'] = $startingAfter
            }
            if ($endingBefore) {
                $queryParams['endingBefore'] = $endingBefore
            }
            if ($networkIds) {
                $queryParams['networkIds[]'] = $networkIds
            }
            if ($serials) {
                $queryParams['serials[]'] = $serials
            }
            if ($metrics) {
                $queryParams['metrics[]'] = $metrics
            }
        
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/sensor/readings/history?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
            return $response
        } catch {
        Write-Debug $_
        Throw $_
    }
    }
}