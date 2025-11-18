function Invoke-MerakiNetworkModifySmDevicesTags {
    <#
    .SYNOPSIS
    Modifies tags for devices in a Meraki network.
    
    .DESCRIPTION
    The Invoke-MerakiNetworkModifySmDevicesTags function allows you to modify tags for devices in a specified Meraki network by providing the authentication token, network ID, and a JSON formatted string of tags configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to modify device tags.
    
    .PARAMETER TagsConfig
    A JSON formatted string of tags configuration.
    
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
        scope = [ "withAny, old_tag" ]
        tags = [ "tag1", "tag2" ]
        updateAction = "add"
    }

    $configJson = $config | ConvertTo-Json
    Invoke-MerakiNetworkModifySmDevicesTags -AuthToken "your-api-token" -NetworkId "1234" -TagsConfig $configJson
    This example modifies tags for devices in the Meraki network with ID "1234" with the specified tags configuration.
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the modification is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$NetworkId,
            [parameter(Mandatory=$true)]
            [string]$TagsConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/sm/devices/modifyTags"
    
            $body = $TagsConfig
    
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }