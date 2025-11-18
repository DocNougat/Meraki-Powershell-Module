function New-MerakiOrganizationWirelessZigbeeDisenrollment {
    <#
    .SYNOPSIS
    Creates a Zigbee disenrollment for a Meraki organization.

    .DESCRIPTION
    New-MerakiOrganizationWirelessZigbeeDisenrollment submits a POST request to the Meraki API to create a Zigbee disenrollment under the specified organization. The function expects a Meraki API key and a JSON body describing the disenrollment configuration. If OrganizationID is not supplied, the function attempts to resolve it via Get-OrgID -AuthToken <token>. If multiple organizations are found, the function returns the message "Multiple organizations found. Please specify an organization ID.".

    .PARAMETER AuthToken
    The Meraki API key (X-Cisco-Meraki-API-Key) used to authenticate the request. This parameter is mandatory.

    .PARAMETER OrganizationID
    The Meraki organization ID where the Zigbee disenrollment will be created. If omitted, the function calls Get-OrgID -AuthToken $AuthToken to attempt to determine a single organization ID. If Get-OrgID returns the string "Multiple organizations found. Please specify an organization ID.", that string is returned and the operation is aborted.

    .PARAMETER DisenrollmentConfig
    A string containing the JSON body for the disenrollment request. This must conform to the Meraki API schema for a Zigbee disenrollment. This parameter is mandatory.

    .EXAMPLE
    # Provide an explicit organization ID and a JSON payload string
    $payload = @{
        doorLockIds = @("Q2XX", "Q2YY")
    } | ConvertTo-Json -Depth 10 -Compress
    New-MerakiOrganizationWirelessZigbeeDisenrollment -AuthToken $apiKey -OrganizationID "123456" -DisenrollmentConfig $payload

    .NOTES
    - Uses the Meraki API endpoint:
        https://api.meraki.com/api/v1/organizations/{organizationId}/wireless/zigbee/disenrollments
    - Ensure the AuthToken has sufficient privileges to create Zigbee disenrollments.

    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$DisenrollmentConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/wireless/zigbee/disenrollments"

            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $DisenrollmentConfig
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}