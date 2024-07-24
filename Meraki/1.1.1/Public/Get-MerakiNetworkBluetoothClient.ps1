function Get-MerakiNetworkBluetoothClient {
    <#
    .SYNOPSIS
    Retrieves a Bluetooth client from a specified Meraki network by ID.

    .DESCRIPTION
    This function retrieves the details of a Bluetooth client in a specified Meraki network by ID. The function can also include the connectivity history of the client if specified.

    .PARAMETER AuthToken
    The Meraki API token to use for authentication.

    .PARAMETER NetworkId
    The ID of the Meraki network that the client is associated with.

    .PARAMETER BluetoothClientId
    The ID of the Bluetooth client to retrieve.

    .PARAMETER IncludeConnectivityHistory
    Optional. Specifies whether to include the connectivity history of the client in the response. Default is true.

    .PARAMETER ConnectivityHistoryTimespan
    Optional. Specifies the time range for the connectivity history of the client in seconds. If not specified, the full history is returned.

    .EXAMPLE
    Get-MerakiNetworkBluetoothClient -AuthToken "1234" -NetworkId "5678" -BluetoothClientId "abcd" -IncludeConnectivityHistory $true -ConnectivityHistoryTimespan 86400

    Retrieves the details of the Bluetooth client with ID "abcd" in the Meraki network with ID "5678", including the connectivity history for the past 24 hours.

    .NOTES
    
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$bluetoothClientId,
        [parameter(Mandatory=$false)]
        [bool]$includeConnectivityHistory = $true,
        [parameter(Mandatory=$false)]
        [int]$connectivityHistoryTimespan = $null
    )

    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $queryParams = @{}
    
        if ($includeConnectivityHistory) {
            $queryParams['includeConnectivityHistory'] = $includeConnectivityHistory
        }
        if ($connectivityHistoryTimespan) {
            $queryParams['connectivityHistoryTimespan'] = $connectivityHistoryTimespan
        }
    
        $queryString = New-MerakiQueryString -queryParams $queryParams
    
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/bluetoothClients/$bluetoothClientId?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
