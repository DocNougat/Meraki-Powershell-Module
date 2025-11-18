function Set-MerakiOrganizationAuthRadiusServer {
    <#
    .SYNOPSIS
    Updates an existing RADIUS server configuration for a Meraki organization.

    .DESCRIPTION
    Sends a PUT request to the Meraki API endpoint for organization RADIUS servers to update the server identified by ServerID. The ServerConfig parameter should contain the RADIUS server settings as JSON (string) or an object that can be converted to JSON. If OrganizationID is omitted, the function attempts to discover a single organization ID via Get-OrgID -AuthToken; if multiple organizations are returned, you must supply OrganizationID explicitly.

    .PARAMETER AuthToken
    The Meraki API key. Supplied as the X-Cisco-Meraki-API-Key header. Required.

    .PARAMETER ServerID
    The identifier (ID) of the RADIUS server to update. Required.

    .PARAMETER ServerConfig
    The RADIUS server configuration payload. Provide JSON as a string or a PowerShell object that represents the payload. 

    .PARAMETER OrganizationID
    The Meraki organization ID to operate on. If not provided, the function will call Get-OrgID -AuthToken to determine the organization. If multiple organizations are found, the function will return an instructive message and abort; in that case supply OrganizationID explicitly. Optional.

    .EXAMPLE
    # Using a JSON string for ServerConfig:
    $json = '{
    "name":"HQ RADIUS server",
    "address":"1.2.3.4",
    "modes":[{"mode":"auth","port":1812}],
    "secret":"secret"
    }'
    Set-MerakiOrganizationAuthRadiusServer -AuthToken 'APIKEY' -ServerID 'server123' -ServerConfig $json -OrganizationID 'org_456'

    .EXAMPLE
    # Using a PowerShell object for ServerConfig:
    $config = @{
    name = 'HQ RADIUS server'
    address = '1.2.3.4'
    modes = @(@{ mode = 'auth'; port = 1812 })
    secret = 'secret'
    }
    Set-MerakiOrganizationAuthRadiusServer -AuthToken 'APIKEY' -ServerID 'server123' -ServerConfig ($config | ConvertTo-Json -Depth 5)

    .RETURNS
    The response object from Invoke-RestMethod (typically the updated RADIUS server resource in JSON converted to a PowerShell object).

    .NOTES
    - Early API Access must be enabled on the target organization to use this endpoint.
    - Requires network access to api.meraki.com.
    - The provided API key must have write permission for the target organization.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$ServerID,
        [parameter(Mandatory=$true)]
        [string]$ServerConfig,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken)
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
            
            $body = $ServerConfig

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/auth/radius/servers/$ServerID"
            
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}