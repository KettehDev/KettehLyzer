# ============================================================
#  ██████╗ ███████╗████████╗████████╗███████╗██╗  ██╗██╗  ██╗
#  ██╔══██╗██╔════╝╚══██╔══╝╚══██╔══╝██╔════╝██║  ██║██║  ╚██╗
#  ██████╔╝█████╗     ██║      ██║   █████╗  ███████║██║   ╚██╗
#  ██╔══██╗██╔══╝     ██║      ██║   ██╔══╝  ██╔══██║██║    ██║
#  ██████╔╝███████╗   ██║      ██║   ███████╗██║  ██║███████╗██║
#  ╚═════╝ ╚══════╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝
#              CHEATER CATCHER v9  ::  ENHANCED EDITION
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
$DarkGreen = "DarkGreen"
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
║           ⚡ ULTIMATE CHEATER CATCHER v9 ⚡                 ║
║              CRYSTAL & ANCHOR DETECTION ACTIVE               ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Magenta

Write-Host ""
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  ⚡  ENHANCED CHEATER DETECTION ENGINE  ⚡" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""
Write-Host "  [LOADING] Initializing cheat detection..." -ForegroundColor Yellow
Write-Host "  [LOADING] Loading enhanced signature database..." -ForegroundColor Yellow
Write-Host "  [LOADING] Connecting to Modrinth API..." -ForegroundColor Yellow
Write-Host ""

# ─── LOADING BAR ──────────────────────────────────────────────
for ($i = 0; $i -le 100; $i += 5) {
    $bar = "["
    $filled = [math]::Floor($i / 5)
    $bar += ("█" * $filled).PadRight(20, "░")
    $bar += "]"
    Write-Host "`r  $bar $i% " -ForegroundColor Cyan -NoNewline
    Start-Sleep -Milliseconds 15
}
Write-Host "`r  [████████████████████] 100% " -ForegroundColor Green
Write-Host "  [SYSTEM] Enhanced cheat detection ready." -ForegroundColor Green
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

# ─── ENHANCED CHEAT DETECTION ────────────────────────────────

# CRYSTAL PVP CHEAT CLIENTS (SPECIFIC TO YOUR MOD LIST)
$CrystalCheatClients = @(
    'crystal', 'anchor', 'optimizer', 'glax', 'kindas', 'marlow', 'autocrystal',
    'crystalaura', 'crystalpvp', 'crystaltweaks', 'anchoraura', 'bedaura',
    'glaxcrystal', 'kindcrystal', 'marlowcrystal'
)

# MAIN CHEAT CLIENTS
$CheatClientNames = @(
    'wurst','meteor','impact','liquidbounce','aristois','future','lambdaclient',
    'rusherhack','sigmaclient','novoline','ghostclient','kamiblue','salhack','clickcrystals',
    'baritone','vengeance','immediatelyfast','sigma','jello','exhibition','vape','entropy',
    'kuro','rise','flux','zero','raven','astolfo','exhibition','dortware','xenon',
    'tenacity','gamesense','skeet','primordial','azura','recode','fdp','fdpclient',
    'aero','exhi','trident','skid','skidded','crystalia','crystalfight'
)

# CHEAT FEATURES (EXPANDED)
$CheatStrings = @(
    # CRYSTAL PVP SPECIFIC
    'AutoCrystal','CrystalAura','AnchorAura','BedAura','CrystalOptimizer','AnchorOptimizer',
    'CrystalPlace','CrystalBreak','AnchorPlace','AnchorBreak','GlaxCrystal','KindCrystal',
    'MarlowCrystal','CrystalMod','CrystalHelper','AutoAnchor','AutoCrystalAura',
    
    # COMBAT
    'AimAssist','KillAura','Reach','HitBox','Aura','BowAimbot','Velocity','AntiKnockback',
    'Criticals','AutoClicker','HitSelect','MultiAura','TriggerBot','AxeSpam','ShieldBreaker',
    'Combat','Fight','PvP','Crystal','TotemPop','HitBox','Aura',
    
    # MOVEMENT
    'Flight','BHop','SpeedMine','NoFall','Phase','Blink','Freecam','NoSlow','Scaffold',
    'ElytraFly','JumpReset','LongJump','Strafe','Sprint','Fly','Glide','Step',
    'Speed','FlyHack','NoFallHack','BunnyHop',
    
    # WORLD
    'XRay','ESP','Nametags','Chams','Tracers','Radar','ChestStealer','Nuker',
    'AutoCrystal','AutoAnchor','AutoDoubleHand','AutoHitCrystal','AutoPot','AutoTotem',
    'AutoArmor','InventoryTotem','CrystalAura','AnchorMacro','HoleFiller','AutoBlockPlace',
    
    # UTILITY
    'PingSpoof','SelfDestruct','WebMacro','FastPlace','FastBreak','AutoGapple','AutoEat',
    'AutoFish','AutoPearl','AutoSoup','AutoSwitch','AutoTrap','AutoMine','AutoBed',
    
    # CLIENT SPECIFIC
    'Meteor','Wurst','Impact','Aristois','LiquidBounce','Future','RusherHack',
    'Sigma','Novoline','GhostClient','KamiBlue','SalHack','ClickCrystals',
    'Baritone','Vengeance','ImmediatelyFast','Exhibition','Vape','Entropy'
)

