function Get-MerakiOrganizationDevicesPacketCaptureCaptures {
<#
.SYNOPSIS
Retrieves packet capture records for devices in a Meraki organization, with optional filtering and pagination.

.DESCRIPTION
Get-MerakiOrganizationDevicesPacketCaptureCaptures returns packet capture metadata for devices within a specified Meraki organization. Results can be filtered by capture ID, network, device serial, process, capture status, name, client MAC, notes, device name, admin name and time range. Supports pagination and sort order.

.PARAMETER AuthToken
The API key used to authenticate to the Meraki API. (string, mandatory)

.PARAMETER OrganizationID
The organization ID to query. If not provided, the function will attempt to determine the organization ID using the provided AuthToken. (string)

.PARAMETER captureIds
array of strings
Return the packet captures of the specified capture ids.

.PARAMETER networkIds
array of strings
Return the packet captures of the specified network(s).

.PARAMETER serials
array of strings
Return the packet captures of the specified device(s) (by serial number).

.PARAMETER process
array of strings
Return the packet captures of the specified process.

.PARAMETER captureStatus
array of string
Return the packet captures of the specified capture status.

.PARAMETER name
array of string
Return the packet captures matching the specified name.

.PARAMETER clientMac
array of string
Return the packet captures matching the specified client MAC address(es).

.PARAMETER notes
string
Return the packet captures matching the specified notes.

.PARAMETER deviceName
string
Return the packet captures matching the specified device name.

.PARAMETER adminName
string
Return the packet captures matching the specified admin name.

.PARAMETER t0
string
The beginning of the timespan for the data (ISO 8601 or timestamp). The maximum lookback period is 365 days from today. Do not specify t0/t1 if using timespan.

.PARAMETER t1
string
The end of the timespan for the data (ISO 8601 or timestamp). t1 can be a maximum of 365 days after t0. Do not specify t0/t1 if using timespan.

.PARAMETER timespan
number
The timespan in seconds for which the information will be fetched. If specifying timespan, do not specify parameters t0 and t1. The value must be in seconds and be less than or equal to 365 days. The default is 365 days.
Maximum = 31536000

.PARAMETER perPage
integer
The number of entries per page returned. Acceptable range is 3 - 100. Default is 10.

.PARAMETER startingAfter
string
A token used by the server to indicate the start of the page. Often provided by the Link header for pagination. Client applications should not construct this token.

.PARAMETER endingBefore
string
A token used by the server to indicate the end of the page. Often provided by the Link header for pagination. Client applications should not construct this token.

.PARAMETER sortOrder
string
Sorted order of entries. Valid values: "ascending" or "descending". Default is "descending".
enum = ["ascending","descending"]

.EXAMPLE
# Retrieve captures for specific networks within the organization
Get-MerakiOrganizationDevicesPacketCaptureCaptures -AuthToken $token -OrganizationID "1234" -networkIds @("N_1","N_2") -perPage 50


#>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$false)]
        [array]$captureIds = $null,
        [parameter(Mandatory=$false)]
        [array]$networkIds = $null,
        [parameter(Mandatory=$false)]
        [array]$serials = $null,
        [parameter(Mandatory=$false)]
        [array]$process = $null,
        [parameter(Mandatory=$false)]
        [array]$captureStatus = $null,
        [parameter(Mandatory=$false)]
        [array]$name = $null,
        [parameter(Mandatory=$false)]
        [array]$clientMac = $null,
        [parameter(Mandatory=$false)]
        [string]$notes = $null,
        [parameter(Mandatory=$false)]
        [string]$deviceName = $null,
        [parameter(Mandatory=$false)]
        [string]$adminName = $null,
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
        [string]$sortOrder = $null
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        Try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "Content-Type" = "application/json"
            }
            $queryParams = @{}
            if ($captureIds) {
                $queryParams['captureIds[]'] = $captureIds
            }
            if ($networkIds) {
                $queryParams['networkIds[]'] = $networkIds
            }
            if ($serials) {
                $queryParams['serials[]'] = $serials
            }
            if ($process) {
                $queryParams['process[]'] = $process
            }
            if ($captureStatus) {
                $queryParams['captureStatus[]'] = $captureStatus
            }
            if ($name) {
                $queryParams['name[]'] = $name
            }
            if ($clientMac) {
                $queryParams['clientMac[]'] = $clientMac
            }
            if ($notes) {
                $queryParams['notes'] = $notes
            }
            if ($deviceName) {
                $queryParams['deviceName'] = $deviceName
            }
            if ($adminName) {
                $queryParams['adminName'] = $adminName
            }
            if ($t0) {
                $queryParams['t0'] = $t0
            }
            if ($t1) {
                $queryParams['t1'] = $t1
            }
            if ($timespan) {
                $queryParams['timespan'] = $timespan
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
            if ($sortOrder) {
                $queryParams['sortOrder'] = $sortOrder
            }
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URI = "https://api.meraki.com/api/v1/organizations/$OrganizationID/devices/packetCapture/captures?$queryString"
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}