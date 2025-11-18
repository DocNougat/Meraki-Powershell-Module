
function Get-MerakiOrganizationSensorGatewaysConnectionsLatest {
    <#
    .SYNOPSIS
    Retrieves the latest gateway connection information for sensors in a Meraki organization.

    .DESCRIPTION
    Get-MerakiOrganizationSensorGatewaysConnectionsLatest calls the Meraki API endpoint
    /organizations/{organizationId}/sensor/gateways/connections/latest and returns the most
    recent gateway connection details for sensors in the specified organization. The function
    builds query parameters for pagination and sensor filtering, sends the request using the
    provided API key, and returns the deserialized JSON response as PowerShell objects.

    .PARAMETER AuthToken
    The Meraki API key used for authentication. This parameter is mandatory and is sent in
    the X-Cisco-Meraki-API-Key request header.

    .PARAMETER OrganizationID
    The Meraki organization ID to query. If not specified, the function attempts to obtain the
    organization ID by calling Get-OrgID -AuthToken $AuthToken. If multiple organizations are
    found, the function returns the message "Multiple organizations found. Please specify an organization ID."
    Provide an explicit OrganizationID to avoid ambiguity.

    .PARAMETER perPage
    (Optional) The number of items to return per page. Must be an integer between 3 and 1000.
    If omitted, the API default page size is used.

    .PARAMETER startingAfter
    (Optional) Pagination token. Return items starting after the specified resource ID. Use this
    to page forward through results.

    .PARAMETER endingBefore
    (Optional) Pagination token. Return items ending before the specified resource ID. Use this
    to page backward through results.

    .PARAMETER SensorSerials
    (Optional) An array of sensor serial numbers to filter results to one or more sensors.
    These are passed as repeated query parameters (sensorSerials[]). Example: -SensorSerials 'Q123-45','Q678-90'

    .EXAMPLE
    # Basic: use AuthToken and let the function determine the organization (via Get-OrgID)
    Get-MerakiOrganizationSensorGatewaysConnectionsLatest -AuthToken 'abcdef123456'

    .NOTES
    - Requests include the X-Cisco-Meraki-API-Key header with the provided AuthToken.
    - The function constructs query parameters for perPage, startingAfter, endingBefore, and sensorSerials[].
    - Errors thrown by Invoke-RestMethod are written to the debug stream and re-thrown to the caller.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$false)]
        [ValidateRange(3, 1000)]
        [int]$perPage = $null,
        [parameter(Mandatory=$false)]
        [string]$startingAfter = $null,
        [parameter(Mandatory=$false)]
        [string]$endingBefore = $null,
        [parameter(Mandatory=$false)]
        [array]$SensorSerials
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                'X-Cisco-Meraki-API-Key' = $AuthToken
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
            if ($SensorSerials) {
                $queryParams['sensorSerials[]'] = $SensorSerials
            }

            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/sensor/gateways/connections/latest?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}