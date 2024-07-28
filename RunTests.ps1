#Requires -Modules Pester

[CmdletBinding(PositionalBinding=$false)]
Param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]
    $Module = 'Meraki',

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]
    $Version = '1.1.2',

    [Parameter()]
    [ValidateSet('Unit','Function','Module')]
    [string[]]
    $Tag = '*',

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [Alias('TestPath')]
    [string]
    $Path = ( Join-Path -Path $PSScriptRoot -ChildPath 'Tests' )
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ( $PSBoundParameters.ContainsKey( 'Debug' ) ) {
    $DebugPreference = 'Continue'
}

[string]$projectRoot = $PSScriptRoot
Write-Verbose ( 'projectRoot: {0}' -f $projectRoot )

[string]$moduleNameVersion = "$Module{0}$Version" -f [IO.Path]::DirectorySeparatorChar

[string]$sourceRoot = Join-Path -Path $projectRoot -ChildPath $moduleNameVersion
Write-Verbose ( 'sourceRoot: {0}' -f $sourceRoot )

# Collect module source subdirectory paths
[string[]]$moduleSourcePath = Get-ChildItem -Path $sourceRoot -Directory |
    Select-Object -ExpandProperty FullName
$moduleSourcePath.ForEach({ Write-Verbose ( 'moduleSourcePath[]: {0}' -f $PSItem ) })

# Begin building the Pester container array
[array]$containers = @(
    New-PesterContainer -Path ( Get-ChildItem -Path $Path -Filter '*.ps1' ) -Data @{
        ProjectRoot = $projectRoot
        SourceRoot = $sourceRoot
    }
)

[string]$moduleSourceRoot = $sourceRoot
Write-Verbose ( 'moduleSourceRoot: {0}' -f $moduleSourceRoot )

# The name of the current module
[string]$moduleName = $Module
Write-Verbose ( 'moduleName: {0}' -f $moduleName )

# Passed to the current module's tests
[HashTable]$containerData = @{
    ProjectRoot = $projectRoot
    ModuleSourceRoot = $moduleSourceRoot
    ModuleName = $moduleName
}

# # Add common test container for this module
# Write-Verbose ( 'Adding container for module tests in {0}' -f $moduleName )
# $containers += New-PesterContainer -Path $moduleTest -Data $containerData


# # Paths to the directories containing the current module's unit tests
# [string[]]$unitTestPath = @(
    # Join-Path -Path $moduleTestRoot -ChildPath 'Private'
    # Join-Path -Path $moduleTestRoot -ChildPath 'Public'
# )

# # Collect the paths to the unit test scripts
# [string[]]$unitTest = Get-ChildItem -Path $unitTestPath -Filter '*.ps1' -Recurse |
    # Select-Object -ExpandProperty FullName
# $unitTest.ForEach({ Write-Verbose ( 'unitTest[]: {0}' -f $PSItem ) })

# # Add unit test container for this module
# Write-Verbose ( 'Adding container for unit tests in {0}' -f $moduleName )
# $containers += New-PesterContainer -Path $unitTest -Data $containerData

# Use the type accelerator to generate configuration
$config = [PesterConfiguration]@{
    Run = @{
        Exit = $true
        Container = $containers
    }
    Filter = @{
        Tag = $Tag
    }
    Output = @{
        Verbosity = 'Detailed'
    }
    Should = @{
        ErrorAction = 'Stop'
    }
}

# Run selected tests
Invoke-Pester -Configuration $config
