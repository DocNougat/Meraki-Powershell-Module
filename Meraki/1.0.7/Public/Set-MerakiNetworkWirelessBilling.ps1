function Set-MerakiNetworkWirelessBilling {
    <#
    .SYNOPSIS
    Updates a network wireless billing configuration.
    
    .DESCRIPTION
    The Set-MerakiNetworkWirelessBilling function allows you to update a network wireless billing configuration by providing the authentication token, network ID, and a JSON formatted string of the billing configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
    .PARAMETER BillingConfig
    A JSON formatted string of the billing configuration.
    
    .EXAMPLE
    $BillingConfig = [PSCustomObject]@{
        currency = "USD"
        plans = @(
            [PSCustomObject]@{
                id = "1"
                price = 5
                bandwidthLimits = [PSCustomObject]@{
                    limitUp = 1000
                    limitDown = 1000
                }
                timeLimit = "1 hour"
            }
        )
    }

    $BillingConfig = $BillingConfig | ConvertTo-Json -Compress
    Set-MerakiNetworkWirelessBilling -AuthToken "your-api-token" -NetworkId "1234" -BillingConfig $BillingConfig

    This example updates a network wireless billing configuration with the specified configuration.
    
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
            [string]$BillingConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/wireless/billing"
    
            $body = $BillingConfig
    
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }