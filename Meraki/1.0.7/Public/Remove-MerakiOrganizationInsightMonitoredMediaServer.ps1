function Remove-MerakiOrganizationInsightMonitoredMediaServer {
    <#
    .SYNOPSIS
    Deletes a monitored media server for a Meraki organization's insight.
    
    .DESCRIPTION
    The Remove-MerakiOrganizationInsightMonitoredMediaServer function allows you to delete a monitored media server for a specified Meraki organization's insight by providing the authentication token, organization ID, and monitored media server ID.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER OrganizationId
    The organization ID of the Meraki organization for which you want to delete the monitored media server.
    
    .PARAMETER MonitoredMediaServerId
    The ID of the monitored media server that you want to delete.
    
    .EXAMPLE
    Remove-MerakiOrganizationInsightMonitoredMediaServer -AuthToken "your-api-token" -OrganizationId "1234" -MonitoredMediaServerId "1"
    
    This example deletes a monitored media server for the Meraki organization with ID "1234".
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the deletion is successful, otherwise, it displays an error message.
    #>
    
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$MonitoredMediaServerId
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/insight/monitoredMediaServers/$MonitoredMediaServerId"
    
            $response = Invoke-RestMethod -Method Delete -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}