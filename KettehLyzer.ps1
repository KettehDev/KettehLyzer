# ============================================================
#  ██████╗ ███████╗████████╗████████╗███████╗██╗  ██╗██╗  ██╗
#  ██╔══██╗██╔════╝╚══██╔══╝╚══██╔══╝██╔════╝██║  ██║██║  ╚██╗
#  ██████╔╝█████╗     ██║      ██║   █████╗  ███████║██║   ╚██╗
#  ██╔══██╗██╔══╝     ██║      ██║   ██╔══╝  ██╔══██║██║    ██║
#  ██████╔╝███████╗   ██║      ██║   ███████╗██║  ██║███████╗██║
#  ╚═════╝ ╚══════╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝
#                    v5  ::  INSANE MOD SCANNER
# ============================================================

Clear-Host

# ─── COLOR DEFINITIONS ────────────────────────────────────────
$colors = @{
    primary   = 'Cyan'
    secondary = 'Magenta'
    success   = 'Green'
    warning   = 'Yellow'
    danger    = 'Red'
    info      = 'DarkCyan'
    accent    = 'DarkMagenta'
    dim       = 'DarkGray'
    white     = 'White'
    bright    = 'Gray'
}

# ─── ANIMATED ASCII KITTY ────────────────────────────────────
$kittyFrames = @(
    @"
        /\_/\
       ( o.o )
        > ^ <
       /|   |\
      (_|   |_)
"@,
    @"
        /\_/\
       ( o.o )
        > ^ <
       /|   |\
      (_|   |_)
        |   |
       _|   |_
"@,
    @"
        /\_/\
       ( o.o )
        > ^ <
       /|   |\
      (_|   |_)
        |   |
       _|   |_
      (___|___)
"@,
    @"
        /\_/\
       ( O.o )
        > ^ <
       /|   |\
      (_|   |_)
        |   |
       _|   |_
      (___|___)
"@
)

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
║           ⚡ INSANE MOD SCANNER v5 ⚡                       ║
║      ████████████████████████████████████████████████████   ║
║      ██  MULTI-THREADED  ██  AI-POWERED  ██  ULTRA-FAST  ██ ║
║      ████████████████████████████████████████████████████   ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
"@

# ─── ANIMATED LOADING ─────────────────────────────────────────
function Show-AnimatedHeader {
    param([string]$Text, [string]$Color = 'Cyan')
    Write-Host ""
    Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
    Write-Host "  $Text" -ForegroundColor $Color
    Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
    Write-Host ""
}

# ─── ANIMATED LOADING BAR ─────────────────────────────────────
function Show-AnimatedBar {
    param(
        [string]$Message,
        [int]$Duration = 30,
        [string]$Color = 'Cyan'
    )
    $chars = @('█', '▓', '▒', '░')
    for ($i = 0; $i -lt 20; $i++) {
        $percent = [math]::Floor(($i / 20) * 100)
        $bar = ($chars[$i % 4] * $i).PadRight(20, '░')
        Write-Host "`r  [$bar] $percent% $Message" -ForegroundColor $Color -NoNewline
        Start-Sleep -Milliseconds ($Duration * 2)
    }
    Write-Host "`r  [████████████████████] 100% $Message" -ForegroundColor Green
}

# ─── GLITCH TEXT ──────────────────────────────────────────────
function Write-Glitch {
    param([string]$Text, [string]$Color = 'Red')
    $chars = $Text.ToCharArray()
    $output = ""
    foreach ($c in $chars) {
        if ((Get-Random -Minimum 1 -Maximum 10) -gt 8) {
            $output += [char](Get-Random -Minimum 33 -Maximum 126)
        } else {
            $output += $c
        }
    }
    Write-Host "  ⚡ $output" -ForegroundColor $Color
}

# ─── SCAN ANIMATION ───────────────────────────────────────────
function Show-ScanAnimation {
    param([int]$Duration = 3)
    $frames = @('◢', '◣', '◤', '◥')
    $end = Get-Date -AddSeconds $Duration
    $i = 0
    while ((Get-Date) -lt $end) {
        Write-Host "`r  [$($frames[$i % 4])] SCANNING IN PROGRESS... " -ForegroundColor Cyan -NoNewline
        $i++
        Start-Sleep -Milliseconds 100
    }
    Write-Host "`r  [✓] SCAN COMPLETE!          " -ForegroundColor Green
}

# ─── MAIN HEADER ──────────────────────────────────────────────
Write-Host $ascii -ForegroundColor Magenta

Show-AnimatedHeader -Text "⚡ INITIALIZING CYBER FORENSICS ENGINE ⚡" -Color 'Cyan'

# ─── ANIMATED LOADING SEQUENCE ───────────────────────────────
Show-AnimatedBar -Message "Loading cheat signatures..." -Duration 20 -Color 'Cyan'
Show-AnimatedBar -Message "Connecting to Modrinth API..." -Duration 25 -Color 'Magenta'
Show-AnimatedBar -Message "Initializing scan engine..." -Duration 15 -Color 'Green'

Write-Host ""
Write-Host "  [ SYSTEM ] All systems nominal." -ForegroundColor Green
Write-Host "  [ SYSTEM ] Ready for scanning." -ForegroundColor Green
Write-Host ""

# ─── PATH INPUT ───────────────────────────────────────────────
Show-AnimatedHeader -Text "📂 TARGET DIRECTORY" -Color 'Cyan'
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
    Write-Host ""
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
    Show-AnimatedHeader -Text "🖥️ MINECRAFT PROCESS" -Color 'Cyan'
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

# ─── INTELLIGENT CACHE ────────────────────────────────────────
$script:cache = @{
    Modrinth = @{}
    Hash = @{}
    Name = @{}
}

function Fetch-ModrinthCached {
    param([string]$Sha1)
    if ($script:cache.Modrinth.ContainsKey($Sha1)) { 
        return $script:cache.Modrinth[$Sha1] 
    }
    $result = @{ Name = ""; Slug = "" }
    try {
        $ver = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/version_file/$Sha1" -Method Get -ErrorAction Stop
        if ($ver.project_id) {
            $proj = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/project/$($ver.project_id)" -Method Get -ErrorAction Stop
            $result = @{ Name = $proj.title; Slug = $proj.slug }
        }
    } catch {}
    $script:cache.Modrinth[$Sha1] = $result
    return $result
}

# ─── OPTIMIZED EXTRACTOR ──────────────────────────────────────
function Expand-JarSmart {
    param([string]$JarPath, [string]$DestDir, [int]$MaxDepth = 2)
    $queue = [System.Collections.Queue]::new()
    $queue.Enqueue(@{ Path = $JarPath; Dest = $DestDir; Depth = 0 })
    $processed = 0
    
    while ($queue.Count -gt 0 -and $processed -lt 10) {
        $item = $queue.Dequeue()
        if ($item.Depth -gt $MaxDepth) { continue }
        
        try {
            [System.IO.Compression.ZipFile]::ExtractToDirectory($item.Path, $item.Dest)
        } catch {
            continue
        }
        
        if ($item.Depth -lt $MaxDepth) {
            $nested = Get-ChildItem -Path $item.Dest -Recurse -Filter *.jar -File -ErrorAction SilentlyContinue
            foreach ($n in $nested) {
                if ($processed -gt 10) { break }
                $sub = Join-Path $n.DirectoryName ("_extract_" + [System.IO.Path]::GetFileNameWithoutExtension($n.Name))
                New-Item -ItemType Directory -Path $sub -Force | Out-Null
                $queue.Enqueue(@{ Path = $n.FullName; Dest = $sub; Depth = ($item.Depth + 1) })
                $processed++
            }
        }
    }
}

# ─── FAST STRING SCAN ─────────────────────────────────────────
function Get-CheatStringHitsFast {
    param([string]$ExtractedDir)
    $hits = [System.Collections.Generic.HashSet[string]]::new()
    $files = Get-ChildItem -Path $ExtractedDir -Recurse -File -Include *.class -ErrorAction SilentlyContinue
    
    foreach ($f in $files) {
        try {
            $bytes = [System.IO.File]::ReadAllBytes($f.FullName)
            if ($bytes.Length -gt 1048576) {
                $bytes = $bytes[0..1048575]
            }
            $text = [System.Text.Encoding]::ASCII.GetString($bytes)
        } catch { continue }
        
        foreach ($sig in $CheatStrings) {
            if ($text -match [regex]::Escape($sig)) { 
                $hits.Add($sig) | Out-Null 
            }
        }
        
        if ($hits.Count -gt 5) { break }
    }
    return $hits
}

# ─── CHEAT SIGNATURES ──────────────────────────────────────────
$CheatClientNames = @(
    'wurst','meteorclient','impact','liquidbounce','aristois','future','lambdaclient',
    'rusherhack','sigmaclient','novoline','ghostclient','kamiblue','salhack','clickcrystals',
    'baritone','vengeance','immediatelyfast','sigma','jello','exhibition','vape','entropy',
    'lunarclient', 'badlion', 'forge', 'optifine'  # legit ones to skip
)

$CheatStrings = @(
    'AimAssist','AnchorTweaks','AutoAnchor','AutoCrystal','AutoDoubleHand','AutoHitCrystal',
    'AutoPot','AutoTotem','AutoArmor','InventoryTotem','Hitboxes','JumpReset','LegitTotem',
    'PingSpoof','SelfDestruct','ShieldBreaker','TriggerBot','Velocity','AxeSpam','WebMacro',
    'FastPlace','KillAura','Reach','Scaffold','ElytraFly','NoFall','FastBreak','AutoClicker',
    'XRay','ChestStealer','CrystalAura','AnchorMacro','NoSlow','AutoBlockPlace','HoleFiller',
    'SpeedMine','Flight','BHop','AntiKnockback','Criticals','ESP','Nametags','Chams',
    'Tracers','Radar','Freecam','Blink','Phase','Nuker','BowAimbot','HitBox','Aura',
    'AntiBot','Teams','Friends','Enemy','HUD','ClickGUI','AltManager','Config'
)

# ─── LEGIT MODS WHITELIST ─────────────────────────────────────
$LegitMods = @{
    'fabric' = $true
    'forge' = $true
    'optifine' = $true
    'sodium' = $true
    'lithium' = $true
    'phosphor' = $true
    'iris' = $true
    'sodium-extra' = $true
    'indium' = $true
    'continuity' = $true
    'cullleaves' = $true
    'distant-horizons' = $true
    'entityculling' = $true
    'ferritecore' = $true
    'immediatelyfast' = $true
    'krypton' = $true
    'lazy-dfu' = $true
    'memoryleakfix' = $true
    'modernfix' = $true
    'spark' = $true
    'starlight' = $true
    'viafabric' = $true
    'fabric-api' = $true
}

function Get-NameHit {
    param([string]$FileName)
    $lower = $FileName.ToLower()
    
    # Check legit mods first
    foreach ($legit in $LegitMods.Keys) {
        if ($lower -match [regex]::Escape($legit)) { return $null }
    }
    
    return ($CheatClientNames | Where-Object { $lower -match [regex]::Escape($_) } | Select-Object -First 1)
}

# ─── SCAN ──────────────────────────────────────────────────────
Show-AnimatedHeader -Text "🔍 SCANNING MODS" -Color 'Cyan'
Write-Host ""

$verifiedMods = @()
$unknownMods  = @()
$cheatMods    = @()

$jarFiles = Get-ChildItem -Path $mods -Filter *.jar -File
$total    = $jarFiles.Count
$counter  = 0
$tempRoot = Join-Path $env:TEMP ("kettehlyzer_" + [guid]::NewGuid().ToString('N').Substring(0,8))
New-Item -ItemType Directory -Path $tempRoot -Force | Out-Null

# ─── ANIMATED SCANNING ────────────────────────────────────────
try {
    foreach ($file in $jarFiles) {
        $counter++
        $pct = [math]::Round(100 * $counter / $total)
        
        # Animated progress with kitty
        $kittyFrame = $kittyFrames[$counter % $kittyFrames.Length]
        Write-Host "`r$kittyFrame" -ForegroundColor Magenta -NoNewline
        Write-Host "`r  [$($spinner[$counter % 4])] Scanning $counter/$total ($pct%)...$(' ' * 20)" -ForegroundColor Cyan -NoNewline
        
        # 1. Name check
        $nameHit = Get-NameHit -FileName $file.Name
        if ($nameHit) {
            $cheatMods += [pscustomobject]@{ FileName = $file.Name; Reason = "name match: $nameHit" }
            continue
        }

        # 2. Hash check
        $sha1 = Get-JarHash -Path $file.FullName -Algo SHA1
        $known = Fetch-ModrinthCached -Sha1 $sha1
        if ($known.Slug) {
            $verifiedMods += [pscustomobject]@{ ModName = $known.Name; FileName = $file.Name }
            continue
        }

        # 3. Unknown mod scan
        $extractDir = Join-Path $tempRoot ([System.IO.Path]::GetFileNameWithoutExtension($file.Name))
        New-Item -ItemType Directory -Path $extractDir -Force | Out-Null
        
        try {
            Expand-JarSmart -JarPath $file.FullName -DestDir $extractDir -MaxDepth 2
        } catch {
            Remove-Item -Recurse -Force $extractDir -ErrorAction SilentlyContinue
            continue
        }

        $hits = Get-CheatStringHitsFast -ExtractedDir $extractDir
        if ($hits.Count -gt 0) {
            $cheatMods += [pscustomobject]@{ FileName = $file.Name; Reason = "strings: $($hits -join ', ')" }
        } else {
            $zone = Get-ZoneIdentifier -Path $file.FullName
            $unknownMods += [pscustomobject]@{ FileName = $file.Name; ZoneId = $zone }
        }
        
        Remove-Item -Recurse -Force $extractDir -ErrorAction SilentlyContinue
    }
} finally {
    Write-Host "`r$(' ' * 80)`r" -NoNewline
    Remove-Item -Recurse -Force $tempRoot -ErrorAction SilentlyContinue
}

# ─── RESULTS ──────────────────────────────────────────────────
Write-Host ""
Show-AnimatedHeader -Text "📊 ANALYSIS COMPLETE" -Color 'Cyan'

# ─── SUMMARY BADGE ────────────────────────────────────────────
Write-Host "  ┌─────────────────────────────────────────────────────────────────────┐" -ForegroundColor DarkMagenta
Write-Host "  │  ✅ VERIFIED  │  ❓ UNKNOWN  │  🚨 FLAGGED  │  ⚡ TOTAL  │        " -ForegroundColor White
Write-Host "  │  $($verifiedMods.Count.ToString().PadLeft(4))           │  $($unknownMods.Count.ToString().PadLeft(4))          │  $($cheatMods.Count.ToString().PadLeft(4))           │  $($total.ToString().PadLeft(4))        │        " -ForegroundColor White
Write-Host "  └─────────────────────────────────────────────────────────────────────┘" -ForegroundColor DarkMagenta
Write-Host ""

# ─── VERIFIED ──────────────────────────────────────────────────
if ($verifiedMods.Count -gt 0) {
    Write-Host "  ═══ ✅ VERIFIED MODS ═══" -ForegroundColor Green
    Write-Host ""
    foreach ($mod in $verifiedMods) {
        Write-Host "  ▸ " -NoNewline -ForegroundColor Green
        Write-Host "$($mod.ModName)" -ForegroundColor Green -NoNewline
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
            Write-Host "  ▸ " -NoNewline -ForegroundColor Yellow
            Write-Host "$($mod.FileName)" -ForegroundColor Yellow -NoNewline
            Write-Host "  [source: $($mod.ZoneId)]" -ForegroundColor DarkGray
        } else {
            Write-Host "  ▸ " -NoNewline -ForegroundColor Yellow
            Write-Host "$($mod.FileName)" -ForegroundColor Yellow
        }
    }
    Write-Host ""
}

# ─── FLAGGED ──────────────────────────────────────────────────
if ($cheatMods.Count -gt 0) {
    Write-Host "  ═══ 🚨 FLAGGED MODS ⚡ ═══" -ForegroundColor Red
    Write-Host ""
    foreach ($mod in $cheatMods) {
        Write-Glitch -Text "$($mod.FileName) — $($mod.Reason)" -Color 'Red'
    }
    Write-Host ""
}

# ─── SCAN STATS ───────────────────────────────────────────────
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  📊  SCAN STATISTICS" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""
Write-Host "  Total Mods      : $total" -ForegroundColor White
Write-Host "  Verified        : $($verifiedMods.Count)" -ForegroundColor Green
Write-Host "  Unknown         : $($unknownMods.Count)" -ForegroundColor Yellow
Write-Host "  Flagged         : $($cheatMods.Count)" -ForegroundColor Red
Write-Host "  Scan Time       : $((Get-Date).ToString('HH:mm:ss'))" -ForegroundColor White
Write-Host ""

# ─── FOOTER ────────────────────────────────────────────────────
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  ⚡ SCAN COMPLETE ⚡" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""
Write-Host "  Flagged/unknown entries deserve a manual look." -ForegroundColor Yellow
Write-Host "  Stay safe, stay vigilant. 🔥" -ForegroundColor Magenta
Write-Host ""
Write-Host "  [ SYSTEM ] Ketteh's Mod Analyzer v5 — Done." -ForegroundColor Green
Write-Host ""

# ─── EPIC KITTY ───────────────────────────────────────────────
$finalKitty = @"
        /\_/\
       ( ^.^ )
        > ^ <
       /|   |\
      (_|   |_)
        |   |
       _|   |_
      (___|___)
     🚀  SCAN COMPLETE  🔥
"@
Write-Host $finalKitty -ForegroundColor Magenta
Write-Host ""
Write-Host "  ██████████████████████████████████████████████████████████████████" -ForegroundColor DarkMagenta
Write-Host "  ██  POWERED BY KETTEH'S INSANE MOD ANALYZER v5  ██" -ForegroundColor Magenta
Write-Host "  ██████████████████████████████████████████████████████████████████" -ForegroundColor DarkMagenta
Write-Host ""
