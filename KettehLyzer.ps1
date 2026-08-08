# ============================================================
#  ██████╗ ███████╗████████╗████████╗███████╗██╗  ██╗██╗  ██╗
#  ██╔══██╗██╔════╝╚══██╔══╝╚══██╔══╝██╔════╝██║  ██║██║  ╚██╗
#  ██████╔╝█████╗     ██║      ██║   █████╗  ███████║██║   ╚██╗
#  ██╔══██╗██╔══╝     ██║      ██║   ██╔══╝  ██╔══██║██║    ██║
#  ██████╔╝███████╗   ██║      ██║   ███████╗██║  ██║███████╗██║
#  ╚═════╝ ╚══════╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝
#           KETTEH SS BYPASS DETECTOR v7.0
#         CATCHES MODS HIDING FROM SCREENSHARES 🔥
# ============================================================

Clear-Host

# ─── COLOR DEFINITIONS ────────────────────────────────────────
$Cyan = "Cyan"
$Magenta = "Magenta"
$Green = "Green"
$Yellow = "Yellow"
$Red = "Red"
$White = "White"
$Gray = "Gray"
$DarkGray = "DarkGray"
$DarkMagenta = "DarkMagenta"
$DarkCyan = "DarkCyan"
$DarkRed = "DarkRed"

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
║        ⚡ SS BYPASS & HIDE DETECTOR v7.0 ⚡               ║
║     CATCHES MODS HIDING FROM SCREENSHARES 🔥              ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Magenta

Write-Host ""
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  ⚡  SS BYPASS DETECTION ENGINE  ⚡" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""
Write-Host "  [SYSTEM] Loading SS bypass signatures..." -ForegroundColor Yellow
Write-Host "  [SYSTEM] Loading hide detection patterns..." -ForegroundColor Yellow
Write-Host "  [SYSTEM] Loading injection detection..." -ForegroundColor Yellow
Write-Host "  [SYSTEM] Ready to expose hidden cheats." -ForegroundColor Yellow
Write-Host ""

# ─── LOADING BAR ──────────────────────────────────────────────
for ($i = 0; $i -le 100; $i += 5) {
    $bar = "["
    $filled = [math]::Floor($i / 5)
    $bar += ("█" * $filled).PadRight(20, "░")
    $bar += "]"
    Write-Host "`r  $bar $i% " -ForegroundColor Cyan -NoNewline
    Start-Sleep -Milliseconds 8
}
Write-Host "`r  [████████████████████] 100% " -ForegroundColor Green
Write-Host "  [SYSTEM] Engine ready." -ForegroundColor Green
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
    Write-Host "  [SYSTEM] Using default path:" -ForegroundColor Yellow -NoNewline
    Write-Host " $mods" -ForegroundColor White
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

# ─── SS BYPASS SIGNATURES ─────────────────────────────────────
$HideSignatures = @(
    # File Hiding
    'File', 'Hide', 'Hidden', 'Directory', 'Delete', 'Temp', 'Cache', 'Clean',
    'DeleteOnExit', 'File.delete', 'Files.delete', 'Files.move', 'Files.copy',
    'FileOutputStream', 'FileInputStream', 'RandomAccessFile',
    
    # Process Hiding
    'Process', 'HideWindow', 'Shell', 'Execute', 'Runtime', 'ProcessBuilder',
    'ProcessHandle', 'ProcessInfo', 'GetProcess', 'FindProcess',
    
    # Memory Hiding
    'Memory', 'Heap', 'Stack', 'Unsafe', 'Direct', 'Buffer', 'Mapped',
    'Unsafe.allocateMemory', 'Unsafe.putInt', 'Unsafe.getInt',
    'Native', 'JNI', 'JNA', 'Invoke', 'Call',
    
    # Injection
    'Inject', 'Injection', 'Injector', 'Injector', 'Load', 'Insert',
    'ClassLoader', 'System.load', 'loadLibrary', 'DefineClass',
    'Instrumentation', 'Agent_OnLoad', 'Agent_OnAttach', 'Transform',
    'ClassFileTransformer', 'JVM_LoadClass', 'AttachCurrentThread',
    
    # Bypass
    'Bypass', 'Disable', 'Disabler', 'Spoof', 'Spoofer', 'Bypasser',
    'AntiCheat', 'AAC', 'NCP', 'Vulcan', 'Matrix', 'Verus', 'Spartan',
    'Watchdog', 'Grim', 'Intave', 'Kauri', 'Negativity',
    
    # Ghost/Stealth
    'Ghost', 'Stealth', 'Invisible', 'Invisible', 'Phantom', 'Shadow',
    'Dark', 'Cloak', 'Hide', 'Secret', 'Undetectable', 'Injection'
)

