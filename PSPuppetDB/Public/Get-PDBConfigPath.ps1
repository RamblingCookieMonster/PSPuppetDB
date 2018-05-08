# Borrowed from Brandon Olin - Thanks!
function Get-PDBConfigPath {
    <#
    .SYNOPSIS
        Get PSPuppetDB configuration file path

    .DESCRIPTION
        Get PSPuppetDB configuration file path

    .EXAMPLE
        Get-PDBConfigPath

    .FUNCTIONALITY
        PuppetDB
    #>
    [CmdletBinding()]
    param()
    end {
        if (Test-IsWindows) {
            Join-Path -Path $env:TEMP -ChildPath "$env:USERNAME-$env:COMPUTERNAME-pspuppetdb.xml"
        }
        else {
            Join-Path -Path $env:HOME -ChildPath '.pspuppetdbconfig' # Leading . and no file extension to be Unixy.
        }
    }
}