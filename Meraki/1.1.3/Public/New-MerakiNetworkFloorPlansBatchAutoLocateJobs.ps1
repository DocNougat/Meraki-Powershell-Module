function New-MerakiNetworkFloorPlansBatchAutoLocateJobs {
<#
.SYNOPSIS
Submits a batch auto-locate job for floor plans within a Meraki network.

.DESCRIPTION
New-MerakiNetworkFloorPlansBatchAutoLocateJobs creates a batch job that attempts to auto-locate one or more floor plans for the specified Meraki network using the Meraki Dashboard API.
This cmdlet wraps the POST /networks/{networkId}/floorPlans/autoLocate/jobs/batch endpoint and returns the API response object.

.SYNTAX
New-MerakiNetworkFloorPlansBatchAutoLocateJobs -AuthToken <string> -NetworkId <string>

.PARAMETER AuthToken
The Meraki API key used to authenticate the request. Provide a valid API key with sufficient permissions to manage floor plans in the target network.
Type: String
Required: True

.PARAMETER NetworkId
The identifier (networkId) of the Meraki network for which the batch auto-locate job will be created.
Type: String
Required: True

.EXAMPLE
# Submit a batch auto-locate job for the specified network
New-MerakiNetworkFloorPlansBatchAutoLocateJobs -AuthToken '1234567890abcdef' -NetworkId 'L_1234abcd'

.LINK
Meraki Dashboard API documentation: https://developer.cisco.com/meraki/api-v1/ (refer to the Floor Plans endpoints)
#>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/floorPlans/autoLocate/jobs/batch"

        $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}