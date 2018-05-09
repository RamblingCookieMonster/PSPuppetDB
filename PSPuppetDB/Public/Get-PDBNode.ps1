function Get-PDBNode {
    <#
    .SYNOPSIS
        Query PuppetDB nodes
    .DESCRIPTION
        Query PuppetDB nodes
    .EXAMPLE
        Get-PDBNode
        # Get all the nodes!
    .EXAMPLE
        Get-PDBNode host.fqdn
        # Get a specific node
    .EXAMPLE
        Get-PDBNode -FactName 'operatingsystemrelease' -FactValue '2012 R2'
        # Get nodes where the operatingsystemrelease is 2012 R2
    #>
    [cmdletbinding()]
    Param (
        [parameter(position=1)]
        [string]
        $Certname,

        [string]$FactName,
        [string]$FactValue,
        [validateset('=','~','>','<','>=','<=')]$FactOperator = '=',

        [ValidateNotNull()]
        [string]$BaseUri = $PDBConfig.BaseUri,

        [ValidateNotNull()]
        [X509Certificate]$Certificate = $PDBConfig.Certificate
    )
    $URI = Join-Parts -Separator '/' -Parts $BaseUri, nodes, $Certname
    $IRMParams = @{Uri = $URI}
    if($Certificate){
        $IRMParams.add('Certificate',$Certificate)
    }
    if($FactName)
    {
        $b = @{query='["{0}", ["fact", "{1}"], "{2}"]' -f $FactOperator, $FactName, $FactValue }
        $IRMParams.add('Body', $b)
    }
    Write-Verbose $($b | out-string)
    Invoke-RestMethod @IRMParams
}