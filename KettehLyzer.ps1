[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
$OutputEncoding           = [System.Text.Encoding]::UTF8
chcp 65001 | Out-Null
Clear-Host

# ─── KETTEH CYBER BANNER ──────────────────────────────────────
$Banner = @"
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   ██╗  ██╗███████╗████████╗████████╗███████╗██╗  ██╗                     ║
║   ██║ ██╔╝██╔════╝╚══██╔══╝╚══██╔══╝██╔════╝██║  ██║                     ║
║   █████╔╝ █████╗     ██║      ██║   █████╗  ███████║                     ║
║   ██╔═██╗ ██╔══╝     ██║      ██║   ██╔══╝  ██╔══██║                     ║
║   ██║  ██╗███████╗   ██║      ██║   ███████╗██║  ██║                     ║
║   ╚═╝  ╚═╝╚══════╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝                     ║
║                                                                           ║
║   █████╗ ███╗   ██╗ █████╗ ██╗  ██╗   ██╗███████╗███████╗██████╗        ║
║  ██╔══██╗████╗  ██║██╔══██╗██║  ╚██╗ ██╔╝╚══███╔╝██╔════╝██╔══██╗       ║
║  ███████║██╔██╗ ██║███████║██║   ╚████╔╝  ███╔╝ █████╗  ██████╔╝        ║
║  ██╔══██║██║╚██╗██║██╔══██║██║    ╚██╔╝  ███╔╝  ██╔══╝  ██╔══██╗        ║
║  ██║  ██║██║ ╚████║██║  ██║███████╗ ██║   ███████╗███████╗██║  ██║        ║
║  ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝ ╚═╝   ╚══════╝╚══════╝╚═╝  ╚═╝        ║
║                                                                           ║
║              ⚡  M O D   A N A L Y Z E R  ⚡                           ║
║                   D E T E C T   C H E A T S                            ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
"@

Write-Host $Banner -ForegroundColor Cyan

# ─── GLOW LINE ──────────────────────────────────────────────────
Write-Host ("  " + "█" * 72) -ForegroundColor DarkMagenta
Write-Host "  ███████╗██╗   ██╗██████╗ ███████╗██████╗  ██████╗ ██╗  ██╗" -ForegroundColor Magenta
Write-Host "  ██╔════╝╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗██╔═══██╗╚██╗██╔╝" -ForegroundColor Magenta
Write-Host "  █████╗   ╚████╔╝ ██████╔╝█████╗  ██████╔╝██║   ██║ ╚███╔╝ " -ForegroundColor Magenta
Write-Host "  ██╔══╝    ╚██╔╝  ██╔═══╝ ██╔══╝  ██╔══██╗██║   ██║ ██╔██╗ " -ForegroundColor Magenta
Write-Host "  ███████╗   ██║   ██║     ███████╗██║  ██║╚██████╔╝██╔╝ ██╗" -ForegroundColor Magenta
Write-Host "  ╚══════╝   ╚═╝   ╚═╝     ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝" -ForegroundColor Magenta
Write-Host ("  " + "█" * 72) -ForegroundColor DarkMagenta
Write-Host ""

Write-Host "  ⚡ █████████████████████████████████████████████████████████████████" -ForegroundColor DarkCyan
Write-Host "  ⚡  ███████  ██   ██  ██████  ███████  ██████  ██████  ██    ██" -ForegroundColor Cyan
Write-Host "  ⚡  ██       ██   ██  ██   ██ ██       ██   ██ ██   ██ ██    ██" -ForegroundColor Cyan
Write-Host "  ⚡  ███████  ███████  ██████  ███████  ██████  ██████  ██    ██" -ForegroundColor Cyan
Write-Host "  ⚡       ██  ██   ██  ██   ██      ██  ██   ██ ██   ██ ██    ██" -ForegroundColor Cyan
Write-Host "  ⚡  ███████  ██   ██  ██   ██ ███████  ██   ██ ██   ██  ██████" -ForegroundColor Cyan
Write-Host "  ⚡ █████████████████████████████████████████████████████████████████" -ForegroundColor DarkCyan
Write-Host ""

# ─── PATH INPUT ─────────────────────────────────────────────────
Write-Host "  📂  TARGET DIRECTORY" -ForegroundColor White
Write-Host "  ────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host "  Enter path to the mods folder:" -ForegroundColor White
Write-Host "  (press Enter to use default)" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  ────▶ " -ForegroundColor Cyan -NoNewline
$modsPath = Read-Host
Write-Host ""

if ([string]::IsNullOrWhiteSpace($modsPath)) {
    $modsPath = "$env:USERPROFILE\AppData\Roaming\.minecraft\mods"
    Write-Host "  ◆ Using default path: $modsPath" -ForegroundColor Yellow
    Write-Host ""
}

if (-not (Test-Path $modsPath -PathType Container)) {
    Write-Host ""
    Write-Host "  ⚠️  INVALID PATH!" -ForegroundColor Red
    Write-Host "  Press any key to exit..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

Add-Type -AssemblyName System.IO.Compression.FileSystem

# ─── ANIMATED LOADING ──────────────────────────────────────────
Write-Host "  ═══ INITIALIZING SCAN ENGINE ═══" -ForegroundColor DarkCyan
$loadingChars = @("█", "▓", "▒", "░")
for ($i = 0; $i -le 100; $i += 5) {
    $bar = "["
    $filled = [math]::Floor($i / 5)
    $bar += ($loadingChars[$i % 4] * $filled).PadRight(20, "░")
    $bar += "]"
    Write-Host "`r  $bar $i% " -ForegroundColor Cyan -NoNewline
    Start-Sleep -Milliseconds 15
}
Write-Host "`r  [████████████████████] 100% " -ForegroundColor Green
Write-Host ""

# ─── CHEAT PATTERNS ────────────────────────────────────────────
$cheatPatterns = @(
    # Cheat Clients
    "wurst","meteor","impact","liquidbounce","aristois","future","sigma","vape",
    "dqrkis","grim","prestige","asteria","catlean","vengeance","exhibition",
    "rusherhack","novoline","ghostclient","kamiblue","salhack","clickcrystals",
    "baritone","doomsday","kuro","rise","flux","zero","astolfo","xenon",
    
    # Crystal PVP
    "autocrystal","crystalaura","anchoraura","bedaura","autocrystalaura",
    "autodoublehand","autohitcrystal","crystaloptimizer","anchoroptimizer",
    
    # Combat
    "killaura","aimassist","reach","hitbox","triggerbot","bowaimbot",
    "antiknockback","velocity","criticals","autoclicker",
    
    # Movement
    "nofall","bhop","flight","phase","blink","freecam","scaffold",
    "elytrafly","speedmine","jumpreset","longjump",
    
    # Visual
    "xray","esp","nametags","chams","tracers","radar",
    
    # Utility
    "cheststealer","nuker","autoarmor","autopot","autototem",
    "inventorytotem","pingspoof","selfdestruct","fastplace","fastbreak",
    
    # Obfuscation
    "meteordevelopment","cc/novoline","com/alan/clients","club/maxstats",
    "wtf/moonlight","me/zeroeightsix/kami","net/ccbluex",
    "xyz/greaj","com/cheatbreaker","com/moonsworth","phantom-refmap.json",
    
    # Rats
    "sessionstealer","tokenlogger","tokengrabber","discordtoken",
    "remoteaccess","reverseshell","c2server","backdoor"
)

# ─── FUNCTIONS ──────────────────────────────────────────────────
function Get-FileSHA1 {
    param([string]$Path)
    return (Get-FileHash -Path $Path -Algorithm SHA1).Hash
}

function Query-Modrinth {
    param([string]$Hash)
    try {
        $ver = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/version_file/$Hash" -Method Get -UseBasicParsing -ErrorAction Stop
        if ($ver.project_id) {
            $proj = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/project/$($ver.project_id)" -Method Get -UseBasicParsing -ErrorAction Stop
            return @{ Name = $proj.title; Slug = $proj.slug }
        }
    } catch { }
    return @{ Name = ""; Slug = "" }
}

function Query-Megabase {
    param([string]$Hash)
    try {
        $result = Invoke-RestMethod -Uri "https://megabase.vercel.app/api/query?hash=$Hash" -Method Get -UseBasicParsing -ErrorAction Stop
        if (-not $result.error) { return $result.data }
    } catch { }
    return $null
}

function Invoke-ScanJar {
    param([string]$FilePath)
    
    $found = [System.Collections.Generic.HashSet[string]]::new()
    $isCheatClient = $false
    
    try {
        $archive = [System.IO.Compression.ZipFile]::OpenRead($FilePath)
        
        foreach ($entry in $archive.Entries) {
            $name = $entry.FullName.ToLower()
            
            # Check names
            foreach ($cheat in $cheatPatterns) {
                if ($name -match $cheat) {
                    $found.Add($cheat)
                    if ($cheat -match "wurst|meteor|impact|sigma|vengeance|dqrkis|grim|prestige|exhibition|rusherhack|novoline") {
                        $isCheatClient = $true
                    }
                }
            }
            
            # Check class files
            if ($name -match '\.class$') {
                try {
                    $st = $entry.Open()
                    $ms = New-Object System.IO.MemoryStream
                    $st.CopyTo($ms); $st.Close()
                    $bytes = $ms.ToArray(); $ms.Dispose()
                    $text = [System.Text.Encoding]::ASCII.GetString($bytes).ToLower()
                    
                    foreach ($cheat in $cheatPatterns) {
                        if ($cheat.Length -gt 4 -and $text -match $cheat) {
                            $found.Add($cheat)
                            if ($cheat -match "wurst|meteor|impact|sigma|vengeance|dqrkis|grim|prestige|exhibition|rusherhack|novoline") {
                                $isCheatClient = $true
                            }
                        }
                    }
                } catch { }
            }
        }
        $archive.Dispose()
    } catch { }
    
    return @{ 
        Hits = $found
        IsCheatClient = $isCheatClient
        HitCount = $found.Count
    }
}

function Invoke-DeepScan {
    param([string]$FilePath)
    $flags = [System.Collections.Generic.List[string]]::new()
    
    try {
        $zip = [System.IO.Compression.ZipFile]::OpenRead($FilePath)
        
        $hasRuntimeExec = $false
        $hasHttpDownload = $false
        $hasHttpExfil = $false
        $hasObfuscation = $false
        
        foreach ($entry in $zip.Entries) {
            if ($entry.FullName -match '\.class$') {
                try {
                    $st = $entry.Open()
                    $ms = New-Object System.IO.MemoryStream
                    $st.CopyTo($ms); $st.Close()
                    $bytes = $ms.ToArray(); $ms.Dispose()
                    $text = [System.Text.Encoding]::ASCII.GetString($bytes)
                    
                    if ($text -match "java/lang/Runtime" -and $text -match "exec") { $hasRuntimeExec = $true }
                    if ($text -match "HttpURLConnection" -and $text -match "FileOutputStream") { $hasHttpDownload = $true }
                    if ($text -match "setDoOutput" -and $text -match "getOutputStream") { $hasHttpExfil = $true }
                    if ($text -match "ProGuard|Allatori|ZKM|Stringer|Radon|Paramorphism") { $hasObfuscation = $true }
                } catch { }
            }
        }
        $zip.Dispose()
        
        if ($hasRuntimeExec) { $flags.Add("⚡ RUNTIME.EXEC — Can execute OS commands") }
        if ($hasHttpDownload) { $flags.Add("⬇ HTTP DOWNLOAD — Fetches files from remote server") }
        if ($hasHttpExfil) { $flags.Add("📤 DATA EXFIL — Sends data to external server") }
        if ($hasObfuscation) { $flags.Add("🕵️ OBFUSCATION — Uses obfuscation techniques") }
        
    } catch { }
    
    return $flags
}

# ─── SCAN ──────────────────────────────────────────────────────
$jarFiles = Get-ChildItem -Path $modsPath -Filter *.jar -File
$total = $jarFiles.Count

Write-Host "  🔍 Found $total JAR files" -ForegroundColor Green
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkCyan
Write-Host ""

$verifiedMods = @()
$unknownMods = @()
$cheatMods = @()
$suspiciousMods = @()
$dangerousMods = @()

$idx = 0
$spinner = @("◢","◣","◤","◥")

foreach ($jar in $jarFiles) {
    $idx++
    $pct = [math]::Round(100 * $idx / $total)
    $spin = $spinner[$idx % $spinner.Length]
    Write-Host "`r  [$spin] Scanning $idx/$total ($pct%) — $($jar.Name)" -ForegroundColor Cyan -NoNewline
    
    # Hash check
    $hash = Get-FileSHA1 -Path $jar.FullName
    $verified = $false
    
    if ($hash) {
        $modrinthData = Query-Modrinth -Hash $hash
        if ($modrinthData.Slug) {
            $verifiedMods += [PSCustomObject]@{ FileName = $jar.Name; ModName = $modrinthData.Name }
            continue
        }
        $megabaseData = Query-Megabase -Hash $hash
        if ($megabaseData.name) {
            $verifiedMods += [PSCustomObject]@{ FileName = $jar.Name; ModName = $megabaseData.name }
            continue
        }
    }
    
    # Scan for cheats
    $scanResult = Invoke-ScanJar -FilePath $jar.FullName
    
    if ($scanResult.IsCheatClient) {
        $cheatMods += [PSCustomObject]@{
            FileName = $jar.Name
            Hits = $scanResult.Hits
            HitCount = $scanResult.HitCount
        }
        # Deep scan for dangerous mods
        $flags = Invoke-DeepScan -FilePath $jar.FullName
        if ($flags.Count -gt 0) {
            $dangerousMods += [PSCustomObject]@{
                FileName = $jar.Name
                Flags = $flags
            }
        }
    } elseif ($scanResult.HitCount -gt 0) {
        $suspiciousMods += [PSCustomObject]@{
            FileName = $jar.Name
            Hits = $scanResult.Hits
            HitCount = $scanResult.HitCount
        }
    } else {
        $unknownMods += [PSCustomObject]@{ FileName = $jar.Name }
    }
}

Write-Host "`r" + " " * 80 + "`r" -NoNewline

# ─── RESULTS ───────────────────────────────────────────────────
Write-Host ""
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  📊  S C A N   R E S U L T S" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

$totalFlagged = $cheatMods.Count + $suspiciousMods.Count

Write-Host "  ┌─────────────────────────────────────────────────────────────────┐" -ForegroundColor DarkMagenta
Write-Host "  │  ✅ VERIFIED    │  ❓ UNKNOWN    │  ⚠️ SUSPICIOUS │  🚨 CHEATS  │" -ForegroundColor White
Write-Host "  │  $($verifiedMods.Count.ToString().PadLeft(4))           │  $($unknownMods.Count.ToString().PadLeft(4))          │  $($suspiciousMods.Count.ToString().PadLeft(4))           │  $($cheatMods.Count.ToString().PadLeft(4))        │" -ForegroundColor White
Write-Host "  └─────────────────────────────────────────────────────────────────┘" -ForegroundColor DarkMagenta
Write-Host ""

# ─── CHEATS ────────────────────────────────────────────────────
if ($cheatMods.Count -gt 0) {
    Write-Host "  ═══ 🚨 C H E A T S   D E T E C T E D ═══" -ForegroundColor Red
    Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkRed
    Write-Host ""
    
    foreach ($mod in $cheatMods) {
        Write-Host "  ⚡ $($mod.FileName)" -ForegroundColor Red
        Write-Host "     ─────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
        
        $clientHits = $mod.Hits | Where-Object { $_ -match "wurst|meteor|impact|sigma|vengeance|dqrkis|grim|prestige|exhibition|rusherhack|novoline" }
        if ($clientHits.Count -gt 0) {
            Write-Host "     🔥 CHEAT CLIENT: $($clientHits -join ', ')" -ForegroundColor Magenta
        }
        Write-Host "     🎯 SIGNATURES: $($mod.Hits -join ', ')" -ForegroundColor Yellow
        Write-Host "     📊 HIT COUNT: $($mod.HitCount)" -ForegroundColor Gray
        Write-Host ""
    }
}

# ─── DANGEROUS MODS ───────────────────────────────────────────
if ($dangerousMods.Count -gt 0) {
    Write-Host "  ═══ ☣️  D A N G E R O U S   M O D S ═══" -ForegroundColor DarkRed
    Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkRed
    Write-Host ""
    
    foreach ($mod in $dangerousMods) {
        Write-Host "  ☢️ $($mod.FileName)" -ForegroundColor DarkRed
        Write-Host "     ─────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
        foreach ($flag in $mod.Flags) {
            Write-Host "     $flag" -ForegroundColor Red
        }
        Write-Host ""
    }
}

# ─── SUSPICIOUS ─────────────────────────────────────────────────
if ($suspiciousMods.Count -gt 0) {
    Write-Host "  ═══ ⚠️  S U S P I C I O U S   M O D S ═══" -ForegroundColor Yellow
    Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkYellow
    Write-Host ""
    
    foreach ($mod in $suspiciousMods) {
        Write-Host "  ⚠️ $($mod.FileName)" -ForegroundColor Yellow
        Write-Host "     🎯 PATTERNS: $($mod.Hits -join ', ')" -ForegroundColor DarkGray
        Write-Host "     📊 HIT COUNT: $($mod.HitCount)" -ForegroundColor Gray
        Write-Host ""
    }
}

# ─── UNKNOWN ──────────────────────────────────────────────────
if ($unknownMods.Count -gt 0) {
    Write-Host "  ═══ ❓ U N K N O W N   M O D S ═══" -ForegroundColor DarkGray
    Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
    Write-Host ""
    
    $displayUnknown = $unknownMods | Select-Object -First 20
    foreach ($mod in $displayUnknown) {
        Write-Host "  ▸ $($mod.FileName)" -ForegroundColor DarkGray
    }
    if ($unknownMods.Count -gt 20) {
        Write-Host "  ... and $($unknownMods.Count - 20) more" -ForegroundColor DarkGray
    }
    Write-Host ""
}

# ─── VERIFIED ──────────────────────────────────────────────────
if ($verifiedMods.Count -gt 0) {
    Write-Host "  ═══ ✅ V E R I F I E D   M O D S ═══" -ForegroundColor Green
    Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkGreen
    Write-Host ""
    
    $displayVerified = $verifiedMods | Select-Object -First 20
    foreach ($mod in $displayVerified) {
        Write-Host "  ✓ $($mod.ModName)" -ForegroundColor Green -NoNewline
        Write-Host " [$($mod.FileName)]" -ForegroundColor DarkGray
    }
    if ($verifiedMods.Count -gt 20) {
        Write-Host "  ... and $($verifiedMods.Count - 20) more" -ForegroundColor DarkGray
    }
    Write-Host ""
}

# ─── SECURITY RATING ───────────────────────────────────────────
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  🛡️  S E C U R I T Y   R A T I N G" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

$riskScore = ($cheatMods.Count * 3) + ($suspiciousMods.Count * 1) + ($dangerousMods.Count * 5)

if ($dangerousMods.Count -gt 0) {
    Write-Host "  ☣️  STATUS: CRITICAL — Dangerous mods detected!" -ForegroundColor DarkRed
    Write-Host "  ⚡ IMMEDIATE ACTION REQUIRED" -ForegroundColor Red
} elseif ($cheatMods.Count -gt 0) {
    Write-Host "  🚨 STATUS: COMPROMISED — Cheat clients detected!" -ForegroundColor Red
    Write-Host "  ⚠️ Remove flagged mods immediately" -ForegroundColor Yellow
} elseif ($suspiciousMods.Count -gt 3) {
    Write-Host "  ⚠️  STATUS: CAUTION — Suspicious mods found" -ForegroundColor Yellow
    Write-Host "  🔍 Manual inspection recommended" -ForegroundColor Yellow
} else {
    Write-Host "  ✅ STATUS: CLEAN — No threats detected" -ForegroundColor Green
    Write-Host "  🔥 You're good to go!" -ForegroundColor Green
}
Write-Host ""

# ─── STATS ─────────────────────────────────────────────────────
Write-Host "  📊  S C A N   S T A T S" -ForegroundColor Cyan
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkCyan
Write-Host ""
Write-Host "  📦 Total Files    : $total" -ForegroundColor White
Write-Host "  ✅ Verified      : $($verifiedMods.Count)" -ForegroundColor Green
Write-Host "  ❓ Unknown       : $($unknownMods.Count)" -ForegroundColor Yellow
Write-Host "  ⚠️ Suspicious    : $($suspiciousMods.Count)" -ForegroundColor Yellow
Write-Host "  🚨 Cheats        : $($cheatMods.Count)" -ForegroundColor Red
Write-Host "  ☣️ Dangerous     : $($dangerousMods.Count)" -ForegroundColor DarkRed
Write-Host "  📊 Risk Score    : $riskScore" -ForegroundColor White
Write-Host ""

# ─── FOOTER ────────────────────────────────────────────────────
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host "  🔥  K E T T E H   M O D   A N A L Y Z E R" -ForegroundColor Magenta
Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkMagenta
Write-Host ""

$kitty = @"
        /\_/\
       ( ^.^ )
        > ^ <
       /|   |\
      (_|   |_)
"@
Write-Host $kitty -ForegroundColor Magenta
Write-Host "  ⚡  Stay vigilant. Stay safe." -ForegroundColor Cyan
Write-Host "  🔥  No mercy for cheaters." -ForegroundColor Magenta
Write-Host ""

Write-Host "  Press any key to exit..." -ForegroundColor DarkGray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
