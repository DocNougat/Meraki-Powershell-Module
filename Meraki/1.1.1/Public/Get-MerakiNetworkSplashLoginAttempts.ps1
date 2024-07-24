function Get-MerakiNetworkSplashLoginAttempts {
    <#
    .SYNOPSIS
    Retrieves a list of splash login attempts for a given network, filtered by optional parameters.

    .DESCRIPTION
    This function retrieves a list of splash login attempts for a given Meraki network. You can optionally filter the results using the timespan, login identifier, and SSID number parameters.

    .PARAMETER AuthToken
    The Meraki Dashboard API token.

    .PARAMETER networkId
    The ID of the Meraki network for which to retrieve the splash login attempts.

    .PARAMETER timespan
    The timespan, in seconds, for which to retrieve splash login attempts. This should be a positive integer.

    .PARAMETER loginIdentifier
    A string used to identify the login attempt. This can be the email address or username of the user attempting to log in.

    .PARAMETER ssidNumber
    The SSID number for which to retrieve splash login attempts.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkSplashLoginAttempts -AuthToken "1234" -networkId "N_1234" -timespan 3600 -loginIdentifier "user@example.com"

    Retrieves all splash login attempts for the given network in the last hour where the login identifier is "user@example.com".

    .NOTES
    For more information about the Meraki Dashboard API and retrieving splash login attempts, see:
    https://developer.cisco.com/meraki/api-v1/#!get-network-splash-login-attempts
    #>
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$networkId,
        [parameter(Mandatory=$false)]
        [int]$timespan = $null,
        [parameter(Mandatory=$false)]
        [string]$loginIdentifier = $null,
        [parameter(Mandatory=$false)]
        [int]$ssidNumber = $null
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $queryParams = @{}
        if ($timespan) {
            $queryParams['timespan'] = $timespan
        }
        if ($loginIdentifier) {
            $queryParams['loginIdentifier'] = $loginIdentifier
        }
        if ($ssidNumber) {
            $queryParams['ssidNumber'] = $ssidNumber
        }
    
        $queryString = New-MerakiQueryString -queryParams $queryParams
        $URI = "https://api.meraki.com/api/v1/networks/$networkId/splashLoginAttempts?$queryString"
        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
