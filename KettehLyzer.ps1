# ============================================================
#  ██████╗ ███████╗████████╗████████╗███████╗██╗  ██╗██╗  ██╗
#  ██╔══██╗██╔════╝╚══██╔══╝╚══██╔══╝██╔════╝██║  ██║██║  ╚██╗
#  ██████╔╝█████╗     ██║      ██║   █████╗  ███████║██║   ╚██╗
#  ██╔══██╗██╔══╝     ██║      ██║   ██╔══╝  ██╔══██║██║    ██║
#  ██████╔╝███████╗   ██║      ██║   ███████╗██║  ██║███████╗██║
#  ╚═════╝ ╚══════╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝
#              KETTEH MOD ANALYZER v10.0
#           PURE CHEAT STRING DETECTION 🔥
# ============================================================

Clear-Host
$Host.UI.RawUI.WindowTitle = "⚡ KETTEH MOD ANALYZER v10.0 ⚡"

# ─── COLOR DEFINITIONS ────────────────────────────────────────
$Cyan = "Cyan"; $Magenta = "Magenta"; $Green = "Green"; $Yellow = "Yellow"; $Red = "Red"
$White = "White"; $Gray = "Gray"; $DarkGray = "DarkGray"; $DarkMagenta = "DarkMagenta"
$DarkCyan = "DarkCyan"; $DarkRed = "DarkRed"

# ─── ASCII BANNER ─────────────────────────────────────────────
Write-Host @"
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║      ██╗  ██╗███████╗████████╗████████╗███████╗██╗  ██╗     ║
║      ██║ ██╔╝██╔════╝╚══██╔══╝╚══██╔══╝██╔════╝██║  ██║     ║
║      █████╔╝ █████╗     ██║      ██║   █████╗  ███████║     ║
║      ██╔═██╗ ██╔══╝     ██║      ██║   ██╔══╝  ██╔══██║     ║
║      ██║  ██╗███████╗   ██║      ██║   ███████╗██║  ██║     ║
║      ╚═╝  ╚═╝╚══════╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝     ║
║                                                               ║
║           ⚡ MOD ANALYZER v10.0 ⚡                         ║
║        CHEAT STRING DETECTION ENGINE 🔥                  ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Magenta

Write-Host ""
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  ⚡  CHEAT STRING DETECTION ENGINE" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""

# ─── LOADING ──────────────────────────────────────────────────
Write-Host "  [SYSTEM] Loading cheat string database..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 300
Write-Host "  [SYSTEM] Initializing detection engine..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 300
Write-Host "  [SYSTEM] Ready to catch cheaters." -ForegroundColor Green
Write-Host ""

# ─── LOADING BAR ──────────────────────────────────────────────
Write-Host "  ═══ LOADING MODULES ═══" -ForegroundColor DarkCyan
for ($i = 0; $i -le 100; $i += 5) {
    $bar = "["
    $filled = [math]::Floor($i / 5)
    $bar += ("█" * $filled).PadRight(20, "░")
    $bar += "]"
    Write-Host "`r  $bar $i% " -ForegroundColor Cyan -NoNewline
    Start-Sleep -Milliseconds 15
}
Write-Host "`r  [████████████████████] 100% " -ForegroundColor Green
Write-Host ""

# ─── MINECRAFT CHECK ──────────────────────────────────────────
$process = Get-Process javaw -ErrorAction SilentlyContinue
if (-not $process) { $process = Get-Process java -ErrorAction SilentlyContinue }
if ($process) {
    try { $elapsed = (Get-Date) - $process.StartTime } catch {}
    Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
    Write-Host "  🖥️  MINECRAFT PROCESS" -ForegroundColor Cyan
    Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
    Write-Host "  Process     : $($process.Name)" -ForegroundColor Green
    Write-Host "  PID         : $($process.Id)" -ForegroundColor Green
    Write-Host "  Uptime      : $($elapsed.Hours)h $($elapsed.Minutes)m $($elapsed.Seconds)s" -ForegroundColor Green
    Write-Host ""
}

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
    Write-Host "  [SYSTEM] Using default path: $mods" -ForegroundColor Yellow
    Write-Host ""
}

if (-not (Test-Path $mods -PathType Container)) {
    Write-Host ""
    Write-Host "  ⚠️  ERROR: Invalid path!" -ForegroundColor Red
    Write-Host "  [SYSTEM] Terminating scan." -ForegroundColor Red
    exit 1
}

Write-Host "  [SYSTEM] Target locked." -ForegroundColor Green
Write-Host ""

# ─── DEPENDENCIES ─────────────────────────────────────────────
Add-Type -AssemblyName System.IO.Compression.FileSystem

# ─── CHEAT STRINGS ─────────────────────────────────────────────
$CheatStrings = @(
    'KillAura', 'AimAssist', 'Reach', 'HitBox', 'Aura', 'BowAimbot', 'Velocity',
    'AntiKnockback', 'Criticals', 'AutoClicker', 'Flight', 'BHop', 'SpeedMine',
    'NoFall', 'Phase', 'Blink', 'Freecam', 'NoSlow', 'Scaffold', 'ElytraFly',
    'XRay', 'ESP', 'Nametags', 'Chams', 'Tracers', 'Radar', 'ChestStealer',
    'Nuker', 'AutoCrystal', 'AutoAnchor', 'AutoPot', 'AutoTotem', 'AutoArmor',
    'CrystalAura', 'PingSpoof', 'SelfDestruct', 'FastPlace', 'FastBreak',
    'ClickGUI', 'AltManager', 'Meteor', 'Wurst', 'Impact', 'Aristois',
    'LiquidBounce', 'Future', 'RusherHack', 'Sigma', 'Novoline', 'GhostClient',
    'AutoBed', 'AutoFarm', 'AutoFish', 'AutoSoup', 'AutoSwitch', 'AutoTrap',
    'AutoMine', 'AutoPearl', 'AutoGapple', 'AutoEat'
)

# ─── CHEAT CLIENT NAMES ───────────────────────────────────────
$CheatClientNames = @(
    'wurst','meteor','impact','liquidbounce','aristois','future',
    'sigma','vape','entropy','dqrkis','ketteh','eventplugin',
    'crystalaura','autocrystal','anchoraura','bedaura',
    'rusherhack','novoline','ghostclient','kamiblue','salhack','clickcrystals',
    'baritone','vengeance','exhibition','kuro','rise','flux',
    'zero','raven','astolfo','dortware','xenon','tenacity'
)

