# ============================================================
#  ██████╗ ███████╗████████╗████████╗███████╗██╗  ██╗██╗  ██╗
#  ██╔══██╗██╔════╝╚══██╔══╝╚══██╔══╝██╔════╝██║  ██║██║  ╚██╗
#  ██████╔╝█████╗     ██║      ██║   █████╗  ███████║██║   ╚██╗
#  ██╔══██╗██╔══╝     ██║      ██║   ██╔══╝  ██╔══██║██║    ██║
#  ██████╔╝███████╗   ██║      ██║   ███████╗██║  ██║███████╗██║
#  ╚═════╝ ╚══════╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝
#              KETTEH MOD ANALYZER v11.0
#       CATCHES GRIM CLIENT + ALL CHEATS 🔥
# ============================================================

Clear-Host
$Host.UI.RawUI.WindowTitle = "⚡ KETTEH MOD ANALYZER v11.0 ⚡"

# ─── COLOR DEFINITIONS ────────────────────────────────────────
$Cyan = "Cyan"; $Magenta = "Magenta"; $Green = "Green"; $Yellow = "Yellow"; $Red = "Red"
$White = "White"; $Gray = "Gray"; $DarkGray = "DarkGray"; $DarkMagenta = "DarkMagenta"
$DarkCyan = "DarkCyan"; $DarkRed = "DarkRed"; $DarkGreen = "DarkGreen"

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
║        ⚡ ULTIMATE CHEAT DETECTOR v11.0 ⚡                 ║
║     CATCHES GRIM CLIENT + ALL CHEATS 🔥                  ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Magenta

Write-Host ""
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  ⚡  ULTIMATE CHEAT DETECTION ENGINE" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""

Write-Host "  [SYSTEM] Loading cheat string database..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 300
Write-Host "  [SYSTEM] Loading Grim Client signatures..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 300
Write-Host "  [SYSTEM] Loading injector detection..." -ForegroundColor Yellow
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

# ─── GRIM CLIENT SIGNATURES ───────────────────────────────────
$GrimSignatures = @(
    'Grim', 'GrimClient', 'GrimClientV2', 'GrimInject', 'GrimInjector',
    'GrimBypass', 'GrimAC', 'GrimAntiCheat', 'GrimBypasser',
    'ClientV2', 'GhostClient', 'GhostInject', 'StealthClient',
    'InvisibleClient', 'DarkClient', 'ShadowClient'
)

# ─── INJECTOR SIGNATURES ──────────────────────────────────────
$InjectorSignatures = @(
    'Injector', 'Injection', 'Inject', 'Hook', 'Hooking', 'Detour',
    'JNI_CreateJavaVM', 'AttachCurrentThread', 'System.load', 'loadLibrary',
    'Unsafe', 'DirectBuffer', 'MappedByteBuffer', 'Instrumentation',
    'ClassFileTransformer', 'Agent_OnLoad', 'Agent_OnAttach', 'JVM_LoadClass'
)

# ─── CHEAT CLIENT NAMES ───────────────────────────────────────
$CheatClientNames = @(
    'wurst','meteor','impact','liquidbounce','aristois','future',
    'sigma','vape','entropy','dqrkis','ketteh','eventplugin',
    'crystalaura','autocrystal','anchoraura','bedaura',
    'rusherhack','novoline','ghostclient','kamiblue','salhack','clickcrystals',
    'baritone','vengeance','exhibition','kuro','rise','flux',
    'zero','raven','astolfo','dortware','xenon','tenacity',
    'grim','grimclient','griminject','ghostclient','stealthclient'
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
    $hits = @{ Cheat = @(); Grim = @(); Injector = @() }
    $files = Get-ChildItem -Path $ExtractedDir -Recurse -File -Include *.class -ErrorAction SilentlyContinue
    foreach ($f in $files) {
        try {
            $bytes = [System.IO.File]::ReadAllBytes($f.FullName)
            if ($bytes.Length -gt 524288) { $bytes = $bytes[0..524287] }
            $text = [System.Text.Encoding]::ASCII.GetString($bytes)
        } catch { continue }
        foreach ($sig in $CheatStrings) {
            if ($text -match $sig) { $hits.Cheat += $sig }
        }
        foreach ($sig in $GrimSignatures) {
            if ($text -match $sig) { $hits.Grim += $sig }
        }
        foreach ($sig in $InjectorSignatures) {
            if ($text -match $sig) { $hits.Injector += $sig }
        }
        $totalHits = $hits.Cheat.Count + $hits.Grim.Count + $hits.Injector.Count
        if ($totalHits -gt 30) { break }
    }
    $hits.Cheat = $hits.Cheat | Select-Object -Unique
    $hits.Grim = $hits.Grim | Select-Object -Unique
    $hits.Injector = $hits.Injector | Select-Object -Unique
    return $hits
}

function Get-ThreatLevel {
    param([hashtable]$Hits)
    $total = $Hits.Cheat.Count + $Hits.Grim.Count + $Hits.Injector.Count
    if ($Hits.Grim.Count -gt 0) { return "CRITICAL - GRIM CLIENT" }
    if ($Hits.Injector.Count -gt 2) { return "CRITICAL - INJECTOR" }
    if ($total -ge 10) { return "CRITICAL" }
    if ($total -ge 5) { return "HIGH" }
    if ($total -ge 2) { return "MEDIUM" }
    return "LOW"
}

# ─── SCAN ──────────────────────────────────────────────────────
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  🔍  SCANNING FOR CHEATS + GRIM CLIENT" -ForegroundColor Cyan
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
                Hits = @{ Cheat = @(); Grim = @(); Injector = @() }
            }
            continue
        }

        # 2. HASH CHECK
        $sha1 = Get-JarHash -Path $file.FullName -Algo SHA1
        try {
            $ver = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/version_file/$sha1" -Method Get -ErrorAction Stop
            if ($ver.project_id) {
                $proj = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/project/$($ver.project_id)" -Method Get -ErrorAction Stop
                $verifiedMods += [pscustomobject]@{ ModName = $proj.title; FileName = $file.Name }
                continue
            }
        } catch {}

        # 3. DEEP SCAN
        $extractDir = Join-Path $tempRoot ([System.IO.Path]::GetFileNameWithoutExtension($file.Name))
        New-Item -ItemType Directory -Path $extractDir -Force | Out-Null
        Expand-JarLimited -JarPath $file.FullName -DestDir $extractDir

        $hits = Get-CheatHits -ExtractedDir $extractDir
        $totalHits = $hits.Cheat.Count + $hits.Grim.Count + $hits.Injector.Count
        
        if ($totalHits -gt 0) {
            $cheatMods += [pscustomobject]@{ 
                FileName = $file.Name
                Type = if ($hits.Grim.Count -gt 0) { "GRIM CLIENT" } else { "CHEAT FEATURES" }
                Reason = "$totalHits signatures found"
                Threat = Get-ThreatLevel -Hits $hits
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

# ─── GRIM CLIENT RUNNING CHECK ───────────────────────────────
Write-Host ""
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  🕵️  SCANNING FOR RUNNING GRIM CLIENT" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""

$grimFound = $false
$processes = Get-Process
$javaProcesses = $processes | Where-Object { $_.ProcessName -match "java|javaw" }

foreach ($p in $javaProcesses) {
    try {
        $modules = Get-Process -Id $p.Id -Module -ErrorAction SilentlyContinue
        $grimModules = $modules | Where-Object { 
            $_.ModuleName -match "grim|client|inject|hook|ghost|stealth|shadow|dark" 
        }
        if ($grimModules) {
            Write-Host "  🚨 GRIM CLIENT DETECTED IN MEMORY!" -ForegroundColor DarkRed
            Write-Host "  ▸ Process: $($p.ProcessName).exe (PID: $($p.Id))" -ForegroundColor Red
            Write-Host "  ▸ Suspicious modules found:" -ForegroundColor Yellow
            foreach ($mod in $grimModules) {
                Write-Host "    🔸 $($mod.ModuleName)" -ForegroundColor Red
            }
            $grimFound = $true
        }
    } catch {}
}

if (-not $grimFound) {
    Write-Host "  ✅ No running Grim Client detected." -ForegroundColor Green
}
Write-Host ""

# ─── RESULTS ──────────────────────────────────────────────────
Write-Host ""
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  📊  ANALYSIS COMPLETE" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""

$criticalCount = ($cheatMods | Where-Object { $_.Threat -match "CRITICAL" }).Count
$highCount = ($cheatMods | Where-Object { $_.Threat -eq "HIGH" }).Count
$mediumCount = ($cheatMods | Where-Object { $_.Threat -eq "MEDIUM" }).Count
$grimCount = ($cheatMods | Where-Object { $_.Type -eq "GRIM CLIENT" }).Count

Write-Host "  ┌─────────────────────────────────────────────────────────────────────────────────────────────┐" -ForegroundColor DarkMagenta
Write-Host "  │  ✅ VERIFIED  │  ❓ UNKNOWN  │  🚨 CHEATS  │  ☠️ GRIM  │  💀 CRITICAL  │  📦 TOTAL  │   " -ForegroundColor White
Write-Host "  │  $($verifiedMods.Count.ToString().PadLeft(4))           │  $($unknownMods.Count.ToString().PadLeft(4))          │  $($cheatMods.Count.ToString().PadLeft(4))           │  $grimCount.ToString().PadLeft(4)           │  $criticalCount.ToString().PadLeft(4)           │  $($total.ToString().PadLeft(4))        │   " -ForegroundColor White
Write-Host "  └─────────────────────────────────────────────────────────────────────────────────────────────┘" -ForegroundColor DarkMagenta
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
        if ($_.Threat -match "CRITICAL") { return 0 }
        if ($_.Threat -eq "HIGH") { return 1 }
        if ($_.Threat -eq "MEDIUM") { return 2 }
        return 3
    }) {
        $threatColor = switch -Wildcard ($mod.Threat) {
            "*CRITICAL*" { $DarkRed }
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
        
        if ($mod.Hits.Grim.Count -gt 0) {
            Write-Host "  ╠══════════════════════════════════════════════════════════════════╣" -ForegroundColor DarkRed
            Write-Host "  ║  ☠️ GRIM CLIENT SIGNATURES:" -ForegroundColor DarkRed
            foreach ($hit in $mod.Hits.Grim) {
                Write-Host "  ║     🔸 $hit" -ForegroundColor Red
            }
        }
        
        if ($mod.Hits.Injector.Count -gt 0) {
            Write-Host "  ╠══════════════════════════════════════════════════════════════════╣" -ForegroundColor DarkRed
            Write-Host "  ║  💉 INJECTOR SIGNATURES:" -ForegroundColor Cyan
            foreach ($hit in $mod.Hits.Injector) {
                Write-Host "  ║     🔸 $hit" -ForegroundColor Magenta
            }
        }
        
        if ($mod.Hits.Cheat.Count -gt 0) {
            Write-Host "  ╠══════════════════════════════════════════════════════════════════╣" -ForegroundColor DarkRed
            Write-Host "  ║  🎯 CHEAT STRINGS:" -ForegroundColor Cyan
            foreach ($hit in $mod.Hits.Cheat) {
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

if ($grimCount -gt 0) {
    Write-Host "  ☠️  STATUS: GRIM CLIENT DETECTED!" -ForegroundColor DarkRed
    Write-Host "  ▸ $grimCount mods with GRIM CLIENT signatures!" -ForegroundColor DarkRed
    Write-Host "  ▸ These are ghost clients that bypass screenshares!" -ForegroundColor Red
    Write-Host "  ▸ ACTION REQUIRED: REMOVE IMMEDIATELY" -ForegroundColor DarkRed
} elseif ($criticalCount -gt 0) {
    Write-Host "  ⚠️  STATUS: CRITICAL THREATS DETECTED!" -ForegroundColor DarkRed
    Write-Host "  ▸ $criticalCount mods with CRITICAL signatures!" -ForegroundColor DarkRed
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
    Write-Host "  ▸ No cheats detected" -ForegroundColor Green
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
Write-Host "    Grim Client   : $grimCount" -ForegroundColor DarkRed
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
Write-Host "  🔥  Justice served. Grim Client + Cheaters caught." -ForegroundColor Magenta
Write-Host ""
Write-Host "  [SYSTEM] Ketteh Mod Analyzer v11.0 — Done." -ForegroundColor Green
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
Write-Host "  🔥  No mercy for cheaters!" -ForegroundColor Magenta
Write-Host ""
