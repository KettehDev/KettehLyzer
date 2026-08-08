# ============================================================
#  ██████╗ ███████╗████████╗████████╗███████╗██╗  ██╗██╗  ██╗
#  ██╔══██╗██╔════╝╚══██╔══╝╚══██╔══╝██╔════╝██║  ██║██║  ╚██╗
#  ██████╔╝█████╗     ██║      ██║   █████╗  ███████║██║   ╚██╗
#  ██╔══██╗██╔══╝     ██║      ██║   ██╔══╝  ██╔══██║██║    ██║
#  ██████╔╝███████╗   ██║      ██║   ███████╗██║  ██║███████╗██║
#  ╚═════╝ ╚══════╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝
#           KETTEH SS BYPASS DETECTOR v9.0
#         CATCHES MODS HIDING FROM SCREENSHARES 🔥
# ============================================================

Clear-Host
$Host.UI.RawUI.WindowTitle = "⚡ KETTEH SS BYPASS DETECTOR v9.0 ⚡"

# ─── COLOR DEFINITIONS ────────────────────────────────────────
$Cyan = "Cyan"; $Magenta = "Magenta"; $Green = "Green"; $Yellow = "Yellow"; $Red = "Red"
$White = "White"; $Gray = "Gray"; $DarkGray = "DarkGray"; $DarkMagenta = "DarkMagenta"
$DarkCyan = "DarkCyan"; $DarkRed = "DarkRed"; $DarkGreen = "DarkGreen"

# ─── BIG EPIC CAT ──────────────────────────────────────────────
$bigCat = @"
        ╔═══════════════════════════════════════════════════╗
        ║    /\_/\    /\_/\    /\_/\    /\_/\    /\_/\    ║
        ║   ( o.o )  ( ^.^ )  ( >.< )  ( O.o )  ( -.- )   ║
        ║    > ^ <    > ^ <    > ^ <    > ^ <    > ^ <    ║
        ║   /|   |\  /|   |\  /|   |\  /|   |\  /|   |\   ║
        ║  (_|   |_)(_|   |_)(_|   |_)(_|   |_)(_|   |_)  ║
        ║    |   |    |   |    |   |    |   |    |   |    ║
        ║   _|   |_  _|   |_  _|   |_  _|   |_  _|   |_   ║
        ║  (___|___)(___|___)(___|___)(___|___)(___|___)  ║
        ║                                                   ║
        ║  🔥  CATCHING CHEATERS SINCE 2024  🔥           ║
        ║  ⚡  JUSTICE SERVED. NO MERCY.  ⚡              ║
        ╚═══════════════════════════════════════════════════╝
"@

function Write-Rainbow {
    param([string]$Text, [int]$Delay = 15)
    $colors = @('Red','Yellow','Green','Cyan','Magenta','White')
    $i = 0
    foreach ($char in $Text.ToCharArray()) {
        if ($char -eq ' ') { Write-Host " " -NoNewline; continue }
        Write-Host $char -ForegroundColor $colors[$i % $colors.Length] -NoNewline
        $i++; Start-Sleep -Milliseconds $Delay
    }
    Write-Host ""
}

# ─── BANNER ──────────────────────────────────────────────────
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
║        ⚡ SS BYPASS & HIDE DETECTOR v9.0 ⚡               ║
║     CATCHES MODS HIDING FROM SCREENSHARES 🔥              ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Magenta

Write-Host ""
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  ⚡  SS BYPASS DETECTION ENGINE" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""

# ─── LOADING ──────────────────────────────────────────────────
Write-Host "  [SYSTEM] Loading SS bypass signatures..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 300
Write-Host "  [SYSTEM] Loading hide detection patterns..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 300
Write-Host "  [SYSTEM] Loading injection detection..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 300
Write-Host "  [SYSTEM] Ready to expose hidden cheats." -ForegroundColor Green
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

# ─── SIGNATURES ────────────────────────────────────────────────
$HideSignatures = @(
    'Hide','Hidden','Delete','Temp','Cache','Clean','DeleteOnExit',
    'Process','HideWindow','Shell','Runtime','Unsafe','Direct','Buffer',
    'Native','JNI','JNA','Inject','Injection','Injector','ClassLoader',
    'System.load','loadLibrary','Instrumentation','Agent_OnLoad',
    'Transform','Bypass','Disable','Spoof','AntiCheat','AAC','NCP',
    'Ghost','Stealth','Invisible','Phantom','Shadow','Cloak','Undetectable'
)

$CheatSignatures = @(
    'KillAura','AimAssist','Reach','HitBox','Aura','BowAimbot','Velocity',
    'AntiKnockback','Criticals','AutoClicker','Flight','BHop','NoFall',
    'Phase','Blink','Freecam','NoSlow','Scaffold','ElytraFly',
    'XRay','ESP','Nametags','Chams','Tracers','Radar','ChestStealer',
    'AutoCrystal','CrystalAura','PingSpoof','SelfDestruct','FastPlace',
    'FastBreak','ClickGUI','AltManager'
)

