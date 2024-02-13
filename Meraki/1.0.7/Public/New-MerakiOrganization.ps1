function New-MerakiOrganization {
    <#
    .SYNOPSIS
    Creates a new Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The New-MerakiOrganization function allows you to create a new Meraki organization by providing the authentication token and a JSON configuration for the organization.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationConfig
    The JSON configuration for the organization to be created. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $OrganizationConfig = [PSCustomObject]@{
        name = "My organization"
        management = @{
            details = @(
                @{
                    name = "MSP ID"
                    value = "123456"
                }
            )
        }
    }

    $OrganizationConfig = $OrganizationConfig | ConvertTo-Json -Compress

    New-MerakiOrganization -AuthToken "your-api-token" -OrganizationConfig $OrganizationConfig

    This example creates a new Meraki organization with name "My organization" and management details.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the creation is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$OrganizationConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }
        
        $body = $OrganizationConfig

        $url = "https://api.meraki.com/api/v1/organizations"
        
        $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}