function Get-MerakiOrganizationWirelessZigbeeDisenrollment {
    <#
    .SYNOPSIS
        Retrieves a Meraki organization wireless Zigbee disenrollment by ID.

    .DESCRIPTION
        Gets details for a single Zigbee disenrollment in a specified Meraki organization using the Meraki Dashboard API.
        The function sends the supplied API key in the X-Cisco-Meraki-API-Key header. If OrganizationID is omitted,
        the function attempts to resolve a single organization ID by calling Get-OrgID -AuthToken <AuthToken>. If multiple
        organizations are found, the function will request an explicit OrganizationID.

    .PARAMETER AuthToken
        The Meraki API key used to authenticate the request. This value is required and is sent in the
        X-Cisco-Meraki-API-Key header.

    .PARAMETER OrganizationID
        The Meraki organization identifier that contains the Zigbee disenrollment. If not provided, the helper
        Get-OrgID -AuthToken <AuthToken> is called to auto-resolve a single organization ID. If multiple organizations
        exist, the function will return a message asking the caller to specify an organization ID.

    .PARAMETER DisenrollmentId
        The ID of the Zigbee disenrollment to retrieve. This value is required.

    .EXAMPLE
        Get-MerakiOrganizationWirelessZigbeeDisenrollment -AuthToken '123456789abcdef' -DisenrollmentId 'abc123'
        Retrieves the specified Zigbee disenrollment for the organization automatically resolved by Get-OrgID.

    .NOTES
        - Requires a valid Meraki API key with permissions to read organization wireless/zigbee resources.
        - Performs an HTTP GET to:
        https://api.meraki.com/api/v1/organizations/{organizationId}/wireless/zigbee/disenrollments/{disenrollmentId}

    .LINK
        https://developer.cisco.com/meraki/api-v1/  # Meraki Dashboard API documentation
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$DisenrollmentId
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try { 
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
            }

            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/wireless/zigbee/disenrollments/$DisenrollmentId"

            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}