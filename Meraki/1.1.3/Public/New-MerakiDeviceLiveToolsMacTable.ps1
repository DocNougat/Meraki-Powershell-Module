function New-MerakiDeviceLiveToolsMacTable {
<#
.SYNOPSIS
Posts a Live Tools MAC table request to a Meraki device.

.DESCRIPTION
New-MerakiDeviceLiveToolsMacTable sends an HTTP POST to the Meraki Dashboard API endpoint
/devices/{serial}/liveTools/macTable. The function includes the provided Meraki API key
in the "X-Cisco-Meraki-API-Key" header and sets the Content-Type to application/json; charset=utf-8.
An optional JSON payload may be supplied and will be sent as the request body. The function
returns the deserialized JSON response from the API (or throws on error).

.PARAMETER AuthToken
The Meraki API key to authenticate the request. This should be a valid Dashboard API key
with appropriate permissions to query device live tools. This parameter is required.

.PARAMETER Serial
The serial number of the target Meraki device. This parameter is required.

.PARAMETER callbackJson
Optional JSON string to include as the POST body. 

.EXAMPLE
# Call without a body (no callbackJson)
New-MerakiDeviceLiveToolsMacTable -AuthToken '0123456789abcdef' -Serial 'Q2AA-XXXX-XXXX'

.NOTES
- Ensure the API key (AuthToken) is stored and handled securely; avoid hard-coding secrets in scripts.
- The caller is responsible for handling any thrown exceptions; the function will re-throw on failure.

.LINK
https://developer.cisco.com/meraki/api/
#>        
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$DeviceSerial,
        [parameter(Mandatory=$false)]
        [string]$callbackJson
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $url = "https://api.meraki.com/api/v1/devices/$DeviceSerial/liveTools/macTable"

        $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $callbackJson
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}