function New-MerakiOrganizationCameraCustomAnalyticsArtifact {
    <#
    .SYNOPSIS
    Creates a new custom analytics artifact for a Meraki organization's camera.
    
    .DESCRIPTION
    The New-MerakiOrganizationCameraCustomAnalyticsArtifact function allows you to create a new custom analytics artifact for a Meraki organization's camera by providing the authentication token, organization ID, and a name for the artifact.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to create the custom analytics artifact.
    
    .PARAMETER ArtifactName
    The unique name for the custom analytics artifact.
    
    .EXAMPLE
    New-MerakiOrganizationCameraCustomAnalyticsArtifact -AuthToken "your-api-token" -OrganizationId "1234567890" -Name "example"
    
    This example creates a new custom analytics artifact named "example" for the Meraki organization with ID "1234567890".
    
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
        [string]$ArtifactName
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $body = @{
                "name" = $ArtifactName
            } | ConvertTo-Json
    
            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/camera/customAnalytics/artifacts"
    
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}