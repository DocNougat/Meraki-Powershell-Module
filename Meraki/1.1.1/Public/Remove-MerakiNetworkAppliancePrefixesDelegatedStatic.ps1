function Remove-MerakiNetworkAppliancePrefixesDelegatedStatic {
    <#
    .SYNOPSIS
    Deletes a static delegated prefix for a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Remove-MerakiNetworkAppliancePrefixesDelegatedStatic function allows you to delete a static delegated prefix for a specified Meraki network by providing the authentication token, network ID, and static delegated prefix ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to delete the static delegated prefix.

    .PARAMETER StaticDelegatedPrefixId
    The ID of the static delegated prefix that you want to delete.

    .EXAMPLE
    Remove-MerakiNetworkAppliancePrefixesDelegatedStatic -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -StaticDelegatedPrefixId "your-static-prefix-id"

    This example deletes the static delegated prefix with ID "your-static-prefix-id" for the Meraki network with ID "L_123456789012345678".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the static delegated prefix deletion is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$StaticDelegatedPrefixId
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/prefixes/delegated/statics/$StaticDelegatedPrefixId"
        $response = Invoke-RestMethod -Method Delete -Uri $uri -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}