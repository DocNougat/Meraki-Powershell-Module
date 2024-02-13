function Get-MerakiNetworkTrafficShapingDscpTaggingOptions {
    <#
    .SYNOPSIS
    Retrieves the available DSCP tagging options for traffic shaping in a Meraki network.

    .DESCRIPTION
    The Get-MerakiNetworkTrafficShapingDscpTaggingOptions function retrieves the available Differentiated Services Code Point (DSCP) tagging options for traffic shaping in a Meraki network using the Meraki Dashboard API. This information can be useful for configuring traffic shaping rules based on specific DSCP values.

    .PARAMETER AuthToken
    The Meraki Dashboard API authentication token to use for the request.

    .PARAMETER NetworkId
    The ID of the Meraki network for which to retrieve the available DSCP tagging options.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkTrafficShapingDscpTaggingOptions -AuthToken '12345' -NetworkId 'abcd'

    This example retrieves the available DSCP tagging options for traffic shaping in the Meraki network with ID 'abcd' using the Meraki Dashboard API authentication token '12345'.

    .NOTES
    For more information on DSCP and traffic shaping in Meraki networks, see the Meraki documentation:
    https://documentation.meraki.com/MX/Firewall_and_Traffic_Shaping/DSCP_Tagging_Options_for_Traffic_Shaping

    #>

    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId
    )

    $header = @{
        'X-Cisco-Meraki-API-Key' = $AuthToken
    }

    try {
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/trafficShaping/dscpTaggingOptions" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}