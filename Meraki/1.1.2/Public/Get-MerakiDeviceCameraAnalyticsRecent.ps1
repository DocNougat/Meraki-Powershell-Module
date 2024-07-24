function Get-MerakiDeviceCameraAnalyticsRecent {
    <#
    .SYNOPSIS
        Gets recent analytics data for a specific Cisco Meraki camera device by serial number.
    .DESCRIPTION
        This function makes a REST API call to the Meraki dashboard API to retrieve recent analytics data for a specific Cisco Meraki camera device, based on its serial number. The function returns detailed information about the camera's recent analytics data, including object counts, zones, and more.
    .PARAMETER AuthToken
        The authentication token to use for the API call. This should be a valid API key for the Meraki dashboard.
    .PARAMETER deviceSerial
        The serial number of the Cisco Meraki camera device to retrieve recent analytics data for.
    .PARAMETER ObjectType
        The object type to filter the analytics data by. Valid values include 'person', 'vehicle', and 'face'.
    .EXAMPLE
        PS C:\> Get-MerakiDeviceCameraAnalyticsRecent -AuthToken "myapikey" -deviceSerial "Q2XX-XXXX-XXXX"
        Returns recent analytics data for the Cisco Meraki camera device with the specified serial number.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$DeviceSerial,
        [parameter(Mandatory=$false)]
        [string]$ObjectType
    )
    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }

        $queryParams = @{}
    
        if ($ObjectType) {
            $queryParams['ObjectType'] = $ObjectType
        }
        $queryString = New-MerakiQueryString -queryParams $queryParams
    
        $URL = "https://api.meraki.com/api/v1/devices/$DeviceSerial/camera/analytics/recent?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
