function Set-MerakiNetworkSwitchDSCPToCOSMappings {
    <#
    .SYNOPSIS
    Updates the DSCP to CoS mappings for a network switch.
    
    .DESCRIPTION
    The Set-MerakiNetworkSwitchDSCPToCOSMappings function allows you to update the DSCP to CoS mappings for a specified network switch by providing the authentication token, network ID, and a JSON formatted string of mappings.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network in which the network switch is located.
    
    .PARAMETER Mappings
    A JSON formatted string of mappings.
    
    .EXAMPLE
    $Mappings = '{
        "mappings": [
            {
                "dscp": 1,
                "cos": 1,
                "title": "Video"
            }
        ]
    }'
    $Mappings = $Mappings | ConvertTo-Json -Compress
    Set-MerakiNetworkSwitchDSCPToCOSMappings -AuthToken "your-api-token" -NetworkId "1234" -Mappings $Mappings
    
    This example updates the DSCP to CoS mappings for the network switch in the Meraki network with ID "1234" with the specified mappings.
    
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
            [string]$Mappings
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/dscpToCosMappings"
    
            $body = $Mappings
    
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -Body $body
            return $response
        }
        catch {
            Write-Host $_
        }
    }