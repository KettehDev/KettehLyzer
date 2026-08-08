# ============================================================
#  ██████╗ ███████╗████████╗████████╗███████╗██╗  ██╗██╗  ██╗
#  ██╔══██╗██╔════╝╚══██╔══╝╚══██╔══╝██╔════╝██║  ██║██║  ╚██╗
#  ██████╔╝█████╗     ██║      ██║   █████╗  ███████║██║   ╚██╗
#  ██╔══██╗██╔══╝     ██║      ██║   ██╔══╝  ██╔══██║██║    ██║
#  ██████╔╝███████╗   ██║      ██║   ███████╗██║  ██║███████╗██║
#  ╚═════╝ ╚══════╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝
#              AGGRESSIVE CHEATER CATCHER v11
#           CATCHES BLATANT CHEATS BY NAME & STRINGS
# ============================================================

Clear-Host

# ─── COLOR SCHEME ─────────────────────────────────────────────
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
║           ⚡ AGGRESSIVE CHEATER CATCHER v11 ⚡              ║
║            CATCHES BLATANT CHEATS ON SIGHT 🔥              ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Magenta

Write-Host ""
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  ⚡  AGGRESSIVE DETECTION ENGINE  ⚡" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""
Write-Host "  [LOADING] Initializing aggressive cheat detection..." -ForegroundColor Yellow
Write-Host "  [LOADING] Loading cheat signatures (EXPANDED)..." -ForegroundColor Yellow
Write-Host "  [LOADING] Connecting to Modrinth API..." -ForegroundColor Yellow
Write-Host ""

# ─── LOADING BAR ──────────────────────────────────────────────
for ($i = 0; $i -le 100; $i += 5) {
    $bar = "["
    $filled = [math]::Floor($i / 5)
    $bar += ("█" * $filled).PadRight(20, "░")
    $bar += "]"
    Write-Host "`r  $bar $i% " -ForegroundColor Cyan -NoNewline
    Start-Sleep -Milliseconds 10
}
Write-Host "`r  [████████████████████] 100% " -ForegroundColor Green
Write-Host "  [SYSTEM] Aggressive detection ready." -ForegroundColor Green
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

# ─── MINECRAFT PROCESS ────────────────────────────────────────
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

# ─── MODRINTH API ─────────────────────────────────────────────
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

# ─── EXTRACTOR ─────────────────────────────────────────────────
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

# ─── AGGRESSIVE CHEAT DETECTION ──────────────────────────────

# EXPANDED CHEAT CLIENT NAMES - CATCHES EVERYTHING
$CheatClientNames = @(
    # Common cheats
    'wurst','meteor','impact','liquidbounce','aristois','future','lambda',
    'rusherhack','sigma','novoline','ghostclient','kamiblue','salhack','clickcrystals',
    'baritone','vengeance','exhibition','vape','entropy','kuro','rise','flux',
    'zero','raven','astolfo','dortware','xenon','tenacity','gamesense','skeet',
    'primordial','azura','recode','fdp','aero','exhi','trident','skid','skidded',
    
    # CRYSTAL CHEATS
    'autocrystal','crystalaura','anchoraura','bedaura','crystalfight','crystalia',
    'crystaloptimizer','anchoroptimizer','glaxcrystal','kindcrystal','marlowcrystal',
    
    # BLATANT CHEATS - SPECIFIC TO YOUR LIST
    'dqrkis','dqrkis-client','dqrkis-v6','darkis','darkis-client',
    'ketteh','kettehseventplugin','kettehs','eventplugin',
    'client-mod','cheat-client','hack-client','ghost-client',
    
    # Additional cheats
    'jello','kura','rise','flux','zero','raven','astolfo'
)

# EXPANDED CHEAT STRINGS
$CheatStrings = @(
    # Combat
    'KillAura','AimAssist','Reach','HitBox','Aura','BowAimbot','Velocity','AntiKnockback',
    'Criticals','AutoClicker','HitSelect','MultiAura','TriggerBot','AxeSpam','ShieldBreaker',
    'CombatHack','FightHack','PvPHack',
    
    # Movement
    'Flight','BHop','SpeedMine','NoFall','Phase','Blink','Freecam','NoSlow','Scaffold',
    'ElytraFly','JumpReset','LongJump','Strafe','Sprint','Fly','Glide','Step',
    'SpeedHack','FlyHack','NoFallHack','BunnyHop','MotionHack',
    
    # World
    'XRay','ESP','Nametags','Chams','Tracers','Radar','ChestStealer','Nuker',
    'AutoCrystal','AutoAnchor','AutoDoubleHand','AutoHitCrystal','AutoPot','AutoTotem',
    'AutoArmor','InventoryTotem','CrystalAura','AnchorMacro','HoleFiller','AutoBlockPlace',
    
    # Utility
    'PingSpoof','SelfDestruct','WebMacro','FastPlace','FastBreak','AutoGapple','AutoEat',
    'AutoFish','AutoPearl','AutoSoup','AutoSwitch','AutoTrap','AutoMine','AutoBed',
    'AutoFarm','AutoBreed','AutoShear','AutoHoe',
    
    # Client Specific
    'Meteor','Wurst','Impact','Aristois','LiquidBounce','Future','RusherHack',
    'Sigma','Novoline','GhostClient','KamiBlue','SalHack','ClickCrystals',
    'Baritone','Vengeance','ImmediatelyFast','Exhibition','Vape','Entropy',
    
    # Event System (KettehsEventPlugin)
    'EventHandler','Listener','Subscribe','EventBus','PostEvent','RegisterEvent',
    'PacketEvent','TickEvent','RenderEvent','KeyInputEvent','MouseEvent',
    
    # Blatant cheat indicators
    'Hack','Cheat','Client','Module','Toggle','KeyBind','ClickGUI','HUDEditor'
)

# LEGIT MODS - SAFE
$LegitMods = @{
    'fabric' = $true; 'forge' = $true; 'fabric-api' = $true
    'sodium' = $true; 'lithium' = $true; 'phosphor' = $true; 'iris' = $true
    'indium' = $true; 'continuity' = $true; 'cullleaves' = $true
    'entityculling' = $true; 'ferritecore' = $true; 'krypton' = $true
    'lazy-dfu' = $true; 'memoryleakfix' = $true; 'modernfix' = $true
    'spark' = $true; 'starlight' = $true; 'viafabric' = $true
    'modmenu' = $true; 'worldedit' = $true; 'jei' = $true; 'rei' = $true
    'emi' = $true; 'xaero' = $true; 'journeymap' = $true
    'polytone' = $true; 'sodium-extra' = $true; 'placeholder-api' = $true
    'walksylib' = $true; 'yetanotherconfiglib' = $true; 'collective' = $true
    'essential' = $true; 'borderlessfullscreen' = $true; 'autoreconnect' = $true
    'fullbrightnesstoggle' = $true; 'naturalmotionblur' = $true
    'shieldfixes' = $true; 'shieldstatus' = $true
    'ambience' = $true; 'crosshairaddons' = $true
    'anchoroptimizer' = $true; 'crystaloptimizer' = $true
    'crossbowoptimizer' = $true; 'consumableoptimizer' = $true
    'optimizer' = $true; 'glow' = $true
}

function Get-NameHit {
    param([string]$FileName)
    $lower = $FileName.ToLower()
    
    # First check if it's a legit mod
    foreach ($legit in $LegitMods.Keys) {
        if ($lower -match [regex]::Escape($legit)) { 
            return $null
        }
    }
    
    # Check for blatant cheats
    foreach ($cheat in $CheatClientNames) {
        if ($lower -match [regex]::Escape($cheat)) { 
            return $cheat
        }
    }
    
    # Check for suspicious keywords
    $suspicious = @('client', 'hack', 'cheat', 'module', 'v6', 'v7', 'v8', 'beta', 'alpha')
    foreach ($word in $suspicious) {
        if ($lower -match [regex]::Escape($word)) {
            # Only flag if it's not a known legit mod
            return "SUSPICIOUS: $word"
        }
    }
    
    return $null
}

function Get-CheatHits {
    param([string]$ExtractedDir)
    $hits = @()
    $files = Get-ChildItem -Path $ExtractedDir -Recurse -File -Include *.class,*.json -ErrorAction SilentlyContinue
    foreach ($f in $files) {
        try {
            $bytes = [System.IO.File]::ReadAllBytes($f.FullName)
            if ($bytes.Length -gt 1048576) { $bytes = $bytes[0..1048575] }
            $text = [System.Text.Encoding]::ASCII.GetString($bytes)
        } catch { continue }
        foreach ($sig in $CheatStrings) {
            if ($text -match [regex]::Escape($sig)) { 
                $hits += $sig 
            }
        }
        if ($hits.Count -gt 20) { break }
    }
    return $hits | Select-Object -Unique
}

# ─── SCAN ──────────────────────────────────────────────────────
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  🔍  AGGRESSIVE SCANNING" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""

