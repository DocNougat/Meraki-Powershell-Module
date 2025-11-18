function Set-MerakiOrganizationApplianceDnsLocalProfile {
    <#
    .SYNOPSIS
    Updates the DNS local profile settings for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiOrganizationApplianceDnsLocalProfile function allows you to update the DNS local profile settings for a specified Meraki organization by providing the authentication token, organization ID, and a DNS local profile configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to update the security intrusion settings.

    .PARAMETER ProfileID
    The ID of the DNS local profile to be updated.

    .PARAMETER DnsLocalProfileConfig
    A string containing the DNS local profile configuration. The string should be in JSON format and should include the "dnsServers" property.

    .EXAMPLE
    $config = [PSCustomObject]@{
        name = "Default DNS Profile"
    }

    $config = $config | ConvertTo-Json -Compress -Depth 4
    Set-MerakiOrganizationApplianceDnsLocalProfile -AuthToken "your-api-token" -OrganizationId "your-organization-id" -ProfileID "your-profile-id" -DnsLocalProfileConfig $config

    This example updates the DNS local profile settings for the Meraki organization with ID "your-organization-id", using the specified DNS local profile configuration.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the DNS local profile settings update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$ProfileID,
        [parameter(Mandatory=$true)]
        [string]$DnsLocalProfileConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $body = $DnsLocalProfileConfig

            $uri = "https://api.meraki.com/api/v1/organizations/$OrganizationId/appliance/dns/local/profiles/$ProfileID"
            $response = Invoke-RestMethod -Method Put -Uri $uri -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}