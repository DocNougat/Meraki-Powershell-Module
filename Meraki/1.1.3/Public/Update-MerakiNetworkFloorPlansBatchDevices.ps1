function Update-MerakiNetworkFloorPlansBatchDevices {
<#
.SYNOPSIS
    Sends a POST request to the Meraki Dashboard API to batch-update floor plan devices for a network.

.DESCRIPTION
    Update-MerakiNetworkFloorPlansBatchDevices calls the Meraki API endpoint
    /networks/{networkId}/floorPlans/devices/batchUpdate using the provided API key.
    The function constructs standard Meraki headers (X-Cisco-Meraki-API-Key and Content-Type)
    and returns the deserialized JSON response from Invoke-RestMethod. Errors from the API call
    are propagated as terminating exceptions.

.PARAMETER AuthToken
    The Meraki Dashboard API key to include in the X-Cisco-Meraki-API-Key header.
    Type: String
    Required: True

.PARAMETER NetworkID
    The Meraki network identifier (networkId) used to target the floor plans endpoint.
    Type: String
    Required: False (but the API endpoint requires a valid networkId to operate)

.EXAMPLE
    # Basic usage (replace with a real API key and network ID)
    Update-MerakiNetworkFloorPlansBatchDevices -AuthToken 'abcd1234' -NetworkID 'L_12345'
    
.LINK
    Meraki Dashboard API documentation: https://developer.cisco.com/meraki/api-v1/
#>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$NetworkID
    )
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
            
            $url = "https://api.meraki.com/api/v1/networks/$NetworkID/floorPlans/devices/batchUpdate"
            
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
}