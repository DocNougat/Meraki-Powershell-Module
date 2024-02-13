function Set-MerakiOrganizationActionBatch {
    <#
    .SYNOPSIS
    Updates an existing action batch for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiOrganizationActionBatch function allows you to update an existing action batch for a specified Meraki organization by providing the authentication token, organization ID, action batch ID, and action batch configuration.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to update an action batch.

    .PARAMETER ActionBatchId
    The ID of the action batch you want to update.

    .PARAMETER ActionBatchConfig
    The JSON configuration for the updated action batch. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $config = [PSCustomObject]@{
        confirmed = $true
        synchronous = $true
        actions = @(
            [PSCustomObject]@{
                resource = "/organizations/{organizationId}/networks/{networkId}/devices/{serial}/switchPorts/{portId}"
                operation = "update"
                body = [PSCustomObject]@{
                    name = "New port name"
                }
            }
        )
    }

    $config = $config | ConvertTo-Json -Compress

    Set-MerakiOrganizationActionBatch -AuthToken "your-api-token" -OrganizationId "1234567890" -ActionBatchId "AB_1234567890" -ActionBatchConfig $config
    This example updates the action batch with ID "AB_1234567890" for the Meraki organization with ID "1234567890" using the provided action batch configuration.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the configuration is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$ActionBatchId,
        [parameter(Mandatory=$true)]
        [string]$ActionBatchConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
            
            $body = $ActionBatchConfig

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/actionBatches/$ActionBatchId"
            
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}