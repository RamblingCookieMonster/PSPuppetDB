# PSPuppetDB

This is a simple wrapper for the [PuppetDB Query API](https://puppet.com/docs/puppetdb/5.2/api/query/v4/query.html)

It has had very limited testing on a specific version of PuppetDB (open source, not PE)

Issues and pull requests would be welcome!

## Instructions

* Have PuppetDB accessible somewhere

```powershell
# One time setup
    # Download the repository
    # Unblock the zip
    # Extract the PSPuppetDB folder to a module path (e.g. $env:USERPROFILE\Documents\WindowsPowerShell\Modules\)
# Or, with PowerShell 5 or later or PowerShellGet:
    Install-Module PSPuppetDB

# Import the module.
    Import-Module PSPuppetDB    #Alternatively, Import-Module \\Path\To\PSPuppetDB

# Get commands in the module
    Get-Command -Module PSPuppetDB

# Get help
    Get-Help Get-PDBNode -Full

# Set up a default baseuri
    Set-PDBConfig -BaseUri http://puppetdb.fqdn:8080/v4
    # Set-PDBConfig can also handle an x509 certificate
    # Do use cert based auth if you can

# Get all the nodes!
    $Nodes = Get-PDBNode
    $Nodes[0]

# Get some subset of nodes where the operatingsystemrelease fact = 2012 R2
    Get-PDBNode -FactName 'operatingsystemrelease' -FactValue '2012 R2'

# Get all the facts for a node
    Get-PDBNodeFact -Certname somenode.fqdn
```
