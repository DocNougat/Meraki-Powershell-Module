function Set-MerakiNetworkSwitchPortSchedule {
    <#
    .SYNOPSIS
    Updates a port schedule for a network switch.
    
    .DESCRIPTION
    The Set-MerakiNetworkSwitchPortSchedule function allows you to update a port schedule for a specified network switch by providing the authentication token, network ID, port schedule ID, and a JSON formatted string of port schedule configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network in which the network switch is located.
    
    .PARAMETER PortScheduleId
    The ID of the port schedule to be updated.
    
    .PARAMETER PortScheduleConfig
    A JSON formatted string of port schedule configuration.
    
    .EXAMPLE
    $PortScheduleConfig = [PSCustomObject]@{
        name = "Weekdays schedule"
        portSchedule = @{
            monday = @{
                active = $true
                from = "9:00"
                to = "17:00"
            }
            tuesday = @{
                active = $true
                from = "9:00"
                to = "17:00"
            }
            wednesday = @{
                active = $true
                from = "9:00"
                to = "17:00"
            }
            thursday = @{
                active = $true
                from = "9:00"
                to = "17:00"
            }
            friday = @{
                active = $true
                from = "9:00"
                to = "17:00"
            }
            saturday = @{
                active = $false
                from = "0:00"
                to = "24:00"
            }
            sunday = @{
                active = $false
                from = "0:00"
                to = "24:00"
            }
        }
    }

    $PortScheduleConfig = $PortScheduleConfig | ConvertTo-Json -Compress
    Set-MerakiNetworkSwitchPortSchedule -AuthToken "your-api-token" -NetworkId "1234" -PortScheduleId "NDU2N18yXzM=" -PortScheduleConfig $PortScheduleConfig

    This example updates the port schedule for the network switch in the Meraki network with ID "1234" with the specified port schedule configuration.
    
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
            [string]$PortScheduleId,
            [parameter(Mandatory=$true)]
            [string]$PortScheduleConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/portSchedules/$PortScheduleId"
    
            $body = $PortScheduleConfig
    
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
            Write-Host $_
        }
    }