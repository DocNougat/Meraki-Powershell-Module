function Remove-MerakiNetwork {
    <#
    .SYNOPSIS
    Removes a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Remove-MerakiNetwork function allows you to remove a Meraki network by providing the authentication token and the network ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkID
    The ID(s) of the network(s) to be removed. You can provide a single network ID as a string or multiple network IDs as an array.

    .EXAMPLE
    Remove-MerakiNetwork -AuthToken "your-api-token" -NetworkID "L_1234567890"

    This example removes a Meraki network with the ID "L_1234567890" using the provided API token.

    .EXAMPLE
    Remove-MerakiNetwork -AuthToken "your-api-token" -NetworkID @("L_1234567890", "L_0987654321")

    This example removes multiple Meraki networks with the IDs "L_1234567890" and "L_0987654321" using the provided API token.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function throws an error if there is a problem removing the network(s).
    #>
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [array]$NetworkID
    )

    $header = @{
        "X-Cisco-Meraki-API-Key" = $AuthToken
        "content-type" = "application/json; charset=utf-8"
    }

    $url = "https://api.meraki.com/api/v1/networks/$NetworkID"
    try{
        Invoke-RestMethod -Uri $url -Method Delete -Headers $header -UserAgent "MerakiPowerShellModule/1.02 DocNougat" -Body $body
        Write-Host "Successfully removed Network: $NetworkID"
    } catch {
        Write-Host $_
        Throw $_
    }
}