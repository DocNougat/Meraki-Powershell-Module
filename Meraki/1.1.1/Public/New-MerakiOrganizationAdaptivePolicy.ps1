function New-MerakiOrganizationAdaptivePolicy {
    <#
    .SYNOPSIS
    Creates a new adaptive policy for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The New-MerakiOrganizationAdaptivePolicy function allows you to create a new adaptive policy for a specified Meraki organization by providing the authentication token, organization ID, and policy configuration.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to create a new adaptive policy.

    .PARAMETER PolicyConfig
    The JSON configuration for the adaptive policy. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $config = [PSCustomObject]@{
        name = "Test Policy"
        description = "Test Policy description"
        lastEntryRule = "default"
        destinationGroup = @{
            id = "1234567890"
            name = "Test Destination Group"
            sgt = 123
        }
        sourceGroup = @{
            id = "0987654321"
            name = "Test Source Group"
            sgt = 456
        }
        acls = @(
            @{
                id = "1111111111"
                name = "Test ACL 1"
            },
            @{
                id = "2222222222"
                name = "Test ACL 2"
            }
        )
    }

    $configJson = $config | ConvertTo-Json -Compress

    New-MerakiOrganizationAdaptivePolicy -AuthToken "your-api-token" -OrganizationId "1234567890" -PolicyConfig $configJson
    This example creates a new adaptive policy for the Meraki organization with ID "1234567890" using the provided policy configuration.

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
        [string]$PolicyConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
            
            $body = $PolicyConfig

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/adaptivePolicy/policies"
            
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}