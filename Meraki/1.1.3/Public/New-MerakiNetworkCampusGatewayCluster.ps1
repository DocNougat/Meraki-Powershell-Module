function New-MerakiNetworkCampusGatewayCluster {
    <#
    .SYNOPSIS
    Creates a new Meraki campus gateway cluster in the specified network.

    .DESCRIPTION
    Calls the Meraki Dashboard API to create a campus gateway cluster for the given network. The CampusGatewayConfig parameter should be provided as a JSON string or as a PowerShell object that can be converted to JSON. The function sends the API key in the X-Cisco-Meraki-API-Key request header and posts to the POST /networks/{networkId}/campusGateway/clusters endpoint.

    .PARAMETER AuthToken
    The Meraki Dashboard API key (X-Cisco-Meraki-API-Key). Must have permissions to create resources in the target network.

    .PARAMETER NetworkId
    The identifier of the Meraki network where the campus gateway cluster will be created (for example: L_1234abcd).

    .PARAMETER CampusGatewayConfig
    A JSON string describing the campus gateway cluster configuration according to the Meraki API schema (for example: name, devices, publicIp, location, etc.). If passing a PowerShell object or hashtable, convert it to JSON with ConvertTo-Json (mind the -Depth parameter for nested objects).

    .EXAMPLE
    # Using a PowerShell JSON string
    $config = '{
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
    New-MerakiNetworkCampusGatewayCluster -AuthToken $env:MERAKI_API_KEY -NetworkId 'L_123456789012345' -CampusGatewayConfig $config

    .NOTES
    - Endpoint: POST https://api.meraki.com/api/v1/networks/{networkId}/campusGateway/clusters
    - Request Content-Type: application/json; charset=utf-8
    - Ensure the provided CampusGatewayConfig is valid JSON that matches the Meraki API's expected schema.
    - The caller is responsible for error handling; this function surfaces Invoke-RestMethod errors.
    - API reference: https://developer.cisco.com/meraki/api-v1/
    #>
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$NetworkId,
            [parameter(Mandatory=$true)]
            [string]$CampusGatewayConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/campusGateway/clusters"
    
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $CampusGatewayConfig
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }