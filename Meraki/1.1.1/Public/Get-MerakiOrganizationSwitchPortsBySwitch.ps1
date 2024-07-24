function Get-MerakiOrganizationSwitchPortsBySwitch {
    <#
    .SYNOPSIS
    Retrieves a list of switch ports for a given switch, optionally filtered by various parameters.
    
    .DESCRIPTION
    This function retrieves a list of switch ports for a given switch in a Meraki organization. The function allows for filtering the results by various parameters, such as the MAC address of the switch port or the IDs of the networks to which the switch belongs.
    
    .PARAMETER AuthToken
    The Meraki Dashboard API token for the Meraki organization.
    
    .PARAMETER OrgId
    The ID of the Meraki organization. If not specified, the ID of the organization associated with the API token will be used.
    
    .PARAMETER perPage
    The number of entries per page returned. Default is 10.
    
    .PARAMETER startingAfter
    The starting port ID for pagination. If not specified, returns from the first port.
    
    .PARAMETER endingBefore
    The ending port ID for pagination. If not specified, returns up to the last port.
    
    .PARAMETER networkIds
    An array of network IDs to filter the ports by. Only ports connected to the specified networks will be returned.
    
    .PARAMETER portProfileIds
    An array of port profile IDs to filter the ports by. Only ports with the specified port profiles will be returned.
    
    .PARAMETER name
    The name of the switch port to filter by. Only ports with a matching name will be returned.
    
    .PARAMETER mac
    The MAC address of the switch port to filter by. Only ports with a matching MAC address will be returned.
    
    .PARAMETER macs
    An array of MAC addresses to filter the ports by. Only ports with a matching MAC address will be returned.
    
    .PARAMETER serial
    The serial number of the switch to retrieve ports for.
    
    .PARAMETER serials
    An array of serial numbers to filter the ports by.
    
    .PARAMETER configurationUpdatedAfter
    Filter ports based on whether they have been updated since a specified time. The time should be specified in ISO 8601 format.
    
    .EXAMPLE
    PS C:\> Get-MerakiOrganizationSwitchPortsBySwitch -AuthToken '12345' -serial 'Q2XX-XXXX-XXXX'
    
    This example retrieves all switch ports for the switch with serial number 'Q2XX-XXXX-XXXX' in the organization associated with the API token '12345'.
    
    .EXAMPLE
    PS C:\> Get-MerakiOrganizationSwitchPortsBySwitch -AuthToken '12345' -serial 'Q2XX-XXXX-XXXX' -name 'Server Port'
    
    This example retrieves all switch ports for the switch with serial number 'Q2XX-XXXX-XXXX' in the organization associated with the API token '12345' that have a name of 'Server Port'.
    
    .NOTES
    For more information, see the official documentation for the Meraki Dashboard API:
    https://developer.cisco.com/meraki/api-v1/#!get-organization-switch-ports-by-switch
    
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
        [array]$networkIds,
        [parameter(Mandatory=$false)]
        [array]$portProfileIds,
        [parameter(Mandatory=$false)]
        [string]$name,
        [parameter(Mandatory=$false)]
        [string]$mac,
        [parameter(Mandatory=$false)]
        [array]$macs,
        [parameter(Mandatory=$false)]
        [string]$serial,
        [parameter(Mandatory=$false)]
        [array]$serials,
        [parameter(Mandatory=$false)]
        [string]$configurationUpdatedAfter
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try { 
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
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
            if ($portProfileIds) {
                $queryParams['portProfileIds[]'] = $portProfileIds
            }
            if ($name) {
                $queryParams['name'] = $name
            }
            if ($mac) {
                $queryParams['mac'] = $mac
            }
            if ($macs) {
                $queryParams['macs[]'] = $macs
            }
            if ($serial) {
                $queryParams['serial'] = $serial
            }
            if ($serials) {
                $queryParams['serials[]'] = $serials
            }
            if ($configurationUpdatedAfter) {
                $queryParams['configurationUpdatedAfter'] = $configurationUpdatedAfter
            }
        
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/switch/ports/bySwitch?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
            return $response
        } catch {
        Write-Debug $_
        Throw $_
    }
    }
}