# ─── CHEAT SIGNATURES ──────────────────────────────────────────
$CheatSignatures = @(
    'KillAura', 'AimAssist', 'Reach', 'HitBox', 'Aura', 'BowAimbot', 'Velocity',
    'AntiKnockback', 'Criticals', 'AutoClicker', 'Flight', 'BHop', 'SpeedMine',
    'NoFall', 'Phase', 'Blink', 'Freecam', 'NoSlow', 'Scaffold', 'ElytraFly',
    'XRay', 'ESP', 'Nametags', 'Chams', 'Tracers', 'Radar', 'ChestStealer',
    'Nuker', 'AutoCrystal', 'CrystalAura', 'PingSpoof', 'SelfDestruct',
    'FastPlace', 'FastBreak', 'ClickGUI', 'AltManager', 'AutoPot', 'AutoTotem',
    'AutoArmor', 'CrystalAura', 'AnchorAura', 'BedAura'
)

# ─── CHEAT CLIENT NAMES ───────────────────────────────────────
$CheatClientNames = @(
    'wurst','meteor','impact','liquidbounce','aristois','future',
    'sigma','vape','entropy','dqrkis','ketteh','eventplugin',
    'crystalaura','autocrystal','anchoraura','bedaura',
    'rusherhack','novoline','ghostclient','kamiblue','salhack','clickcrystals',
    'baritone','vengeance','exhibition','kuro','rise','flux',
    'zero','astolfo','dortware','xenon','tenacity',
    'injector','inject','bypass','exploit','spoofer','disabler','crasher'
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
    try {
        [System.IO.Compression.ZipFile]::ExtractToDirectory($JarPath, $DestDir)
    } catch {
        return
    }
    $nested = Get-ChildItem -Path $DestDir -Recurse -Filter *.jar -File -ErrorAction SilentlyContinue
    foreach ($n in $nested) {
        $sub = Join-Path $n.DirectoryName ("_extract_" + [System.IO.Path]::GetFileNameWithoutExtension($n.Name))
        New-Item -ItemType Directory -Path $sub -Force | Out-Null
        try {
            [System.IO.Compression.ZipFile]::ExtractToDirectory($n.FullName, $sub)
        } catch {}
    }
}

function Get-NameHit {
    param([string]$FileName)
    $lower = $FileName.ToLower()
    foreach ($legit in $LegitMods.Keys) {
        if ($lower -match [regex]::Escape($legit)) { return $null }
    }
    foreach ($cheat in $CheatClientNames) {
        if ($lower -match [regex]::Escape($cheat)) { return $cheat }
    }
    return $null
}

function Get-SSBypassHits {
    param([string]$ExtractedDir)
    $hits = @{
        Hide = @()
        Injection = @()
        Bypass = @()
        Cheat = @()
    }
    
    $files = Get-ChildItem -Path $ExtractedDir -Recurse -File -Include *.class -ErrorAction SilentlyContinue
    foreach ($f in $files) {
        try {
            $bytes = [System.IO.File]::ReadAllBytes($f.FullName)
            if ($bytes.Length -gt 524288) { $bytes = $bytes[0..524287] }
            $text = [System.Text.Encoding]::ASCII.GetString($bytes)
        } catch { continue }
        
        foreach ($sig in $HideSignatures) {
            if ($text -match [regex]::Escape($sig)) { $hits.Hide += $sig }
        }
        foreach ($sig in $CheatSignatures) {
            if ($text -match [regex]::Escape($sig)) { $hits.Cheat += $sig }
        }
        
        $totalHits = $hits.Hide.Count + $hits.Cheat.Count
        if ($totalHits -gt 20) { break }
    }
    
    $hits.Hide = $hits.Hide | Select-Object -Unique
    $hits.Cheat = $hits.Cheat | Select-Object -Unique
    return $hits
}

