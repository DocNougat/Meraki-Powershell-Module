function Get-MerakiOrganizationSensorReadingsLatest {
    <#
    .SYNOPSIS
    Gets the latest sensor readings for a Meraki organization.
    
    .DESCRIPTION
    This function retrieves the latest sensor readings for a Meraki organization using the Meraki Dashboard API.
    
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
    
    .PARAMETER networkIds
    An array of network IDs to filter the results by.
    
    .PARAMETER serials
    An array of serial numbers to filter the results by.
    
    .PARAMETER metrics
    An array of metrics to retrieve. If not specified, all available metrics are retrieved.
    
    .EXAMPLE
    PS C:\> Get-MerakiOrganizationSensorReadingsLatest -AuthToken "your_api_key"
    
    Retrieves the latest sensor readings for the first organization returned by Get-MerakiOrganizations.
    
    .EXAMPLE
    PS C:\> Get-MerakiOrganizationSensorReadingsLatest -AuthToken "your_api_key" -OrgId "1234" -metrics @("temperature", "humidity") -perPage 100
    
    Retrieves the latest sensor readings for the organization with ID "1234" for the "temperature" and "humidity" metrics, with 100 entries per page.
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
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/sensor/readings/latest?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
        Write-Debug $_
        Throw $_
    }
    }
}