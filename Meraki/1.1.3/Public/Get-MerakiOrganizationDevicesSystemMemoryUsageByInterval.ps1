function Get-MerakiOrganizationDevicesSystemMemoryUsageByInterval {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [Parameter(Mandatory=$false)]
        [int]$perPage = $null,
        [Parameter(Mandatory=$false)]
        [string]$startingAfter = $null,
        [Parameter(Mandatory=$false)]
        [string]$endingBefore = $null,
        [Parameter(Mandatory=$false)]
        [string]$t0 = $null,
        [Parameter(Mandatory=$false)]
        [string]$t1 = $null,
        [Parameter(Mandatory=$false)]
        [int]$timespan = $null,
        [Parameter(Mandatory=$false)]
        [int]$Interval = $null,
        [Parameter(Mandatory=$false)]
        [array]$networkIds = $null,
        [Parameter(Mandatory=$false)]
        [array]$serials = $null,
        [Parameter(Mandatory=$false)]
        [array]$productTypes = $null
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
            If ($perPage) {
                $queryParams['perPage'] = $perPage
            }
            If ($startingAfter) {
                $queryParams['startingAfter'] = $startingAfter
            }
            If ($endingBefore) {
                $queryParams['endingBefore'] = $endingBefore
            }
            If ($t0) {
                $queryParams['t0'] = $t0
            }
            If ($t1) {
                $queryParams['t1'] = $t1
            }
            If ($timespan) {
                $queryParams['timespan'] = $timespan
            }
            If ($Interval) {
                $queryParams['interval'] = $Interval
            }
            if ($networkIds) {
                $queryParams['networkIds[]'] = $networkIds
            }
            if ($serials) {
                $queryParams['serials[]'] = $serials
            }
            if ($productTypes) {
                $queryParams['productTypes[]'] = $productTypes
            }
            
            $queryString = New-MerakiQueryString -queryParams $queryParams
            $URI = "https://api.meraki.com/api/v1/organizations/$OrganizationID/devices/system/memory/usage/history/byInterval?$queryString"
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"

            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}
