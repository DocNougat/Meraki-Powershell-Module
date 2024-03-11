function Set-MerakiOrganizationApplianceVPNFirewallRules {
    <#
    .SYNOPSIS
    Updates the VPN Firewall Rules settings for a Meraki organization.
    
    .DESCRIPTION
    This function updates the VPN Firewall Rules settings for a Meraki organization using the Meraki Dashboard API. The function takes a JSON configuration as input and sends it to the API endpoint to update the settings.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to update the VPN Firewall Rules settings.
    
    .PARAMETER FirewallRules
    The JSON configuration for the VPN Firewall Rules settings to be updated. Refer to the JSON schema for required parameters and their format.
    
    .EXAMPLE
    $FirewallRules = [PSCustomObject]@{
        rules = @(
            [PSCustomObject]@{
                comment = "Allow TCP traffic to subnet with HTTP servers."
                policy = "allow"
                protocol = "tcp"
                srcPort = "Any"
                srcCidr = "Any"
                destPort = "443"
                destCidr = "192.168.1.0/24"
                syslogEnabled = $false
            }
        )
        syslogDefaultRule = $false
    }

    $FirewallRules = $FirewallRules | ConvertTo-Json -Compress

    Set-MerakiOrganizationApplianceVPNFirewallRules -AuthToken "your-api-token" -OrganizationId "L_9817349871234" -FirewallRules $FirewallRules

    This example updates the VPN Firewall Rules settings for the specified organization.
    
    .NOTES
    For more information about the Meraki Dashboard API, see https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [Parameter(Mandatory = $true)]
        [string]$FirewallRules
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $body = $FirewallRules
    
            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/appliance/vpn/vpnFirewallRules"
    
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}