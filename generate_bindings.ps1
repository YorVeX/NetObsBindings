$config = "multi-file", "generate-file-scoped-namespaces", "generate-helper-types", "exclude-funcs-with-body", "generate-macro-bindings"
$replacements = "vec2=@System.Numerics.Vector2", "vec3=@System.Numerics.Vector3", "vec4=@System.Numerics.Vector4"

$obsModuleTracersals = ".\obs-studio\libobs\obs-source.h", ".\obs-studio\libobs\media-io\audio-io.h", ".\obs-studio\libobs\obs.h", ".\obs-studio\libobs\media-io\video-io.h", ".\obs-studio\libobs\media-io\frame-rate.h", ".\obs-studio\libobs\graphics\graphics.h", ".\obs-studio\libobs\obs-interaction.h", ".\obs-studio\libobs\obs-encoder.h", ".\obs-studio\libobs\obs-service.h", ".\obs-studio\libobs\util\base.h", ".\obs-studio\libobs\obs-properties.h", ".\obs-studio\libobs\obs-data.h", ".\obs-studio\libobs\util\text-lookup.h", ".\obs-studio\libobs\util\profiler.h", ".\obs-studio\libobs\callback\proc.h", ".\obs-studio\libobs\callback\signal.h", ".\obs-studio\libobs\obs-missing-files.h", ".\obs-studio\libobs\callback\calldata.h", ".\obs-studio\libobs\graphics\input.h"

 foreach ($obsModuleTracersal in $obsModuleTracersals)
 {
    $moduleNameParts = [System.IO.Path]::GetFileNameWithoutExtension($obsModuleTracersal).Replace("-io", "").Split("-")

    for ($i = 0; $i -lt $moduleNameParts.Length; $i++)
    {
        $moduleNameParts[$i] = (Get-Culture).TextInfo.ToTitleCase($moduleNameParts[$i])
    }

    $moduleName = -Join $moduleNameParts
    $moduleName = "Obs" + $moduleName.TrimStart("Obs")

     ClangSharpPInvokeGenerator `
        -c $config `
        --file .\obs-studio\libobs\obs-module.h <# file we want to generate bindings for #>  `
        --traverse $obsModuleTracersal `
        -n ObsInterop <# namespace of the bindings #> `
        --methodClassName $moduleName <# class name where to put methods #> `
        --libraryPath obs <# name of the DLL #> `
        -o .\NetObsBindings\ObsInterop <# output folder #> `
        -r $replacements
 }




ClangSharpPInvokeGenerator `
    -c $config `
    --file .\obs-studio\UI\obs-frontend-api\obs-frontend-api.h <# file we want to generate bindings for #>  `
    --file .\obs-studio\libobs\util\darray.h  `
    --include-directory .\obs-studio\libobs `
    --include-directory .\obs-studio\libobs\util `
    -n ObsInterop <# namespace of the bindings #> `
    --methodClassName ObsFrontendApi <# class name where to put methods #> `
    --libraryPath obs <# name of the DLL #> `
    -o .\NetObsBindings\ObsInterop <# output folder #> `
    -r $replacements