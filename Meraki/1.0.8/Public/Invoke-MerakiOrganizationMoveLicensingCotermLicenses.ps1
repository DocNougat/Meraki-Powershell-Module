function Invoke-MerakiOrganizationMoveLicensingCotermLicenses {
    <#
    .SYNOPSIS
    Moves licenses for a Meraki organization's licensing coterm.
    
    .DESCRIPTION
    The Invoke-MerakiOrganizationMoveLicensingCotermLicenses function allows you to move licenses for a specified Meraki organization's licensing coterm by providing the authentication token, organization ID, and an optional license move configuration string.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER OrganizationId
    The organization ID of the Meraki organization for which you want to move the licenses.
    
    .PARAMETER LicenseMoveConfig
    An optional string containing the license move configuration. The string should be in JSON format and should include the properties as defined in the schema.
    
    .EXAMPLE
    $LicenseMoveConfig = [PSCustomObject]@{
        destination = @{
            organizationId = "123"
            mode = "addDevices"
        }
        licenses = @(
            @{
                key = "Z2AA-BBBB-CCCC"
                counts = @(
                    @{
                        model = "MR Enterprise"
                        count = 5
                    }
                )
            }
        )
    }

    $LicenseMoveConfig = $LicenseMoveConfig | ConvertTo-Json -Compress

    Invoke-MerakiOrganizationMoveLicensingCotermLicenses -AuthToken "your-api-token" -OrganizationId "1234" -LicenseMoveConfig $LicenseMoveConfig

    This example moves licenses for the Meraki organization with ID "1234".
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the move is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$false)]
            [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
            [parameter(Mandatory=$false)]
            [string]$LicenseMoveConfig
        )
        If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
            Return "Multiple organizations found. Please specify an organization ID."
        } else {
            try {
                $header = @{
                    "X-Cisco-Meraki-API-Key" = $AuthToken
                    "content-type" = "application/json; charset=utf-8"
                }
        
                $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/licensing/coterm/licenses/move"
        
                $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat" -Body $LicenseMoveConfig
                return $response
            }
            catch {
                Write-Debug $_
                Throw $_
            }
        }
    }