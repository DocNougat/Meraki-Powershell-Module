function Invoke-MerakiNetworkInstallSmDeviceApps {
    <#
    .SYNOPSIS
    Installs apps on a device in a Meraki network.
    
    .DESCRIPTION
    The Invoke-MerakiNetworkInstallSmDeviceApps function allows you to install apps on a device in a specified Meraki network by providing the authentication token, network ID, device ID, and a JSON formatted string of app configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network in which the device is located.
    
    .PARAMETER DeviceId
    The ID of the device on which the apps will be installed.
    
    .PARAMETER AppConfig
    A JSON formatted string of app configuration.
    
    .EXAMPLE
    $config = [PSCustomObject]@{
        appIds = @(
            "1284392014819",
            "2983092129865"
        )
        force = $false
    }

    $config = $config | ConvertTo-Json
    Invoke-MerakiNetworkInstallSmDeviceApps -AuthToken "your-api-token" -NetworkId "1234" -DeviceId "5678" -AppConfig $config
    This example installs apps on the device with ID "5678" in the Meraki network with ID "1234" with the specified app configuration.
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the installation is successful, otherwise, it displays an error message.
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
            [string]$AppConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/sm/devices/$DeviceId/installApps"
    
            $body = $AppConfig
    
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }