﻿@{
    # Some defaults for all dependencies
    PSDependOptions = @{
        Target = '$ENV:USERPROFILE\Documents\WindowsPowerShell\Modules'
        AddToPath = $True
        Parameters = @{
            Force = $True
        }
    }

    'psake' = '4.7.0'
    'PSDeploy' = '0.2.5'
    'BuildHelpers' = '1.1.1'
    'Pester' = '4.3.1'
}