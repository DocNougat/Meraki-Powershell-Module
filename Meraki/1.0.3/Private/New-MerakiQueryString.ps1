function New-MerakiQueryString {
        <#
    .SYNOPSIS
        Generates a query string for Meraki API requests.

    .PARAMETER queryParams
        A hashtable of query parameters to be included in the query string.

    .EXAMPLE
        New-MerakiQueryString -queryParams @{timespan=86400; object_type="person"}
        Generates a query string with the timespan and object_type query parameters.

    .NOTES
        For more information on using the Meraki API, see the documentation at:
        https://developer.cisco.com/meraki/api-v1/
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [hashtable]$queryParams
    )

    try {
        $queryString = ""
        $Keys = $queryParams.Keys
        foreach($Key in $Keys){
            $Value = $queryParams.$Key
            if ($Value -is [array]) {
                $i = 0
                foreach ($item in $Value) {
                    $queryString += $Key + "=" + $item + "&"
                    $i++
                }
            } else {
                $queryString += $Key + "=" + $Value + "&"
            }
        }

        If($queryString.length -eq 0){
            $queryString = [uri]::EscapeUriString($queryString)
        } else {
            $queryString = [uri]::EscapeUriString($queryString.Substring(0,$queryString.length-1))
        }
        return $queryString
    }
    catch {
        Write-Error $_.Exception.Message
    }
}