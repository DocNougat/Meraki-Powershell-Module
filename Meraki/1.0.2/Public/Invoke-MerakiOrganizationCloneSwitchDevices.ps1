function Invoke-MerakiOrganizationCloneSwitchDevices {
    <#
    .SYNOPSIS
    Clones the configuration of a source switch to one or more target switches in a Meraki organization.
    
    .DESCRIPTION
    The Invoke-MerakiOrganizationCloneSwitchDevices function allows you to clone the configuration of a source switch to one or more target switches in a Meraki organization by providing the authentication token, organization ID, and a JSON formatted string of clone configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER OrganizationId
    The ID of the Meraki organization.
    
    .PARAMETER CloneConfig
    A JSON formatted string of clone configuration.
    
    .EXAMPLE
    $CloneConfig = '{
        "sourceSerial": "Q234-ABCD-5678",
        "targetSerials": [
            "Q234-ABCD-0001",
            "Q234-ABCD-0002",
            "Q234-ABCD-0003"
        ]
    }'
    $CloneConfig = $CloneConfig | ConvertTo-Json -Compress
    Invoke-MerakiOrganizationCloneSwitchDevices -AuthToken "your-api-token" -OrganizationId "1234" -CloneConfig $CloneConfig
    
    This example clones the configuration of the source switch with serial number "Q234-ABCD-5678" to the target switches with serial numbers "Q234-ABCD-0001", "Q234-ABCD-0002", and "Q234-ABCD-0003" in the Meraki organization with ID "1234".
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the clone operation is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$false)]
            [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
            [parameter(Mandatory=$true)]
            [string]$CloneConfig
        )
        If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
            Return "Multiple organizations found. Please specify an organization ID."
        } else {
            try {
                $header = @{
                    "X-Cisco-Meraki-API-Key" = $AuthToken
                    "content-type" = "application/json; charset=utf-8"
                }
        
                $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/switch/devices/clone"
        
                $body = $CloneConfig
        
                $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
                return $response
            }
            catch {
                Write-Host $_
            }
        }
    }