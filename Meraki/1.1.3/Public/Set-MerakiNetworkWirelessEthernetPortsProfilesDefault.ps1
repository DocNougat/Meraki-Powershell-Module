<#
.SYNOPSIS
Sets the default wireless Ethernet ports profile for a Meraki network.

.DESCRIPTION
Set-MerakiNetworkWirelessEthernetPortsProfilesDefault configures the default Ethernet port profile used by wireless devices in the specified Meraki network by calling the Meraki Dashboard API endpoint:
PUT /networks/{networkId}/wireless/ethernet/ports/profiles/setDefault

.PARAMETER AuthToken
The Cisco Meraki API key used to authenticate the request. Provide a valid, scoped API token with permissions to modify network configuration.

.PARAMETER NetworkId
The identifier of the Meraki network (for example: L_1234abcd). This network will receive the updated default Ethernet ports profile.

.PARAMETER profileId
The identifier of the Ethernet ports profile to make the network default. This should be an existing profile ID available in the organization.

.EXAMPLE
# Set the default Ethernet ports profile for a network
Set-MerakiNetworkWirelessEthernetPortsProfilesDefault -AuthToken 'abcd0123...' -NetworkId 'L_1234567890' -profileId '98123098712371'

.LINK
https://developer.cisco.com/meraki/api-v1/ (Meraki Dashboard API reference)
#>
function Set-MerakiNetworkWirelessEthernetPortsProfilesDefault {
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$NetworkId,
            [parameter(Mandatory=$true)]
            [string]$profileId
        )

        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/wireless/ethernet/ports/profiles/setDefault"

            $body = @{
                "profileId" = $profileId
            }
            $body = $body | ConvertTo-Json -Compress -Depth 4
            
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }