function Get-PDBNodeFact {
    <#
    .Synopsis
        Query PuppetDB nodes
    .DESCRIPTION
        Query PuppetDB nodes
    .EXAMPLE
        Get-PDBNodeFact host.fqdn
        # Get all facts for a specified node
    .EXAMPLE
        Get-PDBNodeFact host.fqdn -FactName
    #>
    [cmdletbinding()]
    Param (
        [parameter(position=1)]
        [string]
        $Certname,

        [parameter(position=2)]
        [string]
        $FactName,

        [ValidateNotNull()]
        [string]$BaseUri = $PDBConfig.BaseUri,

        [ValidateNotNull()]
        [X509Certificate]$Certificate = $PDBConfig.Certificate
    )
    $URI = Join-Parts -Separator '/' -Parts $BaseUri, nodes, $Certname, facts, $FactName
    $h = @{}
    $IRMParams = @{
        Uri = $URI
    }
    if($Certificate){
        $IRMParams.add('Certificate',$Certificate)
    }
    $r = Invoke-RestMethod @IRMParams
    if($r.count -gt 0)
    {
        $r | foreach-object { [void]$h.set_item($_.Name, $_.Value) }
        [pscustomobject]$h
    }
}