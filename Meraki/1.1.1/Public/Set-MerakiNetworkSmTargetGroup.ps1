function Set-MerakiNetworkSmTargetGroup {
    <#
    .SYNOPSIS
    Updates a target group in a Meraki network.
    
    .DESCRIPTION
    The Set-MerakiNetworkSmTargetGroup function allows you to update a target group in a specified Meraki network by providing the authentication token, network ID, target group ID, and a JSON formatted string of group configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network in which the target group is located.
    
    .PARAMETER TargetGroupId
    The ID of the target group to be updated.
    
    .PARAMETER GroupConfig
    A JSON formatted string of group configuration.
    
    .EXAMPLE
    $config = [PSCustomObject]@{
        name = "My target group"
        scope = "none"
    }

    $groupConfig = $config | ConvertTo-Json -Compress
    Set-MerakiNetworkSmTargetGroup -AuthToken "your-api-token" -NetworkId "1234" -TargetGroupId "5678" -GroupConfig $groupConfig

    This example updates a target group in the Meraki network with ID "1234" with the specified group configuration.
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the update is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$NetworkId,
            [parameter(Mandatory=$true)]
            [string]$TargetGroupId,
            [parameter(Mandatory=$true)]
            [string]$GroupConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/sm/targetGroups/$TargetGroupId"
    
            $body = $GroupConfig
    
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }