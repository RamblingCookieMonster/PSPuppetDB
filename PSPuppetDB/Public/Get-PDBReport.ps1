function Get-PDBReport {
    <#
    .Synopsis
        Query PuppetDB reports
    .DESCRIPTION
        Query PuppetDB reports
    .EXAMPLE
        Get-PDBReport host.fqdn
    #>
    [cmdletbinding()]
    Param (
        [parameter(position=1)]
        [string]
        $Node,

        [validateset('=','~','>','<','>=','<=')]
        $Operator = '=',

        [ValidateNotNull()]
        [string]$BaseUri = $PDBConfig.BaseUri
    )
    $URI = Join-Parts -Separator '/' -Parts $BaseUri, reports
    $IRMParams = @{Uri = $URI}
    $b = @{query='["{0}", "certname", "{1}"]' -f $Operator, $Node }
    $IRMParams.add('Body', $b)
    Write-Verbose $($b | out-string)
    Invoke-RestMethod @IRMParams
}