$CheatClientNames = @(
    'wurst','meteor','impact','liquidbounce','aristois','future',
    'sigma','vape','entropy','dqrkis','crystalaura','autocrystal',
    'rusherhack','novoline','ghostclient','kamiblue','salhack',
    'baritone','vengeance','exhibition','kuro','rise','flux'
)

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

function Get-SSBypassHits {
    param([string]$ExtractedDir)
    $hits = @{ Hide = @(); Cheat = @() }
    $files = Get-ChildItem -Path $ExtractedDir -Recurse -File -Include *.class -ErrorAction SilentlyContinue
    foreach ($f in $files) {
        try {
            $bytes = [System.IO.File]::ReadAllBytes($f.FullName)
            if ($bytes.Length -gt 524288) { $bytes = $bytes[0..524287] }
            $text = [System.Text.Encoding]::ASCII.GetString($bytes)
        } catch { continue }
        foreach ($sig in $HideSignatures) {
            if ($text -match $sig) { $hits.Hide += $sig }
        }
        foreach ($sig in $CheatSignatures) {
            if ($text -match $sig) { $hits.Cheat += $sig }
        }
        if (($hits.Hide.Count + $hits.Cheat.Count) -gt 30) { break }
    }
    $hits.Hide = $hits.Hide | Select-Object -Unique
    $hits.Cheat = $hits.Cheat | Select-Object -Unique
    return $hits
}

function Get-ThreatLevel {
    param([hashtable]$Hits)
    $total = $Hits.Hide.Count + $Hits.Cheat.Count
    if ($total -ge 10) { return "CRITICAL" }
    if ($total -ge 5) { return "HIGH" }
    if ($total -ge 2) { return "MEDIUM" }
    return "LOW"
}

# ─── SCAN ──────────────────────────────────────────────────────
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  🔍  SCANNING FOR SS BYPASSES" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""

$verifiedMods = @(); $unknownMods = @(); $bypassMods = @()
$jarFiles = Get-ChildItem -Path $mods -Filter *.jar -File
$total = $jarFiles.Count; $counter = 0
$tempRoot = Join-Path $env:TEMP ("kettehlyzer_" + [guid]::NewGuid().ToString('N').Substring(0,8))
New-Item -ItemType Directory -Path $tempRoot -Force | Out-Null

