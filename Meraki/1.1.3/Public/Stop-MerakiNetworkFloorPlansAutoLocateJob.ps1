function Stop-MerakiNetworkFloorPlansAutoLocateJob {
<#
.SYNOPSIS
Stops (cancels) a Meraki Network Floor Plans auto-locate job.

.DESCRIPTION
Sends a cancel request to the Meraki Dashboard API to stop an in-progress or scheduled auto-locate job for floor plans within a specified network.
This cmdlet issues a POST to the networks/{networkId}/floorPlans/autoLocate/jobs/{jobId}/cancel endpoint and returns the API response.

.PARAMETER AuthToken
The Meraki API key (X-Cisco-Meraki-API-Key). This value is required and must have sufficient privileges to modify the target network.

.PARAMETER NetworkID
The identifier (ID) of the Meraki network that owns the floor plan auto-locate job. If omitted, the cmdlet will pass a null/empty value to the request URL which will likely cause the API to return an error. Provide the correct NetworkID for the job you intend to cancel.

.PARAMETER JobID
The identifier (ID) of the auto-locate job to cancel. This value is required.

.EXAMPLE
# Cancel a job and display the result
Stop-MerakiNetworkFloorPlansAutoLocateJob -AuthToken $apiKey -NetworkID $network -JobID $jobId
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
            
            $body = $SNMPConfig

            $url = "https://api.meraki.com/api/v1/networks/$NetworkID/floorPlans/autoLocate/jobs/$JobID/cancel"

            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
}