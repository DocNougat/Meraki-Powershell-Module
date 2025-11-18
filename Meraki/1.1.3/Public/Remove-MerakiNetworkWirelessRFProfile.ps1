function Remove-MerakiNetworkWirelessRFProfile {
    <#
    .SYNOPSIS
    Deletes a network wireless RF profile.
    
    .DESCRIPTION
    The Remove-MerakiNetworkWirelessRFProfile function allows you to delete a network wireless RF profile by providing the authentication token, network ID, and RF profile ID.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
    .PARAMETER RFProfileId
    The ID of the RF profile to be deleted.
    
    .EXAMPLE
    Remove-MerakiNetworkWirelessRFProfile -AuthToken "your-api-token" -NetworkId "1234" -RFProfileId "1001"
    
    This example deletes a network wireless RF profile with the specified ID.
    
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
            [string]$RFProfileId
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/wireless/rfProfiles/$RFProfileId"
    
            $response = Invoke-RestMethod -Method Delete -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }