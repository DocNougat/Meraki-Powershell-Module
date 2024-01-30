function New-MerakiNetworkSwitchStack {
    <#
    .SYNOPSIS
    Creates a new network switch stack.
    
    .DESCRIPTION
    The New-MerakiNetworkSwitchStack function allows you to create a new network switch stack by providing the authentication token, network ID, and a JSON formatted string of stack configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
    .PARAMETER StackConfig
    A JSON formatted string of stack configuration.
    
    .EXAMPLE
    $StackConfig = [PSCustomObject]@{
        name = "A cool stack"
        serials = @(
            "QBZY-XWVU-TSRQ",
            "QBAB-CDEF-GHIJ"
        )
    }

    $StackConfig = $StackConfig | ConvertTo-Json
    New-MerakiNetworkSwitchStack -AuthToken "your-api-token" -NetworkId "1234" -StackConfig $StackConfig

    This example creates a new network switch stack with the specified configuration.
    
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
            [string]$StackConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/stacks"
    
            $body = $StackConfig
    
            $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
            Write-Host $_
        }
    }