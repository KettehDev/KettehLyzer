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
$DarkGreen = "DarkGreen"

# ─── RAINBOW TEXT FUNCTION ────────────────────────────────────
function Write-Rainbow {
    param([string]$Text, [int]$Delay = 20)
    $colors = @('Red','Yellow','Green','Cyan','Magenta','White')
    $i = 0
    foreach ($char in $Text.ToCharArray()) {
        if ($char -eq ' ') { 
            Write-Host " " -NoNewline
            continue 
        }
        $color = $colors[$i % $colors.Length]
        Write-Host $char -ForegroundColor $color -NoNewline
        $i++
        Start-Sleep -Milliseconds $Delay
    }
    Write-Host ""
}

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

# ─── ASCII BANNER ─────────────────────────────────────────────
$banner = @"
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
"@

# ─── DISPLAY BANNER ──────────────────────────────────────────
$bannerLines = $banner -split "`n"
foreach ($line in $bannerLines) {
    if ($line -match "█" -or $line -match "╔" -or $line -match "╗" -or $line -match "║" -or $line -match "╚" -or $line -match "╝" -or $line -match "═") {
        Write-Host $line -ForegroundColor DarkMagenta
    } elseif ($line -match "KETTEH" -or $line -match "SS BYPASS") {
        Write-Rainbow -Text $line -Delay 10
    } else {
        Write-Host $line -ForegroundColor Magenta
    }
}

Write-Host ""
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta

# ─── ANIMATED LOADING ──────────────────────────────────────────
Write-Host "  ⚡  SS BYPASS DETECTION ENGINE" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""

$loadingTexts = @(
    "[SYSTEM] Loading SS bypass signatures...",
    "[SYSTEM] Loading hide detection patterns...",
    "[SYSTEM] Loading injection detection...",
    "[SYSTEM] Ready to expose hidden cheats."
)

foreach ($text in $loadingTexts) {
    $dots = ""
    for ($i = 0; $i -lt 3; $i++) {
        $dots += "."
        Write-Host "`r  $text$dots" -ForegroundColor Yellow -NoNewline
        Start-Sleep -Milliseconds 250
    }
    Write-Host "`r  $text" -ForegroundColor Green
    Start-Sleep -Milliseconds 150
}
Write-Host ""

# ─── ANIMATED LOADING BAR ─────────────────────────────────────
Write-Host "  ═══ LOADING MODULES ═══" -ForegroundColor DarkCyan
for ($i = 0; $i -le 100; $i += 2) {
    $bar = "["
    $filled = [math]::Floor($i / 2)
    $bar += ("█" * $filled).PadRight(50, "░")
    $bar += "]"
    $percent = $i.ToString().PadLeft(3)
    Write-Host "`r  $bar $percent% " -ForegroundColor Cyan -NoNewline
    Start-Sleep -Milliseconds 10
}
Write-Host "`r  [██████████████████████████████████████████████████] 100% " -ForegroundColor Green
Write-Host ""

# ─── MINECRAFT CHECK ──────────────────────────────────────────
$process = Get-Process javaw -ErrorAction SilentlyContinue
if (-not $process) { $process = Get-Process java -ErrorAction SilentlyContinue }
if ($process) {
    try { $elapsed = (Get-Date) - $process.StartTime } catch {}
    Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
    Write-Host "  🖥️  MINECRAFT PROCESS" -ForegroundColor Cyan
    Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
    Write-Host "  Process     : " -NoNewline
    Write-Host "$($process.Name)" -ForegroundColor Green -NoNewline
    Write-Host "  PID         : " -NoNewline
    Write-Host "$($process.Id)" -ForegroundColor Green
    Write-Host "  Uptime      : " -NoNewline
    Write-Host "$($elapsed.Hours)h $($elapsed.Minutes)m $($elapsed.Seconds)s" -ForegroundColor Green
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
    'File','Hide','Hidden','Directory','Delete','Temp','Cache','Clean',
    'DeleteOnExit','File.delete','Files.delete','Files.move','Files.copy',
    'Process','HideWindow','Shell','Execute','Runtime','ProcessBuilder',
    'Memory','Heap','Stack','Unsafe','Direct','Buffer','Mapped',
    'Unsafe.allocateMemory','Unsafe.putInt','Unsafe.getInt',
    'Native','JNI','JNA','Invoke','Call',
    'Inject','Injection','Injector','Load','Insert',
    'ClassLoader','System.load','loadLibrary','DefineClass',
    'Instrumentation','Agent_OnLoad','Agent_OnAttach','Transform',
    'ClassFileTransformer','JVM_LoadClass','AttachCurrentThread',
    'Bypass','Disable','Disabler','Spoof','Spoofer','Bypasser',
    'AntiCheat','AAC','NCP','Vulcan','Matrix','Verus','Spartan',
    'Ghost','Stealth','Invisible','Phantom','Shadow','Cloak','Undetectable'
)

$CheatSignatures = @(
    'KillAura','AimAssist','Reach','HitBox','Aura','BowAimbot','Velocity',
    'AntiKnockback','Criticals','AutoClicker','Flight','BHop','SpeedMine',
    'NoFall','Phase','Blink','Freecam','NoSlow','Scaffold','ElytraFly',
    'XRay','ESP','Nametags','Chams','Tracers','Radar','ChestStealer',
    'Nuker','AutoCrystal','CrystalAura','PingSpoof','SelfDestruct',
    'FastPlace','FastBreak','ClickGUI','AltManager'
)

