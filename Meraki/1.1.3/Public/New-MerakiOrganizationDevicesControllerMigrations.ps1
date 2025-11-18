function New-MerakiOrganizationDevicesControllerMigrations {
    <#
    .SYNOPSIS
    Creates controller migration tasks for devices in a Meraki organization.

    .DESCRIPTION
    New-MerakiOrganizationDevicesControllerMigrations issues a POST to the Meraki API endpoint
    /organizations/{organizationId}/devices/controller/migrations to create device controller migrations.
    The function builds required request headers (including the X-Cisco-Meraki-API-Key), posts the provided
    migration configuration JSON body, and returns the deserialized API response. If OrganizationID is not
    provided, it attempts to discover it via Get-OrgID -AuthToken $AuthToken. If Get-OrgID returns the
    string "Multiple organizations found. Please specify an organization ID.", the function returns that
    message and does not call the API.

    .PARAMETER AuthToken
    The Meraki API key to authenticate the request. This parameter is mandatory.

    .PARAMETER OrganizationID
    The Meraki organization ID to target. If omitted, the function calls Get-OrgID -AuthToken $AuthToken
    to determine the organization. If multiple organizations are found, the function returns the message
    "Multiple organizations found. Please specify an organization ID." instead of calling the API.
    This parameter is optional.

    .PARAMETER MigrationConfig
    A JSON-formatted string containing the migration configuration payload required by the Meraki API.
    This should be a valid JSON body for the migrations endpoint (for example produced with ConvertTo-Json
    or read from a file using Get-Content -Raw). This parameter is mandatory.

    .EXAMPLE
    # Provide token and JSON body inline (ensure JSON string is properly quoted/escaped)
    $token = 'abcd1234'
    $json = @{
        serials = @("Q2XX-XXXX-XXXX","ABC1-2345-6789")
        target = "wirelessController"
    } | ConvertTo-Json -Depth 10 -Compress
    New-MerakiOrganizationDevicesControllerMigrations -AuthToken $token -MigrationConfig $json

    .NOTES
    - The function sets a User-Agent of "MerakiPowerShellModule/1.1.3 DocNougat" and Content-Type
        "application/json; charset=utf-8".
    - Ensure the MigrationConfig string is valid JSON as required by the Meraki migrations API.
    - HTTP or API errors encountered during the Invoke-RestMethod call will be thrown to the caller;
        enable debugging or trap/try/catch around the call to inspect details.
    - This function targets the Meraki API v1 endpoint for organization device controller migrations.

    #>    
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$MigrationConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/devices/controller/migrations"

            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $MigrationConfig
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}