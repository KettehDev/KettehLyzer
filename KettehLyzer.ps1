Clear-Host
Write-Host @"
   /\_/\        KettehLyzer v2
  ( o.o )        --------------------------------
   > ^ <         mod verification + cheat detection
"@ -ForegroundColor Magenta
Write-Host "Concept inspired by HadronCollision's Habibi Mod Analyzer — rebuilt for KettehTools" -ForegroundColor DarkGray
Write-Host "Reads your mods folder + queries the public Modrinth API for known-mod verification. Nothing else leaves your machine." -ForegroundColor DarkGray
Write-Host

# ---------------------------------------------------------------------------
# Path input
# ---------------------------------------------------------------------------
Write-Host "Enter path to the mods folder: " -NoNewline
Write-Host "(press Enter to use default)" -ForegroundColor DarkGray
$mods = Read-Host "PATH"
Write-Host

if (-not $mods) {
    $mods = Join-Path $env:APPDATA ".minecraft\mods"
    Write-Host "Continuing with " -NoNewline
    Write-Host $mods -ForegroundColor White
    Write-Host
}

if (-not (Test-Path $mods -PathType Container)) {
    Write-Host "Invalid path!" -ForegroundColor Red
    exit 1
}

Add-Type -AssemblyName System.IO.Compression.FileSystem

# ---------------------------------------------------------------------------
# Minecraft uptime
# ---------------------------------------------------------------------------
$process = Get-Process javaw -ErrorAction SilentlyContinue
if (-not $process) { $process = Get-Process java -ErrorAction SilentlyContinue }
if ($process) {
    try { $elapsed = (Get-Date) - $process.StartTime } catch {}
    Write-Host "{ Minecraft Uptime }" -ForegroundColor DarkCyan
    Write-Host "$($process.Name) PID $($process.Id) — running $($elapsed.Hours)h $($elapsed.Minutes)m $($elapsed.Seconds)s"
    Write-Host
}

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
function Get-JarHash {
    param([string]$Path, [string]$Algo = 'SHA1')
    return (Get-FileHash -Path $Path -Algorithm $Algo).Hash
}

function Get-ZoneIdentifier {
    param([string]$Path)
    $ads = Get-Content -Raw -Stream Zone.Identifier $Path -ErrorAction SilentlyContinue
    if ($ads -match "HostUrl=(.+)") { return $matches[1] }
    return $null
}

# Cache so re-checking the same hash (duplicate jars, re-runs) doesn't re-hit the API.
$modrinthCache = @{}
function Fetch-Modrinth {
    param([string]$Sha1)
    if ($modrinthCache.ContainsKey($Sha1)) { return $modrinthCache[$Sha1] }
    $result = @{ Name = ""; Slug = "" }
    try {
        $ver = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/version_file/$Sha1" -Method Get -ErrorAction Stop
        if ($ver.project_id) {
            $proj = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/project/$($ver.project_id)" -Method Get -ErrorAction Stop
            $result = @{ Name = $proj.title; Slug = $proj.slug }
        }
    } catch {}
    $modrinthCache[$Sha1] = $result
    return $result
}

# Recursively unpacks a jar AND any nested jars found inside it (fat jars / META-INF/jars
# dependency bundles), so string scanning below actually sees every embedded class file —
# not just the top level.
function Expand-JarRecursive {
    param([string]$JarPath, [string]$DestDir, [int]$Depth = 0)
    if ($Depth -gt 3) { return }
    try { [System.IO.Compression.ZipFile]::ExtractToDirectory($JarPath, $DestDir) } catch { return }
    $nested = Get-ChildItem -Path $DestDir -Recurse -Filter *.jar -File -ErrorAction SilentlyContinue
    foreach ($n in $nested) {
        $sub = Join-Path $n.DirectoryName ("_" + [System.IO.Path]::GetFileNameWithoutExtension($n.Name))
        New-Item -ItemType Directory -Path $sub -Force | Out-Null
        Expand-JarRecursive -JarPath $n.FullName -DestDir $sub -Depth ($Depth + 1)
    }
}

# Known cheat-client / package names — catches renamed or obfuscated jars by name alone.
$CheatClientNames = @(
    'wurst','meteorclient','impact','liquidbounce','aristois','future','lambdaclient',
    'rusherhack','sigmaclient','novoline','ghostclient','kamiblue','salhack','clickcrystals',
    'baritone','vengeance','immediatelyfast'
)

# Feature/method-level signatures — expanded from Habibi's original list.
$CheatStrings = @(
    'AimAssist','AnchorTweaks','AutoAnchor','AutoCrystal','AutoDoubleHand','AutoHitCrystal',
    'AutoPot','AutoTotem','AutoArmor','InventoryTotem','Hitboxes','JumpReset','LegitTotem',
    'PingSpoof','SelfDestruct','ShieldBreaker','TriggerBot','Velocity','AxeSpam','WebMacro',
    'FastPlace','KillAura','Reach','Scaffold','ElytraFly','NoFall','FastBreak','AutoClicker',
    'XRay','ChestStealer','CrystalAura','AnchorMacro','NoSlow','AutoBlockPlace','HoleFiller',
    'SpeedMine'
)

function Get-NameHit {
    param([string]$FileName)
    $lower = $FileName.ToLower()
    return ($CheatClientNames | Where-Object { $lower -match [regex]::Escape($_) } | Select-Object -First 1)
}

