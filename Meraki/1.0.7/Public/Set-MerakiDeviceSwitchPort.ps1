function Set-MerakiDeviceSwitchPort {
    <#
    .SYNOPSIS
    Updates a device switch port.
    
    .DESCRIPTION
    The Set-MerakiDeviceSwitchPort function allows you to update a device switch port by providing the authentication token, device serial, port ID, and a JSON formatted string of port configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER DeviceSerial
    The serial number of the device.
    
    .PARAMETER PortId
    The ID of the port to be updated.
    
    .PARAMETER PortConfig
    A JSON formatted string of port configuration.
    
    .EXAMPLE
    $PortConfig = [PSCustomObject]@{
        name = "My switch port"
        tags = @("tag1", "tag2")
        enabled = $true
        poeEnabled = $true
        type = "access"
        vlan = 10
        voiceVlan = 20
        allowedVlans = "1,3,5-10"
        isolationEnabled = $false
        rstpEnabled = $true
        stpGuard = "disabled"
        linkNegotiation = "Auto negotiate"
        portScheduleId = "1234"
        udld = "Alert only"
        accessPolicyType = "Sticky MAC allow list"
        accessPolicyNumber = 2
        macAllowList = @("34:56:fe:ce:8e:b0", "34:56:fe:ce:8e:b1")
        stickyMacAllowList = @("34:56:fe:ce:8e:b0", "34:56:fe:ce:8e:b1")
        stickyMacAllowListLimit = 5
        stormControlEnabled = $true
        adaptivePolicyGroupId = "123"
        peerSgtCapable = $false
        flexibleStackingEnabled = $true
        daiTrusted = $false
        profile = @{
            enabled = $false
            id = "1284392014819"
            iname = "iname"
        }
    }

    $PortConfig = $PortConfig | ConvertTo-Json -Compress
    Set-MerakiDeviceSwitchPort -AuthToken "your-api-token" -DeviceSerial "Q2GV-ABCD-1234" -PortId "5" -PortConfig $PortConfig

    This example updates the device switch port with the specified port configuration.
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the update is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$DeviceSerial,
            [parameter(Mandatory=$true)]
            [string]$PortId,
            [parameter(Mandatory=$true)]
            [string]$PortConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/devices/$DeviceSerial/switch/ports/$PortId"
    
            $body = $PortConfig
    
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }