# Generic module deployment.
#
# ASSUMPTIONS:
#
# * Nuget key in $ENV:NugetApiKey
# * Set-BuildEnvironment from BuildHelpers module has populated ENV:BHPSModulePath and related variables

Deploy LocalModule {
    By FileSystem ModuleCopy {
        FromSource $ENV:BHModulePath
        To $ENV:BHBuildOutput\$ENV:BHProjectName
        Tagged Local, AppVeyor, Build, ModuleCopy
        WithOptions @{
            Mirror = $true
        }
    }
}

Deploy Module {
    By PSGalleryModule {
        FromSource $ENV:BHBuildOutput\$ENV:BHProjectName
        To PSGallery
        Tagged AppVeyor-Deploy
        WithOptions @{
            ApiKey = $ENV:NugetApiKey
        }
    }

    By AppVeyorModule {
        FromSource $ENV:BHBuildOutput\$ENV:BHProjectName
        To AppVeyor
        Tagged AppVeyor
        WithOptions @{
            Version = $env:APPVEYOR_BUILD_VERSION
        }
    }
}
