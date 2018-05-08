function Initialize-PDBConfig {
    <#
    .SYNOPSIS
        Initialize PSPuppetDB module configuration

    .DESCRIPTION
        Initialize PSPuppetDB module configuration, and $PDBConfig module variable

    .PARAMETER BaseUri
        PuppetDB BaseUri to use as default

    .PARAMETER Credential
        PuppetDB Credential to use as default

    .PARAMETER Certificate
        PuppetDB Certificate to use as default

    .FUNCTIONALITY
        PuppetDb
    #>
    [cmdletbinding()]
    param(
        [string]$BaseUri,
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $PSCredential,
        [string]$Path = $script:_PDBConfigXmlPath
    )
    Switch ($script:PDBConfigProps)
    {
        'BaseUri'     { $Script:PDBConfig.BaseUri = $BaseUri }
        'Credential'  { $Script:PDBConfig.Credential = $Credential }
        'Certificate' { $Script:PDBConfig.Certificate = $Certificate }
    }

    $SelectParams = @{
        Property = $Script:PDBConfigProps
    }
    if(-not (Test-IsWindows)) {
        $SelectParams.Add('ExcludeProperty', 'Credential')
    }
    #Write the global variable and the xml
    $Script:PDBConfig |
        Select-Object @SelectParams |
        Export-Clixml -Path $Path -Force
}
