param(
    [string[]]$PartFiles = @(
        'C:\Users\russe\OneDrive\Desktop\Neutrons Finished\Diffusion-Explorer-main.chop-shop-replacement\_lt24MB\_parts\part001.bin',
        'C:\Users\russe\OneDrive\Desktop\Neutrons Finished\Diffusion-Explorer-main.chop-shop-replacement\_lt24MB\_parts\part002.bin',
        'C:\Users\russe\OneDrive\Desktop\Neutrons Finished\Diffusion-Explorer-main.chop-shop-replacement\_lt24MB\_parts\part003.bin',
        'C:\Users\russe\OneDrive\Desktop\Neutrons Finished\Diffusion-Explorer-main.chop-shop-replacement\_lt24MB\_parts\part004.bin',
        'C:\Users\russe\OneDrive\Desktop\Neutrons Finished\Diffusion-Explorer-main.chop-shop-replacement\_lt24MB\_parts\part005.bin'
    ),
    [string]$Output = 'C:\Users\russe\OneDrive\Desktop\Neutrons Finished\Diffusion-Explorer-main.chop-shop-replacement.compiled.zip'
)

$fallbackDir = 'C:\Users\russe\OneDrive\Desktop\Neutrons Finished\Diffusion-Explorer-main.chop-shop-replacement_lt24MB_parts'
$fallbackNames = @('part001.bin','part002.bin','part003.bin','part004.bin','part005.bin')

# If any specified part is missing, try the flat local folder variant.
if ($PartFiles | Where-Object { -not (Test-Path -LiteralPath $_) }) {
    Write-Output "Using local flat folder fallback: $fallbackDir"
    $existing = Get-ChildItem -LiteralPath $fallbackDir -Filter 'part*.bin' | Sort-Object Name
    if ($existing.Count -lt 1) {
        throw "No part files found in fallback folder: $fallbackDir"
    }
    $lookup = @{}
    foreach ($file in $existing) { $lookup[$file.Name] = $file.FullName }
    $resolved = New-Object System.Collections.Generic.List[string]
    foreach ($name in $fallbackNames) {
        if (-not $lookup.ContainsKey($name)) { throw "Missing fallback part: $name" }
        $resolved.Add($lookup[$name])
    }
    $PartFiles = $resolved.ToArray()
}

foreach ($p in $PartFiles) {
    if (-not (Test-Path -LiteralPath $p)) { throw "Missing part file: $p" }
}

$outDir = Split-Path -Parent $Output
if (-not (Test-Path -LiteralPath $outDir)) { New-Item -ItemType Directory -Path $outDir -Force | Out-Null }

$inStreams = New-Object System.Collections.Generic.List[System.IO.FileStream]
$outStream = [System.IO.File]::Create($Output)
try {
    foreach ($part in $PartFiles) {
        $in = [System.IO.File]::OpenRead($part)
        $inStreams.Add($in)
        $in.CopyTo($outStream)
    }
}
finally {
    foreach ($s in $inStreams) { $s.Dispose() }
    $outStream.Dispose()
}

$hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $Output).Hash
$size = (Get-Item -LiteralPath $Output).Length
Write-Output \"Rebuilt: $Output\"
Write-Output \"Size: $size\"
Write-Output \"SHA256: $hash\"
