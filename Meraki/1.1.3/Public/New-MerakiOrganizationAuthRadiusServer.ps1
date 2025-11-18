function New-MerakiOrganizationAuthRadiusServer {
    <#
    .SYNOPSIS
    Creates a new RADIUS server for a Meraki organization.

    .DESCRIPTION
    New-MerakiOrganizationAuthRadiusServer sends a POST request to the Meraki Dashboard API to create a new authentication RADIUS server configuration for the specified organization.
    The function requires a valid Meraki API key and a JSON payload describing the RADIUS server configuration. If OrganizationID is not provided, the function attempts to resolve a single organization ID using the provided AuthToken via Get-OrgID; if multiple organizations are returned, the function will prompt to specify an OrganizationID.

    .PARAMETER AuthToken
    The Meraki API key used to authenticate the request. This parameter is required.

    .PARAMETER ServerConfig
    A JSON string that represents the RADIUS server configuration payload expected by the Meraki API. Provide a JSON payload (for example produced by ConvertTo-Json on a hashtable/PSCustomObject) that matches the schema for an organization's RADIUS server. This parameter is required.

    .PARAMETER OrganizationID
    The ID of the Meraki organization where the RADIUS server will be created. If omitted, the function attempts to retrieve the organization ID automatically using Get-OrgID -AuthToken <AuthToken>. If multiple organizations are found, the function returns the message: "Multiple organizations found. Please specify an organization ID."

    .EXAMPLE
    # Using an explicit OrganizationID and JSON payload (string)
    $auth = '0123456789abcdef0123456789abcdef01234567'
    $jsonPayload = @{
        name = "corp-radius-1"
        address = "10.0.0.10"
        modes = @( 
            @{
                mode = "auth"
                port = 1812
            }
        )
        secret = "s3cret"
    } | ConvertTo-Json -Depth 5 -compress

    New-MerakiOrganizationAuthRadiusServer -AuthToken $auth -ServerConfig $jsonPayload -OrganizationID '123456'

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

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/auth/radius/servers"

            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}