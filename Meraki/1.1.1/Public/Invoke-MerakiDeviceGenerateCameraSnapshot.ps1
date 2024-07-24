function Invoke-MerakiDeviceGenerateCameraSnapshot {
    <#
    .SYNOPSIS
    Generates a camera snapshot for a Meraki device.
    
    .DESCRIPTION
    The Invoke-MerakiDeviceGenerateCameraSnapshot function allows you to generate a camera snapshot for a specified Meraki device by providing the authentication token, device serial number, and an optional snapshot configuration string.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER Serial
    The serial number of the Meraki device for which you want to generate a camera snapshot.
    
    .PARAMETER SnapshotConfig
    An optional string containing the snapshot configuration. The string should be in JSON format and should include the properties as defined in the schema.
    
    .EXAMPLE
    $SnapshotConfig = [PSCustomObject]@{
        timestamp = "2021-04-30T15:18:08Z"
        fullframe = $false
    }

    $SnapshotConfig = $SnapshotConfig | ConvertTo-Json -Compress

    Invoke-MerakiDeviceGenerateCameraSnapshot -AuthToken "your-api-token" -Serial "Q2GV-ABCD-1234" -SnapshotConfig $SnapshotConfig

    This example generates a camera snapshot for the Meraki device with serial number "Q2GV-ABCD-1234".
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the snapshot generation is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$Serial,
            [parameter(Mandatory=$false)]
            [string]$SnapshotConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/devices/$Serial/camera/generateSnapshot"
    
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat" -Body $SnapshotConfig
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }