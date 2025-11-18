function Set-MerakiOrganizationWirelessLocationScanningReceiver {
    <# 
    .SYNOPSIS
    Updates a wireless location scanning receiver for a Meraki organization.

    .DESCRIPTION
    Sends a PUT request to the Meraki Dashboard API to update an existing wireless location scanning receiver under the specified organization. The function authenticates using a Meraki API key. If OrganizationID is not provided, the function attempts to infer it via Get-OrgID -AuthToken. ReceiverConfig must be provided as a JSON string or a PowerShell object (convertible to JSON) that matches the Meraki API schema for location scanning receivers.

    .PARAMETER AuthToken
    Meraki API key used to authenticate the request. This parameter is mandatory.

    .PARAMETER OrganizationID
    The Meraki organization ID in which to create the receiver. If omitted, the function calls Get-OrgID -AuthToken to determine a single organization ID. If multiple organizations are found, the function will require an explicit OrganizationID.

    .PARAMETER ReceiverID
    The unique identifier of the receiver to be updated.

    .PARAMETER ReceiverConfig
    The request body for the new receiver. Can be a JSON-formatted string or a PowerShell object/hashtable that can be converted to JSON. Must include the fields required by the Meraki API (for example: name, latitude, longitude, floor, and any other provider-specific properties).

    .EXAMPLE
    # Provide a JSON string for the receiver configuration
    $ReceiverConfigJson = @{
        url       = "https://example.com/receiver"
        version   = "3"
        radio     = @{
            type = "Wi-Fi"
        }
    } | ConvertTo-Json -Depth 10 -Compress
    New-MerakiOrganizationWirelessLocationScanningReceiver -AuthToken 'ABCDEF...' -OrganizationID '123456' -ReceiverConfig $ReceiverConfigJson

    .NOTES
    - The function performs a POST to: /organizations/{organizationId}/wireless/location/scanning/receivers
    - Ensure the provided API key has permissions to manage wireless location scanning resources.
    - Validate ReceiverConfig against the Meraki API documentation for required and optional fields before calling.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$false)]
        [string]$ReceiverID,
        [parameter(Mandatory=$true)]
        [string]$ReceiverConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
            
            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/wireless/location/scanning/receivers/$ReceiverId"

            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $ReceiverConfig
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}