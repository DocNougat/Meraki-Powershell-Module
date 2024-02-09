function Get-MerakiOrganizationInventoryDevice {
    <#
    .SYNOPSIS
    Retrieves a Meraki device inventory item by serial number for a specified organization.

    .DESCRIPTION
    This function retrieves a Meraki device inventory item by serial number for a specified organization using the Meraki Dashboard API. The authentication token, serial number, and organization ID are required for this operation.

    .PARAMETER AuthToken
    Specifies the authentication token for the Meraki Dashboard API.

    .PARAMETER SerialNumber
    Specifies the serial number of the Meraki device.

    .PARAMETER OrgID
    Specifies the ID of the Meraki organization. If not specified, the function will use the ID of the first organization returned by Get-MerakiOrganizations.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationInventoryDevice -AuthToken "12345" -OrgId "123456" -SerialNumber "ABCD1234"

    Retrieves the Meraki device with serial number "ABCD1234" for the organization with ID "123456" using the authentication token "12345".

    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$SerialNumber,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken)
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                'X-Cisco-Meraki-API-Key' = $AuthToken
            }
            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/inventory/devices/$SerialNumber" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
            return $response
        }
        catch {
        Write-Host $_
        Throw $_
    }
    }
}
