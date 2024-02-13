function Set-MerakiNetworkSwitchSTP {
    <#
    .SYNOPSIS
    Updates a network switch STP.
    
    .DESCRIPTION
    The Set-MerakiNetworkSwitchSTP function allows you to update a network switch STP by providing the authentication token, network ID, and a JSON formatted string of the STP configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
    .PARAMETER STPConfig
    A JSON formatted string of the STP configuration.
    
    .EXAMPLE
    $STPConfig = [PSCustomObject]@{
        rstpEnabled = $true
        stpBridgePriority = @(
            @{
                switches = @("Q234-ABCD-0001", "Q234-ABCD-0002", "Q234-ABCD-0003")
                stpPriority = 4096
            },
            @{
                stacks = @("789102", "123456", "129102")
                stpPriority = 28672
            }
        )
    }

    $STPConfig = $STPConfig | ConvertTo-Json -Compress
    Set-MerakiNetworkSwitchSTP -AuthToken "your-api-token" -NetworkId "1234" -STPConfig $STPConfig

    This example updates a network switch STP with the specified configuration.
    
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
            [string]$STPConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/stp"
    
            $body = $STPConfig
    
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }