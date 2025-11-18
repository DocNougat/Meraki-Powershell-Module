function Set-MerakiNetworkCameraWirelessProfile {
    <#
    .SYNOPSIS
    Updates the configuration of a Meraki campus gateway cluster for a given network.

    .DESCRIPTION
    Sends a PUT request to the Meraki Dashboard API endpoint for campus gateway clusters:
    https://api.meraki.com/api/v1/networks/{networkId}/campusGateway/clusters/{clusterId}
    The function attaches the provided API key as the X-Cisco-Meraki-API-Key header and submits the payload in JSON format.
    The cmdlet returns the deserialized response from the API (as returned by Invoke-RestMethod) or throws on error.

    NOTE: Although the function name is Set-MerakiNetworkCameraWirelessProfile, the implementation targets the campusGateway/clusters endpoint. Ensure this target is correct for your intended use.

    .PARAMETER AuthToken
    The Meraki API key used to authenticate the request. This value is sent in the X-Cisco-Meraki-API-Key header. Keep this value secret.

    .PARAMETER NetworkId
    The identifier of the Meraki network that contains the target campus gateway cluster (string).

    .PARAMETER ClusterID
    The identifier of the campus gateway cluster to update (string).

    .PARAMETER ClusterConfig
    The request body to send as the cluster configuration. Provide a JSON string representing the desired cluster settings, or pass a PowerShell object converted to JSON (e.g., using ConvertTo-Json) prior to calling the cmdlet.
    
    .EXAMPLE
    # Provide a raw JSON string as the payload
    $token = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxx'
    $networkId = 'N_123456789'
    $clusterId = 'C_987654321'
    $jsonBody = '{
        "name": "North Campus",
        "uplinks": [
            {
                "interface": "man1",
                "vlan": 5,
                "addresses": [
                    {
                        "assignmentMode": "static",
                        "protocol": "ipv4",
                        "gateway": "1.2.3.5",
                        "subnetMask": "255.255.255.0"
                    }
                ]
            }
        ],
        "tunnels": [
            {
                "uplink": { "interface": "man1" },
                "interface": "tun1",
                "vlan": 6,
                "addresses": [
                    {
                        "protocol": "ipv4",
                        "gateway": "2.3.5.6",
                        "subnetMask": "255.255.255.0"
                    }
                ]
            }
        ],
        "nameservers": {
            "addresses": [ "8.8.8.8", "8.8.4.4" ]
        },
        "portChannels": [
            {
                "name": "Port-channel1",
                "vlan": 25,
                "allowedVlans": "10-20"
            }
        ],
        "devices": [
            {
                "serial": "Q234-ABCD-0001",
                "uplinks": [
                    {
                        "interface": "man1",
                        "addresses": [
                            {
                                "protocol": "ipv4",
                                "address": "5.1.2.3"
                            }
                        ]
                    }
                ],
                "tunnels": [
                    {
                        "interface": "tun1",
                        "addresses": [
                            {
                                "protocol": "ipv4",
                                "address": "6.2.6.7"
                            }
                        ]
                    }
                ]
            }
        ],
        "notes": "This cluster is for New York Office"
    }'
    Set-MerakiNetworkCameraWirelessProfile -AuthToken $token -NetworkId $networkId -ClusterID $clusterId -ClusterConfig $jsonBody

    .NOTES
    - Content-Type: application/json; charset=utf-8 is used.
    - The function forwards any Invoke-RestMethod exceptions; consider wrapping calls in try/catch when using this cmdlet.
    - User-Agent used by the implementation: MerakiPowerShellModule/1.1.3 DocNougat

    .LINK
    https://developer.cisco.com/meraki/api-v1/ (Meraki Dashboard API reference)
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$ClusterID,
        [parameter(Mandatory=$true)]
        [string]$ClusterConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/campusGateway/clusters/$ClusterID"

        $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $ClusterConfig
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}