function Set-MerakiNetworkClientPolicy {
    <#
    .SYNOPSIS
    Updates the policy for a client on a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkClientPolicy function allows you to update the policy for a specified client on a Meraki network by providing the authentication token, network ID, client ID, and a client policy configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to update the client policy.

    .PARAMETER ClientId
    The ID of the client for which you want to update the policy.

    .PARAMETER ClientPolicyConfig
    A string containing the client policy configuration. The string should be in JSON format and should include the "devicePolicy" property, as well as the "groupPolicyId" property if the device policy is set to "Group policy".

    .EXAMPLE
    $config = [PSCustomObject]@{
        devicePolicy = "Group policy"
        groupPolicyId = "123456"
    }

    $config = $config | ConvertTo-Json -Compress
    Set-MerakiNetworkClientPolicy -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -ClientId "123456789012345" -ClientPolicyConfig $config

    This example sets the policy for the client with ID "123456789012345" on the Meraki network with ID "L_123456789012345678" to the group policy with ID "123456".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the policy update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$ClientId,
        [parameter(Mandatory=$true)]
        [string]$ClientPolicyConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $ClientPolicyConfig

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/clients/$ClientId/policy"

        $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}