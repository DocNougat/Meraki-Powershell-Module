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
    $serials = [PSCustomObject]@{
        serials = @("Q2HP-XXXX-XXXX", "Q2HP-YYYY-YYYY")
    }
    $serials = ConvertTo-Json -Compress

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
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$Serials
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
            }

            $body = $Serials

            $uri = "https://api.meraki.com/api/v1/organizations/$OrganizationId/inventory/release"
            $response = Invoke-RestMethod -Method Post -Uri $uri -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
            Write-Error $_
        }
    }
}