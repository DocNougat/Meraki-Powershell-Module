function Set-MerakiOrganizationCellularGatewayEsimsSwap {
    <#
    .SYNOPSIS
    Gets the status of an eSIM profile swap operation for Meraki Cellular Gateway devices within an organization.

    .DESCRIPTION
    Calls the Meraki REST API endpoint to Gets the status of an eSIM profile swap operation for Meraki Cellular Gateway devices within an organization. 
    The function issues a PUT to /organizations/{organizationId}/cellularGateway/esims/swap/{id} using the provided API key and JSON request body. 
    If OrganizationID is omitted, the function attempts to resolve an organization ID by calling Get-OrgID -AuthToken $AuthToken. 
    If multiple organizations are found, the function will return the message "Multiple organizations found. Please specify an organization ID."

    .PARAMETER AuthToken
    The Meraki API key used for authentication. This parameter is mandatory.

    .PARAMETER OrganizationID
    The Meraki organization ID in which to perform the eSIM swap. This parameter is optional; when not provided the function will try to determine the organization ID via Get-OrgID. If multiple organizations are returned by Get-OrgID the user must provide an explicit OrganizationID.

    .PARAMETER eSIMEID
    The eSIM EID. This parameter is mandatory.

    .EXAMPLE    
    Set-MerakiOrganizationCellularGatewayEsimsSwap -AuthToken $token -eSIMEID "890192345982"

    .NOTES
    - Requires network access to api.meraki.com.
    - The function sets Content-Type to "application/json; charset=utf-8" and uses a custom UserAgent ("MerakiPowerShellModule/1.1.3 DocNougat").
    - Ensure the AuthToken has sufficient privileges to perform eSIM operations in the target organization.

    .LINK
    https://developer.cisco.com/meraki/api-v1/
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$eSIMEID
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/cellularGateway/esims/swap/$eSIMEID"

            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}