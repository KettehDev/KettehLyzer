Write-Host @"
   /\_/\        KettehTools :: KettehLyzer
  ( o.o )        --------------------------------
   > ^ <         paste your mods folder path below, or press Enter for default
"@ -ForegroundColor Magenta

$typed = Read-Host "Mods folder path (Enter = default .minecraft\mods)"
$ModsPath = if([string]::IsNullOrWhiteSpace($typed)){ Join-Path $env:APPDATA '.minecraft\mods' } else { $typed }
if(-not (Test-Path $ModsPath)){ Write-Host "No mods folder at $ModsPath" -ForegroundColor Red; return }
Add-Type -AssemblyName System.IO.Compression.FileSystem
$CheatSignatures = @('wurst','meteorclient','impact','liquidbounce','aristois','future','lambdaclient','rusherhack','sigmaclient','novoline','ghostclient','kamiblue','salhack','clickcrystals','baritone')
$jars = Get-ChildItem $ModsPath -Filter *.jar -File
Write-Host "Found $($jars.Count) jar(s) in $ModsPath" -ForegroundColor Cyan
$results = @()
foreach($jar in $jars){
  $entry = [ordered]@{ Name=$jar.Name; SizeKB=[math]::Round($jar.Length/1KB,1); Modified=$jar.LastWriteTime; SHA256=(Get-FileHash $jar.FullName -Algorithm SHA256).Hash }
  try {
    $zip = [System.IO.Compression.ZipFile]::OpenRead($jar.FullName)
    $pkgHit = $zip.Entries | Where-Object { $p = $_.FullName.ToLower(); $CheatSignatures | Where-Object { $p -like "$_/*" -or $p -like "*/$_/*" } } | Select-Object -First 1
    $nameHit = $CheatSignatures | Where-Object { $jar.Name.ToLower() -match [regex]::Escape($_) } | Select-Object -First 1
    if($pkgHit -or $nameHit){ $entry.CheatHit = $true; $entry.CheatMatch = if($pkgHit){ $pkgHit.FullName } else { $nameHit } } else { $entry.CheatHit = $false }
    $fmj = $zip.GetEntry('fabric.mod.json')
    if($fmj){ $r = New-Object IO.StreamReader($fmj.Open()); $json = $r.ReadToEnd() | ConvertFrom-Json; $r.Close()
      $entry.ModId = $json.id; $entry.Version = $json.version; $entry.Authors = ($json.authors -join ', '); $entry.Environment = $json.environment
    } else { $entry.FabricMeta = 'MISSING' }
    $toml = $zip.GetEntry('META-INF/mods.toml')
    if($toml){ $r = New-Object IO.StreamReader($toml.Open()); $entry.ModsToml = ($r.ReadToEnd() -split "`n" | Select-Object -First 8) -join ' | '; $r.Close() }
    else { $entry.ModsToml = 'MISSING' }
    $mixinEntries = $zip.Entries | Where-Object { $_.FullName -match '\.mixins\.json$' }
    $entry.MixinConfigs = if($mixinEntries){ ($mixinEntries.FullName -join ', ') } else { 'none' }
    $coreMods = $zip.GetEntry('META-INF/coremods.json')
    if($coreMods){ $entry.CoreMod = 'YES — inspect manually' }
    $zip.Dispose()
  } catch { $entry.ParseError = $_.Exception.Message }
  $results += [pscustomobject]$entry
}
$results | Format-Table -AutoSize
Write-Host "`n--- Cheat signature verdicts ---" -ForegroundColor Cyan
foreach($r in $results){
  if($r.CheatHit){ Write-Host (" [!] " + $r.Name + " -> possible cheat client match: " + $r.CheatMatch) -ForegroundColor Red }
  else { Write-Host (" [ok] " + $r.Name) -ForegroundColor DarkGray }
}
Write-Host "`nDone. Anything flagged [!] deserves a manual look / a screen-share check." -ForegroundColor Yellow
