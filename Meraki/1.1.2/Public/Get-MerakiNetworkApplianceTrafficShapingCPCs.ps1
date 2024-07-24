function Get-MerakiNetworkApplianceTrafficShapingCPCs {
    <#
    .SYNOPSIS
    Retrieves a list of custom performance classes for a network's traffic shaping settings.

    .DESCRIPTION
    This function retrieves a list of the custom performance classes that have been configured for a network's traffic shaping settings in the Meraki Dashboard. It requires authentication with a Meraki API key that has read access to the specified network.

    .PARAMETER AuthToken
    The Meraki API key to use for authentication.

    .PARAMETER NetworkId
    The ID of the network to retrieve custom performance classes for.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkApplianceTrafficShapingCPCs -AuthToken "1234" -NetworkId "N_12345678"

    Retrieves a list of custom performance classes for the network with ID "N_12345678", using the Meraki API key "1234" for authentication.

    .NOTES
    For more information about the Meraki Dashboard API and its parameters, see the official documentation at https://developer.cisco.com/meraki/api-v1/.
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
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/trafficShaping/customPerformanceClasses" -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}