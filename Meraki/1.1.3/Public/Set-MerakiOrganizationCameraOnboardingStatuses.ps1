function Set-MerakiOrganizationCameraOnboardingStatuses {
    <#
    .SYNOPSIS
    Updates the onboarding status of a Meraki organization's camera.
    
    .DESCRIPTION
    The Set-MerakiOrganizationCameraOnboardingStatuses function allows you to update the onboarding status of a Meraki organization's camera by providing the authentication token, organization ID, and a JSON configuration for the onboarding status.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to update the onboarding status.
    
    .PARAMETER Device
    The JSON configuration for the onboarding status to be updated. Refer to the JSON schema for required parameters and their format.
    
    .EXAMPLE
    $Device = [PSCustomObject]@{
        serial = "Q2GV-ABCD-1234"
        wirelessCredentialsSent = $true
    }

    $Device = $Device | ConvertTo-JSON -Compress

    Set-MerakiOrganizationCameraOnboardingStatuses -AuthToken "your-api-token" -OrganizationId "1234567890" -Device $Device

    This example updates the onboarding status of the Meraki organization's camera with serial "Q2GV-ABCD-1234".
    
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
        [parameter(Mandatory=$false)]
        [string]$Device
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
            If($Device){
                $body = $Device
    
                $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/camera/onboarding/statuses"
            
                $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $body
            } else {
                $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/camera/onboarding/statuses"
            
                $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            }
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}