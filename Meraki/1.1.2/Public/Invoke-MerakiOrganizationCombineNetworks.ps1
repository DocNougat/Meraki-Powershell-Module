function Invoke-MerakiOrganizationCombineNetworks {
    <#
    .SYNOPSIS
    Combines multiple Meraki networks into a single combined network using the Meraki Dashboard API.

    .DESCRIPTION
    The Invoke-MerakiOrganizationCombineNetworks function allows you to combine multiple Meraki networks into a single combined network by providing the authentication token, combined network name, and a list of network IDs to be combined.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER ComboConfig
    The JSON configuration for the combined network to be created. Refer to the JSON schema for required parameters and their format.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to create a new combined network.

    .EXAMPLE
    $ComboConfig = [PSCustomObject]@{
        name = "Long Island Office"
        networkIds = @("N_1234", "N_5678")
        enrollmentString = "my-enrollment-string"
    }

    $ComboConfig = $ComboConfig | ConvertTo-JSON -Compress

    Invoke-MerakiOrganizationCombineNetworks -AuthToken "your-api-token" -ComboConfig $ComboConfig -OrganizationId "1234567890"

    This example combines the Meraki networks with IDs "N_1234" and "N_5678" into a new combined network with name "Long Island Office" for the Meraki organization with ID "1234567890". The combined network has an enrollment string of "my-enrollment-string".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the configuration is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$ComboConfig,
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
            
            $body = $ComboConfig

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/networks/combine"
            
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}