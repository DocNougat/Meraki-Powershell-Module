function Set-MerakiNetworkSwitchACLs {
    <#
    .SYNOPSIS
    Updates the access control lists for a network switch.
    
    .DESCRIPTION
    The Set-MerakiNetworkSwitchACLs function allows you to update the access control lists for a specified network switch by providing the authentication token, network ID, and a JSON formatted string of ACL rules.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network in which the network switch is located.
    
    .PARAMETER ACLRules
    A JSON formatted string of ACL rules.
    
    .EXAMPLE
    $ACLRules = '{
        "rules": [
            {
                "comment": "Deny SSH",
                "policy": "deny",
                "ipVersion": "ipv4",
                "protocol": "tcp",
                "srcCidr": "10.1.10.0/24",
                "srcPort": "any",
                "dstCidr": "172.16.30/24",
                "dstPort": "22",
                "vlan": "10"
            }
        ]
    }'
    $ACLRules = $ACLRules | ConvertTo-Json
    Set-MerakiNetworkSwitchACLs -AuthToken "your-api-token" -NetworkId "1234" -ACLRules $ACLRules
    
    This example updates the access control lists for the network switch in the Meraki network with ID "1234" with the specified ACL rules.
    
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
            [string]$ACLRules
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/accessControlLists"
    
            $body = $ACLRules
    
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
            Write-Host $_
        }
    }