function Set-MerakiOrganizationAdaptivePolicyACL {
    <#
    .SYNOPSIS
    Updates an existing adaptive policy ACL for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiOrganizationAdaptivePolicyACL function allows you to update an existing adaptive policy ACL for a specified Meraki organization by providing the authentication token, organization ID, ACL ID, and ACL configuration.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to update an adaptive policy ACL.

    .PARAMETER ACLId
    The ID of the adaptive policy ACL you want to update.

    .PARAMETER ACLConfig
    The JSON configuration for the updated adaptive policy ACL. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $config = [PSCustomObject]@{
        name = "Test ACL"
        description = "Test ACL description"
        ipVersion = "ipv4"
        rules = @(
            [PSCustomObject]@{
                policy = "allow"
                protocol = "tcp"
                dstPort = "80"
                srcPort = "any"
            }
        )
    }

    $config = $config | ConvertTo-Json -Compress

    Set-MerakiOrganizationAdaptivePolicyACL -AuthToken "your-api-token" -OrganizationId "1234567890" -ACLId "1234567890" -ACLConfig $config

    This example updates the adaptive policy ACL with ID "1234567890" for the Meraki organization with ID "1234567890" using the provided ACL configuration.

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
        [string]$ACLId,
        [parameter(Mandatory=$true)]
        [string]$ACLConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
            
            $body = $ACLConfig

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/adaptivePolicy/acls/$ACLId"
            
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}