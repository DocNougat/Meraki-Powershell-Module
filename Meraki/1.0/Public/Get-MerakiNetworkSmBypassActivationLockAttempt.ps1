function Get-MerakiNetworkSmBypassActivationLockAttempt {
    <#
    .SYNOPSIS
    Retrieves the details of a specified SM device's bypass activation lock attempt.
    
    .PARAMETER AuthToken
    The API token generated in the Meraki dashboard.
    
    .PARAMETER NetworkId
    The network ID for the network containing the SM device.
    
    .PARAMETER AttemptId
    The unique ID of the bypass activation lock attempt to retrieve details for.
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkSmBypassActivationLockAttempt -AuthToken "1234" -NetworkId "L_123456789012345678" -AttemptId "123456789012345"
    
    Retrieves the details of the SM device's bypass activation lock attempt with ID "123456789012345" in the network with ID "L_123456789012345678".
    
    .NOTES
    For more information on using the Meraki API, see https://developer.cisco.com/meraki/api/.
    #>
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$AttemptId
    )
    
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/sm/bypassActivationLockAttempts/$attemptId" -Header $header
        return $response
    }
    catch {
        Write-Error "Failed to retrieve bypass activation lock attempt details: $_"
    }
}
