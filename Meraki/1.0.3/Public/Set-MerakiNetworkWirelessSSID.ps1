function Set-MerakiNetworkWirelessSSID {
    <#
    .SYNOPSIS
    Updates a network wireless SSID.
    
    .DESCRIPTION
    The Set-MerakiNetworkWirelessSSID function allows you to update a network wireless SSID by providing the authentication token, network ID, SSID number, and a JSON formatted string of the SSID configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
    .PARAMETER SSIDNumber
    The number of the SSID.
    
    .PARAMETER SSIDConfig
    A JSON formatted string of the SSID configuration.
    
    .EXAMPLE
    $SSIDConfig = {
        "name": "My SSID",
        "enabled": true,
        "authMode": "8021x-radius",
        "enterpriseAdminAccess": "access enabled",
        "encryptionMode": "wpa",
        "psk": "deadbeef",
        "wpaEncryptionMode": "WPA2 only",
        "dot11w": {
            "enabled": true,
            "required": false
        },
        "dot11r": {
            "enabled": true,
            "adaptive": true
        },
        "splashPage": "Click-through splash page",
        "splashGuestSponsorDomains": [ "example.com" ],
        "oauth": {
            "allowedDomains": [ "example.com" ]
        },
        "localRadius": {
            "cacheTimeout": 60,
            "passwordAuthentication": { "enabled": false },
            "certificateAuthentication": {
                "enabled": true,
                "useLdap": false,
                "useOcsp": true,
                "ocspResponderUrl": "http://ocsp-server.example.com",
                "clientRootCaCertificate": {
                    "contents": "-----BEGIN CERTIFICATE-----\nMIIEKjCCAxKgAwIBAgIRANb+lsED3eb4+6YKLFFYqEkwDQYJKoZIhvcNAQELBQAw\ngYcxCzAJBgNVBAYTAlVTMRMwEQYDVQQIDApDYWxpZm9ybmlhMREwDwYDVQQHDAhT\nYW4gSm9zZTEcMBoGA1UECgwTQ2lzY28gU3lzdGVtcywgSW5jLjESMBAGA1UECwwJ\nRE5BU3BhY2VzMR4wHAYDVQQDDBVjaXNjby5vcGVucm9hbWluZy5vcmcwHhcNMjAx\nMTA1MjEzMzM1WhcNMjExMTA1MjIzMzM1WjCBpDEcMBoGCgmSJomT8ixkAQETDGRu\nYXNwYWNlczpVUzELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAkNBMQ4wDAYDVQQKEwVD\naXNjbzEcMBoGA1UECxMTV0JBOldSSVggRW5kLUVudGl0eTE8MDoGA1UEAxMzNjQ3\nMDcwNDM4NDQ5NjQxMjAwMDAuMTg4MzQuaHMuY2lzY28ub3BlbnJvYW1pbmcub3Jn\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAoqjP9QgRGyUO3p7SH9QK\nuTq6UYK7nAyjImgS4yQxeBkyZ5f2EUkX8m/AOcewpPxxPBhjPKRwxGeX3S50ksiA\nayFomUeslR0S0Z7RN9rzJa+CFyi9MwWIHMbLgXpB8tsSpgTAqwrzoTzOGq9fgC6u\npZhdZrBkg3FeJgD88goCi9mZDsY2YAoeGRLFJ2fR8iICqIVQy+Htq9pE22WBLpnS\nKjL3+mR9FArHNFtWlhKF2YHMUqyHHrnZnF/Ns7QNoMMF7/CK18iAKgnb+2wuGKM2\naEMddOeOTtz+i/rgjkp/RGMt011EdCsso0/cTo9qqX/bxOOCE4/Mne/ChMkQPnNU\nCwIDAQABo3IwcDAJBgNVHRMEAjAAMB8GA1UdIwQYMBaAFIG+4l5yiB01gP0sw4ML\nUSopqYcuMB0GA1UdDgQWBBSby1T9leYVOVVdOZXiHCSaDDEMiDAOBgNVHQ8BAf8E\nBAMCBaAwEwYDVR0lBAwwCgYIKwYBBQUHAwIwDQYJKoZIhvcNAQELBQADggEBAEyE\n1mjSUyY6uNp6W4l20w7SskALSJDRKkOeZxAgF3VMxlsCuEl70s9oEfntwIpyQtSa\njON/9yJHbwm/Az824bmk8Dc7AXIPhay+dftXb8j529gPuYB9AKoPNg0NctkyYCQh\na/3YQVdDWX7XgmEiXkL57M7G6+IdcPDONLArfjOcT9qHdkVVq1AIjlMSx3OQQmm/\nuoLb/G9q/97QA2/l8shG/Na8HjVqGLcl5TNZdbNhs2w9ogxr/GNzqdvym6RQ8vT/\nUR2n+uwH4n1MUxmHYYeyot5dnIV1IJ6hQ54JAncM9HvCLFk1WHz6RKshQUCuPBiJ\nwTw70BVktzJnb0VLeDg=\n-----END CERTIFICATE-----"
                }
            }
        },
        "ldap": {
            "servers": [
                {
                    "host": "127.0.0.1",
                    "port": 389
                }
            ],
            "credentials": {
                "distinguishedName": "cn=user,dc=example,dc=com",
                "password": "password"
            },
            "baseDistinguishedName": "dc=example,dc=com",
            "serverCaCertificate": {
                "contents": "-----BEGIN CERTIFICATE-----\nMIIEKjCCAxKgAwIBAgIRANb+lsED3eb4+6YKLFFYqEkwDQYJKoZIhvcNAQELBQAw\ngYcxCzAJBgNVBAYTAlVTMRMwEQYDVQQIDApDYWxpZm9ybmlhMREwDwYDVQQHDAhT\nYW4gSm9zZTEcMBoGA1UECgwTQ2lzY28gU3lzdGVtcywgSW5jLjESMBAGA1UECwwJ\nRE5BU3BhY2VzMR4wHAYDVQQDDBVjaXNjby5vcGVucm9hbWluZy5vcmcwHhcNMjAx\nMTA1MjEzMzM1WhcNMjExMTA1MjIzMzM1WjCBpDEcMBoGCgmSJomT8ixkAQETDGRu\nYXNwYWNlczpVUzELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAkNBMQ4wDAYDVQQKEwVD\naXNjbzEcMBoGA1UECxMTV0JBOldSSVggRW5kLUVudGl0eTE8MDoGA1UEAxMzNjQ3\nMDcwNDM4NDQ5NjQxMjAwMDAuMTg4MzQuaHMuY2lzY28ub3BlbnJvYW1pbmcub3Jn\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAoqjP9QgRGyUO3p7SH9QK\nuTq6UYK7nAyjImgS4yQxeBkyZ5f2EUkX8m/AOcewpPxxPBhjPKRwxGeX3S50ksiA\nayFomUeslR0S0Z7RN9rzJa+CFyi9MwWIHMbLgXpB8tsSpgTAqwrzoTzOGq9fgC6u\npZhdZrBkg3FeJgD88goCi9mZDsY2YAoeGRLFJ2fR8iICqIVQy+Htq9pE22WBLpnS\nKjL3+mR9FArHNFtWlhKF2YHMUqyHHrnZnF/Ns7QNoMMF7/CK18iAKgnb+2wuGKM2\naEMddOeOTtz+i/rgjkp/RGMt011EdCsso0/cTo9qqX/bxOOCE4/Mne/ChMkQPnNU\nCwIDAQABo3IwcDAJBgNVHRMEAjAAMB8GA1UdIwQYMBaAFIG+4l5yiB01gP0sw4ML\nUSopqYcuMB0GA1UdDgQWBBSby1T9leYVOVVdOZXiHCSaDDEMiDAOBgNVHQ8BAf8E\nBAMCBaAwEwYDVR0lBAwwCgYIKwYBBQUHAwIwDQYJKoZIhvcNAQELBQADggEBAEyE\n1mjSUyY6uNp6W4l20w7SskALSJDRKkOeZxAgF3VMxlsCuEl70s9oEfntwIpyQtSa\njON/9yJHbwm/Az824bmk8Dc7AXIPhay+dftXb8j529gPuYB9AKoPNg0NctkyYCQh\na/3YQVdDWX7XgmEiXkL57M7G6+IdcPDONLArfjOcT9qHdkVVq1AIjlMSx3OQQmm/\nuoLb/G9q/97QA2/l8shG/Na8HjVqGLcl5TNZdbNhs2w9ogxr/GNzqdvym6RQ8vT/\nUR2n+uwH4n1MUxmHYYeyot5dnIV1IJ6hQ54JAncM9HvCLFk1WHz6RKshQUCuPBiJ\nwTw70BVktzJnb0VLeDg=\n-----END CERTIFICATE-----"
            }
        },
        "activeDirectory": {
            "servers": [
                {
                    "host": "127.0.0.1",
                    "port": 3268
                }
            ],
            "credentials": {
                "logonName": "user",
                "password": "password"
            }
        },
        "radiusServers": [
            {
                "host": "0.0.0.0",
                "port": 3000,
                "secret": "secret-string",
                "radsecEnabled": true,
                "openRoamingCertificateId": 2,
                "caCertificate": "-----BEGIN CERTIFICATE-----\nMIIEKjCCAxKgAwIBAgIRANb+lsED3eb4+6YKLFFYqEkwDQYJKoZIhvcNAQELBQAw\ngYcxCzAJBgNVBAYTAlVTMRMwEQYDVQQIDApDYWxpZm9ybmlhMREwDwYDVQQHDAhT\nYW4gSm9zZTEcMBoGA1UECgwTQ2lzY28gU3lzdGVtcywgSW5jLjESMBAGA1UECwwJ\nRE5BU3BhY2VzMR4wHAYDVQQDDBVjaXNjby5vcGVucm9hbWluZy5vcmcwHhcNMjAx\nMTA1MjEzMzM1WhcNMjExMTA1MjIzMzM1WjCBpDEcMBoGCgmSJomT8ixkAQETDGRu\nYXNwYWNlczpVUzELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAkNBMQ4wDAYDVQQKEwVD\naXNjbzEcMBoGA1UECxMTV0JBOldSSVggRW5kLUVudGl0eTE8MDoGA1UEAxMzNjQ3\nMDcwNDM4NDQ5NjQxMjAwMDAuMTg4MzQuaHMuY2lzY28ub3BlbnJvYW1pbmcub3Jn\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAoqjP9QgRGyUO3p7SH9QK\nuTq6UYK7nAyjImgS4yQxeBkyZ5f2EUkX8m/AOcewpPxxPBhjPKRwxGeX3S50ksiA\nayFomUeslR0S0Z7RN9rzJa+CFyi9MwWIHMbLgXpB8tsSpgTAqwrzoTzOGq9fgC6u\npZhdZrBkg3FeJgD88goCi9mZDsY2YAoeGRLFJ2fR8iICqIVQy+Htq9pE22WBLpnS\nKjL3+mR9FArHNFtWlhKF2YHMUqyHHrnZnF/Ns7QNoMMF7/CK18iAKgnb+2wuGKM2\naEMddOeOTtz+i/rgjkp/RGMt011EdCsso0/cTo9qqX/bxOOCE4/Mne/ChMkQPnNU\nCwIDAQABo3IwcDAJBgNVHRMEAjAAMB8GA1UdIwQYMBaAFIG+4l5yiB01gP0sw4ML\nUSopqYcuMB0GA1UdDgQWBBSby1T9leYVOVVdOZXiHCSaDDEMiDAOBgNVHQ8BAf8E\nBAMCBaAwEwYDVR0lBAwwCgYIKwYBBQUHAwIwDQYJKoZIhvcNAQELBQADggEBAEyE\n1mjSUyY6uNp6W4l20w7SskALSJDRKkOeZxAgF3VMxlsCuEl70s9oEfntwIpyQtSa\njON/9yJHbwm/Az824bmk8Dc7AXIPhay+dftXb8j529gPuYB9AKoPNg0NctkyYCQh\na/3YQVdDWX7XgmEiXkL57M7G6+IdcPDONLArfjOcT9qHdkVVq1AIjlMSx3OQQmm/\nuoLb/G9q/97QA2/l8shG/Na8HjVqGLcl5TNZdbNhs2w9ogxr/GNzqdvym6RQ8vT/\nUR2n+uwH4n1MUxmHYYeyot5dnIV1IJ6hQ54JAncM9HvCLFk1WHz6RKshQUCuPBiJ\nwTw70BVktzJnb0VLeDg=\n-----END CERTIFICATE-----"
            }
        ],
        "radiusProxyEnabled": false,
        "radiusTestingEnabled": true,
        "radiusCalledStationId": "00-11-22-33-44-55:AP1",
        "radiusAuthenticationNasId": "00-11-22-33-44-55:AP1",
        "radiusServerTimeout": 5,
        "radiusServerAttemptsLimit": 5,
        "radiusFallbackEnabled": true,
        "radiusCoaEnabled": true,
        "radiusFailoverPolicy": "Deny access",
        "radiusLoadBalancingPolicy": "Round robin",
        "radiusAccountingEnabled": true,
        "radiusAccountingServers": [
            {
                "host": "0.0.0.0",
                "port": 3000,
                "secret": "secret-string",
                "radsecEnabled": true,
                "caCertificate": "-----BEGIN CERTIFICATE-----\nMIIEKjCCAxKgAwIBAgIRANb+lsED3eb4+6YKLFFYqEkwDQYJKoZIhvcNAQELBQAw\ngYcxCzAJBgNVBAYTAlVTMRMwEQYDVQQIDApDYWxpZm9ybmlhMREwDwYDVQQHDAhT\nYW4gSm9zZTEcMBoGA1UECgwTQ2lzY28gU3lzdGVtcywgSW5jLjESMBAGA1UECwwJ\nRE5BU3BhY2VzMR4wHAYDVQQDDBVjaXNjby5vcGVucm9hbWluZy5vcmcwHhcNMjAx\nMTA1MjEzMzM1WhcNMjExMTA1MjIzMzM1WjCBpDEcMBoGCgmSJomT8ixkAQETDGRu\nYXNwYWNlczpVUzELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAkNBMQ4wDAYDVQQKEwVD\naXNjbzEcMBoGA1UECxMTV0JBOldSSVggRW5kLUVudGl0eTE8MDoGA1UEAxMzNjQ3\nMDcwNDM4NDQ5NjQxMjAwMDAuMTg4MzQuaHMuY2lzY28ub3BlbnJvYW1pbmcub3Jn\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAoqjP9QgRGyUO3p7SH9QK\nuTq6UYK7nAyjImgS4yQxeBkyZ5f2EUkX8m/AOcewpPxxPBhjPKRwxGeX3S50ksiA\nayFomUeslR0S0Z7RN9rzJa+CFyi9MwWIHMbLgXpB8tsSpgTAqwrzoTzOGq9fgC6u\npZhdZrBkg3FeJgD88goCi9mZDsY2YAoeGRLFJ2fR8iICqIVQy+Htq9pE22WBLpnS\nKjL3+mR9FArHNFtWlhKF2YHMUqyHHrnZnF/Ns7QNoMMF7/CK18iAKgnb+2wuGKM2\naEMddOeOTtz+i/rgjkp/RGMt011EdCsso0/cTo9qqX/bxOOCE4/Mne/ChMkQPnNU\nCwIDAQABo3IwcDAJBgNVHRMEAjAAMB8GA1UdIwQYMBaAFIG+4l5yiB01gP0sw4ML\nUSopqYcuMB0GA1UdDgQWBBSby1T9leYVOVVdOZXiHCSaDDEMiDAOBgNVHQ8BAf8E\nBAMCBaAwEwYDVR0lBAwwCgYIKwYBBQUHAwIwDQYJKoZIhvcNAQELBQADggEBAEyE\n1mjSUyY6uNp6W4l20w7SskALSJDRKkOeZxAgF3VMxlsCuEl70s9oEfntwIpyQtSa\njON/9yJHbwm/Az824bmk8Dc7AXIPhay+dftXb8j529gPuYB9AKoPNg0NctkyYCQh\na/3YQVdDWX7XgmEiXkL57M7G6+IdcPDONLArfjOcT9qHdkVVq1AIjlMSx3OQQmm/\nuoLb/G9q/97QA2/l8shG/Na8HjVqGLcl5TNZdbNhs2w9ogxr/GNzqdvym6RQ8vT/\nUR2n+uwH4n1MUxmHYYeyot5dnIV1IJ6hQ54JAncM9HvCLFk1WHz6RKshQUCuPBiJ\nwTw70BVktzJnb0VLeDg=\n-----END CERTIFICATE-----"
            }
        ],
        "radiusAccountingInterimInterval": 5,
        "radiusAttributeForGroupPolicies": "Filter-Id",
        "ipAssignmentMode": "NAT mode",
        "useVlanTagging": false,
        "concentratorNetworkId": "N_24329156",
        "secondaryConcentratorNetworkId": "disabled",
        "disassociateClientsOnVpnFailover": false,
        "vlanId": 10,
        "defaultVlanId": 1,
        "apTagsAndVlanIds": [
            {
                "tags": [ "tag1", "tag2" ],
                "vlanId": 100
            }
        ],
        "walledGardenEnabled": true,
        "walledGardenRanges": [ "example.com", "1.1.1.1/32" ],
        "gre": {
            "concentrator": { "host": "192.168.1.1" },
            "key": 5
        },
        "radiusOverride": false,
        "radiusGuestVlanEnabled": true,
        "radiusGuestVlanId": 1,
        "minBitrate": 5.5,
        "bandSelection": "5 GHz band only",
        "perClientBandwidthLimitUp": 0,
        "perClientBandwidthLimitDown": 0,
        "perSsidBandwidthLimitUp": 0,
        "perSsidBandwidthLimitDown": 0,
        "lanIsolationEnabled": true,
        "visible": true,
        "availableOnAllAps": false,
        "availabilityTags": [ "tag1", "tag2" ],
        "mandatoryDhcpEnabled": false,
        "adultContentFilteringEnabled": false,
        "dnsRewrite": {
            "enabled": true,
            "dnsCustomNameservers": [ "8.8.8.8", "8.8.4.4" ]
        },
        "speedBurst": { "enabled": true },
        "namedVlans": {
            "tagging": {
                "enabled": true,
                "defaultVlanName": "My VLAN",
                "byApTags": [
                    {
                        "tags": [
                            "tag1",
                            "tag2"
                        ],
                        "vlanName": "My VLAN"
                    }
                ]
            },
            "radius": {
                "guestVlan": {
                    "enabled": true,
                    "name": "Guest VLAN"
                }
            }
        }
    }'
    $SSIDConfig = $SSIDConfig | ConvertTo-Json -Compress
    Set-MerakiNetworkWirelessSSID -AuthToken "your-api-token" -NetworkId "1234" -SSIDNumber 0 -SSIDConfig $SSIDConfig
    
    This example updates a network wireless SSID with the specified configuration.
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the update is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$NetworkId,
            [parameter(Mandatory=$true)]
            [int]$SSIDNumber,
            [parameter(Mandatory=$true)]
            [string]$SSIDConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/wireless/ssids/$SSIDNumber"
    
            $body = $SSIDConfig
    
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
            Write-Host $_
        }
    }