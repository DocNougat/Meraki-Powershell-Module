function Get-MerakiOrganizationPiiSmDevicesForKey {
<#
.SYNOPSIS
    Retrieves the PII-related Systems Manager device details for a specific user or device.
.DESCRIPTION
    This function retrieves the PII-related Systems Manager device details for a specific user
    or device specified by the provided criteria (username, email, MAC address, serial number,
    IMEI, or Bluetooth MAC address) for a Meraki organization.
.PARAMETER AuthToken
    The Meraki API authentication token to use for the request.
.PARAMETER OrgID
    The ID of the Meraki organization to retrieve the Systems Manager device details for.
    If not specified, the ID of the first organization associated with the provided
    authentication token will be used.
.PARAMETER username
    The username of the user associated with the device.
.PARAMETER email
    The email address of the user associated with the device.
.PARAMETER mac
    The MAC address of the device.
.PARAMETER serial
    The serial number of the device.
.PARAMETER imei
    The IMEI number of the device.
.PARAMETER bluetoothMac
    The Bluetooth MAC address of the device.
.EXAMPLE
    PS C:\> Get-MerakiOrganizationPiiSmDevicesForKey -AuthToken "myAuthToken" -OrgId "123456" -username "john.doe"
    Returns the PII-related Systems Manager device details for the user with the username "john.doe"
    for the Meraki organization with ID "123456".
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

            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/pii/smDevicesForKey?$queryString"

            $URI = [uri]::EscapeUriString($URL)

            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}