function Get-ThreatLevel {
    param([hashtable]$Hits)
    $total = $Hits.Hide.Count + $Hits.Cheat.Count
    if ($total -ge 10) { return "CRITICAL - SS BYPASS" }
    if ($total -ge 5) { return "HIGH - SUSPICIOUS" }
    if ($total -ge 2) { return "MEDIUM - CHECK" }
    return "LOW - UNKNOWN"
}

# ─── SCAN ──────────────────────────────────────────────────────
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  🔍  SCANNING FOR SS BYPASSES" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""

$verifiedMods = @()
$unknownMods = @()
$bypassMods = @()

$jarFiles = Get-ChildItem -Path $mods -Filter *.jar -File
$total = $jarFiles.Count
$counter = 0
$tempRoot = Join-Path $env:TEMP ("kettehlyzer_" + [guid]::NewGuid().ToString('N').Substring(0,8))
New-Item -ItemType Directory -Path $tempRoot -Force | Out-Null

try {
    foreach ($file in $jarFiles) {
        $counter++
        $pct = [math]::Round(100 * $counter / $total)
        Write-Host "`r  [>>] Scanning $counter/$total ($pct%)...$(' ' * 30)" -ForegroundColor Cyan -NoNewline

        # 1. NAME CHECK
        $nameHit = Get-NameHit -FileName $file.Name
        if ($nameHit) {
            $bypassMods += [pscustomobject]@{ 
                FileName = $file.Name
                Type = "NAME MATCH"
                Reason = "BLATANT CHEAT: $nameHit"
                Threat = "CRITICAL - CHEAT CLIENT"
                Hits = @{ Hide = @(); Cheat = @() }
            }
            continue
        }

        # 2. HASH CHECK
        $sha1 = Get-JarHash -Path $file.FullName -Algo SHA1
        try {
            $ver = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/version_file/$sha1" -Method Get -ErrorAction Stop
            if ($ver.project_id) {
                $proj = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/project/$($ver.project_id)" -Method Get -ErrorAction Stop
                $verifiedMods += [pscustomobject]@{ 
                    ModName = $proj.title
                    FileName = $file.Name
                }
                continue
            }
        } catch {}

        # 3. DEEP SCAN - SS BYPASS DETECTION
        $extractDir = Join-Path $tempRoot ([System.IO.Path]::GetFileNameWithoutExtension($file.Name))
        New-Item -ItemType Directory -Path $extractDir -Force | Out-Null
        
        Expand-JarLimited -JarPath $file.FullName -DestDir $extractDir

        $hits = Get-SSBypassHits -ExtractedDir $extractDir
        $totalHits = $hits.Hide.Count + $hits.Cheat.Count
        
        if ($totalHits -gt 0) {
            $threatLevel = Get-ThreatLevel -Hits $hits
            $bypassMods += [pscustomobject]@{ 
                FileName = $file.Name
                Type = "SS BYPASS"
                Reason = "$totalHits bypass/hide signatures detected"
                Threat = $threatLevel
                Hits = $hits
            }
        } else {
            $zone = Get-ZoneIdentifier -Path $file.FullName
            $unknownMods += [pscustomobject]@{ 
                FileName = $file.Name
                ZoneId = $zone
            }
        }
        
        Remove-Item -Recurse -Force $extractDir -ErrorAction SilentlyContinue
    }
} finally {
    Write-Host "`r$(' ' * 60)`r" -NoNewline
    Remove-Item -Recurse -Force $tempRoot -ErrorAction SilentlyContinue
}

