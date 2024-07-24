function Invoke-MerakiOrganizationInventoryClaim {
    <#
    .SYNOPSIS
    Add Meraki licenses, devices, or orders to an organization.

    .DESCRIPTION
    This function allows you to add licenses, devices, or orders to an organization in Meraki dashboard.

    .PARAMETER AuthToken
    The authentication token for the Meraki API.

    .PARAMETER OrgId
    The organization ID. If not provided, the function will retrieve the ID of the first organization associated with the specified authentication token.

    .PARAMETER Claim
    A pre-formatted JSON string containing the following properties:
        orders: array[] - The numbers of the orders that should be claimed
        serials: array[] - The serials of the devices that should be claimed
        licenses*: array[] - The licenses that should be claimed
            key*: string - The key of the license
            mode: string - Co-term licensing only: either 'renew' or 'addDevices'. 'addDevices' will increase the license limit, while 'renew' will extend the amount of time until expiration. Defaults to 'addDevices'. All licenses must be claimed with the same mode, and at most one renewal can be claimed at a time. Does not apply to organizations using per-device licensing model.

    .EXAMPLE
    $claim = [PSCustomObject]@{
        orders = @("o1234", "o5678")
        serials = @("s1234", "s5678")
        licenses = @(
            [PSCustomObject]@{
                key = "abc123"
                mode = "addDevices"
            },
            [PSCustomObject]@{
                key = "def456"
                mode = "renew"
            }
        )
    }

    $claimJson = $claim | ConvertTo-Json -Compress
    Invoke-MerakiOrganizationInventoryClaim -AuthToken "1234" -Claim $claimJson

    This example claims the orders 'o1234' and 'o5678', the devices 's1234' and 's5678', and the licenses 'abc123' and 'def456' with their respective modes. The function adds the licenses to the first organization associated with the authentication token '1234'.

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.

    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$Claim
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $body = $Claim

            $uri = "https://api.meraki.com/api/v1/organizations/$OrganizationId/inventory/claim"
            $response = Invoke-RestMethod -Method Post -Uri $uri -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}