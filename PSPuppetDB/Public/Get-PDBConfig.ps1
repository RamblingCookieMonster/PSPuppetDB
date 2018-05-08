Function Get-PDBConfig {
    <#
    .SYNOPSIS
        Get PSPuppetDB module configuration.

    .DESCRIPTION
        Get PSPuppetDB module configuration

    .PARAMETER Source
        Get the config data from either...

           Variable: the live module variable used for command defaults
           Xml:      the serialized PSRT.xml that loads when importing the module

        Defaults to Variable

    .PARAMETER Path
        If specified, read config from this XML file determined by Get-PDBConfigPath

    .FUNCTIONALITY
        PuppetDB
    #>
    [cmdletbinding()]
    param(
        [ValidateSet("Variable","Xml")]
        $Source = "Variable",

        $Path = $Script:_PDBConfigXmlPath
    )

    if( $Source -eq "Variable" ) {
        $Script:PDBConfig
    }
    else {
        Import-Clixml -Path $Path |
            Select-Object -Property $Script:PDBConfigProps
    }
}