# ─── RESULTS ──────────────────────────────────────────────────
Write-Host ""
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  📊  ANALYSIS COMPLETE" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""

# ─── SUMMARY TABLE ─────────────────────────────────────────────
$criticalCount = ($bypassMods | Where-Object { $_.Threat -match "CRITICAL" }).Count
$highCount = ($bypassMods | Where-Object { $_.Threat -match "HIGH" }).Count
$mediumCount = ($bypassMods | Where-Object { $_.Threat -match "MEDIUM" }).Count

Write-Host "  ┌─────────────────────────────────────────────────────────────────────────────────────┐" -ForegroundColor DarkMagenta
Write-Host "  │  ✅ VERIFIED  │  ❓ UNKNOWN  │  🚨 SS BYPASS  │  💀 CRITICAL  │  📦 TOTAL  │   " -ForegroundColor White
Write-Host "  │  $($verifiedMods.Count.ToString().PadLeft(4))           │  $($unknownMods.Count.ToString().PadLeft(4))          │  $($bypassMods.Count.ToString().PadLeft(4))           │  $criticalCount.ToString().PadLeft(4)           │  $($total.ToString().PadLeft(4))        │   " -ForegroundColor White
Write-Host "  └─────────────────────────────────────────────────────────────────────────────────────┘" -ForegroundColor DarkMagenta
Write-Host ""

# ─── VERIFIED MODS ─────────────────────────────────────────────
if ($verifiedMods.Count -gt 0) {
    Write-Host "  ✅ VERIFIED MODS (SAFE)" -ForegroundColor Green
    Write-Host "  ─────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    foreach ($mod in $verifiedMods) {
        Write-Host "  ▸ " -NoNewline -ForegroundColor Green
        Write-Host "$($mod.ModName)" -ForegroundColor Green -NoNewline
        Write-Host "  [$($mod.FileName)]" -ForegroundColor DarkGray
    }
    Write-Host ""
}

# ─── UNKNOWN MODS ──────────────────────────────────────────────
if ($unknownMods.Count -gt 0) {
    Write-Host "  ❓ UNKNOWN MODS" -ForegroundColor Yellow
    Write-Host "  ─────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    foreach ($mod in $unknownMods) {
        if ($mod.ZoneId) {
            Write-Host "  ▸ " -NoNewline -ForegroundColor Yellow
            Write-Host "$($mod.FileName)" -ForegroundColor Yellow -NoNewline
            Write-Host "  [downloaded from: $($mod.ZoneId)]" -ForegroundColor DarkGray
        } else {
            Write-Host "  ▸ " -NoNewline -ForegroundColor Yellow
            Write-Host "$($mod.FileName)" -ForegroundColor Yellow
        }
    }
    Write-Host ""
}

