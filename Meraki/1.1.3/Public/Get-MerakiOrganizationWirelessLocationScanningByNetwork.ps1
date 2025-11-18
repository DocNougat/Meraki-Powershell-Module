function Get-MerakiOrganizationWirelessLocationScanningByNetwork {
    <#
    .SYNOPSIS
    Retrieves wireless location scanning configuration by network for a given Meraki organization.

    .DESCRIPTION
    Get-MerakiOrganizationWirelessLocationScanningByNetwork calls the Meraki Dashboard API endpoint
    (/organizations/{organizationId}/wireless/location/scanning/byNetwork) to return location scanning
    settings grouped by network. The function assembles query parameters for pagination and filtering,
    sets the required API key header (X-Cisco-Meraki-API-Key) and performs an HTTP GET using Invoke-RestMethod.
    On success the API response object is returned. Errors from the request are thrown.

    .PARAMETER AuthToken
    String. Mandatory. The Cisco Meraki API key to use for authentication. This value is included
    in the X-Cisco-Meraki-API-Key header for the request.

    .PARAMETER OrganizationID
    String. Optional. The organization identifier to target. If not provided, the function attempts to
    resolve a default via Get-OrgID -AuthToken $AuthToken. If multiple organizations are found and no
    OrganizationID is specified, the function returns the string:
    "Multiple organizations found. Please specify an organization ID."

    .PARAMETER perPage
    Int. Optional. The number of entries per page to request from the API for paginated responses.

    .PARAMETER startingAfter
    String. Optional. Cursor-based pagination parameter. When supplied, results start after this cursor.

    .PARAMETER endingBefore
    String. Optional. Cursor-based pagination parameter. When supplied, results end before this cursor.

    .PARAMETER networkIds
    Array. Optional. One or more network IDs to filter the response by. When sent to the API the parameter
    is encoded as networkIds[] and supports multiple values.

    .EXAMPLE
    # Basic usage with explicit organization
    Get-MerakiOrganizationWirelessLocationScanningByNetwork -AuthToken $token -OrganizationID "123456"

    .NOTES
    - The function constructs query parameters and escapes the final URI before issuing the request.
    - Ensure the provided AuthToken has sufficient permissions to read organization wireless settings.
    - This helper relies on Get-OrgID when OrganizationID is omitted; ensure Get-OrgID is available in the session.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$false)]
        [int]$perPage,
        [parameter(Mandatory=$false)]
        [string]$startingAfter,
        [parameter(Mandatory=$false)]
        [string]$endingBefore,
        [parameter(Mandatory=$false)]
        [array]$networkIds
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try { 
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
            }
            $queryParams = @{}
            If ($perPage) { 
                $queryParams["perPage"] = $perPage 
            }
            If ($startingAfter) { 
                $queryParams["startingAfter"] = $startingAfter 
            }
            If ($endingBefore) { 
                $queryParams["endingBefore"] = $endingBefore 
            }
            If ($networkIds) { 
                $queryParams["networkIds[]"] = $networkIds
            }
                    
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/wireless/location/scanning/byNetwork?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}