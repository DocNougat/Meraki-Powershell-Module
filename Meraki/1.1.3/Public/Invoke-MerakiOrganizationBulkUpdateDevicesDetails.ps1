function Invoke-MerakiOrganizationBulkUpdateDevicesDetails {
<#
.SYNOPSIS
Invokes a bulk update of device details for a specified organization in the Meraki dashboard.

.DESCRIPTION
The Invoke-MerakiOrganizationBulkUpdateDevicesDetails function is used to perform a bulk update of device details for a specified organization in the Meraki dashboard. It requires an authentication token, organization ID, and the bulk update data.

.PARAMETER AuthToken
The authentication token to access the Meraki API.

.PARAMETER OrganizationID
The ID of the organization for which the bulk update is to be performed. If not specified, the function will attempt to retrieve the organization ID using the Get-OrgID function.

.PARAMETER BulkUpdate
The bulk update data in JSON format.

.EXAMPLE
$AuthToken = "your_auth_token"
$BulkUpdate = @{
    serials = @("Q234-ABCD-0001","Q234-ABCD-0002","Q234-ABCD-0003")
    details = @(
        @{
            name = "username"
            value = "ABC"
        },
        @{
            name = "password"
            value = "ABC123"
        },
        @{
            name = "enable password"
            value = "ABC123"
        }
    )
} | ConvertTo-Json -compress -depth 4

Invoke-MerakiOrganizationBulkUpdateDevicesDetails -AuthToken $AuthToken -BulkUpdate $BulkUpdate

.NOTES
This function requires the Meraki PowerShell module version 1.1.3 or later.
#>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$BulkUpdate
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
            $body = $BulkUpdate

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationID/devices/details/bulkUpdate"

            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $body
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}