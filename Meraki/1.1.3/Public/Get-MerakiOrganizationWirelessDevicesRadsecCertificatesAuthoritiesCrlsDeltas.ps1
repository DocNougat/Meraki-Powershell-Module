function Get-MerakiOrganizationWirelessDevicesRadsecCertificatesAuthoritiesCrlsDeltas {
    <#
    .SYNOPSIS
    Retrieves RadSec certificate authority CRL Delta records for wireless devices in a Meraki organization.

    .DESCRIPTION
    Get-MerakiOrganizationWirelessDevicesRadsecCertificatesAuthoritiesCrlsDeltas queries the Meraki Dashboard API to return
    RadSec (RADIUS over TLS) certificate authorities associated with wireless devices for a specified organization.
    If OrganizationID is not provided, it attempts to resolve the organization using Get-OrgID -AuthToken <AuthToken>.
    If multiple organizations are found, the function returns the message "Multiple organizations found. Please specify an organization ID."
    The function builds a query string (via New-MerakiQueryString) and sends an authenticated GET request
    using the X-Cisco-Meraki-API-Key header.

    .PARAMETER AuthToken
    The Meraki API key used to authenticate the request. This parameter is mandatory.

    .PARAMETER OrganizationID
    The Meraki organization ID to query. Optional—if omitted, the function attempts to obtain a single
    organization ID using Get-OrgID with the provided AuthToken. If multiple organizations are found,
    the function will return a message asking you to specify an organization ID explicitly.

    .PARAMETER certificateAuthorityIds
    An array of certificate authority IDs to filter results. When provided, the IDs are sent as
    certificateAuthorityIds[] query parameters to the API endpoint.

    .EXAMPLE
    # Use the provided API key and allow the function to auto-resolve a single organization
    Get-MerakiOrganizationWirelessDevicesRadsecCertificatesAuthoritiesCrlsDeltas -AuthToken 'abcd1234'

    .NOTES
    - Depends on helper functions New-MerakiQueryString and Get-OrgID to build query strings and resolve organization IDs.
    - Exceptions encountered during the REST call are thrown to the caller.

    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$false)]
        [array]$certificateAuthorityIds
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try { 
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
            }
            $queryParams = @{}
            If ($certificateAuthorityIds) { 
                $queryParams["certificateAuthorityIds[]"] = $certificateAuthorityIds
            }
                    
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/wireless/devices/radsec/certificates/authorities/crls/deltas?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}