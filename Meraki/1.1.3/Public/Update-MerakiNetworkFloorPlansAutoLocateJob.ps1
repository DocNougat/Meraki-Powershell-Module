function Update-MerakiNetworkFloorPlansAutoLocateJob {
<#
.SYNOPSIS
Recalculates an existing Meraki floor plan auto-locate job for a specified network.

.DESCRIPTION
Sends a POST request to the Meraki Dashboard API to recalculate an auto-locate job associated with a network floor plan. The function supplies the provided API key in the X-Cisco-Meraki-API-Key header and returns the response from Invoke-RestMethod. Errors are written to the Debug stream and rethrown to the caller.

.PARAMETER AuthToken
The Meraki API key used for authentication (sent as the X-Cisco-Meraki-API-Key header). This parameter is required.

.PARAMETER NetworkID
The ID of the Meraki network that owns the floor plan. This value is inserted into the request URL path. If omitted or empty the request URL will be malformed.

.PARAMETER JobID
The ID of the auto-locate job to publish. This parameter is required.

.EXAMPLE
$token = 'abcdefghijklmn0123456789'
Publish-MerakiNetworkFloorPlansAutoLocateJob -AuthToken $token -NetworkID 'N_123456789012345' -JobID 'job_987654321'

Publishes the specified auto-locate job for the given network using the provided API key.
#>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$NetworkID,
        [parameter(Mandatory=$true)]
        [string]$JobID
    )
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
            
            $url = "https://api.meraki.com/api/v1/networks/$NetworkID/floorPlans/autoLocate/jobs/$JobID/recalculate"
            
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
}