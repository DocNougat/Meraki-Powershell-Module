function Invoke-MerakiNetworkCheckinSmDevices {
    <#
    .SYNOPSIS
    Checks in devices for a Meraki network.
    
    .DESCRIPTION
    The Invoke-MerakiNetworkCheckinSmDevices function allows you to check in devices for a specified Meraki network by providing the authentication token, network ID, and a JSON formatted string of check-in configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to check in devices.
    
    .PARAMETER CheckinConfig
    A JSON formatted string of check-in configuration.
    
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
    }

    $config = $config | ConvertTo-Json
    Invoke-MerakiNetworkCheckinSmDevices -AuthToken "your-api-token" -NetworkId "1234" -CheckinConfig $config

    This example checks in devices for the Meraki network with ID "1234" with the specified check-in configuration.
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the check-in is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$NetworkId,
            [parameter(Mandatory=$true)]
            [string]$CheckinConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/sm/devices/checkin"
    
            $body = $CheckinConfig
    
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }