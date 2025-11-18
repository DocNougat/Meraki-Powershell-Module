function New-MerakiOrganizationNetwork {
    <#
    .SYNOPSIS
    Creates a new network for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The New-MerakiOrganizationNetwork function allows you to create a new network for a specified Meraki organization by providing the authentication token, network name, and network configuration.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkConfig
    The JSON configuration for the new network to be created. Refer to the JSON schema for required parameters and their format.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to create a new network.

    .EXAMPLE
    $NetworkConfig = [PSCustomObject]@{
        name = "Main Office"
        productTypes = @("appliance", "switch", "wireless")
        tags = @("tag1", "tag2")
        timeZone = "America/Los_Angeles"
        copyFromNetworkId = "N_24329156"
        notes = "Additional description of the network"
    }

    $NetworkConfig = $NetworkConfig | ConvertTo-Json -Compress -Depth 4

    New-MerakiOrganizationNetwork -AuthToken "your-api-token" -NetworkConfig $NetworkConfig -OrganizationId "1234567890"

    This example creates a new network with name "Main Office" for the Meraki organization with ID "1234567890". The network is configured with product types "appliance", "switch", and "wireless", tags "tag1" and "tag2", and a timezone of "America/Los_Angeles". The network is copied from the network with ID "N_24329156" and has additional notes.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the configuration is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkConfig,
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
            
            $body = $NetworkConfig

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/networks"
            
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}