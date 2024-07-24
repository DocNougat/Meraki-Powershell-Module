function Get-MerakiAdministeredIdentitiesMe {
    <#
    .SYNOPSIS
        Gets the identity of the owner of the API Key in use
    .DESCRIPTION
        This function makes a REST API call to the Meraki dashboard API to retrieve information about owner of the API Key in use, including their name, email address, and role.
    .PARAMETER AuthToken
        The authentication token to use for the API call. This should be a valid API key for the Meraki dashboard.
    .EXAMPLE
        PS C:\> Get-MerakiAdministeredIdentitiesMe -AuthToken "myapikey"
        Returns information about the  owner of the API Key in use
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/administered/identities/me" -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}