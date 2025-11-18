function Get-MerakiOrganizationWirelessControllerDevicesRedundancyStatuses {
    <#
    .SYNOPSIS
    Retrieves redundancy status information for wireless controller devices in a Meraki organization.

    .DESCRIPTION
    Get-MerakiOrganizationWirelessControllerDevicesRedundancyStatuses queries the Cisco Meraki Dashboard API to obtain redundancy statuses for wireless controller devices associated with the specified organization. It sends the API key via the X-Cisco-Meraki-API-Key header and supports pagination and filtering by device serial numbers.

    This function will attempt to auto-resolve the OrganizationID using Get-OrgID if OrganizationID is not provided. If Get-OrgID returns a "Multiple organizations found" message, the function will return that message and exit; in that case, specify the OrganizationID explicitly.

    .PARAMETER AuthToken
    The Cisco Meraki API key used to authenticate the request. This parameter is mandatory.

    .PARAMETER OrganizationID
    The Meraki organization ID to query. If not specified, the function calls Get-OrgID -AuthToken $AuthToken to attempt resolution. If multiple organizations are found, you must supply a specific OrganizationID.

    .PARAMETER perPage
    (Optional) Number of items to return per page for paginated results. Accepts an integer value.

    .PARAMETER startingAfter
    (Optional) A cursor for pagination. Returns results starting after the provided cursor value.

    .PARAMETER endingBefore
    (Optional) A cursor for pagination. Returns results ending before the provided cursor value.

    .PARAMETER serials
    (Optional) An array of device serial numbers to restrict the response to specific devices. Provide one or more serial strings.

    .EXAMPLE
    # Resolve organization automatically and retrieve statuses
    Get-MerakiOrganizationWirelessControllerDevicesRedundancyStatuses -AuthToken 'abcd1234...'

    .NOTES
    - This function uses the Meraki Dashboard API endpoint:
        https://api.meraki.com/api/v1/organizations/{organizationId}/wirelessController/devices/redundancy/statuses
    - Exceptions from Invoke-RestMethod are thrown to the caller. Debug information may be written when an error occurs.
    - Ensure your AuthToken has sufficient permissions to read organization configuration and device status.

    .LINK
    https://developer.cisco.com/meraki/api-v1/ (Meraki Dashboard API documentation)
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$false)]
        [int]$perPage,
        [parameter(Mandatory=$false)]
        [string]$startingAfter,
        [parameter(Mandatory=$false)]
        [string]$endingBefore,
        [parameter(Mandatory=$false)]
        [array]$serials
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try { 
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
            }
            $queryParams = @{}
            If ($perPage) { 
                $queryParams["perPage"] = $perPage 
            }
            If ($startingAfter) { 
                $queryParams["startingAfter"] = $startingAfter 
            }
            If ($endingBefore) { 
                $queryParams["endingBefore"] = $endingBefore 
            }
            If ($serials) { 
                $queryParams["serials[]"] = $serials
            }
                    
            $queryString = New-MerakiQueryString -queryParams $queryParams

            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/wirelessController/devices/redundancy/statuses?$queryString"

            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}