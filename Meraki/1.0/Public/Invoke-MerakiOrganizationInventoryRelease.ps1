function Invoke-MerakiOrganizationInventoryRelease {
    <#
    .SYNOPSIS
    Release devices from an organization's inventory in Meraki dashboard.

    .DESCRIPTION
    This function allows you to release devices from an organization's inventory in Meraki dashboard.

    .PARAMETER AuthToken
    The authentication token for the Meraki API.

    .PARAMETER OrgId
    The organization ID. If not provided, the function will retrieve the ID of the first organization associated with the specified authentication token.

    .PARAMETER Serials
    A pre-formatted JSON string containing an array of serials of the devices that should be released.

    .EXAMPLE
    $serials = '["Q2HP-XXXX-XXXX", "Q2HP-YYYY-YYYY"]'
    Invoke-MerakiOrganizationInventoryRelease -AuthToken "1234" -Serials $serials

    This example releases the devices with serials 'Q2HP-XXXX-XXXX' and 'Q2HP-YYYY-YYYY' from the inventory of the first organization associated with the authentication token '1234'.

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.

    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationId = (Get-MerakiOrganizations -AuthToken $AuthToken).id,
        [parameter(Mandatory=$true)]
        [string]$Serials
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }

        $body = $Serials

        $uri = "https://api.meraki.com/api/v1/organizations/$OrganizationId/inventory/release"
        $response = Invoke-RestMethod -Method Post -Uri $uri -Header $header -Body $body
        return $response
    }
    catch {
        Write-Error $_
    }
}