function Convert-MerakiImageToBase64 {
    param (
        [parameter(Mandatory=$true)]
        [string]$FilePath
    )
    
    try {
        $imageBytes = [System.IO.File]::ReadAllBytes($FilePath)
        $base64String = [Convert]::ToBase64String($imageBytes)
        return $base64String
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}

function New-MerakiOrganizationSplashThemeAsset {
    <#
    .SYNOPSIS
    Uploads a new asset to a specified splash theme for an organization.

    .DESCRIPTION
    This function allows you to upload a new asset to a specified splash theme for an organization by providing the authentication token, organization ID, theme identifier, and asset content.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the organization.

    .PARAMETER ThemeIdentifier
    The identifier of the splash theme.

    .PARAMETER FilePath
    The file path of the asset content to be uploaded.

    .PARAMETER Name
    The file name. Will overwrite files with the same name.

    .EXAMPLE
    $filePath = "C:\path\to\asset.png"
    New-MerakiOrganizationSplashThemeAsset -AuthToken "your-api-token" -OrganizationId "123456" -ThemeIdentifier "theme_id" -FilePath $filePath -Name "asset.png"

    This example uploads a new asset named "asset.png" with the specified content to the splash theme with identifier "theme_id" for the organization with ID "123456".

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$ThemeIdentifier,
        [parameter(Mandatory=$true)]
        [string]$FilePath,
        [parameter(Mandatory=$true)]
        [string]$Name
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $contentBase64 = Convert-MerakiImageToBase64 -FilePath $FilePath

            $body = [PSCustomObject]@{
                content = $contentBase64
                name = $Name
            }

            $jsonBody = $body | ConvertTo-Json -Depth 4
            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/splash/themes/$ThemeIdentifier/assets"

            $response = Invoke-RestMethod -Method Post -Uri $url -Headers $header -Body $jsonBody -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}