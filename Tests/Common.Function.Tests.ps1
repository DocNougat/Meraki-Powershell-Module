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


BeforeDiscovery {
    [array]$file = Get-ChildItem -Path $SourceRoot -Directory |
        Get-ChildItem -Filter '*.ps1' -Recurse
}

Describe "Function basic requirements" -Tag 'Function' -ForEach $file {
    Context "function script should be valid" {
        BeforeAll {
            $file = $PSItem
            [string]$re = '^{0}\\(.+)$' -f [RegEx]::Escape( $SourceRoot )
        }

        It "confirms '<file.Name>' is within the module source tree" {
            $file.FullName | Should -Match $re
        }

        It "confirms '<file.Name>' has valid PowerShell syntax" {
            $file.FullName | Should -Exist

            [string[]]$contents = Get-Content -Path $file.FullName -ErrorAction Stop
            $errors = $null
            $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)

            $errors.Count | Should -Be 0
        }
    }

    # Context "any 'Remove-' functions should support -Confirm and -WhatIf" {
        # BeforeAll {
            # $file = $PSItem
        # }

        # It "confirms '<file.Name>' has both 'SupportsShouldProcess' and 'PSCmdlet.ShouldProcess'" {
            # if ( $file.BaseName -match 'Remove-' ) {
                # $file.FullName | Should -FileContentMatch 'SupportsShouldProcess'
                # $file.FullName | Should -FileContentMatch 'PSCmdlet.ShouldProcess'
            # }
        # }
    # }
}

