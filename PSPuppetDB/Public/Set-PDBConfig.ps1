function Set-PDBConfig {
    <#
        .SYNOPSIS
            Set PSPuppetDB module configuration

        .DESCRIPTION
            Set PSPuppetDB module configuration, and live $PDBConfig module variable

            This data is used as the default for most commands

        .PARAMETER BaseUri
            Specify a Uri to use

        .PARAMETER Certificate
            Specifies the client certificate that is used for a secure web request. Enter a variable that contains a certificate or a command or expression that gets the certificate.

            To find a certificate, use Get-PfxCertificate or use the Get-ChildItem cmdlet in the Certificate (Cert:) drive. If the certificate is not valid or does not have sufficient authority, the command fails.

            This is not serialized to the PuppetDB config on disk
        .FUNCTIONALITY
            PuppetDB
    #>
    [CmdletBinding()]
    param(
        [string]$BaseUri,
        [X509Certificate]$Certificate,
        [string]$Path = $Script:_PDBConfigXmlPath
    )

    Switch ($PSBoundParameters.Keys)
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