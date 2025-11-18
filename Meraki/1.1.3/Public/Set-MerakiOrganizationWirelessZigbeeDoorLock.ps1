function Set-MerakiOrganizationWirelessZigbeeDoorLock {
    <#
    .SYNOPSIS
    Updates configuration for a Zigbee door lock in a Meraki wireless organization.

    .DESCRIPTION
    Set-MerakiOrganizationWirelessZigbeeDoorLock sends a POST request to the Meraki Dashboard API to update the configuration of a Zigbee door lock associated with a specified organization. If OrganizationID is not supplied, the function attempts to resolve it by calling Get-OrgID with the provided AuthToken. If multiple organizations are returned by Get-OrgID, the function returns a message asking the caller to specify an OrganizationID.

    .PARAMETER AuthToken
    The Meraki API authentication token. This token is sent in the X-Cisco-Meraki-API-Key request header. This parameter is required.

    .PARAMETER OrganizationID
    The Meraki organization ID containing the Zigbee door lock. If omitted, the function attempts to determine the organization ID by calling Get-OrgID -AuthToken $AuthToken. If Get-OrgID returns multiple matches, the function will return an error message asking the caller to specify an organization ID.

    .PARAMETER DoorLockID
    The identifier of the Zigbee door lock to update. This parameter is required.

    .PARAMETER DoorLockConfig
    The configuration payload to apply to the door lock. Provide a JSON-formatted string or a PowerShell object that can be converted to JSON. The function posts this payload as the request body with content-type "application/json; charset=utf-8". This parameter is required.

    .EXAMPLE
    $auth = "ABCDEFG1234567890"
    $lockId = "1234"
    $config = @{ 
        name = "FrontDoor" 
    } | ConvertTo-Json -Depth 10 -Compress
    Set-MerakiOrganizationWirelessZigbeeDoorLock -AuthToken $auth -DoorLockID $lockId -DoorLockConfig $config

    .NOTES
    - API endpoint pattern: https://api.meraki.com/api/v1/organizations/{organizationId}/wireless/zigbee/doorLocks/{doorLockId}
    - Ensure the provided AuthToken has the necessary permissions to modify the organization's Zigbee door lock settings.
    - The function will throw an exception on HTTP or invocation errors; callers can trap or handle exceptions as needed.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$DoorLockID,
        [parameter(Mandatory=$true)]
        [string]$DoorLockConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/wireless/zigbee/doorLocks/$DoorLockID"

            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $DoorLockConfig
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}