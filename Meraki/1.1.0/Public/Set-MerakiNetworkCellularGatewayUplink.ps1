function Set-MerakiNetworkCellularGatewayUplink {
    <#
    .SYNOPSIS
    Updates the uplink configuration for a Meraki network's cellular gateway.
    
    .DESCRIPTION
    The Set-MerakiNetworkCellularGatewayUplink function allows you to update the uplink configuration for a specified Meraki network's cellular gateway by providing the authentication token, network ID, and an uplink configuration string.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The network ID of the Meraki network for which you want to update the uplink configuration.
    
    .PARAMETER UplinkConfig
    A string containing the uplink configuration. The string should be in JSON format and should include the properties as defined in the schema.
    
    .EXAMPLE
    $UplinkConfig = [PSCustomObject]@{
        bandwidthLimits = @{
            limitUp = 1000
            limitDown = 1000
        }
    }

    $UplinkConfig = $UplinkConfig | ConvertTo-Json -Compress

    Set-MerakiNetworkCellularGatewayUplink -AuthToken "your-api-token" -NetworkId "N_1234" -UplinkConfig $UplinkConfig

    This example updates the uplink configuration for the Meraki network with ID "N_1234".
    
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
            [string]$UplinkConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/cellularGateway/uplink"
    
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat" -Body $UplinkConfig
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }