function New-MerakiNetworkSwitchLinkAggregation {
    <#
    .SYNOPSIS
    Creates a new link aggregation for a network switch.
    
    .DESCRIPTION
    The New-MerakiNetworkSwitchLinkAggregation function allows you to create a new link aggregation for a specified network switch by providing the authentication token, network ID, and a JSON formatted string of aggregation configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network in which the network switch is located.
    
    .PARAMETER AggregationConfig
    A JSON formatted string of aggregation configuration.
    
    .EXAMPLE
    $AggregationConfig = [PSCustomObject]@{
        switchPorts = @(
            @{
                serial = "Q234-ABCD-0001"
                portId = "1"
            },
            @{
                serial = "Q234-ABCD-0002"
                portId = "2"
            },
            @{
                serial = "Q234-ABCD-0003"
                portId = "3"
            },
            @{
                serial = "Q234-ABCD-0004"
                portId = "4"
            },
            @{
                serial = "Q234-ABCD-0005"
                portId = "5"
            },
            @{
                serial = "Q234-ABCD-0006"
                portId = "6"
            },
            @{
                serial = "Q234-ABCD-0007"
                portId = "7"
            },
            @{
                serial = "Q234-ABCD-0008"
                portId = "8"
            }
        )
    }

    $AggregationConfig = $AggregationConfig | ConvertTo-Json -Compress
    New-MerakiNetworkSwitchLinkAggregation -AuthToken "your-api-token" -NetworkId "1234" -AggregationConfig $AggregationConfig

    This example creates a new link aggregation for the network switch in the Meraki network with ID "1234" with the specified aggregation configuration.
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the creation is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$NetworkId,
            [parameter(Mandatory=$true)]
            [string]$AggregationConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/linkAggregations"
    
            $body = $AggregationConfig
    
            $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
            Write-Host $_
            Throw $_
        }
    }