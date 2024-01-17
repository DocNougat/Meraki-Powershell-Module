function Set-MerakiNetworkCellularGatewayConnectivityMonitoringDests {
    <#
    .SYNOPSIS
    Updates the connectivity monitoring destinations for a Meraki network's cellular gateway.
    
    .DESCRIPTION
    The Set-MerakiNetworkCellularGatewayConnectivityMonitoringDests function allows you to update the connectivity monitoring destinations for a specified Meraki network's cellular gateway by providing the authentication token, network ID, and a connectivity monitoring destinations configuration string.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to update the connectivity monitoring destinations.
    
    .PARAMETER ConnectivityMonitoringDestinations
    A string containing the connectivity monitoring destinations configuration. The string should be in JSON format and should include the properties as defined in the schema.
    
    .EXAMPLE
    $ConnectivityMonitoringDestinations = [PSCustomObject]@{
        destinations = @(
            @{
                ip = "8.8.8.8"
                description = "Google"
                default = $false
            },
            @{
                ip = "1.23.45.67"
                description = "test description"
                default = $true
            },
            @{
                ip = "9.8.7.6"
            }
        )
    }

    $ConnectivityMonitoringDestinations = $ConnectivityMonitoringDestinations | ConvertTo-Json -Compress

    Set-MerakiNetworkCellularGatewayConnectivityMonitoringDests -AuthToken "your-api-token" -NetworkId "N_1234" -ConnectivityMonitoringDestinations $ConnectivityMonitoringDestinations

    This example updates the connectivity monitoring destinations for the Meraki network with ID "N_1234".
    
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
            [string]$ConnectivityMonitoringDestinations
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/cellularGateway/connectivityMonitoringDestinations"
    
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $ConnectivityMonitoringDestinations
            return $response
        }
        catch {
            Write-Host $_
        }
    }