# ─── LEGIT MODS ─────────────────────────────────────────────────
$LegitMods = @{
    'fabric' = $true; 'forge' = $true; 'fabric-api' = $true
    'sodium' = $true; 'lithium' = $true; 'phosphor' = $true; 'iris' = $true
    'modmenu' = $true; 'worldedit' = $true; 'jei' = $true; 'rei' = $true
    'emi' = $true; 'xaero' = $true; 'journeymap' = $true
    'anchoroptimizer' = $true; 'crystaloptimizer' = $true
    'crossbowoptimizer' = $true; 'consumableoptimizer' = $true
    'optimizer' = $true; 'glow' = $true; 'polytone' = $true
    'sodium-extra' = $true; 'placeholder-api' = $true
    'walksylib' = $true; 'yetanotherconfiglib' = $true; 'collective' = $true
    'essential' = $true; 'borderlessfullscreen' = $true; 'autoreconnect' = $true
    'fullbrightnesstoggle' = $true; 'naturalmotionblur' = $true
    'shieldfixes' = $true; 'shieldstatus' = $true
    'ambience' = $true; 'crosshairaddons' = $true
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

function Expand-JarLimited {
    param([string]$JarPath, [string]$DestDir)
    try { [System.IO.Compression.ZipFile]::ExtractToDirectory($JarPath, $DestDir) } catch { return }
    $nested = Get-ChildItem -Path $DestDir -Recurse -Filter *.jar -File -ErrorAction SilentlyContinue
    foreach ($n in $nested) {
        $sub = Join-Path $n.DirectoryName ("_extract_" + [System.IO.Path]::GetFileNameWithoutExtension($n.Name))
        New-Item -ItemType Directory -Path $sub -Force | Out-Null
        try { [System.IO.Compression.ZipFile]::ExtractToDirectory($n.FullName, $sub) } catch {}
    }
}

function Get-NameHit {
    param([string]$FileName)
    $lower = $FileName.ToLower()
    foreach ($legit in $LegitMods.Keys) {
        if ($lower -match $legit) { return $null }
    }
    foreach ($cheat in $CheatClientNames) {
        if ($lower -match $cheat) { return $cheat }
    }
    return $null
}

function Get-CheatHits {
    param([string]$ExtractedDir)
    $hits = @()
    $files = Get-ChildItem -Path $ExtractedDir -Recurse -File -Include *.class -ErrorAction SilentlyContinue
    foreach ($f in $files) {
        try {
            $bytes = [System.IO.File]::ReadAllBytes($f.FullName)
            if ($bytes.Length -gt 524288) { $bytes = $bytes[0..524287] }
            $text = [System.Text.Encoding]::ASCII.GetString($bytes)
        } catch { continue }
        foreach ($sig in $CheatStrings) {
            if ($text -match $sig) { $hits += $sig }
        }
        if ($hits.Count -gt 20) { break }
    }
    return $hits | Select-Object -Unique
}

function Get-ThreatLevel {
    param([int]$Count)
    if ($Count -ge 10) { return "CRITICAL" }
    if ($Count -ge 5) { return "HIGH" }
    if ($Count -ge 2) { return "MEDIUM" }
    return "LOW"
}

# ─── SCAN ──────────────────────────────────────────────────────
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  🔍  SCANNING MODS" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""

$verifiedMods = @(); $unknownMods = @(); $cheatMods = @()
$jarFiles = Get-ChildItem -Path $mods -Filter *.jar -File
$total = $jarFiles.Count; $counter = 0
$tempRoot = Join-Path $env:TEMP ("kettehlyzer_" + [guid]::NewGuid().ToString('N').Substring(0,8))
New-Item -ItemType Directory -Path $tempRoot -Force | Out-Null

try {
    foreach ($file in $jarFiles) {
        $counter++; $pct = [math]::Round(100 * $counter / $total)
        Write-Host "`r  [>>] Scanning $counter/$total ($pct%)...$(' ' * 20)" -ForegroundColor Cyan -NoNewline

        # 1. NAME CHECK
        $nameHit = Get-NameHit -FileName $file.Name
        if ($nameHit) {
            $cheatMods += [pscustomobject]@{ 
                FileName = $file.Name
                Type = "NAME MATCH"
                Reason = "BLATANT CHEAT: $nameHit"
                Threat = "CRITICAL"
                Hits = @()
            }
            continue
        }

        # 2. HASH CHECK (Modrinth verification)
        $sha1 = Get-JarHash -Path $file.FullName -Algo SHA1
        try {
            $ver = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/version_file/$sha1" -Method Get -ErrorAction Stop
            if ($ver.project_id) {
                $proj = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/project/$($ver.project_id)" -Method Get -ErrorAction Stop
                $verifiedMods += [pscustomobject]@{ ModName = $proj.title; FileName = $file.Name }
                continue
            }
        } catch {}

        # 3. DEEP SCAN - CHEAT STRING DETECTION
        $extractDir = Join-Path $tempRoot ([System.IO.Path]::GetFileNameWithoutExtension($file.Name))
        New-Item -ItemType Directory -Path $extractDir -Force | Out-Null
        Expand-JarLimited -JarPath $file.FullName -DestDir $extractDir

        $hits = Get-CheatHits -ExtractedDir $extractDir
        if ($hits.Count -gt 0) {
            $cheatMods += [pscustomobject]@{ 
                FileName = $file.Name
                Type = "CHEAT FEATURES"
                Reason = "$($hits.Count) cheat strings found"
                Threat = Get-ThreatLevel -Count $hits.Count
                Hits = $hits
            }
        } else {
            $zone = Get-ZoneIdentifier -Path $file.FullName
            $unknownMods += [pscustomobject]@{ FileName = $file.Name; ZoneId = $zone }
        }
        Remove-Item -Recurse -Force $extractDir -ErrorAction SilentlyContinue
    }
} finally {
    Remove-Item -Recurse -Force $tempRoot -ErrorAction SilentlyContinue
}

# ─── RESULTS ──────────────────────────────────────────────────
Write-Host ""
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  📊  ANALYSIS COMPLETE" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""

$criticalCount = ($cheatMods | Where-Object { $_.Threat -eq "CRITICAL" }).Count
$highCount = ($cheatMods | Where-Object { $_.Threat -eq "HIGH" }).Count
$mediumCount = ($cheatMods | Where-Object { $_.Threat -eq "MEDIUM" }).Count

Write-Host "  ┌─────────────────────────────────────────────────────────────────────────────────────┐" -ForegroundColor DarkMagenta
Write-Host "  │  ✅ VERIFIED  │  ❓ UNKNOWN  │  🚨 CHEATS  │  💀 CRITICAL  │  📦 TOTAL  │   " -ForegroundColor White
Write-Host "  │  $($verifiedMods.Count.ToString().PadLeft(4))           │  $($unknownMods.Count.ToString().PadLeft(4))          │  $($cheatMods.Count.ToString().PadLeft(4))           │  $criticalCount.ToString().PadLeft(4)           │  $($total.ToString().PadLeft(4))        │   " -ForegroundColor White
Write-Host "  └─────────────────────────────────────────────────────────────────────────────────────┘" -ForegroundColor DarkMagenta
Write-Host ""

# ─── VERIFIED MODS ─────────────────────────────────────────────
if ($verifiedMods.Count -gt 0) {
    Write-Host "  ✅ VERIFIED MODS (SAFE)" -ForegroundColor Green
    Write-Host "  ─────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    foreach ($mod in $verifiedMods) {
        Write-Host "  ▸ $($mod.ModName) [$($mod.FileName)]" -ForegroundColor Green
    }
    Write-Host ""
}