# LEGIT MODS WHITELIST (UPDATED)
$LegitMods = @{
    'fabric' = $true; 'forge' = $true; 'optifine' = $true; 'sodium' = $true
    'lithium' = $true; 'phosphor' = $true; 'iris' = $true; 'indium' = $true
    'continuity' = $true; 'cullleaves' = $true; 'entityculling' = $true
    'ferritecore' = $true; 'krypton' = $true; 'lazy-dfu' = $true
    'memoryleakfix' = $true; 'modernfix' = $true; 'spark' = $true
    'starlight' = $true; 'viafabric' = $true; 'fabric-api' = $true
    'modmenu' = $true; 'worldedit' = $true; 'jei' = $true; 'rei' = $true
    'emi' = $true; 'xaero' = $true; 'journeymap' = $true
    'polytone' = $true; 'sodium-extra' = $true; 'placeholder-api' = $true
    'walksylib' = $true; 'yetanotherconfiglib' = $true; 'collective' = $true
    'essential' = $true; 'borderlessfullscreen' = $true; 'autoreconnect' = $true
    'fullbrightnesstoggle' = $true; 'naturalmotionblur' = $true
    'shieldfixes' = $true; 'shieldstatus' = $true
}

function Get-NameHit {
    param([string]$FileName)
    $lower = $FileName.ToLower()
    
    # First check legit mods
    foreach ($legit in $LegitMods.Keys) {
        if ($lower -match [regex]::Escape($legit)) { return $null }
    }
    
    # Check crystal cheat clients
    foreach ($cheat in $CrystalCheatClients) {
        if ($lower -match [regex]::Escape($cheat)) { 
            return "CRYSTAL PVP: $cheat" 
        }
    }
    
    # Check main cheat clients
    return ($CheatClientNames | Where-Object { $lower -match [regex]::Escape($_) } | Select-Object -First 1)
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
            if ($text -match [regex]::Escape($sig)) { $hits += $sig }
        }
        if ($hits.Count -gt 15) { break }
    }
    return $hits | Select-Object -Unique
}

# ─── SCAN ──────────────────────────────────────────────────────
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  🔍  SCANNING FOR CHEATERS" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""