$CheatClientNames = @(
    'wurst','meteor','impact','liquidbounce','aristois','future',
    'sigma','vape','entropy','dqrkis',
    'crystalaura','autocrystal','anchoraura','bedaura',
    'rusherhack','novoline','ghostclient','kamiblue','salhack','clickcrystals',
    'baritone','vengeance','exhibition','kuro','rise','flux',
    'zero','astolfo','dortware','xenon','tenacity'
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
    } catch { return }
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
        if ($lower -match [regex]::Escape($legit)) { return $null }
    }
    foreach ($cheat in $CheatClientNames) {
        if ($lower -match [regex]::Escape($cheat)) { return $cheat }
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
            if ($text -match [regex]::Escape($sig)) { $hits.Hide += $sig }
        }
        foreach ($sig in $CheatSignatures) {
            if ($text -match [regex]::Escape($sig)) { $hits.Cheat += $sig }
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
    if ($total -ge 12) { return "CRITICAL" }
    if ($total -ge 6) { return "HIGH" }
    if ($total -ge 2) { return "MEDIUM" }
    return "LOW"
}

# ─── ANIMATED SCAN ─────────────────────────────────────────────
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

# ─── SCAN LOOP WITH ANIMATION ────────────────────────────────
$spinner = @('◢', '◣', '◤', '◥')
$spinnerIndex = 0

try {
    foreach ($file in $jarFiles) {
        $counter++
        $pct = [math]::Round(100 * $counter / $total)
        $spinnerChar = $spinner[$spinnerIndex % $spinner.Length]
        $spinnerIndex++
        
        Write-Host "`r  [$spinnerChar] Scanning $counter/$total ($pct%)...$(' ' * 20)" -ForegroundColor Cyan -NoNewline

        # 1. NAME CHECK
        $nameHit = Get-NameHit -FileName $file.Name
        if ($nameHit) {
            $bypassMods += [pscustomobject]@{ 
                FileName = $file.Name
                Type = "NAME MATCH"
                Reason = "BLATANT CHEAT: $nameHit"
                Threat = "CRITICAL"
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

        # 3. DEEP SCAN
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
                Reason = "$totalHits bypass/hide signatures"
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

$criticalCount = ($bypassMods | Where-Object { $_.Threat -eq "CRITICAL" }).Count
$highCount = ($bypassMods | Where-Object { $_.Threat -eq "HIGH" }).Count
$mediumCount = ($bypassMods | Where-Object { $_.Threat -eq "MEDIUM" }).Count

# ─── SUMMARY TABLE ─────────────────────────────────────────────
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
        
        if ($mod.Type -eq "NAME MATCH") {
            Write-Host "  ║  TYPE        : NAME MATCH" -ForegroundColor Yellow
            Write-Host "  ║  REASON      : $($mod.Reason)" -ForegroundColor DarkRed
            Write-Host "  ║  THREAT      : " -NoNewline -ForegroundColor Yellow
            Write-Host "CRITICAL" -ForegroundColor DarkRed
        } else {
            Write-Host "  ║  TYPE        : SS BYPASS / HIDE" -ForegroundColor Yellow
            Write-Host "  ║  REASON      : $($mod.Reason)" -ForegroundColor DarkMagenta
            Write-Host "  ║  THREAT      : " -NoNewline -ForegroundColor Yellow
            Write-Host $mod.Threat -ForegroundColor $threatColor
            Write-Host "  ║  TOTAL HITS  : $($mod.Hits.Hide.Count + $mod.Hits.Cheat.Count)" -ForegroundColor Yellow
            
            if ($mod.Hits.Hide.Count -gt 0) {
                Write-Host "  ╠══════════════════════════════════════════════════════════════════╣" -ForegroundColor DarkRed
                Write-Host "  ║  🕵️ SS BYPASS / HIDE SIGNATURES:" -ForegroundColor Cyan
                foreach ($hit in $mod.Hits.Hide) {
                    Write-Host "  ║     🔸 $hit" -ForegroundColor Red
                }
            }
            
            if ($mod.Hits.Cheat.Count -gt 0) {
                Write-Host "  ╠══════════════════════════════════════════════════════════════════╣" -ForegroundColor DarkRed
                Write-Host "  ║  ⚔️ CHEAT FEATURES FOUND:" -ForegroundColor Cyan
                foreach ($hit in $mod.Hits.Cheat) {
                    Write-Host "  ║     🔸 $hit" -ForegroundColor Magenta
                }
            }
        }
        Write-Host "  ╚══════════════════════════════════════════════════════════════════╝" -ForegroundColor DarkRed
        Write-Host ""
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

# ─── EPIC BIG CAT ─────────────────────────────────────────────
$catLines = $bigCat -split "`n"
$catColors = @($DarkMagenta, $Magenta, $Cyan, $DarkCyan, $Green, $DarkGreen, $Yellow, $Red, $White, $Gray)

for ($i = 0; $i -lt $catLines.Count; $i++) {
    $color = $catColors[$i % $catColors.Length]
    if ($catLines[$i] -match "CATCHING CHEATERS" -or $catLines[$i] -match "JUSTICE SERVED") {
        Write-Rainbow -Text $catLines[$i] -Delay 15
    } else {
        Write-Host $catLines[$i] -ForegroundColor $color
    }
}

Write-Host ""
Write-Host "  🔥  Exposed hidden mods. Justice served." -ForegroundColor Magenta
Write-Host "  ⚡  Stay vigilant, stay safe." -ForegroundColor Cyan
Write-Host ""
