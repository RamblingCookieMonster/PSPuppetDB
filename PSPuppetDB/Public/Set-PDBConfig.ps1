function Set-PDBConfig {
    <#
        .SYNOPSIS
            Set PSPuppetDB module configuration.

        .DESCRIPTION
            Set PSPuppetDB module configuration, and live $PSPDB module variable

            This data is used as the default for most commands.

        .PARAMETER BaseUri
            Specify a Uri to use

        .PARAMETER Credential
            Specify a credential to use for New-ForeSession

        .PARAMETER Session
            Specify a websession to use

            This data is not stored in the XML

        .FUNCTIONALITY
            Foreman
    #>
    [CmdletBinding()]
    param(
        [string]$BaseUri,
        [PSCredential]$Credential,
        [string]$Path = "$ModuleRoot\$env:USERNAME-$env:COMPUTERNAME.xml"
    )

    try
    {
        $Existing = Get-PDBConfig -ErrorAction stop
    }
    catch
    {
        Write-Error $_
        throw $_
    }

    foreach($Key in $PSBoundParameters.Keys)
    {
        if(Get-Variable -name $Key)
        {
            #We use add-member force to cover cases where we add props to this config...
            Add-Member -InputObject $Existing -MemberType NoteProperty -Name $Key -Value $PSBoundParameters.$Key -Force
        }
    }

    #Write the global variable and the xml
    $Script:PSPDB = $Existing
    $Existing | Select-Object -Property * -ExcludeProperty Session | Export-Clixml -Path $Path -Force
}