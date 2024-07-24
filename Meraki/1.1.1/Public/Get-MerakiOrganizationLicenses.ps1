function Get-MerakiOrganizationLicenses {
    <#
    .SYNOPSIS
    Retrieves a list of licenses in an organization or for a specific device/network.
    
    .PARAMETER AuthToken
    Required. The authorization token for the Meraki dashboard API.
    
    .PARAMETER OrgId
    Optional. The ID of the organization for which to retrieve licenses. If not specified, the ID of the first organization associated with the provided authorization token will be used.
    
    .PARAMETER perPage
    Optional. The number of licenses per page to include in the response.
    
    .PARAMETER startingAfter
    Optional. A license ID to use as the starting point for the response.
    
    .PARAMETER endingBefore
    Optional. A license ID to use as the ending point for the response.
    
    .PARAMETER deviceSerial
    Optional. The serial number of a device for which to retrieve licenses.
    
    .PARAMETER networkId
    Optional. The ID of a network for which to retrieve licenses.
    
    .PARAMETER state
    Optional. The state of the licenses to retrieve. Valid values are "active", "expired", "expiring", and "unused".
    
    .EXAMPLE
    PS C:\> Get-MerakiOrganizationLicenses -AuthToken '1234' -perPage 50
    
    Retrieves a list of the first 50 licenses in the first organization associated with the provided authorization token.
    
    .EXAMPLE
    PS C:\> Get-MerakiOrganizationLicenses -AuthToken '1234' -networkId 'L_1234' -state 'active'
    
    Retrieves a list of all active licenses for the network with the ID 'L_1234'.
    #>
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
        [string]$DeviceSerial = $null,
        [parameter(Mandatory=$false)]
        [string]$networkId = $null,
        [parameter(Mandatory=$false)]
        [string]$state = $null
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
            if ($DeviceSerial) {
                $queryParams['deviceSerial'] = $DeviceSerial
            }
            if ($networkId) {
                $queryParams['networkId'] = $networkId
            }
            if ($state) {
                $queryParams['state'] = $state
            }
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URI = "https://api.meraki.com/api/v1/organizations/$OrganizationID/licenses?$queryString"
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}
