function Invoke-MerakiNetworkDevicesvMXClaim {
    <#
    .SYNOPSIS
    Claims vMX100 devices in the Meraki Dashboard using the Meraki Dashboard API.

    .DESCRIPTION
    The Invoke-MerakiNetworkDevicesvMXClaim function allows you to claim vMX100 devices in the Meraki Dashboard by providing the authentication token, network ID, and a vMX claim string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network to which you want to claim vMX100 devices.

    .PARAMETER size
    A string containing the vMX claim. The string should be in JSON format and should include the following property: "size". Valid options are small, medium, large, or 100.

    .EXAMPLE
    Invoke-MerakiNetworkDevicesvMXClaim -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -size "medium"

    This example claims a vMX100 device in the Meraki network with ID "L_123456789012345678".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the claim is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [ValidateSet('small','medium','large','100')]
        [string]$Size
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = @{
            "size" = $Size
        } | ConvertTo-Json -Compress

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/devices/claim/vmx"

        $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}