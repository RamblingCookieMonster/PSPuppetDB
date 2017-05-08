﻿Function Get-PDBConfig {
    <#
    .SYNOPSIS
        Get PSPuppetDB module configuration.

    .DESCRIPTION
        Get PSPuppetDB module configuration

    .PARAMETER Source
        Get the config data from either...
        
           Variable: the live module variable used for command defaults
           Path:      the serialized PSRT.xml that loads when importing the module

        Defaults to Variable

    .PARAMETER Path
        If specified, read config from this XML file.
        
        Defaults to UserName-ComputerName-PSForeman.xml in the module root

    .FUNCTIONALITY
        Foreman
    #>
    [cmdletbinding(DefaultParameterSetName = 'variable')]
    param(
        [parameter(ParameterSetName='variable')]
        [ValidateSet("Variable","Config")]
        $Source = "Variable",

        [parameter(ParameterSetName='path')]
        [parameter(ParameterSetName='variable')]
        $Path = "$ModuleRoot\$env:USERNAME-$env:COMPUTERNAME.xml"
    )

    if(-not (Test-Path -Path $Path -PathType Leaf -ErrorAction SilentlyContinue))
    {
        try
        {
            Write-Verbose "Did not find config file [$Path] attempting to create"
            [pscustomobject]@{
                BaseUri = $null
                Credential = $null
            } | Export-Clixml -Path $Path -Force -ErrorAction Stop
        }
        catch
        {
            Write-Warning $_
            Write-Warning "Failed to create config file [$Path]"
        }
    }    
    
    if($PSCmdlet.ParameterSetName -eq 'variable' -and $Source -eq "variable" -and -not $PSBoundParameters.ContainsKey('Path'))
    {
        $Script:PSPDB
    }
    else
    {
        Import-Clixml -Path $Path
    }
}