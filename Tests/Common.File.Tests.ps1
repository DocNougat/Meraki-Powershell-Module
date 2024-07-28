Param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]
    $ProjectRoot,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]
    $SourceRoot
)

Describe "Source files basic requirements" -Tag 'Function' {
    Context "filenames must be unique" {
        BeforeAll {
            [array]$file = Get-ChildItem -Path $SourceRoot -Directory |
                Get-ChildItem -Filter '*.ps1' -Recurse
        }

        It 'confirms no duplicate file names exist across checked source directories' {
            [string[]]$fileName = $file | Select-Object -ExpandProperty BaseName

            $fileName | Group-Object | Where-Object { $_.Count -gt 1 } | Should -BeNull
        }
    }
}

