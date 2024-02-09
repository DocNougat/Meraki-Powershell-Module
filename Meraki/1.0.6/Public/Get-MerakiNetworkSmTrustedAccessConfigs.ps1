function Get-MerakiNetworkSmTrustedAccessConfigs {
    <#
    .SYNOPSIS
    Retrieves the list of Trusted Access configs for a given network in Systems Manager.
    
    .DESCRIPTION
    This function retrieves the list of Trusted Access configs for a given network in Systems Manager.
    
    .PARAMETER AuthToken
    Required. The Meraki Dashboard API authentication token.
    
    .PARAMETER NetworkId
    Required. The network ID.
    
    .PARAMETER perPage
    Optional. The number of Trusted Access configs to return per page.
    
    .PARAMETER startingAfter
    Optional. A Trusted Access config ID to use as a starting point for the next page of results.
    
    .PARAMETER endingBefore
    Optional. A Trusted Access config ID to use as an ending point for the previous page of results.
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkSmTrustedAccessConfigs -AuthToken "12345" -NetworkId "L_1234" -perPage 50
    
    Retrieves the first 50 Trusted Access configs for the network "L_1234".
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkSmTrustedAccessConfigs -AuthToken "12345" -NetworkId "L_1234" -startingAfter "54321"
    
    Retrieves the Trusted Access configs for the network "L_1234" starting after the config with ID "54321".
    #>
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$networkId,
        [parameter(Mandatory=$false)]
        [int]$perPage = $null,
        [parameter(Mandatory=$false)]
        [string]$startingAfter = $null,
        [parameter(Mandatory=$false)]
        [string]$endingBefore = $null
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $queryParams = @{}
    
        if ($perPage) {
            $queryParams['perPage'] = $perPage
        }
        if ($startingAfter) {
            $queryParams['startingAfter'] = $startingAfter
        }
        if ($endingBefore) {
            $queryParams['endingBefore'] = $endingBefore
        }
        $queryString = New-MerakiQueryString -queryParams $queryParams
    
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/sm/trustedAccessConfigs?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    } catch {
        Write-Host $_
        Throw $_
    }
}