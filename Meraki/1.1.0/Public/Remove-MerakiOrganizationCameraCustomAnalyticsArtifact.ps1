function Remove-MerakiOrganizationCameraCustomAnalyticsArtifact {
    <#
    .SYNOPSIS
    Deletes an existing custom analytics artifact for a Meraki organization's camera.
    
    .DESCRIPTION
    The Remove-MerakiOrganizationCameraCustomAnalyticsArtifact function allows you to delete an existing custom analytics artifact for a specified Meraki organization's camera by providing the authentication token, organization ID, and artifact ID.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to delete a custom analytics artifact.
    
    .PARAMETER ArtifactId
    The ID of the custom analytics artifact you want to delete.
    
    .EXAMPLE
    Remove-MerakiOrganizationCameraCustomAnalyticsArtifact -AuthToken "your-api-token" -OrganizationId "1234567890" -ArtifactId "1234567890"
    
    This example deletes the custom analytics artifact with ID "1234567890" for the Meraki organization with ID "1234567890".
    
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
            [string]$ArtifactId
        )
        If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
            Return "Multiple organizations found. Please specify an organization ID."
        } else {
            try {
                $header = @{
                    "X-Cisco-Meraki-API-Key" = $AuthToken
                    "content-type" = "application/json; charset=utf-8"
                }
        
                $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/camera/customAnalytics/artifacts/$ArtifactId"
        
                $response = Invoke-RestMethod -Method Delete -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
                return $response
            }
            catch {
                Write-Debug $_
            }
        }
    }