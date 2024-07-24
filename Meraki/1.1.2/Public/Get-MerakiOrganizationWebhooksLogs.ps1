function Get-MerakiOrganizationWebhooksLogs {
    <#
    .SYNOPSIS
    Get the webhook logs for an organization in the Meraki dashboard.

    .DESCRIPTION
    Retrieves the webhook logs for a specified organization in the Meraki dashboard using the Meraki API. This function requires an API key and can optionally accept additional parameters to filter the results.

    .PARAMETER AuthToken
    The Meraki API key to use for authentication.

    .PARAMETER OrgId
    The organization ID to retrieve the webhook logs for. If not specified, the ID of the first organization associated with the provided API key will be used.

    .PARAMETER t0
    The beginning of the time range for the webhook logs to retrieve. Can be a string in ISO 8601 format or a UNIX timestamp in seconds. If timespan is specified, this parameter is ignored.

    .PARAMETER t1
    The end of the time range for the webhook logs to retrieve. Can be a string in ISO 8601 format or a UNIX timestamp in seconds. If timespan is specified, this parameter is ignored.

    .PARAMETER timespan
    The timespan for the webhook logs to retrieve, in seconds. If specified, t0 and t1 parameters are ignored.

    .PARAMETER perPage
    The number of logs to return per page.

    .PARAMETER startingAfter
    Retrieve logs that occur after the log with this ID.

    .PARAMETER endingBefore
    Retrieve logs that occur before the log with this ID.

    .PARAMETER url
    The URL of the webhook to retrieve logs for.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationWebhooksLogs -AuthToken "1234567890" -OrgId "123456" -perPage 100

    Retrieves the webhook logs for the organization with ID "123456" using the provided API key, and returns 100 logs per page.

    .NOTES
    The Meraki API key can be obtained from the Meraki dashboard under Organization > Settings > Dashboard API access.

    The Meraki API documentation for this endpoint can be found at https://developer.cisco.com/meraki/api-v1/#!get-organization-webhook-logs.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$false)]
        [string]$t0 = $null,
        [parameter(Mandatory=$false)]
        [string]$t1 = $null,
        [parameter(Mandatory=$false)]
        [int]$timespan = $null,
        [parameter(Mandatory=$false)]
        [int]$perPage = $null,
        [parameter(Mandatory=$false)]
        [string]$startingAfter = $null,
        [parameter(Mandatory=$false)]
        [string]$endingBefore = $null,
        [parameter(Mandatory=$false)]
        [string]$url = $null
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
            if ($url) {
                $queryParams['url'] = $url
            }
        
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/webhooks/logs?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
            return $response
        } catch {
        Write-Debug $_
        Throw $_
    }
    }
}