function Set-MerakiOrganizationConfigTemplateSwitchProfilePort {
    <#
    .SYNOPSIS
    Updates the switch profile port for a network switch in an organization's configuration template.
    
    .DESCRIPTION
    The Set-MerakiOrganizationConfigTemplateSwitchProfilePort function allows you to update the switch profile port for a specified network switch in an organization's configuration template by providing the authentication token, organization ID, configuration template ID, profile ID, port ID, and a JSON formatted string of switch profile port configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER OrganizationId
    The ID of the Meraki organization.
    
    .PARAMETER ConfigTemplateId
    The ID of the configuration template in the organization.
    
    .PARAMETER ProfileId
    The ID of the switch profile in the configuration template.
    
    .PARAMETER PortId
    The ID of the port in the switch profile.
    
    .PARAMETER PortConfig
    A JSON formatted string of switch profile port configuration.
    
    .EXAMPLE
    $PortConfig = '{
        "name": "My switch port",
        "tags": [ "tag1", "tag2" ],
        "enabled": true,
        "poeEnabled": true,
        "type": "access",
        "vlan": 10,
        "voiceVlan": 20,
        "allowedVlans": "1,3,5-10",
        "isolationEnabled": false,
        "rstpEnabled": true,
        "stpGuard": "disabled",
        "linkNegotiation": "Auto negotiate",
        "portScheduleId": "1234",
        "udld": "Alert only",
        "accessPolicyType": "Sticky MAC allow list",
        "accessPolicyNumber": 2,
        "macAllowList": [
            "34:56:fe:ce:8e:b0",
            "34:56:fe:ce:8e:b1"
        ],
        "stickyMacAllowList": [
            "34:56:fe:ce:8e:b0",
            "34:56:fe:ce:8e:b1"
        ],
        "stickyMacAllowListLimit": 5,
        "stormControlEnabled": true,
        "flexibleStackingEnabled": true,
        "daiTrusted": false,
        "profile": {
            "enabled": false,
            "id": "1284392014819",
            "iname": "iname"
        }
    }'
    $PortConfig = $PortConfig | ConvertTo-Json
    Set-MerakiOrganizationConfigTemplateSwitchProfilePort -AuthToken "your-api-token" -OrganizationId "1234" -ConfigTemplateId "5678" -ProfileId "91011" -PortId "121314" -PortConfig $PortConfig
    
    This example updates the switch profile port for the network switch in the Meraki organization with ID "1234", configuration template ID "5678", profile ID "91011", and port ID "121314" with the specified switch profile port configuration.
    
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
        [string]$ConfigTemplateId,
        [parameter(Mandatory=$true)]
        [string]$ProfileId,
        [parameter(Mandatory=$true)]
        [string]$PortId,
        [parameter(Mandatory=$true)]
        [string]$PortConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/configTemplates/$ConfigTemplateId/switch/profiles/$ProfileId/ports/$PortId"
    
            $body = $PortConfig
    
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
            Write-Host $_
        }
    }
}