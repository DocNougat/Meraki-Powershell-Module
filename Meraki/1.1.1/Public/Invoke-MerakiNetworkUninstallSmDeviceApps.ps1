function Invoke-MerakiNetworkUninstallSmDeviceApps {
    <#
    .SYNOPSIS
    Uninstalls apps from a device in a Meraki network.
    
    .DESCRIPTION
    The Invoke-MerakiNetworkUninstallSmDeviceApps function allows you to uninstall apps from a device in a specified Meraki network by providing the authentication token, network ID, device ID, and a JSON formatted string of app IDs.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network in which the device is located.
    
    .PARAMETER DeviceId
    The ID of the device from which the apps will be uninstalled.
    
    .PARAMETER AppIDs
    A JSON formatted string of app IDs to be uninstalled.
    
    .EXAMPLE
    $appIds = @{
        appIds = @(
            "1284392014819",
            "2983092129865"
        )
    } | ConvertTo-Json

    Invoke-MerakiNetworkUninstallSmDeviceApps -AuthToken "your-api-token" -NetworkId "1234" -DeviceId "5678" -AppIDs $appIds
    This example uninstalls apps from the device with ID "5678" in the Meraki network with ID "1234" with the specified app IDs.
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the uninstallation is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$NetworkId,
            [parameter(Mandatory=$true)]
            [string]$DeviceId,
            [parameter(Mandatory=$true)]
            [string]$AppIDs
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/sm/devices/$DeviceId/uninstallApps"
    
            $body = $AppIDs
    
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }