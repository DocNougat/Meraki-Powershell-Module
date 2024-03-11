function Get-MerakiOrganizationWirelessDevicesEthernetStatuses {
    <#
    .SYNOPSIS
    Get the Ethernet statuses of wireless devices for an organization in the Meraki dashboard.

    .DESCRIPTION
    Retrieves the Ethernet statuses of wireless devices for a specified organization in the Meraki dashboard using the Meraki API. This function requires an API key and can optionally accept additional parameters to filter the results.

    .PARAMETER AuthToken
    The Meraki API key to use for authentication.

    .PARAMETER OrgId
    The organization ID to retrieve the Ethernet statuses for. If not specified, the ID of the first organization associated with the provided API key will be used.

    .PARAMETER perPage
    The number of Ethernet statuses to return per page.

    .PARAMETER startingAfter
    Retrieve Ethernet statuses that occur after the status with this ID.

    .PARAMETER endingBefore
    Retrieve Ethernet statuses that occur before the status with this ID.

    .PARAMETER networkIds
    An array of network IDs to retrieve Ethernet statuses for. If not specified, statuses for all networks in the organization will be retrieved.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationWirelessDevicesEthernetStatuses -AuthToken "1234567890" -OrgId "123456" -perPage 100

    Retrieves the Ethernet statuses for the organization with ID "123456" using the provided API key, and returns 100 statuses per page.

    .NOTES
    The Meraki API key can be obtained from the Meraki dashboard under Organization > Settings > Dashboard API access.

    The Meraki API documentation for this endpoint can be found at https://developer.cisco.com/meraki/api-v1/#!get-organization-wireless-devices-ethernet-statuses.
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
        [array]$networkIds = $null
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
        
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/wireless/devices/ethernet/statuses?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
            return $response
        } catch {
        Write-Debug $_
        Throw $_
    }
    }
}