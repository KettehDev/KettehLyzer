[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
$OutputEncoding           = [System.Text.Encoding]::UTF8
chcp 65001 | Out-Null
Clear-Host

# ─── KETTEH BRANDING ──────────────────────────────────────────
$Banner = @"

  ██╗  ██╗███████╗████████╗████████╗███████╗██╗  ██╗
  ██║ ██╔╝██╔════╝╚══██╔══╝╚══██╔══╝██╔════╝██║  ██║
  █████╔╝ █████╗     ██║      ██║   █████╗  ███████║
  ██╔═██╗ ██╔══╝     ██║      ██║   ██╔══╝  ██╔══██║
  ██║  ██╗███████╗   ██║      ██║   ███████╗██║  ██║
  ╚═╝  ╚═╝╚══════╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝
  
   █████╗ ███╗   ██╗ █████╗ ██╗  ██╗   ██╗███████╗███████╗██████╗
  ██╔══██╗████╗  ██║██╔══██╗██║  ╚██╗ ██╔╝╚══███╔╝██╔════╝██╔══██╗
  ███████║██╔██╗ ██║███████║██║   ╚████╔╝  ███╔╝ █████╗  ██████╔╝
  ██╔══██║██║╚██╗██║██╔══██║██║    ╚██╔╝  ███╔╝  ██╔══╝  ██╔══██╗
  ██║  ██║██║ ╚████║██║  ██║███████╗ ██║   ███████╗███████╗██║  ██║
  ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝ ╚═╝   ╚══════╝╚══════╝╚═╝  ╚═╝

                         \    /\
                          )  ( ')
                         (  /  )
                          \(__)|

"@

Write-Host $Banner -ForegroundColor Cyan
Write-Host ("═" * 76) -ForegroundColor DarkCyan
Write-Host "  ███╗   ██╗███████╗██╗  ██╗██╗   ██╗███████╗" -ForegroundColor Magenta
Write-Host "  ████╗  ██║██╔════╝██║  ██║╚██╗ ██╔╝██╔════╝" -ForegroundColor Magenta
Write-Host "  ██╔██╗ ██║█████╗  ███████║ ╚████╔╝ █████╗  " -ForegroundColor Magenta
Write-Host "  ██║╚██╗██║██╔══╝  ██╔══██║  ╚██╔╝  ██╔══╝  " -ForegroundColor Magenta
Write-Host "  ██║ ╚████║███████╗██║  ██║   ██║   ███████╗" -ForegroundColor Magenta
Write-Host "  ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝" -ForegroundColor Magenta
Write-Host ("═" * 76) -ForegroundColor DarkCyan
Write-Host ""

Write-Host "  ⚡ Enter path to the mods folder:" -ForegroundColor White
Write-Host "  (press Enter to use default)" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  ────▶ " -ForegroundColor Cyan -NoNewline
$modsPath = Read-Host
Write-Host ""

if ([string]::IsNullOrWhiteSpace($modsPath)) {
    $modsPath = "$env:USERPROFILE\AppData\Roaming\.minecraft\mods"
    Write-Host "  Using default path: $modsPath" -ForegroundColor Yellow
    Write-Host ""
}

if (-not (Test-Path $modsPath -PathType Container)) {
    Write-Host "  ❌ Invalid path!" -ForegroundColor Red
    Write-Host "  Press any key to exit..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

Add-Type -AssemblyName System.IO.Compression.FileSystem

# ─── REAL CHEAT PATTERNS (NO FALSE FLAGS) ─────────────────────
$realCheatPatterns = @(
    # Actual cheat clients
    "wurst","meteor","impact","liquidbounce","aristois","future","sigma","vape",
    "dqrkis","grim","prestige","asteria","catlean","vengeance","exhibition",
    "rusherhack","novoline","ghostclient","kamiblue","salhack","clickcrystals",
    "baritone","doomsday","kuro","rise","flux","zero","astolfo","xenon",
    
    # Crystal PVP cheats
    "autocrystal","autocrystalaura","crystalaura","anchoraura","bedaura",
    "autodoublehand","autohitcrystal","crystaloptimizer","anchoroptimizer",
    
    # Obvious cheat features
    "killaura","aimassist","reach","hitbox","triggerbot","bowaimbot",
    "antiknockback","velocity","nofall","bhop","flight","phase","blink",
    "freecam","scaffold","elytrafly","xray","esp","nametags","chams",
    "tracers","radar","cheststealer","nuker","autoarmor","autopot",
    "autototem","inventorytotem","hover totem","pingspoof","selfdestruct",
    
    # Obfuscation
    "meteordevelopment","cc/novoline","com/alan/clients","club/maxstats",
    "wtf/moonlight","me/zeroeightsix/kami","net/ccbluex","today/opai",
    "xyz/greaj","com/cheatbreaker","com/moonsworth","phantom-refmap.json",
    
    # Rat detection
    "sessionstealer","tokenlogger","tokengrabber","discordtoken",
    "remoteaccess","reverseshell","c2server","backdoor","keylogger"
)

# ─── LEGIT WORDS TO IGNORE ────────────────────────────────────
$legitWords = @(
    "future","phase","impact","reach","aura","radar","esp","flight","velocity",
    "auto","clicker","crystal","anchor","pot","totem","armor","shield","breaker",
    "double","hover","safe","air","macro","web","mace","spear","stun","slam"
)

# ─── FUNCTIONS ──────────────────────────────────────────────────
function Get-FileSHA1 {
    param([string]$Path)
    return (Get-FileHash -Path $Path -Algorithm SHA1).Hash
}

function Query-Modrinth {
    param([string]$Hash)
    try {
        $versionInfo = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/version_file/$Hash" -Method Get -UseBasicParsing -ErrorAction Stop
        if ($versionInfo.project_id) {
            $projectInfo = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/project/$($versionInfo.project_id)" -Method Get -UseBasicParsing -ErrorAction Stop
            return @{ Name = $projectInfo.title; Slug = $projectInfo.slug }
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

function Invoke-SmartScan {
    param([string]$FilePath)
    
    $found = [System.Collections.Generic.HashSet[string]]::new()
    $fullCheatFound = $false
    
    try {
        $archive = [System.IO.Compression.ZipFile]::OpenRead($FilePath)
        
        foreach ($entry in $archive.Entries) {
            $name = $entry.FullName.ToLower()
            
            # Check if it's a known cheat client
            foreach ($cheat in $realCheatPatterns) {
                if ($name -match $cheat) {
                    $found.Add($cheat)
                    if ($cheat -match "wurst|meteor|impact|sigma|vengeance|dqrkis|grim|prestige") {
                        $fullCheatFound = $true
                    }
                }
            }
            
            # Scan class files
            if ($name -match '\.class$') {
                try {
                    $st = $entry.Open()
                    $ms = New-Object System.IO.MemoryStream
                    $st.CopyTo($ms); $st.Close()
                    $bytes = $ms.ToArray(); $ms.Dispose()
                    $text = [System.Text.Encoding]::ASCII.GetString($bytes).ToLower()
                    
                    foreach ($cheat in $realCheatPatterns) {
                        if ($text -match $cheat -and $cheat.Length -gt 4) {
                            $found.Add($cheat)
                            if ($cheat -match "wurst|meteor|impact|sigma|vengeance|dqrkis|grim|prestige") {
                                $fullCheatFound = $true
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
        IsFullCheat = $fullCheatFound
    }
}

function Invoke-ScanFile {
    param([string]$FilePath)
    $flags = [System.Collections.Generic.List[string]]::new()
    
    try {
        $zip = [System.IO.Compression.ZipFile]::OpenRead($FilePath)
        
        # Check for runtime.exec
        $hasRuntimeExec = $false
        $hasHttpDownload = $false
        $hasHttpExfil = $false
        
        foreach ($entry in $zip.Entries) {
            if ($entry.FullName -match '\.class$') {
                try {
                    $st = $entry.Open()
                    $ms = New-Object System.IO.MemoryStream
                    $st.CopyTo($ms); $st.Close()
                    $bytes = $ms.ToArray(); $ms.Dispose()
                    $text = [System.Text.Encoding]::ASCII.GetString($bytes)
                    
                    if ($text -match "java/lang/Runtime" -and $text -match "exec") {
                        $hasRuntimeExec = $true
                    }
                    if ($text -match "HttpURLConnection" -and $text -match "FileOutputStream") {
                        $hasHttpDownload = $true
                    }
                    if ($text -match "setDoOutput" -and $text -match "getOutputStream") {
                        $hasHttpExfil = $true
                    }
                } catch { }
            }
        }
        $zip.Dispose()
        
        if ($hasRuntimeExec) { $flags.Add("⚠️ RUNTIME.EXEC — Can execute OS commands") }
        if ($hasHttpDownload) { $flags.Add("⚠️ HTTP DOWNLOAD — Fetches files from remote server") }
        if ($hasHttpExfil) { $flags.Add("⚠️ DATA EXFIL — Sends data to external server") }
        
    } catch { }
    
    return $flags
}

# ─── SCAN ──────────────────────────────────────────────────────
$verifiedMods = @()
$unknownMods = @()
$cheatMods = @()
$suspiciousMods = @()

$jarFiles = Get-ChildItem -Path $modsPath -Filter *.jar -File
$total = $jarFiles.Count

Write-Host "  🔍 Found $total JAR files" -ForegroundColor Green
Write-Host ("═" * 76) -ForegroundColor DarkCyan
Write-Host ""

$spinner = @("⣾","⣽","⣻","⢿","⡿","⣟","⣯","⣷")
$idx = 0

foreach ($jar in $jarFiles) {
    $idx++
    $pct = [math]::Round(100 * $idx / $total)
    $spinnerChar = $spinner[$idx % $spinner.Length]
    Write-Host "`r  [$spinnerChar] Scanning $idx/$total ($pct%) — $($jar.Name)" -ForegroundColor Cyan -NoNewline
    
    # Hash check
    $hash = Get-FileSHA1 -Path $jar.FullName
    $verified = $false
    $modName = ""
    
    if ($hash) {
        $modrinthData = Query-Modrinth -Hash $hash
        if ($modrinthData.Slug) {
            $verified = $true
            $modName = $modrinthData.Name
            $verifiedMods += [PSCustomObject]@{ 
                FileName = $jar.Name
                ModName = $modName
            }
            continue
        }
        $megabaseData = Query-Megabase -Hash $hash
        if ($megabaseData.name) {
            $verified = $true
            $modName = $megabaseData.name
            $verifiedMods += [PSCustomObject]@{ 
                FileName = $jar.Name
                ModName = $modName
            }
            continue
        }
    }
    
    # Smart scan for cheats
    $scanResult = Invoke-SmartScan -FilePath $jar.FullName
    
    if ($scanResult.IsFullCheat) {
        $cheatMods += [PSCustomObject]@{
            FileName = $jar.Name
            Hits = $scanResult.Hits
        }
    } elseif ($scanResult.Hits.Count -gt 0) {
        $suspiciousMods += [PSCustomObject]@{
            FileName = $jar.Name
            Hits = $scanResult.Hits
        }
    } else {
        $unknownMods += [PSCustomObject]@{ FileName = $jar.Name }
    }
}

Write-Host "`r" + " " * 80 + "`r" -NoNewline

# ─── RESULTS ───────────────────────────────────────────────────
Write-Host ""
Write-Host ("═" * 76) -ForegroundColor Cyan
Write-Host "  📊  SCAN RESULTS" -ForegroundColor Cyan
Write-Host ("═" * 76) -ForegroundColor Cyan
Write-Host ""

Write-Host "  ✅ VERIFIED   : $($verifiedMods.Count)" -ForegroundColor Green
Write-Host "  ❓ UNKNOWN    : $($unknownMods.Count)" -ForegroundColor Yellow
Write-Host "  ⚠️  SUSPICIOUS : $($suspiciousMods.Count)" -ForegroundColor Yellow
Write-Host "  🚨 CHEATS     : $($cheatMods.Count)" -ForegroundColor Red
Write-Host ""

# ─── CHEATS ────────────────────────────────────────────────────
if ($cheatMods.Count -gt 0) {
    Write-Host ("═" * 76) -ForegroundColor Red
    Write-Host "  🚨 CHEATS DETECTED" -ForegroundColor Red
    Write-Host ("═" * 76) -ForegroundColor Red
    Write-Host ""
    
    foreach ($mod in $cheatMods) {
        Write-Host "  ⚡ $($mod.FileName)" -ForegroundColor Red
        Write-Host "     ─────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
        $displayHits = $mod.Hits | Where-Object { $_ -match "wurst|meteor|impact|sigma|vengeance|dqrkis|grim|prestige" }
        if ($displayHits.Count -gt 0) {
            Write-Host "     CHEAT CLIENT: $($displayHits -join ', ')" -ForegroundColor Magenta
        } else {
            Write-Host "     SUSPICIOUS PATTERNS: $($mod.Hits -join ', ')" -ForegroundColor Yellow
        }
        Write-Host ""
    }
}

# ─── SUSPICIOUS ─────────────────────────────────────────────────
if ($suspiciousMods.Count -gt 0) {
    Write-Host ("═" * 76) -ForegroundColor Yellow
    Write-Host "  ⚠️  SUSPICIOUS MODS" -ForegroundColor Yellow
    Write-Host ("═" * 76) -ForegroundColor Yellow
    Write-Host ""
    
    foreach ($mod in $suspiciousMods) {
        Write-Host "  ⚠️  $($mod.FileName)" -ForegroundColor Yellow
        Write-Host "     PATTERNS: $($mod.Hits -join ', ')" -ForegroundColor DarkGray
        Write-Host ""
    }
}

# ─── UNKNOWN ──────────────────────────────────────────────────
if ($unknownMods.Count -gt 0) {
    Write-Host ("═" * 76) -ForegroundColor DarkGray
    Write-Host "  ❓ UNKNOWN MODS" -ForegroundColor DarkGray
    Write-Host ("═" * 76) -ForegroundColor DarkGray
    Write-Host ""
    
    foreach ($mod in $unknownMods) {
        Write-Host "  ▸ $($mod.FileName)" -ForegroundColor DarkGray
    }
    Write-Host ""
}

# ─── VERIFIED ──────────────────────────────────────────────────
if ($verifiedMods.Count -gt 0) {
    Write-Host ("═" * 76) -ForegroundColor Green
    Write-Host "  ✅ VERIFIED MODS" -ForegroundColor Green
    Write-Host ("═" * 76) -ForegroundColor Green
    Write-Host ""
    
    foreach ($mod in $verifiedMods) {
        Write-Host "  ✓ $($mod.ModName)" -ForegroundColor Green -NoNewline
        Write-Host " [$($mod.FileName)]" -ForegroundColor DarkGray
    }
    Write-Host ""
}

# ─── FOOTER ────────────────────────────────────────────────────
Write-Host ("═" * 76) -ForegroundColor DarkCyan
Write-Host ""
Write-Host "  🔥 Analysis complete. Stay vigilant." -ForegroundColor Magenta
Write-Host "  ⚡ Ketteh's Mod Analyzer v2" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Press any key to exit..." -ForegroundColor DarkGray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
