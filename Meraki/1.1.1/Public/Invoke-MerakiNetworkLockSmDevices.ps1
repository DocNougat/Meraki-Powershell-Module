function Invoke-MerakiNetworkLockSmDevices {
    <#
    .SYNOPSIS
    Locks devices for a Meraki network.
    
    .DESCRIPTION
    The Invoke-MerakiNetworkLockSmDevices function allows you to lock devices for a specified Meraki network by providing the authentication token, network ID, and a JSON formatted string of lock configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to lock devices.
    
    .PARAMETER LockConfig
    A JSON formatted string of lock configuration.
    
    .EXAMPLE
    $config = [PSCustomObject]@{
        wifiMacs = [ "00:11:22:33:44:55" ]
        ids = @(
            "1284392014819",
            "2983092129865"
        )
        serials = @(
            "Q234-ABCD-0001",
            "Q234-ABCD-0002",
            "Q234-ABCD-0003"
        )
        scope = [ "withAny", "tag1", "tag2" ]
        pin = 123456
    }

    $configJson = $config | ConvertTo-Json
    Invoke-MerakiNetworkLockSmDevices -AuthToken "your-api-token" -NetworkId "1234" -LockConfig $configJson
    
    This example locks devices for the Meraki network with ID "1234" with the specified lock configuration.
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the lock is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$NetworkId,
            [parameter(Mandatory=$true)]
            [string]$LockConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/sm/devices/lock"
    
            $body = $LockConfig
    
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }