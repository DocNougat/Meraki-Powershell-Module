function Invoke-MerakiNetworkMoveSmDevices {
    <#
    .SYNOPSIS
    Moves devices to a new network in a Meraki network.
    
    .DESCRIPTION
    The Invoke-MerakiNetworkMoveSmDevices function allows you to move devices to a new network in a specified Meraki network by providing the authentication token, network ID, and a JSON formatted string of move configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network from which you want to move devices.
    
    .PARAMETER MoveConfig
    A JSON formatted string of move configuration.
    
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
        newNetwork = "1284392014819"
    }

    $config = $config | ConvertTo-Json
    Invoke-MerakiNetworkMoveSmDevices -AuthToken "your-api-token" -NetworkId "1234" -MoveConfig $config

    This example moves devices from the Meraki network with ID "1234" to the new network with the specified move configuration.
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the move is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$NetworkId,
            [parameter(Mandatory=$true)]
            [string]$MoveConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/sm/devices/move"
    
            $body = $MoveConfig
    
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }