function Get-MerakiOrganizationCampusGatewayDevicesUplinksLocalOverridesByDevice {
    <#
    .SYNOPSIS
    Retrieves campus gateway devices' uplink local override settings for devices in a Meraki organization.

    .DESCRIPTION
    Get-MerakiOrganizationCampusGatewayDevicesUplinksLocalOverridesByDevice queries the Meraki Dashboard API to return local uplink override configuration for campus gateway devices, optionally filtered by device serial numbers and supporting pagination parameters. The function automatically attempts to resolve the OrganizationID using Get-OrgID when not supplied. If multiple organizations are found, the function returns the message "Multiple organizations found. Please specify an organization ID." The API response (JSON) is converted to PowerShell objects and returned.

    .PARAMETER AuthToken
    The Meraki API key used for authentication. This parameter is mandatory.

    .PARAMETER OrganizationID
    The identifier of the Meraki organization to query. If omitted, the function calls Get-OrgID -AuthToken <AuthToken> to resolve the organization. If multiple organizations are found, the function will return a message asking you to specify an organization ID.

    .PARAMETER perPage
    (Optional) The number of results to return per page for paginated responses. Corresponds to the 'perPage' query parameter accepted by the API.

    .PARAMETER startingAfter
    (Optional) A paging token to indicate where to start returning results. Corresponds to the 'startingAfter' query parameter.

    .PARAMETER endingBefore
    (Optional) A paging token to indicate where to end returning results. Corresponds to the 'endingBefore' query parameter.

    .PARAMETER serials
    (Optional) An array of device serial numbers to filter the results to specific devices. Each element should be a device serial string. These are sent as 'serials[]' query parameters to the API.

    .EXAMPLE
    # Retrieve all uplink local overrides for the specified organization
    Get-MerakiOrganizationCampusGatewayDevicesUplinksLocalOverridesByDevice -AuthToken $apiKey -OrganizationID "123456"

    .EXAMPLE
    # Retrieve uplink local overrides for specific devices
    Get-MerakiOrganizationCampusGatewayDevicesUplinksLocalOverridesByDevice -AuthToken $apiKey -OrganizationID "123456" -serials @("Q2XX-XXXX-XXXX","Q2YY-YYYY-YYYY")

    .NOTES
    - Requires network access to api.meraki.com.
    - Uses header "X-Cisco-Meraki-API-Key" for authentication.
    - Errors from the underlying HTTP request are surfaced as terminating exceptions.
    - This function constructs a query string and calls the endpoint:
        GET /organizations/{organizationId}/campusGateway/devices/uplinks/localOverrides/byDevice

    .LINK
    https://developer.cisco.com/meraki/api/ (refer to Meraki Dashboard API docs for details)
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
        [array]$serials = $null
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
            if ($serials) {
                $queryParams['serials[]'] = $serials
            }
        
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/campusGateway/devices/uplinks/localOverrides/byDevice?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
        Write-Debug $_
        Throw $_
    }
    }
}