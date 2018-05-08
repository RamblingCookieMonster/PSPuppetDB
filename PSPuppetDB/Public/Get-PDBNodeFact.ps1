function Get-PDBNodeFact {
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

        [parameter(position=2)]
        [string]
        $Name,

        [ValidateNotNull()]
        [string]$BaseUri = $PDBConfig.BaseUri
    )
    $URI = Join-Parts -Separator '/' -Parts $BaseUri, nodes, $Node, facts, $Name
    $h = @{}
    $r = Invoke-RestMethod -Uri $URI
    if($r.count -gt 0)
    {
        $r | foreach-object { [void]$h.set_item($_.Name, $_.Value) }
        [pscustomobject]$h
    }
}