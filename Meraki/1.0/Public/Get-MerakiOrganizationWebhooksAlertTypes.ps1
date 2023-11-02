function Get-MerakiOrganizationWebhooksAlertTypes {
    <#
    .SYNOPSIS
    Gets the available alert types for webhooks in a Meraki organization.

    .DESCRIPTION
    The Get-MerakiOrganizationWebhooksAlertTypes function returns a list of the available alert types for webhooks in a specified Meraki organization. You can optionally filter the list of alert types by product type.

    .PARAMETER AuthToken
    The Meraki Dashboard API token.

    .PARAMETER OrgId
    The ID of the Meraki organization. If not specified, the function will use the ID of the first organization associated with the specified API key.

    .PARAMETER ProductType
    The product type to filter the list of alert types by.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationWebhooksAlertTypes -AuthToken "1234" -OrgId "5678"

    Returns a list of all available alert types for webhooks in the organization with ID "5678".

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationWebhooksAlertTypes -AuthToken "1234" -ProductType "appliance"

    Returns a list of all available alert types for webhooks in the organization associated with the specified API key, filtered by the "appliance" product type.

    .NOTES
    For more information on Meraki Dashboard API webhooks and alert types, see https://developer.cisco.com/meraki/api-v1/#!webhooks.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,

        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),

        [parameter(Mandatory=$false)]
        [string]$ProductType = $null
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "Content-Type" = "application/json"
            }
            $queryParams = @{}
            
            if ($ProductType) {
                $queryParams['productType'] = $ProductType
            }
        
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/webhooks/alertTypes?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header
            return $response
        }
        catch {
            Write-Error $_
        }
    }
}
