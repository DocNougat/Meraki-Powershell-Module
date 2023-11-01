function Set-MerakiOrganizationApplianceVPNThirdPartyVPNPeers {
    <#
    .SYNOPSIS
    Updates the Third Party VPN Peers settings for a Meraki organization.
    
    .DESCRIPTION
    This function updates the Third Party VPN Peers settings for a Meraki organization using the Meraki Dashboard API. The function takes a JSON configuration as input and sends it to the API endpoint to update the settings.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to update the Third Party VPN Peers settings.
    
    .PARAMETER VPNConfig
    The JSON configuration for the Third Party VPN Peers settings to be updated. Refer to the JSON schema for required parameters and their format.
    
    .EXAMPLE
    $VPNConfig = '{
        "peers": [
            {
                "name": "Peer Name",
                "publicIp": "123.123.123.1",
                "privateSubnets": [
                    "192.168.1.0/24",
                    "192.168.128.0/24"
                ],
                "localId": "myMXId@meraki.com",
                "remoteId": "miles@meraki.com",
                "ipsecPolicies": {
                    "ikeCipherAlgo": [ "tripledes" ],
                    "ikeAuthAlgo": [ "sha1" ],
                    "ikePrfAlgo": [ "prfsha1" ],
                    "ikeDiffieHellmanGroup": [ "group2" ],
                    "ikeLifetime": 28800,
                    "childCipherAlgo": [ "aes128" ],
                    "childAuthAlgo": [ "sha1" ],
                    "childPfsGroup": [ "disabled" ],
                    "childLifetime": 28800
                },
                "ipsecPoliciesPreset": "default",
                "secret": "Sample Password",
                "ikeVersion": "2",
                "networkTags": [ "none" ]
            }
        ]
    }'
    $VPNConfig = $VPNConfig | ConvertTo-JSON -compress
    
    Set-MerakiOrganizationApplianceVPNThirdPartyVPNPeers -AuthToken "your-api-token" -OrganizationId "L_9817349871234" -VPNConfig $VPNConfig
    
    This example updates the Third Party VPN Peers settings for the specified organization.
    
    .NOTES
    For more information about the Meraki Dashboard API, see https://developer.cisco.com/meraki/api-v1/.
    #>
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$false)]
            [string]$OrganizationId = (Get-MerakiOrganizations -AuthToken $AuthToken).id,
            [Parameter(Mandatory = $true)]
            [string]$VPNConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $body = $VPNConfig
    
            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/appliance/vpn/thirdPartyVPNPeers"
    
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -Body $body
            return $response
        }
        catch {
            Write-Host $_
        }
    }