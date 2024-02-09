function Remove-MerakiNetworkSmUserAccessDevice {
    <#
    .SYNOPSIS
    Deletes a user access device in a Meraki network.
    
    .DESCRIPTION
    The Remove-MerakiNetworkSmUserAccessDevice function allows you to delete a user access device in a specified Meraki network by providing the authentication token, network ID, and user access device ID.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network in which the user access device is located.
    
    .PARAMETER UserAccessDeviceId
    The ID of the user access device to be deleted.
    
    .EXAMPLE
    Remove-MerakiNetworkSmUserAccessDevice -AuthToken "your-api-token" -NetworkId "1234" -UserAccessDeviceId "5678"
    
    This example deletes a user access device in the Meraki network with ID "1234".
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the deletion is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$NetworkId,
            [parameter(Mandatory=$true)]
            [string]$UserAccessDeviceId
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/sm/userAccessDevices/$UserAccessDeviceId"
    
            $response = Invoke-RestMethod -Method Delete -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
            return $response
        }
        catch {
        Write-Host $_
        Throw $_
    }
    }