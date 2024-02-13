function Set-MerakiNetworkApplianceContentFiltering {
    <#
    .SYNOPSIS
    Updates the content filtering settings for a network's appliances using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkApplianceContentFiltering function allows you to update the content filtering settings for a network's appliances by providing the authentication token, network ID, and a content filtering configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the network for which you want to update the content filtering settings.

    .PARAMETER ContentFilterConfig
    A string containing the content filtering configuration. The string should be in JSON format and should include the "allowedUrlPatterns", "blockedUrlPatterns", "blockedUrlCategories", and "urlCategoryListSize" properties.

    .EXAMPLE
    $config = [PSCustomObject]@{
        allowedUrlPatterns = @(
            "http://www.example.org",
            "http://help.com.au"
        )
        blockedUrlPatterns = @(
            "http://www.example.com",
            "http://www.betting.com"
        )
        blockedUrlCategories = @(
            "meraki:contentFiltering/category/1",
            "meraki:contentFiltering/category/7"
        )
        urlCategoryListSize = "topSites"
    }

    $config = $config | ConvertTo-Json -Compress
    Set-MerakiNetworkApplianceContentFiltering -AuthToken "your-api-token" -NetworkId "your-network-id" -ContentFilterConfig $config

    This example updates the content filtering settings for the network with ID "your-network-id", using the specified content filtering configuration.

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
        [string]$ContentFilterConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $ContentFilterConfig

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/contentFiltering"
        $response = Invoke-RestMethod -Method Put -Uri $uri -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}