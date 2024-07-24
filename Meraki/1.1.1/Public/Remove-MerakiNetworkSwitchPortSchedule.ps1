function Remove-MerakiNetworkSwitchPortSchedule {
    <#
    .SYNOPSIS
    Deletes a port schedule for a network switch.
    
    .DESCRIPTION
    The Remove-MerakiNetworkSwitchPortSchedule function allows you to delete a port schedule for a specified network switch by providing the authentication token, network ID, and port schedule ID.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network in which the network switch is located.
    
    .PARAMETER PortScheduleId
    The ID of the port schedule to be deleted.
    
    .EXAMPLE
    Remove-MerakiNetworkSwitchPortSchedule -AuthToken "your-api-token" -NetworkId "1234" -PortScheduleId "NDU2N18yXzM="
    
    This example deletes the port schedule for the network switch in the Meraki network with ID "1234".
    
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
            [string]$PortScheduleId
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/portSchedules/$PortScheduleId"
    
            $response = Invoke-RestMethod -Method Delete -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }