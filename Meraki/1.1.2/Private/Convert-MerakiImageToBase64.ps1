function Convert-MerakiImageToBase64 {
    <#
    .SYNOPSIS
    Converts an image file to a base64-encoded string.

    .DESCRIPTION
    The Convert-MerakiImageToBase64 function allows you to convert an image file to a base64-encoded string that can be used as the value of the "imageContents" property in a Meraki floor plan configuration.

    .PARAMETER FilePath
    The path to the image file you want to convert.

    .EXAMPLE
    $image = "C:\path\to\image.png"
    $base64 = Convert-MerakiImageToBase64 -FilePath $image

    This example converts the image file located at "C:\path\to\image.png" to a base64-encoded string.

    .NOTES
    The function returns the base64-encoded string if the conversion is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$FilePath
    )
    try {
        $bytes = [System.IO.File]::ReadAllBytes($FilePath)
        $base64 = [System.Convert]::ToBase64String($bytes)
        return $base64
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}