# ─── UNKNOWN MODS ──────────────────────────────────────────────
if ($unknownMods.Count -gt 0) {
    Write-Host "  ❓ UNKNOWN MODS" -ForegroundColor Yellow
    Write-Host "  ─────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    foreach ($mod in $unknownMods) {
        if ($mod.ZoneId) {
            Write-Host "  ▸ $($mod.FileName) [downloaded from: $($mod.ZoneId)]" -ForegroundColor Yellow
        } else {
            Write-Host "  ▸ $($mod.FileName)" -ForegroundColor Yellow
        }
    }
    Write-Host ""
}

# ─── CHEATS DETECTED ──────────────────────────────────────────
if ($cheatMods.Count -gt 0) {
    Write-Host "  🚨 CHEATS DETECTED!" -ForegroundColor Red
    Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkRed
    
    foreach ($mod in $cheatMods | Sort-Object { 
        if ($_.Threat -eq "CRITICAL") { return 0 }
        if ($_.Threat -eq "HIGH") { return 1 }
        if ($_.Threat -eq "MEDIUM") { return 2 }
        return 3
    }) {
        $threatColor = switch ($mod.Threat) {
            "CRITICAL" { $DarkRed }
            "HIGH" { $Red }
            "MEDIUM" { $Yellow }
            default { $DarkGray }
        }
        
        Write-Host ""
        Write-Host "  ╔══════════════════════════════════════════════════════════════════╗" -ForegroundColor DarkRed
        Write-Host "  ║  ⚡ FLAGGED: $($mod.FileName)" -ForegroundColor Red
        Write-Host "  ╠══════════════════════════════════════════════════════════════════╣" -ForegroundColor DarkRed
        Write-Host "  ║  TYPE   : $($mod.Type)" -ForegroundColor Yellow
        Write-Host "  ║  REASON : $($mod.Reason)" -ForegroundColor DarkMagenta
        Write-Host "  ║  THREAT : " -NoNewline -ForegroundColor Yellow
        Write-Host $mod.Threat -ForegroundColor $threatColor
        
        if ($mod.Hits.Count -gt 0) {
            Write-Host "  ╠══════════════════════════════════════════════════════════════════╣" -ForegroundColor DarkRed
            Write-Host "  ║  🎯 CHEAT STRINGS FOUND:" -ForegroundColor Cyan
            foreach ($hit in $mod.Hits) {
                Write-Host "  ║     🔸 $hit" -ForegroundColor Red
            }
        }
        Write-Host "  ╚══════════════════════════════════════════════════════════════════╝" -ForegroundColor DarkRed
    }
    Write-Host ""
}

