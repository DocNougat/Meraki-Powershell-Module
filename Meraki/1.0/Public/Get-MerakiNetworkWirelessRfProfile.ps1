function Get-MerakiNetworkWirelessRfProfile {
    <#
    .SYNOPSIS
    Retrieves the details of a specified RF profile for a Meraki network.
    .DESCRIPTION
    This function retrieves the details of a specified RF profile for a Meraki network using the Meraki Dashboard API.
    .PARAMETER AuthToken
    The Meraki API token for the account.
    .PARAMETER networkId
    The ID of the Meraki network for which to retrieve the RF profile details.
    .PARAMETER rfProfileId
    The ID of the RF profile for which to retrieve details.
    .EXAMPLE
    PS> Get-MerakiNetworkWirelessRfProfile -AuthToken "1234" -networkId "abcd" -rfProfileId "5678"
    Retrieves the details of the RF profile with ID "5678" for network "abcd" using the Meraki API token "1234".
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$networkId,
        [parameter(Mandatory=$true)]
        [string]$rfProfileId
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }

        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/wireless/rfProfiles/$rfProfileId" -Header $header
        return $response
    }
    catch {
        Write-Error $_
    }
}
