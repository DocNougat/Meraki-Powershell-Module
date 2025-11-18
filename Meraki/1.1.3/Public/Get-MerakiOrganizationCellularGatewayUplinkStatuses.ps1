function Get-MerakiOrganizationCellularGatewayUplinkStatuses {
    <#
    .SYNOPSIS
    Retrieves the uplink status of cellular gateways in an organization.

    .DESCRIPTION
    This function retrieves the uplink status of cellular gateways in an organization.

    .PARAMETER AuthToken
    The Meraki Dashboard API token.

    .PARAMETER OrgId
    The ID of the organization. If not specified, the function will use the ID of the first organization associated with the token.

    .PARAMETER perPage
    The number of entries per page returned. Default is 10, maximum is 1000.

    .PARAMETER startingAfter
    A string representing the starting point for the next set of records. This value should be taken from the "nextPageToken" field returned in a previous request.

    .PARAMETER endingBefore
    A string representing the ending point for the previous set of records. This value should be taken from the "previousPageToken" field returned in a previous request.

    .PARAMETER networkIds
    An array of network IDs to filter the results by.

    .PARAMETER serials
    An array of serial numbers to filter the results by.

    .PARAMETER iccids
    An array of SIM card ICCIDs to filter the results by.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationCellularGatewayUplinkStatuses -AuthToken '1234' -OrgId '5678'

    Retrieves the uplink status of all cellular gateways in the organization with ID '5678'.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationCellularGatewayUplinkStatuses -AuthToken '1234' -networkIds 'abcd', 'efgh'

    Retrieves the uplink status of all cellular gateways in the networks with IDs 'abcd' and 'efgh'.
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
        [array]$iccids = $null
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
            if ($iccids) {
                $queryParams['iccids[]'] = $iccids
            }
        
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/cellularGateway/uplink/statuses?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
        Write-Debug $_
        Throw $_
    }
    }
}