function Get-MerakiOrganizationPiiPiiKey {
    <#
    .SYNOPSIS
        Retrieves PII (personally identifiable information) keys for a Meraki organization.
    .DESCRIPTION
        This function retrieves PII keys for a Meraki organization specified by the provided
        organization ID or the ID of the first organization associated with the provided
        API authentication token. You can filter the results by specifying one or more of
        the supported search parameters (username, email, mac, serial, imei, bluetoothMac).
    .PARAMETER AuthToken
        The Meraki API authentication token to use for the request.
    .PARAMETER OrgId
        The ID of the Meraki organization to retrieve PII keys for.
        If not specified, the ID of the first organization associated with the provided
        authentication token will be used.
    .PARAMETER username
        A username to search for among the PII keys.
    .PARAMETER email
        An email address to search for among the PII keys.
    .PARAMETER mac
        A MAC address to search for among the PII keys.
    .PARAMETER serial
        A device serial number to search for among the PII keys.
    .PARAMETER imei
        An IMEI number to search for among the PII keys.
    .PARAMETER bluetoothMac
        A Bluetooth MAC address to search for among the PII keys.
    .EXAMPLE
        PS C:\> Get-MerakiOrganizationPiiPiiKey -AuthToken "myAuthToken" -OrgId "123456" -username "alice"
        Returns PII keys for the Meraki organization with ID "123456" that are associated
        with the username "alice".
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
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/pii/piiKeys?$queryString"
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
