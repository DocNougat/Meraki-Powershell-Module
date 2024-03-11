function Get-MerakiNetworkPiiSmDevicesForKey {
    <#
    .SYNOPSIS
    Retrieves Personally Identifiable Information (PII) data for Systems Manager (SM) devices for a specified Meraki network.

    .DESCRIPTION
    The Get-MerakiNetworkPiiSmDevicesForKey function retrieves PII data for SM devices for a specified Meraki network using the Meraki API. You must provide an API authentication token, the network ID, and at least one of the following parameters: username, email, MAC address, serial number, IMEI, or Bluetooth MAC address.

    .PARAMETER AuthToken
    The Meraki API authentication token.

    .PARAMETER NetworkId
    The ID of the network to retrieve PII data for SM devices for.

    .PARAMETER username
    The username associated with the SM device.

    .PARAMETER email
    The email address associated with the SM device.

    .PARAMETER mac
    The MAC address of the SM device.

    .PARAMETER serial
    The serial number of the SM device.

    .PARAMETER imei
    The IMEI number of the SM device.

    .PARAMETER bluetoothMac
    The Bluetooth MAC address of the SM device.

    .EXAMPLE
    Get-MerakiNetworkPiiSmDevicesForKey -AuthToken '12345' -NetworkId 'L_123456789' -email 'test@example.com'

    This example retrieves PII data for SM devices associated with the email address 'test@example.com' for the Meraki network with ID 'L_123456789' using the Meraki API authentication token '12345'.

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
    
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/pii/smDevicesForKey?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}