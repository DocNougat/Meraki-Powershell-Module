function New-MerakiOrganizationCellularGatewayEsimsSwap {
    <#
    .SYNOPSIS
    Performs an eSIM swap operation for Meraki Cellular Gateway devices within an organization.

    .DESCRIPTION
    Calls the Meraki REST API endpoint to swap eSIMs for devices in a specified organization. The function issues a POST to /organizations/{organizationId}/cellularGateway/esims/swap using the provided API key and JSON request body. If OrganizationID is omitted, the function attempts to resolve an organization ID by calling Get-OrgID -AuthToken $AuthToken. If multiple organizations are found, the function will return the message "Multiple organizations found. Please specify an organization ID."

    .PARAMETER AuthToken
    The Meraki API key used for authentication. This parameter is mandatory.

    .PARAMETER OrganizationID
    The Meraki organization ID in which to perform the eSIM swap. This parameter is optional; when not provided the function will try to determine the organization ID via Get-OrgID. If multiple organizations are returned by Get-OrgID the user must provide an explicit OrganizationID.

    .PARAMETER SwapConfig
    The request body for the swap operation. Must be a JSON-formatted string (or an object converted to JSON) matching the Meraki API's expected payload for the eSIM swap operation. This parameter is mandatory.

    .EXAMPLE
    # Build the payload from a PowerShell object and convert to JSON
    $SwapConfig = @{
        swaps = @(
            @{ 
            eid = "890192345982" 
            target = @{
                    accountId = "account-123"
                    communicationPlan = "plan-456"
                    ratePlan = "rate-789"
                } 
            }
        )
    }
    $SwapConfigJson = $SwapConfig | ConvertTo-Json -Depth 10
    New-MerakiOrganizationCellularGatewayEsimsSwap -AuthToken $token -SwapConfig $SwapConfigJson

    .EXAMPLE
    # Multiple Swaps in a single call
    $SwapConfig = @{
        swaps = @(
            @{ 
            eid = "890192345982" 
            target = @{
                    accountId = "account-123"
                    communicationPlan = "plan-456"
                    ratePlan = "rate-789"
                } 
            },
            @{ 
            eid = "890192345983"
            target = @{
                    accountId = "account-456"
                    communicationPlan = "plan-789"
                    ratePlan = "rate-012"
                } 
            }
        )
    }
    $SwapConfigJson = $SwapConfig | ConvertTo-Json -Depth 10
    New-MerakiOrganizationCellularGatewayEsimsSwap -AuthToken $token -SwapConfig $SwapConfigJson

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
        [string]$SwapConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/cellularGateway/esims/swap"

            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $SwapConfig
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}