$verifiedMods = @()
$unknownMods = @()
$cheatMods = @()

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

        # 1. AGGRESSIVE NAME CHECK
        $nameHit = Get-NameHit -FileName $file.Name
        if ($nameHit) {
            $cheatMods += [pscustomobject]@{ 
                FileName = $file.Name
                Reason = "BLATANT CHEAT: $nameHit"
                Type = "CLIENT"
            }
            continue
        }

        # 2. HASH CHECK
        $sha1 = Get-JarHash -Path $file.FullName -Algo SHA1
        $known = Fetch-Modrinth -Sha1 $sha1
        if ($known.Slug) {
            $verifiedMods += [pscustomobject]@{ 
                ModName = $known.Name
                FileName = $file.Name
            }
            continue
        }

        # 3. DEEP SCAN
        $extractDir = Join-Path $tempRoot ([System.IO.Path]::GetFileNameWithoutExtension($file.Name))
        New-Item -ItemType Directory -Path $extractDir -Force | Out-Null
        
        Expand-JarLimited -JarPath $file.FullName -DestDir $extractDir

        $hits = Get-CheatHits -ExtractedDir $extractDir
        if ($hits.Count -gt 1) {
            $cheatMods += [pscustomobject]@{ 
                FileName = $file.Name
                Reason = "CHEAT FEATURES: $($hits[0..4] -join ', ')"
                Type = "FEATURE"
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
Write-Host "  📊  AGGRESSIVE SCAN RESULTS" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""

# ─── SUMMARY ──────────────────────────────────────────────────
Write-Host "  ┌─────────────────────────────────────────────────────────────────────┐" -ForegroundColor DarkMagenta
Write-Host "  │  ✅ VERIFIED  │  ❓ UNKNOWN  │  🚨 CHEATS CAUGHT  │  📦 TOTAL  │   " -ForegroundColor White
Write-Host "  │  $($verifiedMods.Count.ToString().PadLeft(4))           │  $($unknownMods.Count.ToString().PadLeft(4))          │  $($cheatMods.Count.ToString().PadLeft(4))           │  $($total.ToString().PadLeft(4))        │   " -ForegroundColor White
Write-Host "  └─────────────────────────────────────────────────────────────────────┘" -ForegroundColor DarkMagenta
Write-Host ""

# ─── CHEATS CAUGHT (MOST IMPORTANT) ──────────────────────────
if ($cheatMods.Count -gt 0) {
    Write-Host "  🚨 CHEATS CAUGHT!" -ForegroundColor Red
    Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkRed
    foreach ($mod in $cheatMods) {
        if ($mod.Type -eq "CLIENT") {
            Write-Host "  ⚡ $($mod.FileName)" -ForegroundColor Red -NoNewline
            Write-Host "  — $($mod.Reason) [BLATANT CHEAT]" -ForegroundColor DarkRed
        } else {
            Write-Host "  ⚡ $($mod.FileName)" -ForegroundColor Red -NoNewline
            Write-Host "  — $($mod.Reason)" -ForegroundColor DarkMagenta
        }
        Write-Host "  ─────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    }
    Write-Host ""
}

# ─── VERIFIED ──────────────────────────────────────────────────
if ($verifiedMods.Count -gt 0) {
    Write-Host "  ✅ VERIFIED MODS (SAFE)" -ForegroundColor Green
    Write-Host "  ─────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    foreach ($mod in $verifiedMods) {
        Write-Host "  ▸ $($mod.ModName)" -ForegroundColor Green -NoNewline
        Write-Host "  [$($mod.FileName)]" -ForegroundColor DarkGray
    }
    Write-Host ""
}

# ─── UNKNOWN ──────────────────────────────────────────────────
if ($unknownMods.Count -gt 0) {
    Write-Host "  ❓ UNKNOWN MODS" -ForegroundColor Yellow
    Write-Host "  ─────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    foreach ($mod in $unknownMods) {
        if ($mod.ZoneId) {
            Write-Host "  ▸ $($mod.FileName)" -ForegroundColor Yellow -NoNewline
            Write-Host "  [downloaded from: $($mod.ZoneId)]" -ForegroundColor DarkGray
        } else {
            Write-Host "  ▸ $($mod.FileName)" -ForegroundColor Yellow
        }
    }
    Write-Host ""
}

# ─── SECURITY ASSESSMENT ──────────────────────────────────────
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  🛡️  SECURITY ASSESSMENT" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""

if ($cheatMods.Count -gt 0) {
    Write-Host "  ⚠️  STATUS: CHEATS DETECTED!" -ForegroundColor Red
    Write-Host "  ─────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    Write-Host "  ▸ ${cheatMods.Count} cheats found!" -ForegroundColor Red
    Write-Host "  ▸ These are confirmed cheat clients/features" -ForegroundColor Red
    Write-Host "  ▸ ACTION REQUIRED: REMOVE IMMEDIATELY" -ForegroundColor DarkRed
} elseif ($unknownMods.Count -gt 3) {
    Write-Host "  ⚠️  STATUS: CAUTION" -ForegroundColor Yellow
    Write-Host "  ─────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    Write-Host "  ▸ $($unknownMods.Count) unknown mods found" -ForegroundColor Yellow
    Write-Host "  ▸ Manual inspection recommended" -ForegroundColor Yellow
} else {
    Write-Host "  ✅ STATUS: CLEAN" -ForegroundColor Green
    Write-Host "  ─────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    Write-Host "  ▸ No cheats detected" -ForegroundColor Green
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
Write-Host "  Cheats Caught   : $($cheatMods.Count)" -ForegroundColor Red
Write-Host "  Scan Completed  : $((Get-Date).ToString('HH:mm:ss'))" -ForegroundColor White
Write-Host ""

# ─── FOOTER ────────────────────────────────────────────────────
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  ⚡  AGGRESSIVE SCAN COMPLETE  ⚡" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""
Write-Host "  Caught blatant cheats by name AND strings! 🔥" -ForegroundColor Magenta
Write-Host ""
Write-Host "  [SYSTEM] Ketteh's Aggressive Cheater Catcher v11 — Done." -ForegroundColor Green
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
Write-Host "  🔥  Catching ALL cheaters - no mercy!" -ForegroundColor Magenta
Write-Host ""
