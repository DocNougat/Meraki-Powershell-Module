function Get-MerakiOrganizationDevicesUplinksLossAndLatency {
    <#
    .SYNOPSIS
    Gets the loss and latency information for uplinks of devices in a Meraki organization.

    .DESCRIPTION
    This function retrieves the loss and latency information for uplinks of devices in a Meraki organization. You can filter the results by specifying various parameters.

    .PARAMETER AuthToken
    The API key for accessing the Meraki dashboard.

    .PARAMETER OrgId
    The ID of the organization to retrieve devices from. If not specified, the ID of the first organization associated with the API key will be used.

    .PARAMETER t0
    The beginning of the timespan to query. If not specified, the value of (t1 - 3600) will be used.

    .PARAMETER t1
    The end of the timespan to query. If not specified, the current time will be used.

    .PARAMETER timespan
    The timespan to query, in seconds. If specified, it will override t0 and t1.

    .PARAMETER uplink
    The uplink to filter the results by.

    .PARAMETER ip
    The IP address to filter the results by.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationDevicesUplinksLossAndLatency -AuthToken "1234567890abcdef" -uplink "wan1"

    This example retrieves the loss and latency information for the specified uplink.

    .NOTES
    This function requires the Meraki PowerShell module to be installed. You can install it with the following command:

    Install-Module -Name Cisco.Meraki

    .LINK
    https://developer.cisco.com/meraki/api-v1/#!get-organizations-organization-id-devices-uplinks-loss-and-latency
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
        [string]$uplink = $null,
        [parameter(Mandatory=$false)]
        [string]$ip = $null
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
            if ($uplink) {
                $queryParams['uplink[]'] = $uplink
            }
            if ($ip) {
                $queryParams['ip'] = $ip
            }
        
            $queryString = New-MerakiQueryString -queryParams $queryParams
            $URI = "https://api.meraki.com/api/v1/organizations/$OrganizationID/devices/uplinksLossAndLatency?$queryString"
            $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
            return $response
        } catch {
            Write-Error $_
        }
    }
}