# ============================================================
#  ██████╗ ███████╗████████╗████████╗███████╗██╗  ██╗██╗  ██╗
#  ██╔══██╗██╔════╝╚══██╔══╝╚══██╔══╝██╔════╝██║  ██║██║  ╚██╗
#  ██████╔╝█████╗     ██║      ██║   █████╗  ███████║██║   ╚██╗
#  ██╔══██╗██╔══╝     ██║      ██║   ██╔══╝  ██╔══██║██║    ██║
#  ██████╔╝███████╗   ██║      ██║   ███████╗██║  ██║███████╗██║
#  ╚═════╝ ╚══════╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝
#                    v3  ::  mod verification + cheat detection
# ============================================================

Clear-Host

# ─── ASCII ART ────────────────────────────────────────────────
$ascii = @"
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║      ██╗  ██╗███████╗████████╗████████╗███████╗██╗  ██╗     ║
║      ██║ ██╔╝██╔════╝╚══██╔══╝╚══██╔══╝██╔════╝██║  ██║     ║
║      █████╔╝ █████╗     ██║      ██║   █████╗  ███████║     ║
║      ██╔═██╗ ██╔══╝     ██║      ██║   ██╔══╝  ██╔══██║     ║
║      ██║  ██╗███████╗   ██║      ██║   ███████╗██║  ██║     ║
║      ╚═╝  ╚═╝╚══════╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝     ║
║                                                               ║
║                  ⚡ MOD ANALYZER v3 ⚡                       ║
║            verification + cheat detection engine             ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
"@

Write-Host $ascii -ForegroundColor Magenta

# ─── BANNER ────────────────────────────────────────────────────
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  ⚡  CYBER FORENSICS MODULE  ⚡" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""
Write-Host "  [ SYSTEM ] Initializing Ketteh's Mod Analyzer..." -ForegroundColor Yellow
Write-Host "  [ SYSTEM ] Loading cheat signatures..." -ForegroundColor Yellow
Write-Host "  [ SYSTEM ] Connecting to Modrinth API..." -ForegroundColor Yellow
Write-Host ""

# ─── DECORATIVE LOADING ───────────────────────────────────────
Write-Host "  ═══ LOADING MODULES ═══" -ForegroundColor DarkCyan
$loadingChars = @('█', '▓', '▒', '░')
for ($i = 0; $i -lt 20; $i++) {
    $progress = [math]::Floor(($i / 20) * 100)
    $bar = ($loadingChars[$i % 4] * $i).PadRight(20, '░')
    Write-Host "`r  [$bar] $progress% " -ForegroundColor Cyan -NoNewline
    Start-Sleep -Milliseconds 50
}
Write-Host "`r  [████████████████████] 100% " -ForegroundColor Green
Write-Host "  [ SYSTEM ] All systems nominal." -ForegroundColor Green
Write-Host ""

# ─── PATH INPUT ───────────────────────────────────────────────
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  📂  TARGET DIRECTORY" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""
Write-Host "  Enter path to the mods folder:" -ForegroundColor White
Write-Host "  (press Enter to use default)" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  ────▶ " -ForegroundColor Cyan -NoNewline
$mods = Read-Host
Write-Host ""

if (-not $mods) {
    $mods = Join-Path $env:APPDATA ".minecraft\mods"
    Write-Host "  [ SYSTEM ] Using default path:" -ForegroundColor Yellow -NoNewline
    Write-Host " $mods" -ForegroundColor White
    Write-Host ""
}

if (-not (Test-Path $mods -PathType Container)) {
    Write-Host "  ⚠️  ERROR: Invalid path!" -ForegroundColor Red
    Write-Host "  [ SYSTEM ] Terminating scan." -ForegroundColor Red
    exit 1
}

Write-Host "  [ SYSTEM ] Target locked." -ForegroundColor Green
Write-Host ""

# ─── DEPENDENCIES ─────────────────────────────────────────────
Add-Type -AssemblyName System.IO.Compression.FileSystem

# ─── MINECRAFT UPTIME ─────────────────────────────────────────
$process = Get-Process javaw -ErrorAction SilentlyContinue
if (-not $process) { $process = Get-Process java -ErrorAction SilentlyContinue }
if ($process) {
    try { $elapsed = (Get-Date) - $process.StartTime } catch {}
    Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
    Write-Host "  🖥️  MINECRAFT PROCESS" -ForegroundColor Cyan
    Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
    Write-Host "  Process     : $($process.Name)" -ForegroundColor White
    Write-Host "  PID         : $($process.Id)" -ForegroundColor White
    Write-Host "  Uptime      : $($elapsed.Hours)h $($elapsed.Minutes)m $($elapsed.Seconds)s" -ForegroundColor White
    Write-Host ""
}

# ─── HELPERS ──────────────────────────────────────────────────
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

# ─── MODRINTH CACHE ───────────────────────────────────────────
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

# ─── RECURSIVE JAR EXTRACTOR ──────────────────────────────────
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

# ─── CHEAT SIGNATURES ──────────────────────────────────────────
$CheatClientNames = @(
    'wurst','meteorclient','impact','liquidbounce','aristois','future','lambdaclient',
    'rusherhack','sigmaclient','novoline','ghostclient','kamiblue','salhack','clickcrystals',
    'baritone','vengeance','immediatelyfast','sigma','jello','exhibition','vape','entropy'
)

