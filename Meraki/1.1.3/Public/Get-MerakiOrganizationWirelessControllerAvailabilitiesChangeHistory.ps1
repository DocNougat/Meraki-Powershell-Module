function Get-MerakiOrganizationWirelessControllerAvailabilitiesChangeHistory {
    <#
    .SYNOPSIS
    Retrieves the change history for wireless controller availabilities for a Meraki organization.

    .DESCRIPTION
    Calls the Meraki API endpoint to obtain the availability change history of wireless controllers within the specified organization. The function accepts optional time-range and pagination parameters and supports filtering by device serial numbers. If OrganizationID is not provided, the function attempts to resolve it using Get-OrgID -AuthToken <token>.

    .PARAMETER AuthToken
    The API key used to authenticate to the Meraki Dashboard API. This parameter is required.

    .PARAMETER OrganizationID
    The identifier of the Meraki organization to query. If omitted, the function will attempt to determine the organization using Get-OrgID with the provided AuthToken. If multiple organizations are found, the function returns a prompt asking to explicitly provide an OrganizationID.

    .PARAMETER t0
    Optional. The beginning of the timespan for the query. Provide an ISO 8601 timestamp (UTC) or other value accepted by the Meraki API.

    .PARAMETER t1
    Optional. The end of the timespan for the query. Provide an ISO 8601 timestamp (UTC) or other value accepted by the Meraki API.

    .PARAMETER timespan
    Optional. The timespan in seconds (or as accepted by the API) to query from the end time backwards. Use either timespan, or t0/t1 combination.

    .PARAMETER perPage
    Optional. Number of entries per page to return for paginated responses.

    .PARAMETER startingAfter
    Optional. A pagination token indicating that results should start after the supplied value.

    .PARAMETER endingBefore
    Optional. A pagination token indicating that results should end before the supplied value.

    .PARAMETER serials
    Optional. Array of device serial numbers to filter the results to specific devices. When supplied, the parameter is passed as repeated "serials[]" query parameters.

    .EXAMPLE
    Get-MerakiOrganizationWirelessControllerAvailabilitiesChangeHistory -AuthToken $MERAKIAPIKEY -serials @('Q2XX-XXXX-XXXX','Q2YY-YYYY-YYYY') -perPage 50

    Retrieves availability change history for the listed devices with pagination size of 50.

    .NOTES
    - Non-successful HTTP responses will result in an exception being thrown.

    .LINK
    https://developer.cisco.com/meraki/api-v1/#!get-organization-wireless-controller-availabilities-change-history
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
        [string]$timespan = $null,
        [parameter(Mandatory=$false)]
        [int]$perPage,
        [parameter(Mandatory=$false)]
        [string]$startingAfter,
        [parameter(Mandatory=$false)]
        [string]$endingBefore,
        [parameter(Mandatory=$false)]
        [array]$serials
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try { 
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
            }
            $queryParams = @{}
            If ($t0) { 
                $queryParams["t0"] = $t0 
            }
            If ($t1) { 
                $queryParams["t1"] = $t1 
            }
            If ($timespan) { 
                $queryParams["timespan"] = $timespan 
            }
            If ($perPage) { 
                $queryParams["perPage"] = $perPage 
            }
            If ($startingAfter) { 
                $queryParams["startingAfter"] = $startingAfter 
            }
            If ($endingBefore) { 
                $queryParams["endingBefore"] = $endingBefore 
            }
            If ($serials) { 
                $queryParams["serials[]"] = $serials
            }
                    
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/wirelessController/availabilities/changeHistory?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}