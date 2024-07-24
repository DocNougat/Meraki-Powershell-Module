function New-MerakiOrganizationAdaptivePolicyGroup {
    <#
    .SYNOPSIS
    Creates a new adaptive policy group for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The New-MerakiOrganizationAdaptivePolicyGroup function allows you to create a new adaptive policy group for a specified Meraki organization by providing the authentication token, organization ID, and group configuration.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to create a new adaptive policy group.

    .PARAMETER GroupConfig
    The JSON configuration for the adaptive policy group. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $config = [PSCustomObject]@{
        name = "Test Group"
        description = "Test Group description"
        sgt = 123
        policyObjects = @(
            [PSCustomObject]@{
                id = "1234567890"
                name = "Test Policy Object"
            }
        )
    }
    $config = $config | ConvertTo-Json -Compress

    New-MerakiOrganizationAdaptivePolicyGroup -AuthToken "your-api-token" -OrganizationId "1234567890" -GroupConfig $config

    This example creates a new adaptive policy group for the Meraki organization with ID "1234567890" using the provided group configuration.

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
        [string]$GroupConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
            
            $body = $GroupConfig

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/adaptivePolicy/groups"
            
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}