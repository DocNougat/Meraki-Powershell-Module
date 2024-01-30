<#
.SYNOPSIS
    Finds a client by MAC address on all networks in a Meraki organization.
.DESCRIPTION
    This function takes an authentication token and a MAC address as input parameters, and then searches for the MAC address on all networks in a Meraki organization. If the MAC address is found, the function returns the name of the device associated with the MAC address.
.PARAMETER AuthToken
    The authentication token for the Meraki API.
.PARAMETER mac
    The MAC address to search for.
.EXAMPLE
    Find-MerakiClientBymacAddress -AuthToken "1234" -mac "00:11:22:33:44:55"
    This example searches for the MAC address "00:11:22:33:44:55" on all networks in the Meraki organization associated with the authentication token "1234".
#>
function Find-MerakiClientBymacAddress {
    param(
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$mac
    )

    $networks = Get-MerakiOrganizationNetworks -AuthToken $AuthToken

    ForEach($network in $networks){ 
        $clients = Get-MerakiNetworkClients -AuthToken $AuthToken -NetworkId $network.id  
        ForEach ($Client in $clients) {
            If($Client.mac -eq $mac){
                    Write-Host "MAC Address found on network:"
                    write-host $client.recentDeviceName
            }
        }
    }
}