# Scans every extracted .class (and mod metadata .json) file's raw bytes for cheat-feature
# strings. Reading post-extraction (not the compressed jar itself) is what actually finds
# these — class files store method/class names as plain UTF-8 in the constant pool.
function Get-CheatStringHits {
    param([string]$ExtractedDir)
    $hits = [System.Collections.Generic.HashSet[string]]::new()
    $files = Get-ChildItem -Path $ExtractedDir -Recurse -File -Include *.class,*.json -ErrorAction SilentlyContinue
    foreach ($f in $files) {
        try {
            $bytes = [System.IO.File]::ReadAllBytes($f.FullName)
            $text = [System.Text.Encoding]::ASCII.GetString($bytes)
        } catch { continue }
        foreach ($sig in $CheatStrings) {
            if ($text -match [regex]::Escape($sig)) { $hits.Add($sig) | Out-Null }
        }
    }
    return $hits
}

# ---------------------------------------------------------------------------
# Main scan
# ---------------------------------------------------------------------------
$verifiedMods = @()
$unknownMods  = @()
$cheatMods    = @()

$jarFiles = Get-ChildItem -Path $mods -Filter *.jar -File
$total    = $jarFiles.Count
$counter  = 0
$spinner  = @('|','/','-','\')
$tempRoot = Join-Path $env:TEMP ("kettehlyzer_" + [guid]::NewGuid().ToString('N').Substring(0,8))
New-Item -ItemType Directory -Path $tempRoot -Force | Out-Null

try {
    foreach ($file in $jarFiles) {
        $counter++
        $pct = if ($total -gt 0) { [math]::Round(100 * $counter / $total) } else { 100 }
        Write-Host "`r[$($spinner[$counter % 4])] Scanning $counter/$total ($pct%)...$(' ' * 10)" -ForegroundColor Yellow -NoNewline

        # 1. Cheap check first: obvious name/package match.
        $nameHit = Get-NameHit -FileName $file.Name
        if ($nameHit) {
            $cheatMods += [pscustomobject]@{ FileName = $file.Name; Reason = "name match: $nameHit" }
            continue
        }

        # 2. Hash-verify against Modrinth's public database — real, known mods skip the rest.
        $sha1  = Get-JarHash -Path $file.FullName -Algo SHA1
        $known = Fetch-Modrinth -Sha1 $sha1
        if ($known.Slug) {
            $verifiedMods += [pscustomobject]@{ ModName = $known.Name; FileName = $file.Name }
            continue
        }

        # 3. Unknown mod — extract (recursively, so nested/fat jars are covered too) and
        #    scan every class file's constant pool for cheat-feature strings.
        $extractDir = Join-Path $tempRoot ([System.IO.Path]::GetFileNameWithoutExtension($file.Name))
        New-Item -ItemType Directory -Path $extractDir -Force | Out-Null
        Expand-JarRecursive -JarPath $file.FullName -DestDir $extractDir

        $hits = Get-CheatStringHits -ExtractedDir $extractDir
        if ($hits.Count -gt 0) {
            $cheatMods += [pscustomobject]@{ FileName = $file.Name; Reason = "strings: $($hits -join ', ')" }
        } else {
            $zone = Get-ZoneIdentifier -Path $file.FullName
            $unknownMods += [pscustomobject]@{ FileName = $file.Name; ZoneId = $zone }
        }
    }
} finally {
    Write-Host "`r$(' ' * 80)`r" -NoNewline
    Remove-Item -Recurse -Force $tempRoot -ErrorAction SilentlyContinue
}

# ---------------------------------------------------------------------------
# Report
# ---------------------------------------------------------------------------
Write-Host "{ Summary }" -ForegroundColor DarkCyan
Write-Host "Verified: $($verifiedMods.Count)   Unknown: $($unknownMods.Count)   Flagged: $($cheatMods.Count)"
Write-Host

if ($verifiedMods.Count -gt 0) {
    Write-Host "{ Verified Mods }" -ForegroundColor DarkCyan
    foreach ($mod in $verifiedMods) {
        Write-Host ("> {0,-30}" -f $mod.ModName) -ForegroundColor Green -NoNewline
        Write-Host "$($mod.FileName)" -ForegroundColor Gray
    }
    Write-Host
}

if ($unknownMods.Count -gt 0) {
    Write-Host "{ Unknown Mods }" -ForegroundColor DarkCyan
    foreach ($mod in $unknownMods) {
        if ($mod.ZoneId) {
            Write-Host ("> {0,-30}" -f $mod.FileName) -ForegroundColor DarkYellow -NoNewline
            Write-Host "$($mod.ZoneId)" -ForegroundColor DarkGray
            continue
        }
        Write-Host "> $($mod.FileName)" -ForegroundColor DarkYellow
    }
    Write-Host
}

if ($cheatMods.Count -gt 0) {
    Write-Host "{ Flagged Mods }" -ForegroundColor DarkCyan
    foreach ($mod in $cheatMods) {
        Write-Host "> $($mod.FileName)" -ForegroundColor Red -NoNewline
        Write-Host " — $($mod.Reason)" -ForegroundColor DarkMagenta
    }
    Write-Host
}

Write-Host "Done. Flagged/unknown entries deserve a manual look or a screen-share check." -ForegroundColor Yellow
