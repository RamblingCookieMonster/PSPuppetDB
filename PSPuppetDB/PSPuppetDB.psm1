param (
    [bool]$DebugModule = $false
)

# Get public and private function definition files
    $Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
    $Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )
    $FilesToLoad = @([object[]]$Public + [object[]]$Private) | Where-Object {$_}
    $ModuleRoot = $PSScriptRoot

# Dot source the files
# Thanks to Bartek, Constatine
# https://becomelotr.wordpress.com/2017/02/13/expensive-dot-sourcing/
    Foreach($File in $FilesToLoad)
    {
        Write-Verbose "Importing [$File]"
        Try
        {
            if ($DebugModule)
            {
                . $File.FullName
            }
            else {
                . (
                    [scriptblock]::Create(
                        [io.file]::ReadAllText($File.FullName, [Text.Encoding]::UTF8)
                    )
                )
            }
        }
        Catch
        {
            Write-Error -Message "Failed to import function $($File.fullname)"
            Write-Error $_
        }
    }

Try
{
    #Import the config
    $_PDBConfigXmlPath = Get-PDBConfigPath
    $PDBConfigProps = 'BaseUri', 'Credential', 'Certificate'
    $PDBConfig = [pscustomobject]@{} | Select-Object $PDBConfigProps
    $PDBConfig = Get-PDBConfig -Source Config -ErrorAction Stop
    if(-not (Test-Path -Path $_PDBConfigXmlPath -ErrorAction SilentlyContinue)) {
        try {
            Write-Warning "Did not find config file [$_PDBConfigXmlPath], attempting to initialize"
            Initialize-PDBConfig -Path $_PDBConfigXmlPath -ErrorAction Stop
        }
        catch {
            Write-Warning "Failed to create config file [$_PDBConfigXmlPath]: $_"
        }
    }
    else {
        $PDBConfig = Get-PDBConfig -Source Xml
    }
}
Catch
{
    Write-Warning "Error importing PSPuppetDB config"
    Write-Warning $_
}

Export-ModuleMember -Function $Public.BaseName