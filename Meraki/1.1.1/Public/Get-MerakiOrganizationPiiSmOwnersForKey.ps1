function Get-MerakiOrganizationPiiSmOwnersForKey {
    <#
    .SYNOPSIS
        Retrieves the owners of SM devices matching the provided PII data.
    .DESCRIPTION
        This function retrieves the owners of SM devices matching the provided PII data,
        including usernames, emails, MAC addresses, serial numbers, IMEIs, and Bluetooth MAC addresses.
    .PARAMETER AuthToken
        The Meraki API authentication token to use for the request.
    .PARAMETER OrgId
        The ID of the Meraki organization to retrieve SM device owner information for.
        If not specified, the ID of the first organization associated with the provided
        authentication token will be used.
    .PARAMETER username
        The username associated with the SM device owner.
    .PARAMETER email
        The email associated with the SM device owner.
    .PARAMETER mac
        The MAC address associated with the SM device owner.
    .PARAMETER serial
        The serial number associated with the SM device owner.
    .PARAMETER imei
        The IMEI associated with the SM device owner.
    .PARAMETER bluetoothMac
        The Bluetooth MAC address associated with the SM device owner.
    .EXAMPLE
        PS C:\> Get-MerakiOrganizationPiiSmOwnersForKey -AuthToken "myAuthToken" -username "johndoe"
        Returns the owners of SM devices associated with the username "johndoe".
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$false)]
        [string]$username,
        [parameter(Mandatory=$false)]
        [string]$email,
        [parameter(Mandatory=$false)]
        [string]$mac,
        [parameter(Mandatory=$false)]
        [string]$serial,
        [parameter(Mandatory=$false)]
        [string]$imei,
        [parameter(Mandatory=$false)]
        [string]$bluetoothMac
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                'X-Cisco-Meraki-API-Key' = $AuthToken
            }

            $queryParams = @{}

            if ($username) {
                $queryParams['username'] = $username
            }
            if ($email) {
                $queryParams['email'] = $email
            }
            if ($mac) {
                $queryParams['mac'] = $mac
            }
            if ($serial) {
                $queryParams['serial'] = $serial
            }
            if ($imei) {
                $queryParams['imei'] = $imei
            }
            if ($bluetoothMac) {
                $queryParams['bluetoothMac'] = $bluetoothMac
            }
            $queryString = New-MerakiQueryString -queryParams $queryParams

            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/pii/smOwnersForKey?$queryString"

            $URI = [uri]::EscapeUriString($URL)

            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}