$verifiedMods = @()
$unknownMods = @()
$cheatMods = @()
$crystalCheats = @()

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

        # 1. NAME CHECK - ENHANCED
        $nameHit = Get-NameHit -FileName $file.Name
        if ($nameHit) {
            $isCrystal = ($nameHit -match "CRYSTAL PVP")
            $cheatMods += [pscustomobject]@{ 
                FileName = $file.Name
                Reason = "NAME MATCH: $nameHit"
                Type = if ($isCrystal) { "CRYSTAL PVP" } else { "CHEAT CLIENT" }
            }
            if ($isCrystal) { $crystalCheats += $file.Name }
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
        if ($hits.Count -gt 0) {
            $isCrystal = ($hits | Where-Object { $_ -match 'Crystal|Anchor' })
            $cheatMods += [pscustomobject]@{ 
                FileName = $file.Name
                Reason = "STRING MATCH: $($hits[0..5] -join ', ')"
                Type = if ($isCrystal) { "CRYSTAL PVP" } else { "CHEAT" }
            }
            if ($isCrystal) { $crystalCheats += $file.Name }
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
Write-Host "  📊  RESULTS" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""

# ─── SUMMARY ──────────────────────────────────────────────────
Write-Host "  ┌─────────────────────────────────────────────────────────────────────┐" -ForegroundColor DarkMagenta
Write-Host "  │  ✅ VERIFIED  │  ❓ UNKNOWN  │  🚨 CHEATERS  │  💎 CRYSTAL  │      " -ForegroundColor White
Write-Host "  │  $($verifiedMods.Count.ToString().PadLeft(4))           │  $($unknownMods.Count.ToString().PadLeft(4))          │  $($cheatMods.Count.ToString().PadLeft(4))           │  $($crystalCheats.Count.ToString().PadLeft(4))        │      " -ForegroundColor White
Write-Host "  └─────────────────────────────────────────────────────────────────────┘" -ForegroundColor DarkMagenta
Write-Host ""

# ─── CRYSTAL PVP CHEATS (SPECIAL SECTION) ────────────────────
if ($crystalCheats.Count -gt 0) {
    Write-Host "  💎 CRYSTAL PVP CHEATS DETECTED!" -ForegroundColor DarkRed
    Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
    foreach ($cheat in $crystalCheats) {
        Write-Host "  ▸ $cheat" -ForegroundColor DarkRed
    }
    Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
    Write-Host ""
}

# ─── VERIFIED ──────────────────────────────────────────────────
if ($verifiedMods.Count -gt 0) {
    Write-Host "  ✅ VERIFIED MODS" -ForegroundColor Green
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

# ─── CHEATERS ──────────────────────────────────────────────────
if ($cheatMods.Count -gt 0) {
    Write-Host "  🚨 CHEATERS DETECTED!" -ForegroundColor Red
    Write-Host "  ─────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    foreach ($mod in $cheatMods) {
        if ($mod.Type -eq "CRYSTAL PVP") {
            Write-Host "  💎 $($mod.FileName)" -ForegroundColor DarkRed -NoNewline
            Write-Host "  — $($mod.Reason) [CRYSTAL PVP]" -ForegroundColor Red
        } else {
            Write-Host "  ⚡ $($mod.FileName)" -ForegroundColor Red -NoNewline
            Write-Host "  — $($mod.Reason)" -ForegroundColor DarkMagenta
        }
        Write-Host "  ─────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    }
    Write-Host ""
}

# ─── SECURITY ASSESSMENT ──────────────────────────────────────
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  🛡️  SECURITY ASSESSMENT" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""

if ($crystalCheats.Count -gt 0) {
    Write-Host "  💎 STATUS: CRYSTAL PVP CHEATS DETECTED" -ForegroundColor DarkRed
    Write-Host "  ─────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    Write-Host "  ▸ $($crystalCheats.Count) crystal/anchor optimization mods found" -ForegroundColor Red
    Write-Host "  ▸ These are used for crystal PVP cheating" -ForegroundColor Red
    Write-Host "  ▸ Recommended action: REMOVE IMMEDIATELY" -ForegroundColor DarkRed
} elseif ($cheatMods.Count -gt 0) {
    Write-Host "  ⚠️  STATUS: COMPROMISED" -ForegroundColor Red
    Write-Host "  ─────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    Write-Host "  ▸ ${cheatMods.Count} cheat clients/mods detected" -ForegroundColor Red
    Write-Host "  ▸ Remove them immediately to ensure fair play" -ForegroundColor Red
} elseif ($unknownMods.Count -gt 3) {
    Write-Host "  ⚠️  STATUS: CAUTION" -ForegroundColor Yellow
    Write-Host "  ─────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    Write-Host "  ▸ $($unknownMods.Count) unknown mods found" -ForegroundColor Yellow
    Write-Host "  ▸ Manual inspection recommended" -ForegroundColor Yellow
} else {
    Write-Host "  ✅ STATUS: CLEAN" -ForegroundColor Green
    Write-Host "  ─────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    Write-Host "  ▸ No suspicious mods detected" -ForegroundColor Green
    Write-Host "  ▸ You're good to go!" -ForegroundColor Green
}

Write-Host ""

# ─── STATS ─────────────────────────────────────────────────────
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  📊  SCAN STATISTICS" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""
Write-Host "  Total Scanned   : $total" -ForegroundColor White
Write-Host "  Verified        : $($verifiedMods.Count)" -ForegroundColor Green
Write-Host "  Unknown         : $($unknownMods.Count)" -ForegroundColor Yellow
Write-Host "  Cheaters Found  : $($cheatMods.Count)" -ForegroundColor Red
Write-Host "  Crystal PVP     : $($crystalCheats.Count)" -ForegroundColor DarkRed
Write-Host "  Scan Completed  : $((Get-Date).ToString('HH:mm:ss'))" -ForegroundColor White
Write-Host ""

# ─── FOOTER ────────────────────────────────────────────────────
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  ⚡  SCAN COMPLETE  ⚡" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""
Write-Host "  Crystal PVP cheats detected? Time to clean house! 🔥" -ForegroundColor Magenta
Write-Host ""
Write-Host "  [SYSTEM] Ketteh's Cheater Catcher v9 — Done." -ForegroundColor Green
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
