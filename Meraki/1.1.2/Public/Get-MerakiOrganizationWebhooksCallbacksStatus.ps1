function Get-MerakiOrganizationWebhooksCallbacksStatus {
    <#
    .SYNOPSIS
    Retrieves the status of a specific webhook callback for an organization.

    .DESCRIPTION
    This function allows you to retrieve the status of a specific webhook callback for a given organization by providing the authentication token, organization ID, and callback ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the organization.

    .PARAMETER CallbackId
    The ID of the webhook callback.

    .EXAMPLE
    Get-MerakiOrganizationWebhooksCallbacksStatus -AuthToken "your-api-token" -OrganizationId "123456" -CallbackId "7890"

    This example retrieves the status of the webhook callback with ID "7890" for the organization with ID "123456".

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationId = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$CallbackId
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/webhooks/callbacks/statuses/$CallbackId"

            $response = Invoke-RestMethod -Method Get -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}
