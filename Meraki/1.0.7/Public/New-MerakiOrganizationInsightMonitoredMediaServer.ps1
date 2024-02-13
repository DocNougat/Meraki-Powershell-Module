function New-MerakiOrganizationInsightMonitoredMediaServer {
    <#
    .SYNOPSIS
    Creates a monitored media server for a Meraki organization's insight.
    
    .DESCRIPTION
    The New-MerakiOrganizationInsightMonitoredMediaServer function allows you to create a monitored media server for a specified Meraki organization's insight by providing the authentication token, organization ID, and a monitored media server configuration string.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER OrganizationId
    The organization ID of the Meraki organization for which you want to create the monitored media server.
    
    .PARAMETER MonitoredMediaServerConfig
    A string containing the monitored media server configuration. The string should be in JSON format and should include the properties as defined in the schema.
    
    .EXAMPLE
    $MonitoredMediaServerConfig = [PSCustomObject]@{
        name = "Sample VoIP Provider"
        address = "123.123.123.1"
        bestEffortMonitoringEnabled = $true
    }

    $MonitoredMediaServerConfig = $MonitoredMediaServerConfig | ConvertTo-Json -Compress

    New-MerakiOrganizationInsightMonitoredMediaServer -AuthToken "your-api-token" -OrganizationId "1234" -MonitoredMediaServerConfig $MonitoredMediaServerConfig

    This example creates a monitored media server for the Meraki organization with ID "1234".
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the creation is successful, otherwise, it displays an error message.
    #>
    
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$MonitoredMediaServerConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/insight/monitoredMediaServers"
    
            $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $MonitoredMediaServerConfig
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}