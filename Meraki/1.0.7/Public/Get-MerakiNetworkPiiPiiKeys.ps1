function Get-MerakiNetworkPiiPiiKeys {
    <#
    .SYNOPSIS
    Retrieves Personally Identifiable Information (PII) keys for a specified Meraki network.

    .DESCRIPTION
    The Get-MerakiNetworkPiiPiiKeys function retrieves PII keys for a specified Meraki network using the Meraki API. You must provide an API authentication token and the network ID as parameters. You can also specify optional parameters to filter the data returned.

    .PARAMETER AuthToken
    The Meraki API authentication token.

    .PARAMETER NetworkId
    The ID of the network to retrieve PII keys for.

    .PARAMETER username
    The username associated with the device.

    .PARAMETER email
    The email address associated with the device.

    .PARAMETER mac
    The MAC address of the device.

    .PARAMETER serial
    The serial number of the device.

    .PARAMETER imei
    The International Mobile Equipment Identity (IMEI) of the device.

    .PARAMETER bluetoothMac
    The Bluetooth MAC address of the device.

    .EXAMPLE
    Get-MerakiNetworkPiiPiiKeys -AuthToken '12345' -NetworkId 'L_123456789' -username 'user@example.com'

    This example retrieves PII keys for the Meraki network with ID 'L_123456789' using the Meraki API authentication token '12345'. The data returned will be for the device associated with the username 'user@example.com'.

    .NOTES
    For more information about the Meraki API, see https://developer.cisco.com/meraki/api-v1/.
    #>
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$NetworkId,
        [Parameter(Mandatory=$false)]
        [string]$username,
        [Parameter(Mandatory=$false)]
        [string]$email,
        [Parameter(Mandatory=$false)]
        [string]$mac,
        [Parameter(Mandatory=$false)]
        [string]$serial,
        [Parameter(Mandatory=$false)]
        [string]$imei,
        [Parameter(Mandatory=$false)]
        [string]$bluetoothMac
    )
    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
    
        $queryParams = @{}
    
        if ($username) {
            $queryParams['username'] = $username
        }
        if ($email) {
            $queryParams['email'] = $email
        }
        if ($mac) {
            $queryParams['mac'] = $mac
        }
        if ($serial) {
            $queryParams['serial'] = $serial
        }
        if ($imei) {
            $queryParams['imei'] = $imei
        }
        if ($bluetoothMac) {
            $queryParams['bluetoothMac'] = $bluetoothMac
        }
    
        $queryString = New-MerakiQueryString -queryParams $queryParams
    
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/pii/piiKeys?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
