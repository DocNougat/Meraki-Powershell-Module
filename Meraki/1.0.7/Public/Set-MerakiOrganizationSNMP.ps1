function Set-MerakiOrganizationSNMP {
    <#
    .SYNOPSIS
    Update SNMP settings for an organization in the Meraki Dashboard using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiOrganizationSnmp function allows you to update the SNMP settings for an organization in the Meraki Dashboard by providing the authentication token, organization ID, and a JSON configuration for the SNMP settings.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to update the SNMP settings.

    .PARAMETER SNMPConfig
    The JSON configuration for the SNMP settings to be updated. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $SNMPConfig = [PSCustomObject]@{
        v2cEnabled = $false
        v3Enabled = $true
        v3AuthMode = "SHA"
        v3PrivMode = "AES128"
        peerIps = @("123.123.123.1")
    }

    $SNMPConfig = $SNMPConfig | ConvertTo-JSON -Compress

    Set-MerakiOrganizationSnmp -AuthToken "your-api-token" -OrganizationId "234567" -SNMPConfig $SNMPConfig

    This example updates the SNMP settings for the Meraki organization with ID "234567" to enable SNMP version 3, set the authentication mode to SHA, the privacy mode to AES128, and allow access to the SNMP server from the IP address "123.123.123.1".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$SNMPConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
            
            $body = $SNMPConfig

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/snmp"
            
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}