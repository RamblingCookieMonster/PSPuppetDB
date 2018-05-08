function Get-PDBNode {
    <#
    .Synopsis
        Query PuppetDB nodes
    .DESCRIPTION
        Query PuppetDB nodes
    .EXAMPLE
        Get-PDBNode host.fqdn
    #>
    [cmdletbinding()]
    Param (
        [parameter(position=1)]
        [string]
        $Node,

        [string]$FactName,
        [string]$FactValue,
        [validateset('=','~','>','<','>=','<=')]$FactOperator = '=',

        [ValidateNotNull()]
        [string]$BaseUri = $PDBConfig.BaseUri
    )
    $URI = Join-Parts -Separator '/' -Parts $BaseUri, nodes, $Node
    $IRMParams = @{Uri = $URI}
    if($FactName)
    {
        $b = @{query='["{0}", ["fact", "{1}"], "{2}"]' -f $FactOperator, $FactName, $FactValue }
        $IRMParams.add('Body', $b)
    }
    Write-Verbose $($b | out-string)
    Invoke-RestMethod @IRMParams
}