# ─── SECURITY ASSESSMENT ──────────────────────────────────────
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  🛡️  SECURITY ASSESSMENT" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""

if ($criticalCount -gt 0) {
    Write-Host "  ⚠️  STATUS: CHEATS DETECTED!" -ForegroundColor DarkRed
    Write-Host "  ▸ $criticalCount mods with CRITICAL cheat signatures!" -ForegroundColor DarkRed
    Write-Host "  ▸ ACTION REQUIRED: REMOVE IMMEDIATELY" -ForegroundColor Red
} elseif ($highCount -gt 0) {
    Write-Host "  ⚠️  STATUS: HIGH SUSPICION" -ForegroundColor Red
    Write-Host "  ▸ $highCount mods with HIGH cheat signatures" -ForegroundColor Red
    Write-Host "  ▸ ACTION REQUIRED: REMOVE IMMEDIATELY" -ForegroundColor Red
} elseif ($mediumCount -gt 0) {
    Write-Host "  ⚠️  STATUS: CAUTION" -ForegroundColor Yellow
    Write-Host "  ▸ $mediumCount mods with suspicious signatures" -ForegroundColor Yellow
    Write-Host "  ▸ Manual inspection recommended" -ForegroundColor Yellow
} else {
    Write-Host "  ✅ STATUS: CLEAN" -ForegroundColor Green
    Write-Host "  ▸ No cheat signatures detected" -ForegroundColor Green
    Write-Host "  ▸ You're good to go!" -ForegroundColor Green
}

Write-Host ""

# ─── STATISTICS ────────────────────────────────────────────────
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  📊  SCAN STATISTICS" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""
Write-Host "  Total Scanned   : $total" -ForegroundColor White
Write-Host "  Verified Safe   : $($verifiedMods.Count)" -ForegroundColor Green
Write-Host "  Unknown         : $($unknownMods.Count)" -ForegroundColor Yellow
Write-Host "  Cheats Found    : $($cheatMods.Count)" -ForegroundColor Red
Write-Host "    Critical      : $criticalCount" -ForegroundColor DarkRed
Write-Host "    High          : $highCount" -ForegroundColor Red
Write-Host "    Medium        : $mediumCount" -ForegroundColor Yellow
Write-Host "  Scan Completed  : $((Get-Date).ToString('HH:mm:ss'))" -ForegroundColor White
Write-Host ""

# ─── CHEAT STRING DATABASE ────────────────────────────────────
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  📋  CHEAT STRING DATABASE" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""
Write-Host "  Loaded $($CheatStrings.Count) cheat signatures:" -ForegroundColor Yellow
Write-Host ""

$cols = 4
$colWidth = 25
$row = 0
$output = "  "
foreach ($sig in $CheatStrings) {
    $output += $sig.PadRight($colWidth)
    $row++
    if ($row -ge $cols) {
        Write-Host $output -ForegroundColor DarkGray
        $output = "  "
        $row = 0
    }
}
if ($output -ne "  ") { Write-Host $output -ForegroundColor DarkGray }

Write-Host ""
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta

# ─── FOOTER ────────────────────────────────────────────────────
Write-Host ""
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  ⚡  SCAN COMPLETE  ⚡" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""
Write-Host "  🔥  Justice served. Cheaters caught." -ForegroundColor Magenta
Write-Host ""
Write-Host "  [SYSTEM] Ketteh Mod Analyzer v10.0 — Done." -ForegroundColor Green
Write-Host ""

# ─── KITTY ─────────────────────────────────────────────────────
$kitty = @"
        /\_/\
       ( ^.^ )
        > ^ <
       /|   |\
      (_|   |_)
        |   |
       _|   |_
      (___|___)
"@
Write-Host $kitty -ForegroundColor Magenta
Write-Host "  🔥  Catching cheaters since 2024" -ForegroundColor Magenta
Write-Host ""
