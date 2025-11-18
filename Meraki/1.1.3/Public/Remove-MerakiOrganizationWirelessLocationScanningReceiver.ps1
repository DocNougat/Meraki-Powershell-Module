function Remove-MerakiOrganizationWirelessLocationScanningReceiver {
    <#
    .SYNOPSIS
    Removes a wireless location scanning receiver from a Meraki organization.

    .DESCRIPTION
    Removes a location scanning receiver by calling the Meraki Dashboard API DELETE endpoint:
    https://api.meraki.com/api/v1/organizations/{organizationId}/wireless/location/scanning/receivers/{receiverId}
    If OrganizationID is not provided, the function attempts to resolve it via Get-OrgID -AuthToken <AuthToken>. If multiple organizations are found, the function will return a message asking the caller to specify an organization ID. On success, the API response is returned; on failure, an exception is thrown.

    .PARAMETER AuthToken
    The Meraki Dashboard API key used to authenticate requests. This parameter is required.

    .PARAMETER OrganizationID
    The Meraki organization ID from which the receiver will be removed. If omitted, the function attempts to obtain the organization ID using Get-OrgID -AuthToken $AuthToken. If multiple organizations are present, specify this parameter explicitly.

    .PARAMETER ReceiverId
    The identifier of the location scanning receiver to remove. This parameter is required.

    .EXAMPLE
    # Remove a receiver by specifying organization and receiver IDs
    Remove-MerakiOrganizationWirelessLocationScanningReceiver -AuthToken 'YOUR_API_KEY' -OrganizationID '123456' -ReceiverId '7890'

    .NOTES
    - The function sets the request headers: "X-Cisco-Meraki-API-Key" and "content-type: application/json; charset=utf-8".
    - Ensure the provided API key has sufficient permissions and that outbound HTTPS to api.meraki.com is permitted.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$ReceiverId
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
            
            $response = Invoke-RestMethod -Method Delete -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}