# ─── SS BYPASS DETECTED ────────────────────────────────────────
if ($bypassMods.Count -gt 0) {
    Write-Host "  🚨 SS BYPASS / HIDE DETECTED!" -ForegroundColor Red
    Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkRed
    
    foreach ($mod in $bypassMods | Sort-Object { 
        if ($_.Threat -match "CRITICAL") { return 0 }
        if ($_.Threat -match "HIGH") { return 1 }
        if ($_.Threat -match "MEDIUM") { return 2 }
        return 3
    }) {
        $threatColor = switch -Wildcard ($mod.Threat) {
            "*CRITICAL*" { $DarkRed }
            "*HIGH*" { $Red }
            "*MEDIUM*" { $Yellow }
            default { $DarkGray }
        }
        
        Write-Host ""
        Write-Host "  ⚡ $($mod.FileName)" -ForegroundColor Red -NoNewline
        
        if ($mod.Type -eq "NAME MATCH") {
            Write-Host "  — $($mod.Reason)" -ForegroundColor DarkRed
            Write-Host "  ─────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
        } else {
            Write-Host "  — $($mod.Reason)" -ForegroundColor DarkMagenta
            Write-Host "  ─────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
            Write-Host "  🎯 THREAT LEVEL: " -ForegroundColor Yellow -NoNewline
            Write-Host $mod.Threat -ForegroundColor $threatColor
            
            if ($mod.Hits.Hide.Count -gt 0) {
                Write-Host "  🕵️ SS BYPASS / HIDE Signatures Found:" -ForegroundColor Cyan
                foreach ($hit in $mod.Hits.Hide[0..5]) {
                    Write-Host "     🔸 $hit" -ForegroundColor Red
                }
                if ($mod.Hits.Hide.Count -gt 6) {
                    Write-Host "     ... and $($mod.Hits.Hide.Count - 6) more" -ForegroundColor DarkGray
                }
            }
            
            if ($mod.Hits.Cheat.Count -gt 0) {
                Write-Host "  ⚔️ Cheat Features Found:" -ForegroundColor Cyan
                foreach ($hit in $mod.Hits.Cheat[0..5]) {
                    Write-Host "     🔸 $hit" -ForegroundColor Magenta
                }
                if ($mod.Hits.Cheat.Count -gt 6) {
                    Write-Host "     ... and $($mod.Hits.Cheat.Count - 6) more" -ForegroundColor DarkGray
                }
            }
        }
        Write-Host "  ─────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    }
    Write-Host ""
}

# ─── SECURITY ASSESSMENT ──────────────────────────────────────
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  🛡️  SS BYPASS ASSESSMENT" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""

if ($criticalCount -gt 0) {
    Write-Host "  ⚠️  STATUS: SS BYPASS DETECTED!" -ForegroundColor DarkRed
    Write-Host "  ─────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    Write-Host "  ▸ $criticalCount mods with CRITICAL bypass signatures!" -ForegroundColor DarkRed
    Write-Host "  ▸ These mods are actively hiding from screenshares!" -ForegroundColor Red
    Write-Host "  ▸ ACTION REQUIRED: REMOVE IMMEDIATELY" -ForegroundColor DarkRed
} elseif ($highCount -gt 0) {
    Write-Host "  ⚠️  STATUS: HIGH SUSPICION" -ForegroundColor Red
    Write-Host "  ─────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    Write-Host "  ▸ $highCount mods with HIGH bypass signatures" -ForegroundColor Red
    Write-Host "  ▸ Likely using hide/injection techniques" -ForegroundColor Red
    Write-Host "  ▸ ACTION REQUIRED: REMOVE IMMEDIATELY" -ForegroundColor Red
} elseif ($mediumCount -gt 0) {
    Write-Host "  ⚠️  STATUS: CAUTION" -ForegroundColor Yellow
    Write-Host "  ─────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    Write-Host "  ▸ $mediumCount mods with MEDIUM bypass signatures" -ForegroundColor Yellow
    Write-Host "  ▸ Manual inspection recommended" -ForegroundColor Yellow
} elseif ($unknownMods.Count -gt 3) {
    Write-Host "  ⚠️  STATUS: CAUTION" -ForegroundColor Yellow
    Write-Host "  ─────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    Write-Host "  ▸ $($unknownMods.Count) unknown mods found" -ForegroundColor Yellow
    Write-Host "  ▸ Manual inspection recommended" -ForegroundColor Yellow
} else {
    Write-Host "  ✅ STATUS: CLEAN" -ForegroundColor Green
    Write-Host "  ─────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    Write-Host "  ▸ No SS bypass techniques detected" -ForegroundColor Green
    Write-Host "  ▸ You're good to go!" -ForegroundColor Green
}

Write-Host ""

# ─── STATISTICS ────────────────────────────────────────────────
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  📊  SS BYPASS STATISTICS" -ForegroundColor Cyan
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
Write-Host "  ⚡  SS BYPASS SCAN COMPLETE  ⚡" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""
Write-Host "  🔥  Exposed hidden mods. Justice served." -ForegroundColor Magenta
Write-Host ""
Write-Host "  [SYSTEM] Ketteh SS Bypass Detector v7.0 — Done." -ForegroundColor Green
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
Write-Host "  🔥  Exposing hidden cheats since 2024" -ForegroundColor Magenta
Write-Host ""
