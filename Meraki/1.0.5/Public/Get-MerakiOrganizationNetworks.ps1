function Get-MerakiOrganizationNetworks {
    <#
    .SYNOPSIS
    Retrieves the list of networks in a Meraki organization.
    
    .DESCRIPTION
    This function retrieves the list of networks in a specified Meraki organization.
    
    .PARAMETER AuthToken
    The Meraki API token.
    
    .PARAMETER OrgId
    The Meraki organization ID. If not specified, the function retrieves the ID of the first organization listed.
    
    .PARAMETER configTemplateId
    Filter networks by the ID of the config template.
    
    .PARAMETER isBoundToConfigTemplate
    Filter networks by whether or not they are bound to a config template.
    
    .PARAMETER tags
    Filter networks by tags. This parameter accepts an array of tag names.
    
    .PARAMETER tagsFilterType
    Specifies whether to filter networks by any of the specified tags or by all of them. Valid values are "any" and "all".
    
    .PARAMETER perPage
    The number of networks to return per page.
    
    .PARAMETER startingAfter
    The ID of the network to begin the page after.
    
    .PARAMETER endingBefore
    The ID of the network to end the page before.
    
    .EXAMPLE
    PS C:\> Get-MerakiOrganizationNetworks -AuthToken "12345" -OrgId "56789"
    
    Retrieves the list of networks in the Meraki organization with ID "56789".
    
    .EXAMPLE
    PS C:\> Get-MerakiOrganizationNetworks -AuthToken "12345" -configTemplateId "67890" -isBoundToConfigTemplate $true -tags "Sales","Marketing" -tagsFilterType "any" -perPage 10
    
    Retrieves the list of networks in the Meraki organization filtered by the config template with ID "67890", that are bound to a config template, have any of the tags "Sales" or "Marketing", and returns 10 networks per page.
    
    #>
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$false)]
        [string]$configTemplateId = $null,
        [parameter(Mandatory=$false)]
        [bool]$isBoundToConfigTemplate = $false,
        [parameter(Mandatory=$false)]
        [array]$tags = $null,
        [parameter(Mandatory=$false)]
        [string]$tagsFilterType = $null,
        [parameter(Mandatory=$false)]
        [int]$perPage = $null,
        [parameter(Mandatory=$false)]
        [string]$startingAfter = $null,
        [parameter(Mandatory=$false)]
        [string]$endingBefore = $null
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try{
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "Content-Type" = "application/json"
            }
            $queryParams = @{}
            if ($configTemplateId) {
                $queryParams['configTemplateId'] = $configTemplateId
            }
            if ($isBoundToConfigTemplate) {
                $queryParams['isBoundToConfigTemplate'] = $isBoundToConfigTemplate
            }
            if ($tags) {
                $queryParams['tags[]'] = $tags
            }
            if ($tagsFilterType) {
                $queryParams['tagsFilterType'] = $tagsFilterType
            }
            if ($perPage) {
                $queryParams['perPage'] = $perPage
            }
            if ($startingAfter) {
                $queryParams['startingAfter'] = $startingAfter
            }
            if ($endingBefore) {
                $queryParams['endingBefore'] = $endingBefore
            }

            $queryString = New-MerakiQueryString -queryParams $queryParams

            $URI = "https://api.meraki.com/api/v1/organizations/$OrganizationID/networks?$queryString"
            $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
            return $response
        } catch {
        Write-Host $_
        Throw $_
    }
    }
}
