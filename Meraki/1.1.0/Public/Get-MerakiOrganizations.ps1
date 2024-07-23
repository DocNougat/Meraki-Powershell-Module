function Get-MerakiOrganizations {
    <#
    .SYNOPSIS
    Retrieves a list of Meraki organizations associated with the specified API key.
    
    .PARAMETER AuthToken
    The Meraki API key to use for authentication.
    
    .EXAMPLE
    PS C:\> Get-MerakiOrganizations -AuthToken "1234"
    Retrieves a list of all Meraki organizations associated with the API key "1234".
    
    .NOTES
    For more information, see https://developer.cisco.com/meraki/api/#!get-organizations.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken
    )
    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations" -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}