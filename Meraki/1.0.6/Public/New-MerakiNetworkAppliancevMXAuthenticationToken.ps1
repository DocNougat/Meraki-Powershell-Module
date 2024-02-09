function New-MerakiNetworkAppliancevMXAuthenticationToken {
    <#
    .SYNOPSIS
    Creates a new VMX authentication token for a Meraki network.
    
    .DESCRIPTION
    This function creates a new VMX authentication token for a Meraki network using the Meraki Dashboard API.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER Serial
    The serial number of the device for which you want to create a VMX authentication token.
    
    .EXAMPLE
    New-MerakiNetworkAppliancevMXAuthenticationToken -AuthToken "your-api-token" -Serial "Q2GV-ABCD-1234"
    
    This example creates a new VMX authentication token for the specified device.
    
    .NOTES
    For more information about the Meraki Dashboard API, see https://developer.cisco.com/meraki/api-v1/.
    #>
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$Serial
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/devices/$Serial/appliance/vmx/authenticationToken"
    
            $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
            return $response
        }
        catch {
            Write-Host $_
            Throw $_
        }
    }