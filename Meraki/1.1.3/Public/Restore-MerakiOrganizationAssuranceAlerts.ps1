function Restore-MerakiOrganizationAssuranceAlerts {
    <#
    .SYNOPSIS
    Restores specified assurance alerts for a specified organization.

    .DESCRIPTION
    This function allows you to restore specified assurance alerts for a specified organization by providing the authentication token, organization ID, and alert IDs.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the organization.

    .PARAMETER AlertIds
    Array of alert IDs to restore.

    .EXAMPLE
    Restore-MerakiOrganizationAssuranceAlerts -AuthToken "your-api-token" -OrganizationId "123456" -AlertIds @("alertId1", "alertId2")

    This example restores the specified alerts for the organization with ID "123456".

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string[]]$AlertIds
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $body = @{
                alertIds = $AlertIds
            }

            $bodyJson = $body | ConvertTo-Json -Compress -Depth 4

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/assurance/alerts/restore"

            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $bodyJson
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}