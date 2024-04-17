function Get-MerakiDeviceCameraVideoLink {
    <#
    .SYNOPSIS
        Gets the video link for a specific snapshot time from a Cisco Meraki camera by serial number.
    .DESCRIPTION
        This function makes a REST API call to the Meraki dashboard API to retrieve the video link for a specific snapshot time from a Cisco Meraki camera, based on its serial number. The function returns a link to the video, which can be accessed for up to 30 seconds after the timestamp specified in the API call.
    .PARAMETER AuthToken
        The authentication token to use for the API call. This should be a valid API key for the Meraki dashboard.
    .PARAMETER deviceSerial
        The serial number of the Cisco Meraki camera to retrieve the video link for.
    .PARAMETER timestamp
        The timestamp of the snapshot to retrieve the video link for. This should be in Unix epoch time (in seconds).
    .EXAMPLE
        PS C:\> Get-MerakiDeviceCameraVideoLink -AuthToken "myapikey" -deviceSerial "Q2XX-XXXX-XXXX" -timestamp 1618807660
        Returns the video link for the snapshot taken at Unix epoch time 1618807660 from the specified Cisco Meraki camera.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$DeviceSerial,
        [parameter(Mandatory=$false)]
        [string]$timestamp
    )
    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
    
        $queryParams = @{}
    
        if ($timestamp) {
            $queryParams['timestamp'] = $timestamp
        }
        
        $queryString = New-MerakiQueryString -queryParams $queryParams
    
        $URL = "https://api.meraki.com/api/v1/devices/$DeviceSerial/camera/videoLink?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
