function Initialize-PDBConfig {
    <#
    .SYNOPSIS
        Initialize PSPuppetDB module configuration

    .DESCRIPTION
        Initialize PSPuppetDB module configuration, and $PDBConfig module variable

    .PARAMETER BaseUri
        PuppetDB BaseUri to use as default

    .PARAMETER Certificate
        PuppetDB Certificate to use as default

        This is not serialized to disk

    .FUNCTIONALITY
        PuppetDb
    #>
    [cmdletbinding()]
    param(
        [string]$BaseUri,

        [string]$Path = $script:_PDBConfigXmlPath
    )
    Switch ($script:PDBConfigProps)
    {
        'BaseUri'     { $Script:PDBConfig.BaseUri = $BaseUri }
        'Certificate' { $Script:PDBConfig.Certificate = $Certificate }
    }

    $SelectParams = @{
        Property = $Script:PDBConfigProps
    }
    if(-not (Test-IsWindows)) {
        $SelectParams.Add('ExcludeProperty', 'Certificate')
    }

    #Write the global variable and the xml
    $Script:PDBConfig |
        Select-Object @SelectParams |
        Export-Clixml -Path $Path -Force
}