try {
    foreach ($file in $jarFiles) {
        $counter++; $pct = [math]::Round(100 * $counter / $total)
        Write-Host "`r  [>>] Scanning $counter/$total ($pct%)...$(' ' * 20)" -ForegroundColor Cyan -NoNewline

        $nameHit = Get-NameHit -FileName $file.Name
        if ($nameHit) {
            $bypassMods += [pscustomobject]@{ 
                FileName = $file.Name; Type = "NAME MATCH"
                Reason = "BLATANT CHEAT: $nameHit"; Threat = "CRITICAL"
                Hits = @{ Hide = @(); Cheat = @() }
            }
            continue
        }

        $sha1 = Get-JarHash -Path $file.FullName -Algo SHA1
        try {
            $ver = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/version_file/$sha1" -Method Get -ErrorAction Stop
            if ($ver.project_id) {
                $proj = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/project/$($ver.project_id)" -Method Get -ErrorAction Stop
                $verifiedMods += [pscustomobject]@{ ModName = $proj.title; FileName = $file.Name }
                continue
            }
        } catch {}

        $extractDir = Join-Path $tempRoot ([System.IO.Path]::GetFileNameWithoutExtension($file.Name))
        New-Item -ItemType Directory -Path $extractDir -Force | Out-Null
        Expand-JarLimited -JarPath $file.FullName -DestDir $extractDir

        $hits = Get-SSBypassHits -ExtractedDir $extractDir
        if (($hits.Hide.Count + $hits.Cheat.Count) -gt 0) {
            $bypassMods += [pscustomobject]@{ 
                FileName = $file.Name; Type = "SS BYPASS"
                Reason = "$($hits.Hide.Count + $hits.Cheat.Count) signatures"
                Threat = Get-ThreatLevel -Hits $hits; Hits = $hits
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

$criticalCount = ($bypassMods | Where-Object { $_.Threat -eq "CRITICAL" }).Count
$highCount = ($bypassMods | Where-Object { $_.Threat -eq "HIGH" }).Count
$mediumCount = ($bypassMods | Where-Object { $_.Threat -eq "MEDIUM" }).Count

Write-Host "  ┌─────────────────────────────────────────────────────────────────────────────────────┐" -ForegroundColor DarkMagenta
Write-Host "  │  ✅ VERIFIED  │  ❓ UNKNOWN  │  🚨 SS BYPASS  │  💀 CRITICAL  │  📦 TOTAL  │   " -ForegroundColor White
Write-Host "  │  $($verifiedMods.Count.ToString().PadLeft(4))           │  $($unknownMods.Count.ToString().PadLeft(4))          │  $($bypassMods.Count.ToString().PadLeft(4))           │  $criticalCount.ToString().PadLeft(4)           │  $($total.ToString().PadLeft(4))        │   " -ForegroundColor White
Write-Host "  └─────────────────────────────────────────────────────────────────────────────────────┘" -ForegroundColor DarkMagenta
Write-Host ""

# ─── VERIFIED ──────────────────────────────────────────────────
if ($verifiedMods.Count -gt 0) {
    Write-Host "  ✅ VERIFIED MODS (SAFE)" -ForegroundColor Green
    Write-Host "  ─────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    foreach ($mod in $verifiedMods) {
        Write-Host "  ▸ $($mod.ModName) [$($mod.FileName)]" -ForegroundColor Green
    }
    Write-Host ""
}

# ─── UNKNOWN ──────────────────────────────────────────────────
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

# ─── FLAGGED MODS ──────────────────────────────────────────────
if ($bypassMods.Count -gt 0) {
    Write-Host "  🚨 SS BYPASS / HIDE DETECTED!" -ForegroundColor Red
    Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkRed
    
    foreach ($mod in $bypassMods | Sort-Object { 
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
        
        if ($mod.Hits.Hide.Count -gt 0) {
            Write-Host "  ╠══════════════════════════════════════════════════════════════════╣" -ForegroundColor DarkRed
            Write-Host "  ║  🕵️ SS BYPASS SIGNATURES:" -ForegroundColor Cyan
            foreach ($hit in $mod.Hits.Hide) {
                Write-Host "  ║     🔸 $hit" -ForegroundColor Red
            }
        }
        
        if ($mod.Hits.Cheat.Count -gt 0) {
            Write-Host "  ╠══════════════════════════════════════════════════════════════════╣" -ForegroundColor DarkRed
            Write-Host "  ║  ⚔️ CHEAT FEATURES:" -ForegroundColor Cyan
            foreach ($hit in $mod.Hits.Cheat) {
                Write-Host "  ║     🔸 $hit" -ForegroundColor Magenta
            }
        }
        Write-Host "  ╚══════════════════════════════════════════════════════════════════╝" -ForegroundColor DarkRed
    }
    Write-Host ""
}

# ─── ASSESSMENT ────────────────────────────────────────────────
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  🛡️  SECURITY ASSESSMENT" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""

if ($criticalCount -gt 0) {
    Write-Host "  ⚠️  STATUS: SS BYPASS DETECTED!" -ForegroundColor DarkRed
    Write-Host "  ▸ $criticalCount mods with CRITICAL bypass signatures!" -ForegroundColor DarkRed
    Write-Host "  ▸ ACTION REQUIRED: REMOVE IMMEDIATELY" -ForegroundColor Red
} elseif ($highCount -gt 0) {
    Write-Host "  ⚠️  STATUS: HIGH SUSPICION" -ForegroundColor Red
    Write-Host "  ▸ $highCount mods with HIGH bypass signatures" -ForegroundColor Red
    Write-Host "  ▸ ACTION REQUIRED: REMOVE IMMEDIATELY" -ForegroundColor Red
} elseif ($mediumCount -gt 0) {
    Write-Host "  ⚠️  STATUS: CAUTION" -ForegroundColor Yellow
    Write-Host "  ▸ $mediumCount mods with suspicious signatures" -ForegroundColor Yellow
    Write-Host "  ▸ Manual inspection recommended" -ForegroundColor Yellow
} else {
    Write-Host "  ✅ STATUS: CLEAN" -ForegroundColor Green
    Write-Host "  ▸ No SS bypass techniques detected" -ForegroundColor Green
    Write-Host "  ▸ You're good to go!" -ForegroundColor Green
}

Write-Host ""

# ─── STATS ─────────────────────────────────────────────────────
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  📊  SCAN STATISTICS" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""
Write-Host "  Total Scanned   : $total" -ForegroundColor White
Write-Host "  Verified Safe   : $($verifiedMods.Count)" -ForegroundColor Green
Write-Host "  Unknown         : $($unknownMods.Count)" -ForegroundColor Yellow
Write-Host "  SS Bypass Found : $($bypassMods.Count)" -ForegroundColor Red
Write-Host "    Critical      : $criticalCount" -ForegroundColor DarkRed
Write-Host "    High          : $highCount" -ForegroundColor Red
Write-Host "    Medium        : $mediumCount" -ForegroundColor Yellow
Write-Host "  Scan Completed  : $((Get-Date).ToString('HH:mm:ss'))" -ForegroundColor White
Write-Host ""

# ─── FOOTER ────────────────────────────────────────────────────
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  ⚡  SCAN COMPLETE  ⚡" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""

# ─── EPIC BIG CAT ─────────────────────────────────────────────
$catLines = $bigCat -split "`n"
$catColors = @($DarkMagenta, $Magenta, $Cyan, $DarkCyan, $Green, $DarkGreen, $Yellow, $Red, $White, $Gray)

for ($i = 0; $i -lt $catLines.Count; $i++) {
    $color = $catColors[$i % $catColors.Length]
    Write-Host $catLines[$i] -ForegroundColor $color
}

Write-Host ""
Write-Host "  🔥  Justice served. Cheaters exposed." -ForegroundColor Magenta
Write-Host "  ⚡  Stay vigilant, stay safe." -ForegroundColor Cyan
Write-Host ""
