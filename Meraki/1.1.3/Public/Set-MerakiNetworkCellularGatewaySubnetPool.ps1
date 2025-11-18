function Set-MerakiNetworkCellularGatewaySubnetPool {
    <#
    .SYNOPSIS
    Updates the subnet pool for a Meraki network's cellular gateway.
    
    .DESCRIPTION
    The Set-MerakiNetworkCellularGatewaySubnetPool function allows you to update the subnet pool for a specified Meraki network's cellular gateway by providing the authentication token, network ID, and a subnet pool configuration string.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The network ID of the Meraki network for which you want to update the subnet pool.
    
    .PARAMETER SubnetPoolConfig
    A string containing the subnet pool configuration. The string should be in JSON format and should include the properties as defined in the schema.
    
    .EXAMPLE
    $SubnetPoolConfig = [PSCustomObject]@{
        deploymentMode = "routed"
        cidr = "192.168.0.0/16"
        mask = 24
    }

    $SubnetPoolConfig = $SubnetPoolConfig | ConvertTo-Json -Compress -Depth 4

    Set-MerakiNetworkCellularGatewaySubnetPool -AuthToken "your-api-token" -NetworkId "N_1234" -SubnetPoolConfig $SubnetPoolConfig

    This example updates the subnet pool for the Meraki network with ID "N_1234".
    
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
            [string]$SubnetPoolConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/cellularGateway/subnetPool"
    
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $SubnetPoolConfig
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }