function Get-MerakiNetworkWirelessRfProfiles {
    <#
    .SYNOPSIS
    Retrieves the RF profiles for a specified Meraki network.
    .DESCRIPTION
    This function retrieves the RF profiles for a specified Meraki network using the Meraki Dashboard API.
    .PARAMETER AuthToken
    The Meraki API token for the account.
    .PARAMETER networkId
    The ID of the Meraki network for which to retrieve the RF profiles.
    .PARAMETER includeTemplateProfiles
    Specifies whether to include template profiles in the results. Default is true.
    .EXAMPLE
    PS> Get-MerakiNetworkWirelessRfProfiles -AuthToken "1234" -networkId "abcd" -includeTemplateProfiles $true
    Retrieves the RF profiles for network "abcd" using the Meraki API token "1234", including template profiles in the results.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$networkId,
        [parameter(Mandatory=$false)]
        [bool]$includeTemplateProfiles = $true
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $queryParams = @{}

        if ($includeTemplateProfiles) {
            $queryParams['includeTemplateProfiles'] = $includeTemplateProfiles
        }

        $queryString = New-MerakiQueryString -queryParams $queryParams

        $URL = "https://api.meraki.com/api/v1/networks/$networkId/wireless/rfProfiles?$queryString"

        $URI = [uri]::EscapeUriString($URL)

        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