$CheatStrings = @(
    'AimAssist','AnchorTweaks','AutoAnchor','AutoCrystal','AutoDoubleHand','AutoHitCrystal',
    'AutoPot','AutoTotem','AutoArmor','InventoryTotem','Hitboxes','JumpReset','LegitTotem',
    'PingSpoof','SelfDestruct','ShieldBreaker','TriggerBot','Velocity','AxeSpam','WebMacro',
    'FastPlace','KillAura','Reach','Scaffold','ElytraFly','NoFall','FastBreak','AutoClicker',
    'XRay','ChestStealer','CrystalAura','AnchorMacro','NoSlow','AutoBlockPlace','HoleFiller',
    'SpeedMine','Flight','BHop','AntiKnockback','Criticals','ESP','Nametags','Chams',
    'Tracers','Radar','Freecam','Blink','Phase','Nuker','Rape','BowAimbot'
)

function Get-NameHit {
    param([string]$FileName)
    $lower = $FileName.ToLower()
    return ($CheatClientNames | Where-Object { $lower -match [regex]::Escape($_) } | Select-Object -First 1)
}

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

# ─── SCAN ──────────────────────────────────────────────────────
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  🔍  SCANNING MODS" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""

$verifiedMods = @()
$unknownMods  = @()
$cheatMods    = @()

$jarFiles = Get-ChildItem -Path $mods -Filter *.jar -File
$total    = $jarFiles.Count
$counter  = 0
$spinner  = @('◢','◣','◤','◥')
$tempRoot = Join-Path $env:TEMP ("kettehlyzer_" + [guid]::NewGuid().ToString('N').Substring(0,8))
New-Item -ItemType Directory -Path $tempRoot -Force | Out-Null

try {
    foreach ($file in $jarFiles) {
        $counter++
        $pct = if ($total -gt 0) { [math]::Round(100 * $counter / $total) } else { 100 }
        Write-Host "`r  [$($spinner[$counter % 4])] Scanning $counter/$total ($pct%)...$(' ' * 20)" -ForegroundColor Cyan -NoNewline

        $nameHit = Get-NameHit -FileName $file.Name
        if ($nameHit) {
            $cheatMods += [pscustomobject]@{ FileName = $file.Name; Reason = "name match: $nameHit" }
            continue
        }

        $sha1  = Get-JarHash -Path $file.FullName -Algo SHA1
        $known = Fetch-Modrinth -Sha1 $sha1
        if ($known.Slug) {
            $verifiedMods += [pscustomobject]@{ ModName = $known.Name; FileName = $file.Name }
            continue
        }

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
    Write-Host "`r  $(' ' * 80)`r" -NoNewline
    Remove-Item -Recurse -Force $tempRoot -ErrorAction SilentlyContinue
}

# ─── RESULTS ──────────────────────────────────────────────────
Write-Host ""
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  📊  ANALYSIS COMPLETE" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""

# ─── SUMMARY BADGE ────────────────────────────────────────────
Write-Host "  ┌─────────────────────────────────────────────────────────────┐" -ForegroundColor DarkMagenta
Write-Host "  │  ✅ VERIFIED  │  ❓ UNKNOWN  │  🚨 FLAGGED  │              " -ForegroundColor White
Write-Host "  │  $($verifiedMods.Count.ToString().PadLeft(4))           │  $($unknownMods.Count.ToString().PadLeft(4))          │  $($cheatMods.Count.ToString().PadLeft(4))           │              " -ForegroundColor White
Write-Host "  └─────────────────────────────────────────────────────────────┘" -ForegroundColor DarkMagenta
Write-Host ""

# ─── VERIFIED ──────────────────────────────────────────────────
if ($verifiedMods.Count -gt 0) {
    Write-Host "  ═══ ✅ VERIFIED MODS ═══" -ForegroundColor Green
    Write-Host ""
    foreach ($mod in $verifiedMods) {
        Write-Host "  ▸ $($mod.ModName)" -ForegroundColor Green -NoNewline
        Write-Host "  [$($mod.FileName)]" -ForegroundColor DarkGray
    }
    Write-Host ""
}

# ─── UNKNOWN ──────────────────────────────────────────────────
if ($unknownMods.Count -gt 0) {
    Write-Host "  ═══ ❓ UNKNOWN MODS ═══" -ForegroundColor Yellow
    Write-Host ""
    foreach ($mod in $unknownMods) {
        if ($mod.ZoneId) {
            Write-Host "  ▸ $($mod.FileName)" -ForegroundColor Yellow -NoNewline
            Write-Host "  [source: $($mod.ZoneId)]" -ForegroundColor DarkGray
        } else {
            Write-Host "  ▸ $($mod.FileName)" -ForegroundColor Yellow
        }
    }
    Write-Host ""
}

# ─── FLAGGED ──────────────────────────────────────────────────
if ($cheatMods.Count -gt 0) {
    Write-Host "  ═══ 🚨 FLAGGED MODS ⚡ ═══" -ForegroundColor Red
    Write-Host ""
    foreach ($mod in $cheatMods) {
        Write-Host "  ▸ $($mod.FileName)" -ForegroundColor Red -NoNewline
        Write-Host "  — $($mod.Reason)" -ForegroundColor DarkMagenta
    }
    Write-Host ""
}

# ─── FOOTER ────────────────────────────────────────────────────
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  ⚡ SCAN COMPLETE ⚡" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""
Write-Host "  Flagged/unknown entries deserve a manual look." -ForegroundColor Yellow
Write-Host "  Stay safe, stay vigilant. 🔥" -ForegroundColor Magenta
Write-Host ""
Write-Host "  [ SYSTEM ] Ketteh's Mod Analyzer v3 — Done." -ForegroundColor Green
Write-Host ""

# ─── KITTY ─────────────────────────────────────────────────────
$kitty = @"
        /\_/\
       ( o.o )
        > ^ <
       /|   |\
      (_|   |_)
        |   |
       _|   |_
      (___|___)
"@
Write-Host $kitty -ForegroundColor Magenta
Write-Host "  Stay safe, stay vigilant. 🔥" -ForegroundColor Magenta
Write-Host ""
