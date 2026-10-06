# Packs the locally built native payload and uploads it to the "native-payload"
# release, which .github/workflows/release.yml downloads. Run after
# build-openmw-051-runtime.ps1 (and the patch39 release cleanup).
$ErrorActionPreference = 'Stop'
$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$Zip = Join-Path $Root 'native-payload.zip'
Remove-Item $Zip -ErrorAction SilentlyContinue

Push-Location $Root
try {
    # buildscripts/openmw-051-patch39-libopenmw.sha256 is tracked in git already.
    Compress-Archive -Path 'app\src\main\jniLibs', 'app\src\main\assets' -DestinationPath $Zip
    gh release view native-payload 2>$null
    if ($LASTEXITCODE -ne 0) {
        gh release create native-payload --title 'native-payload' --notes 'Prebuilt OpenMW native payload used by CI' --prerelease
    }
    gh release upload native-payload $Zip --clobber
} finally { Pop-Location }
