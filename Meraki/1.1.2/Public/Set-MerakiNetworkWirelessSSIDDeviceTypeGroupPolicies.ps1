function Set-MerakiNetworkWirelessSSIDDeviceTypeGroupPolicies {
    <#
    .SYNOPSIS
    Updates a network wireless SSID device type group policies.
    
    .DESCRIPTION
    The Set-MerakiNetworkWirelessSSIDDeviceTypeGroupPolicies function allows you to update a network wireless SSID device type group policies by providing the authentication token, network ID, SSID number, and a JSON formatted string of the group policies.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
    .PARAMETER SSIDNumber
    The number of the SSID.
    
    .PARAMETER GroupPolicies
    A JSON formatted string of the group policies.
    
    .EXAMPLE
    $GroupPolicies = [PSCustomObject]@{
        enabled = $true
        deviceTypePolicies = @(
            [PSCustomObject]@{
                deviceType = "Android"
                devicePolicy = "Allowed"
            },
            [PSCustomObject]@{
                deviceType = "iPhone"
                devicePolicy = "Group policy"
                groupPolicyId = 101
            }
        )
    }
    $GroupPolicies = $GroupPolicies | ConvertTo-Json -Compress
    Set-MerakiNetworkWirelessSSIDDeviceTypeGroupPolicies -AuthToken "your-api-token" -NetworkId "1234" -SSIDNumber 0 -GroupPolicies $GroupPolicies

    This example updates a network wireless SSID device type group policies with the specified configuration.
    
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
            [int]$SSIDNumber,
            [parameter(Mandatory=$true)]
            [string]$GroupPolicies
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/wireless/ssids/$SSIDNumber/deviceTypeGroupPolicies"
    
            $body = $GroupPolicies
    
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }