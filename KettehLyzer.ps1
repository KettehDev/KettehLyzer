Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.Windows.Forms.Application]::EnableVisualStyles()

# =============================================================================
# THEME - Cyber / Neon
# =============================================================================
$bg        = [System.Drawing.Color]::FromArgb(8, 8, 14)
$panelBg   = [System.Drawing.Color]::FromArgb(14, 14, 24)
$boxBg     = [System.Drawing.Color]::FromArgb(12, 12, 20)
$sidebarBg = [System.Drawing.Color]::FromArgb(11, 11, 19)
$accentM   = [System.Drawing.Color]::FromArgb(255, 70, 210)   # Magenta
$accentC   = [System.Drawing.Color]::FromArgb(70, 220, 255)   # Cyan
$accentG   = [System.Drawing.Color]::FromArgb(90, 230, 150)   # Green
$txt       = [System.Drawing.Color]::FromArgb(235, 235, 245)
$dim       = [System.Drawing.Color]::FromArgb(130, 130, 155)
$yellow    = [System.Drawing.Color]::FromArgb(245, 200, 70)
$red       = [System.Drawing.Color]::FromArgb(245, 80, 90)
$darkred   = [System.Drawing.Color]::FromArgb(190, 35, 45)

$fontTitle = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$fontSub   = New-Object System.Drawing.Font("Segoe UI", 8.5)
$fontUI    = New-Object System.Drawing.Font("Segoe UI", 9)
$fontMono  = New-Object System.Drawing.Font("Consolas", 9)
$fontCat   = New-Object System.Drawing.Font("Consolas", 10)
$fontBtn   = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)

# =============================================================================
# DETECTION ENGINE (kept + slightly cleaned)
# =============================================================================
$CheatPatterns = @(
    "wurst","meteor","impact","liquidbounce","aristois","future","sigma","vape",
    "dqrkis","grim","prestige","asteria","catlean","vengeance","exhibition",
    "rusherhack","novoline","ghostclient","kamiblue","salhack","clickcrystals",
    "baritone","doomsday","kuro","rise","flux","zero","astolfo","xenon",
    "autocrystal","crystalaura","anchoraura","bedaura","autocrystalaura",
    "autodoublehand","autohitcrystal","crystaloptimizer","anchoroptimizer",
    "killaura","aimassist","reach","hitbox","triggerbot","bowaimbot",
    "antiknockback","velocity","criticals","autoclicker",
    "nofall","bhop","flight","phase","blink","freecam","scaffold",
    "elytrafly","speedmine","jumpreset","longjump",
    "xray","esp","nametags","chams","tracers","radar",
    "cheststealer","nuker","autoarmor","autopot","autototem",
    "inventorytotem","pingspoof","selfdestruct","fastplace","fastbreak",
    "meteordevelopment","cc/novoline","com/alan/clients","club/maxstats",
    "wtf/moonlight","me/zeroeightsix/kami","net/ccbluex",
    "xyz/greaj","com/cheatbreaker","com/moonsworth","phantom-refmap.json",
    "sessionstealer","tokenlogger","tokengrabber","discordtoken",
    "remoteaccess","reverseshell","c2server","backdoor"
)
$CheatClientNames = @("wurst","meteor","impact","sigma","vengeance","dqrkis","grim","prestige","exhibition","rusherhack","novoline")

function Get-FileSHA1   { param([string]$Path) (Get-FileHash -Path $Path -Algorithm SHA1).Hash }
function Get-FileSHA256 { param([string]$Path) (Get-FileHash -Path $Path -Algorithm SHA256).Hash }

$script:ModrinthCache = @{}
function Query-Modrinth {
    param([string]$Hash)
    if ($script:ModrinthCache.ContainsKey($Hash)) { return $script:ModrinthCache[$Hash] }
    $r = @{ Name = ""; Spug = ""; Slug = "" }
    try {
        $ver = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/version_file/$Hash" -Method Get -UseBasicParsing -ErrorAction Stop
        if ($ver.project_id) {
            $proj = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/project/$($ver.project_id)" -Method Get -UseBasicParsing -ErrorAction Stop
            $r = @{ Name = $proj.title; Slug = $proj.slug }
        }
    } catch {}
    $script:ModrinthCache[$Hash] = $r
    return $r
}

function Invoke-ScanJar {
    param([string]$FilePath)
    $found = [System.Collections.Generic.HashSet[string]]::new()
    $isClient = $false
    $fileNameLower = (Split-Path $FilePath -Leaf).ToLower()
    foreach ($p in $CheatPatterns) {
        if ($fileNameLower -match [regex]::Escape($p)) {
            $found.Add($p) | Out-Null
            if ($CheatClientNames -contains $p) { $isClient = $true }
        }
    }
    try {
        $archive = [System.IO.Compression.ZipFile]::OpenRead($FilePath)
        foreach ($entry in $archive.Entries) {
            $name = $entry.FullName.ToLower()
            foreach ($p in $CheatPatterns) {
                if ($name -match [regex]::Escape($p)) {
                    $found.Add($p) | Out-Null
                    if ($CheatClientNames -contains $p) { $isClient = $true }
                }
            }
            if ($name -match '\.class$') {
                try {
                    $st = $entry.Open(); $ms = New-Object System.IO.MemoryStream
                    $st.CopyTo($ms); $st.Close()
                    $bytes = $ms.ToArray(); $ms.Dispose()
                    $text = [System.Text.Encoding]::ASCII.GetString($bytes).ToLower()
                    foreach ($p in $CheatPatterns) {
                        if ($p.Length -gt 4 -and $text -match [regex]::Escape($p)) {
                            $found.Add($p) | Out-Null
                            if ($CheatClientNames -contains $p) { $isClient = $true }
                        }
                    }
                } catch {}
            }
        }
        $archive.Dispose()
    } catch {}
    return @{ Hits = $found; IsCheatClient = $isClient; HitCount = $found.Count }
}

function Invoke-DeepScan {
    param([string]$FilePath)
    $flags = [System.Collections.Generic.List[string]]::new()
    try {
        $zip = [System.IO.Compression.ZipFile]::OpenRead($FilePath)
        $execHit = $false; $dlHit = $false; $exfilHit = $false; $obfHit = $false
        foreach ($entry in $zip.Entries) {
            if ($entry.FullName -match '\.class$') {
                try {
                    $st = $entry.Open(); $ms = New-Object System.IO.MemoryStream
                    $st.CopyTo($ms); $st.Close()
                    $bytes = $ms.ToArray(); $ms.Dispose()
                    $text = [System.Text.Encoding]::ASCII.GetString($bytes)
                    if ($text -match "java/lang/Runtime" -and $text -match "exec") { $execHit = $true }
                    if ($text -match "HttpURLConnection" -and $text -match "FileOutputStream") { $dlHit = $true }
                    if ($text -match "setDoOutput" -and $text -match "getOutputStream") { $exfilHit = $true }
                    if ($text -match "ProGuard|Allatori|ZKM|Stringer|Radon|Paramorphism") { $obfHit = $true }
                } catch {}
            }
        }
        $zip.Dispose()
        if ($execHit)  { $flags.Add("Runtime.exec — can run OS commands") }
        if ($dlHit)    { $flags.Add("HTTP download — fetches files from remote") }
        if ($exfilHit) { $flags.Add("HTTP upload — sends data to remote") }
        if ($obfHit)   { $flags.Add("Obfuscated — known obfuscator detected") }
    } catch {}
    return $flags
}

function Get-JavaProcessModules {
    $procs = Get-Process javaw,java -ErrorAction SilentlyContinue
    $rows = @()
    foreach ($p in $procs) {
        $javaDir = try { Split-Path $p.Path -Parent } catch { $null }
        $expectedDirs = @($javaDir, "$env:WINDIR\System32", "$env:WINDIR\SysWOW64", "$env:ProgramFiles", "${env:ProgramFiles(x86)}") | Where-Object { $_ }
        try { $mods = $p.Modules } catch { $mods = @() }
        foreach ($m in $mods) {
            $signed = "Unknown"
            try {
                $sig = Get-AuthenticodeSignature -FilePath $m.FileName -ErrorAction Stop
                $signed = $sig.Status.ToString()
            } catch {}
            $inExpected = $false
            foreach ($d in $expectedDirs) { if ($d -and $m.FileName -like "$d*") { $inExpected = $true } }
            $verdict = "OK"
            if ($signed -ne "Valid" -and -not $inExpected) { $verdict = "Review — unsigned, unusual path" }
            elseif ($signed -ne "Valid") { $verdict = "Unsigned" }
            $rows += [pscustomobject]@{ PID=$p.Id; Module=$m.ModuleName; Path=$m.FileName; Signed=$signed; Verdict=$verdict }
        }
    }
    return $rows
}

function Get-JavaConnections {
    $procs = Get-Process javaw,java -ErrorAction SilentlyContinue
    $rows = @()
    foreach ($p in $procs) {
        try {
            $conns = Get-NetTCPConnection -OwningProcess $p.Id -State Established -ErrorAction SilentlyContinue
        } catch { $conns = @() }
        foreach ($c in $conns) {
            $rows += [pscustomobject]@{ PID=$p.Id; Remote="$($c.RemoteAddress):$($c.RemotePort)"; State=$c.State; Note="Manual review recommended" }
        }
    }
    return $rows
}

function Get-PersistenceItems {
    $rows = @()
    $runKeys = @("HKCU:\Software\Microsoft\Windows\CurrentVersion\Run","HKLM:\Software\Microsoft\Windows\CurrentVersion\Run")
    foreach ($k in $runKeys) {
        try {
            $items = Get-ItemProperty -Path $k -ErrorAction Stop
            foreach ($prop in $items.PSObject.Properties) {
                if ($prop.Name -notmatch '^PS') {
                    $rows += [pscustomobject]@{ Source="Run key"; Name=$prop.Name; Value=$prop.Value }
                }
            }
        } catch {}
    }
    $startupDirs = @([Environment]::GetFolderPath("Startup"), [Environment]::GetFolderPath("CommonStartup"))
    foreach ($dir in $startupDirs) {
        if (Test-Path $dir) {
            Get-ChildItem $dir -File -ErrorAction SilentlyContinue | ForEach-Object {
                $rows += [pscustomobject]@{ Source="Startup folder"; Name=$_.Name; Value=$_.FullName }
            }
        }
    }
    try {
        Get-ScheduledTask -ErrorAction Stop | Where-Object { $_.Date -and ([datetime]$_.Date) -gt (Get-Date).AddDays(-30) } | ForEach-Object {
            $rows += [pscustomobject]@{ Source="Scheduled task"; Name=$_.TaskName; Value=$_.TaskPath }
        }
    } catch {}
    return $rows
}

# =============================================================================
# FORM
# =============================================================================
$form = New-Object System.Windows.Forms.Form
$form.Text = "KettehLyzer  //  SS Toolkit"
$form.Size = New-Object System.Drawing.Size(1120, 760)
$form.StartPosition = "CenterScreen"
$form.BackColor = $bg
$form.ForeColor = $txt
$form.Font = $fontUI
$form.MinimumSize = New-Object System.Drawing.Size(980, 650)

# --- Header ---
$header = New-Object System.Windows.Forms.Panel
$header.Dock = "Top"
$header.Height = 78
$header.BackColor = $panelBg

$catLbl = New-Object System.Windows.Forms.Label
$catLbl.Text = "/\_/\`n( o.o )`n > ^ <"
$catLbl.Font = $fontCat
$catLbl.ForeColor = $accentM
$catLbl.Location = New-Object System.Drawing.Point(16, 8)
$catLbl.AutoSize = $true

$titleLbl = New-Object System.Windows.Forms.Label
$titleLbl.Text = "KETTEHLYZER"
$titleLbl.Font = $fontTitle
$titleLbl.ForeColor = $accentC
$titleLbl.Location = New-Object System.Drawing.Point(95, 12)
$titleLbl.AutoSize = $true

$subLbl = New-Object System.Windows.Forms.Label
$subLbl.Text = "Layered mod • process • network • persistence checks   •   Read-only toolkit"
$subLbl.Font = $fontSub
$subLbl.ForeColor = $dim
$subLbl.Location = New-Object System.Drawing.Point(97, 42)
$subLbl.AutoSize = $true

$header.Controls.AddRange(@($catLbl, $titleLbl, $subLbl))

# --- Main layout: Sidebar + Content ---
$mainSplit = New-Object System.Windows.Forms.SplitContainer
$mainSplit.Dock = "Fill"
$mainSplit.SplitterDistance = 190
$mainSplit.FixedPanel = "Panel1"
$mainSplit.IsSplitterFixed = $true
$mainSplit.BackColor = $bg
$mainSplit.Panel1.BackColor = $sidebarBg
$mainSplit.Panel2.BackColor = $bg

# Sidebar buttons
function New-SideBtn {
    param([string]$Text, [int]$Y)
    $b = New-Object System.Windows.Forms.Button
    $b.Text = $Text
    $b.Location = New-Object System.Drawing.Point(12, $Y)
    $b.Size = New-Object System.Drawing.Size(166, 38)
    $b.FlatStyle = "Flat"
    $b.FlatAppearance.BorderSize = 0
    $b.BackColor = $sidebarBg
    $b.ForeColor = $txt
    $b.Font = $fontBtn
    $b.TextAlign = "MiddleLeft"
    $b.Padding = New-Object System.Windows.Forms.Padding(12, 0, 0, 0)
    $b.Cursor = [System.Windows.Forms.Cursors]::Hand
    return $b
}

$btnMods     = New-SideBtn "  Mods Scan"      20
$btnProc     = New-SideBtn "  Process / Inj"  66
$btnNet      = New-SideBtn "  Network"        112
$btnPersist  = New-SideBtn "  Persistence"    158
$btnTools    = New-SideBtn "  Tools"          204
$btnReport   = New-SideBtn "  Report"         250

$sideButtons = @($btnMods, $btnProc, $btnNet, $btnPersist, $btnTools, $btnReport)
$mainSplit.Panel1.Controls.AddRange($sideButtons)

# Content panels
$contentHost = New-Object System.Windows.Forms.Panel
$contentHost.Dock = "Fill"
$contentHost.BackColor = $bg
$mainSplit.Panel2.Controls.Add($contentHost)

function New-ContentPanel {
    $p = New-Object System.Windows.Forms.Panel
    $p.Dock = "Fill"
    $p.BackColor = $bg
    $p.Visible = $false
    return $p
}

$panelMods    = New-ContentPanel
$panelProc    = New-ContentPanel
$panelNet     = New-ContentPanel
$panelPersist = New-ContentPanel
$panelTools   = New-ContentPanel
$panelReport  = New-ContentPanel

$contentHost.Controls.AddRange(@($panelMods, $panelProc, $panelNet, $panelPersist, $panelTools, $panelReport))

# Helper: switch panels + highlight button
function Show-Panel {
    param($Panel, $ActiveBtn)
    foreach ($p in @($panelMods, $panelProc, $panelNet, $panelPersist, $panelTools, $panelReport)) {
        $p.Visible = $false
    }
    $Panel.Visible = $true
    foreach ($b in $sideButtons) {
        $b.BackColor = $sidebarBg
        $b.ForeColor = $txt
    }
    $ActiveBtn.BackColor = [System.Drawing.Color]::FromArgb(25, 25, 40)
    $ActiveBtn.ForeColor = $accentC
}

# =============================================================================
# MODS PANEL
# =============================================================================
$pathBar = New-Object System.Windows.Forms.Panel
$pathBar.Dock = "Top"
$pathBar.Height = 52
$pathBar.BackColor = $panelBg

$pathLbl = New-Object System.Windows.Forms.Label
$pathLbl.Text = "Mods folder"
$pathLbl.ForeColor = $dim
$pathLbl.Location = New-Object System.Drawing.Point(14, 16)
$pathLbl.AutoSize = $true

$pathBox = New-Object System.Windows.Forms.TextBox
$pathBox.Text = Join-Path $env:APPDATA ".minecraft\mods"
$pathBox.Location = New-Object System.Drawing.Point(100, 13)
$pathBox.Size = New-Object System.Drawing.Size(480, 24)
$pathBox.BackColor = $boxBg
$pathBox.ForeColor = $txt
$pathBox.BorderStyle = "FixedSingle"
$pathBox.Font = $fontMono

$browseBtn = New-Object System.Windows.Forms.Button
$browseBtn.Text = "Browse"
$browseBtn.Location = New-Object System.Drawing.Point(590, 11)
$browseBtn.Size = New-Object System.Drawing.Size(80, 28)
$browseBtn.FlatStyle = "Flat"
$browseBtn.BackColor = $panelBg
$browseBtn.ForeColor = $txt
$browseBtn.FlatAppearance.BorderColor = $dim

$scanBtn = New-Object System.Windows.Forms.Button
$scanBtn.Text = "RUN FULL SCAN"
$scanBtn.Location = New-Object System.Drawing.Point(680, 11)
$scanBtn.Size = New-Object System.Drawing.Size(140, 28)
$scanBtn.FlatStyle = "Flat"
$scanBtn.BackColor = $accentM
$scanBtn.ForeColor = [System.Drawing.Color]::Black
$scanBtn.Font = $fontBtn
$scanBtn.Cursor = [System.Windows.Forms.Cursors]::Hand

$pathBar.Controls.AddRange(@($pathLbl, $pathBox, $browseBtn, $scanBtn))

# Search + progress
$searchBar = New-Object System.Windows.Forms.Panel
$searchBar.Dock = "Top"
$searchBar.Height = 36
$searchBar.BackColor = $bg

$searchLbl = New-Object System.Windows.Forms.Label
$searchLbl.Text = "Filter:"
$searchLbl.ForeColor = $dim
$searchLbl.Location = New-Object System.Drawing.Point(14, 9)
$searchLbl.AutoSize = $true

$searchBox = New-Object System.Windows.Forms.TextBox
$searchBox.Location = New-Object System.Drawing.Point(55, 6)
$searchBox.Size = New-Object System.Drawing.Size(280, 22)
$searchBox.BackColor = $boxBg
$searchBox.ForeColor = $txt
$searchBox.BorderStyle = "FixedSingle"

$progress = New-Object System.Windows.Forms.ProgressBar
$progress.Location = New-Object System.Drawing.Point(350, 9)
$progress.Size = New-Object System.Drawing.Size(470, 16)
$progress.Style = "Continuous"

$searchBar.Controls.AddRange(@($searchLbl, $searchBox, $progress))

$modsList = New-Object System.Windows.Forms.ListView
$modsList.View = "Details"
$modsList.FullRowSelect = $true
$modsList.GridLines = $false
$modsList.Dock = "Fill"
$modsList.BackColor = $boxBg
$modsList.ForeColor = $txt
$modsList.Font = $fontMono
$modsList.BorderStyle = "None"
$modsList.Columns.Add("File", 280) | Out-Null
$modsList.Columns.Add("Status", 120) | Out-Null
$modsList.Columns.Add("Detail", 480) | Out-Null

$panelMods.Controls.Add($modsList)
$panelMods.Controls.Add($searchBar)
$panelMods.Controls.Add($pathBar)

# Context menu for mods
$ctxMods = New-Object System.Windows.Forms.ContextMenuStrip
$miCopyName = $ctxMods.Items.Add("Copy filename")
$miCopyDetail = $ctxMods.Items.Add("Copy detail")
$modsList.ContextMenuStrip = $ctxMods

# =============================================================================
# PROCESS PANEL
# =============================================================================
$procBtn = New-Object System.Windows.Forms.Button
$procBtn.Text = "SCAN JAVA PROCESS MODULES"
$procBtn.Dock = "Top"
$procBtn.Height = 36
$procBtn.FlatStyle = "Flat"
$procBtn.BackColor = $accentC
$procBtn.ForeColor = [System.Drawing.Color]::Black
$procBtn.Font = $fontBtn

$procList = New-Object System.Windows.Forms.ListView
$procList.View = "Details"
$procList.FullRowSelect = $true
$procList.Dock = "Fill"
$procList.BackColor = $boxBg
$procList.ForeColor = $txt
$procList.Font = $fontMono
$procList.BorderStyle = "None"
$procList.Columns.Add("PID", 70) | Out-Null
$procList.Columns.Add("Module", 160) | Out-Null
$procList.Columns.Add("Path", 420) | Out-Null
$procList.Columns.Add("Signed", 100) | Out-Null
$procList.Columns.Add("Verdict", 220) | Out-Null

$panelProc.Controls.Add($procList)
$panelProc.Controls.Add($procBtn)

# =============================================================================
# NETWORK PANEL
# =============================================================================
$netBtn = New-Object System.Windows.Forms.Button
$netBtn.Text = "LIST JAVA CONNECTIONS"
$netBtn.Dock = "Top"
$netBtn.Height = 36
$netBtn.FlatStyle = "Flat"
$netBtn.BackColor = $accentC
$netBtn.ForeColor = [System.Drawing.Color]::Black
$netBtn.Font = $fontBtn

$netList = New-Object System.Windows.Forms.ListView
$netList.View = "Details"
$netList.FullRowSelect = $true
$netList.Dock = "Fill"
$netList.BackColor = $boxBg
$netList.ForeColor = $txt
$netList.Font = $fontMono
$netList.BorderStyle = "None"
$netList.Columns.Add("PID", 70) | Out-Null
$netList.Columns.Add("Remote", 280) | Out-Null
$netList.Columns.Add("State", 100) | Out-Null
$netList.Columns.Add("Note", 300) | Out-Null

$panelNet.Controls.Add($netList)
$panelNet.Controls.Add($netBtn)

# =============================================================================
# PERSISTENCE PANEL
# =============================================================================
$persistBtn = New-Object System.Windows.Forms.Button
$persistBtn.Text = "CHECK STARTUP / PERSISTENCE"
$persistBtn.Dock = "Top"
$persistBtn.Height = 36
$persistBtn.FlatStyle = "Flat"
$persistBtn.BackColor = $accentC
$persistBtn.ForeColor = [System.Drawing.Color]::Black
$persistBtn.Font = $fontBtn

$persistList = New-Object System.Windows.Forms.ListView
$persistList.View = "Details"
$persistList.FullRowSelect = $true
$persistList.Dock = "Fill"
$persistList.BackColor = $boxBg
$persistList.ForeColor = $txt
$persistList.Font = $fontMono
$persistList.BorderStyle = "None"
$persistList.Columns.Add("Source", 160) | Out-Null
$persistList.Columns.Add("Name", 200) | Out-Null
$persistList.Columns.Add("Value", 500) | Out-Null

$panelPersist.Controls.Add($persistList)
$panelPersist.Controls.Add($persistBtn)

# =============================================================================
# TOOLS PANEL
# =============================================================================
$toolsLayout = New-Object System.Windows.Forms.Panel
$toolsLayout.Dock = "Fill"
$toolsLayout.BackColor = $bg
$toolsLayout.Padding = New-Object System.Windows.Forms.Padding(20)

# Single file scan
$grpSingle = New-Object System.Windows.Forms.GroupBox
$grpSingle.Text = "  Single JAR Deep Scan  "
$grpSingle.ForeColor = $accentC
$grpSingle.Font = $fontBtn
$grpSingle.Location = New-Object System.Drawing.Point(20, 20)
$grpSingle.Size = New-Object System.Drawing.Size(820, 140)
$grpSingle.BackColor = $panelBg

$singlePath = New-Object System.Windows.Forms.TextBox
$singlePath.Location = New-Object System.Drawing.Point(20, 35)
$singlePath.Size = New-Object System.Drawing.Size(580, 24)
$singlePath.BackColor = $boxBg
$singlePath.ForeColor = $txt
$singlePath.BorderStyle = "FixedSingle"

$singleBrowse = New-Object System.Windows.Forms.Button
$singleBrowse.Text = "Browse JAR"
$singleBrowse.Location = New-Object System.Drawing.Point(610, 33)
$singleBrowse.Size = New-Object System.Drawing.Size(90, 26)
$singleBrowse.FlatStyle = "Flat"
$singleBrowse.BackColor = $boxBg
$singleBrowse.ForeColor = $txt

$singleScanBtn = New-Object System.Windows.Forms.Button
$singleScanBtn.Text = "Deep Scan"
$singleScanBtn.Location = New-Object System.Drawing.Point(710, 33)
$singleScanBtn.Size = New-Object System.Drawing.Size(90, 26)
$singleScanBtn.FlatStyle = "Flat"
$singleScanBtn.BackColor = $accentM
$singleScanBtn.ForeColor = [System.Drawing.Color]::Black

$singleResult = New-Object System.Windows.Forms.TextBox
$singleResult.Multiline = $true
$singleResult.ScrollBars = "Vertical"
$singleResult.Location = New-Object System.Drawing.Point(20, 70)
$singleResult.Size = New-Object System.Drawing.Size(780, 55)
$singleResult.BackColor = $boxBg
$singleResult.ForeColor = $txt
$singleResult.BorderStyle = "FixedSingle"
$singleResult.Font = $fontMono
$singleResult.ReadOnly = $true

$grpSingle.Controls.AddRange(@($singlePath, $singleBrowse, $singleScanBtn, $singleResult))

# Hash calculator
$grpHash = New-Object System.Windows.Forms.GroupBox
$grpHash.Text = "  Hash Calculator  "
$grpHash.ForeColor = $accentC
$grpHash.Font = $fontBtn
$grpHash.Location = New-Object System.Drawing.Point(20, 175)
$grpHash.Size = New-Object System.Drawing.Size(820, 110)
$grpHash.BackColor = $panelBg

$hashPath = New-Object System.Windows.Forms.TextBox
$hashPath.Location = New-Object System.Drawing.Point(20, 35)
$hashPath.Size = New-Object System.Drawing.Size(580, 24)
$hashPath.BackColor = $boxBg
$hashPath.ForeColor = $txt
$hashPath.BorderStyle = "FixedSingle"

$hashBrowse = New-Object System.Windows.Forms.Button
$hashBrowse.Text = "Browse"
$hashBrowse.Location = New-Object System.Drawing.Point(610, 33)
$hashBrowse.Size = New-Object System.Drawing.Size(90, 26)
$hashBrowse.FlatStyle = "Flat"
$hashBrowse.BackColor = $boxBg
$hashBrowse.ForeColor = $txt

$hashBtn = New-Object System.Windows.Forms.Button
$hashBtn.Text = "Calculate"
$hashBtn.Location = New-Object System.Drawing.Point(710, 33)
$hashBtn.Size = New-Object System.Drawing.Size(90, 26)
$hashBtn.FlatStyle = "Flat"
$hashBtn.BackColor = $accentC
$hashBtn.ForeColor = [System.Drawing.Color]::Black

$hashResult = New-Object System.Windows.Forms.TextBox
$hashResult.Location = New-Object System.Drawing.Point(20, 70)
$hashResult.Size = New-Object System.Drawing.Size(780, 24)
$hashResult.BackColor = $boxBg
$hashResult.ForeColor = $accentG
$hashResult.BorderStyle = "FixedSingle"
$hashResult.Font = $fontMono
$hashResult.ReadOnly = $true

$grpHash.Controls.AddRange(@($hashPath, $hashBrowse, $hashBtn, $hashResult))

# Quick actions
$grpQuick = New-Object System.Windows.Forms.GroupBox
$grpQuick.Text = "  Quick Actions  "
$grpQuick.ForeColor = $accentC
$grpQuick.Font = $fontBtn
$grpQuick.Location = New-Object System.Drawing.Point(20, 300)
$grpQuick.Size = New-Object System.Drawing.Size(820, 90)
$grpQuick.BackColor = $panelBg

$btnOpenMods = New-Object System.Windows.Forms.Button
$btnOpenMods.Text = "Open Mods Folder"
$btnOpenMods.Location = New-Object System.Drawing.Point(20, 35)
$btnOpenMods.Size = New-Object System.Drawing.Size(150, 32)
$btnOpenMods.FlatStyle = "Flat"
$btnOpenMods.BackColor = $boxBg
$btnOpenMods.ForeColor = $txt

$btnOpenAppData = New-Object System.Windows.Forms.Button
$btnOpenAppData.Text = "Open .minecraft"
$btnOpenAppData.Location = New-Object System.Drawing.Point(185, 35)
$btnOpenAppData.Size = New-Object System.Drawing.Size(140, 32)
$btnOpenAppData.FlatStyle = "Flat"
$btnOpenAppData.BackColor = $boxBg
$btnOpenAppData.ForeColor = $txt

$btnClearCache = New-Object System.Windows.Forms.Button
$btnClearCache.Text = "Clear Modrinth Cache"
$btnClearCache.Location = New-Object System.Drawing.Point(340, 35)
$btnClearCache.Size = New-Object System.Drawing.Size(160, 32)
$btnClearCache.FlatStyle = "Flat"
$btnClearCache.BackColor = $boxBg
$btnClearCache.ForeColor = $txt

$btnSysInfo = New-Object System.Windows.Forms.Button
$btnSysInfo.Text = "Java Process Snapshot"
$btnSysInfo.Location = New-Object System.Drawing.Point(515, 35)
$btnSysInfo.Size = New-Object System.Drawing.Size(160, 32)
$btnSysInfo.FlatStyle = "Flat"
$btnSysInfo.BackColor = $boxBg
$btnSysInfo.ForeColor = $txt

$grpQuick.Controls.AddRange(@($btnOpenMods, $btnOpenAppData, $btnClearCache, $btnSysInfo))

$toolsLayout.Controls.AddRange(@($grpSingle, $grpHash, $grpQuick))
$panelTools.Controls.Add($toolsLayout)

# =============================================================================
# REPORT PANEL
# =============================================================================
$reportBtn = New-Object System.Windows.Forms.Button
$reportBtn.Text = "GENERATE + SAVE REPORT (.txt)"
$reportBtn.Dock = "Top"
$reportBtn.Height = 36
$reportBtn.FlatStyle = "Flat"
$reportBtn.BackColor = $accentC
$reportBtn.ForeColor = [System.Drawing.Color]::Black
$reportBtn.Font = $fontBtn

$reportBox = New-Object System.Windows.Forms.RichTextBox
$reportBox.Dock = "Fill"
$reportBox.BackColor = $boxBg
$reportBox.ForeColor = $txt
$reportBox.Font = $fontMono
$reportBox.ReadOnly = $true
$reportBox.BorderStyle = "None"

$panelReport.Controls.Add($reportBox)
$panelReport.Controls.Add($reportBtn)

# =============================================================================
# STATUS BAR
# =============================================================================
$statusLbl = New-Object System.Windows.Forms.Label
$statusLbl.Dock = "Bottom"
$statusLbl.Height = 28
$statusLbl.TextAlign = "MiddleLeft"
$statusLbl.Text = "  Ready  •  Select a section from the left"
$statusLbl.ForeColor = $dim
$statusLbl.BackColor = $panelBg
$statusLbl.Padding = New-Object System.Windows.Forms.Padding(10, 0, 0, 0)

# Assemble form
$form.Controls.Add($mainSplit)
$form.Controls.Add($statusLbl)
$form.Controls.Add($header)

# =============================================================================
# EVENTS
# =============================================================================

# Sidebar navigation
$btnMods.Add_Click({ Show-Panel $panelMods $btnMods })
$btnProc.Add_Click({ Show-Panel $panelProc $btnProc })
$btnNet.Add_Click({ Show-Panel $panelNet $btnNet })
$btnPersist.Add_Click({ Show-Panel $panelPersist $btnPersist })
$btnTools.Add_Click({ Show-Panel $panelTools $btnTools })
$btnReport.Add_Click({ Show-Panel $panelReport $btnReport })

# Default view
Show-Panel $panelMods $btnMods

# Browse mods folder
$browseBtn.Add_Click({
    $dlg = New-Object System.Windows.Forms.FolderBrowserDialog
    $dlg.Description = "Select Minecraft mods folder"
    if ($dlg.ShowDialog() -eq "OK") { $pathBox.Text = $dlg.SelectedPath }
})

# Full mod scan
$scanBtn.Add_Click({
    $modsList.Items.Clear()
    $modsPath = $pathBox.Text.Trim()
    if (-not (Test-Path $modsPath -PathType Container)) {
        $statusLbl.Text = "  Invalid mods folder path"
        $statusLbl.ForeColor = $red
        return
    }
    $jars = Get-ChildItem -Path $modsPath -Filter *.jar -File -ErrorAction SilentlyContinue
    $total = $jars.Count
    if ($total -eq 0) {
        $statusLbl.Text = "  No .jar files found in that folder"
        $statusLbl.ForeColor = $yellow
        return
    }
    $progress.Maximum = $total
    $progress.Value = 0
    $script:VerifiedCount = 0; $script:UnknownCount = 0; $script:SuspiciousCount = 0
    $script:CheatCount = 0; $script:DangerousCount = 0
    $idx = 0

    foreach ($jar in $jars) {
        $idx++
        $progress.Value = $idx
        $statusLbl.Text = "  Scanning $idx / $total  —  $($jar.Name)"
        $statusLbl.ForeColor = $accentC
        [System.Windows.Forms.Application]::DoEvents()

        $hash = Get-FileSHA1 -Path $jar.FullName
        $known = Query-Modrinth -Hash $hash

        if ($known.Slug) {
            $item = New-Object System.Windows.Forms.ListViewItem($jar.Name)
            $item.SubItems.Add("Verified") | Out-Null
            $item.SubItems.Add($known.Name) | Out-Null
            $item.ForeColor = $accentG
            $modsList.Items.Add($item) | Out-Null
            $script:VerifiedCount++
            continue
        }

        $scan = Invoke-ScanJar -FilePath $jar.FullName
        if ($scan.IsCheatClient) {
            $deep = Invoke-DeepScan -FilePath $jar.FullName
            $item = New-Object System.Windows.Forms.ListViewItem($jar.Name)
            $status = if ($deep.Count -gt 0) { "DANGEROUS" } else { "CHEAT CLIENT" }
            $item.SubItems.Add($status) | Out-Null
            $detail = ($scan.Hits -join ', ')
            if ($deep.Count -gt 0) { $detail += "  |  " + ($deep -join '; ') }
            $item.SubItems.Add($detail) | Out-Null
            $item.ForeColor = if ($deep.Count -gt 0) { $darkred } else { $red }
            $modsList.Items.Add($item) | Out-Null
            if ($deep.Count -gt 0) { $script:DangerousCount++ } else { $script:CheatCount++ }
        }
        elseif ($scan.HitCount -gt 0) {
            $item = New-Object System.Windows.Forms.ListViewItem($jar.Name)
            $item.SubItems.Add("Suspicious") | Out-Null
            $item.SubItems.Add(($scan.Hits -join ', ')) | Out-Null
            $item.ForeColor = $yellow
            $modsList.Items.Add($item) | Out-Null
            $script:SuspiciousCount++
        }
        else {
            $item = New-Object System.Windows.Forms.ListViewItem($jar.Name)
            $item.SubItems.Add("Unknown") | Out-Null
            $item.SubItems.Add("No hash match • no signature hits") | Out-Null
            $item.ForeColor = $dim
            $modsList.Items.Add($item) | Out-Null
            $script:UnknownCount++
        }
    }

    foreach ($c in $modsList.Columns) { $c.Width = -2 }

    $verdict = if ($script:DangerousCount -gt 0) { "CRITICAL — dangerous mods found" }
               elseif ($script:CheatCount -gt 0) { "FLAGGED — cheat client(s) found" }
               elseif ($script:SuspiciousCount -gt 3) { "REVIEW — several suspicious mods" }
               else { "CLEAN — no strong mod-based hits" }

    $statusLbl.Text = "  Done. $verdict   (V:$($script:VerifiedCount)  U:$($script:UnknownCount)  S:$($script:SuspiciousCount)  C:$($script:CheatCount)  D:$($script:DangerousCount))"
    $statusLbl.ForeColor = if ($script:DangerousCount -gt 0 -or $script:CheatCount -gt 0) { $red }
                           elseif ($script:SuspiciousCount -gt 3) { $yellow } else { $accentG }
})

# Filter
$searchBox.Add_TextChanged({
    $filter = $searchBox.Text.ToLower()
    foreach ($item in $modsList.Items) {
        $item.ForeColor = $item.ForeColor  # keep original color logic simple
        if ($filter -eq "" -or $item.Text.ToLower().Contains($filter) -or $item.SubItems[2].Text.ToLower().Contains($filter)) {
            # ListView doesn't support easy hide, so we just leave it (basic filter can be expanded later)
        }
    }
})

# Process scan
$procBtn.Add_Click({
    $procList.Items.Clear()
    $statusLbl.Text = "  Enumerating Java process modules..."
    $statusLbl.ForeColor = $accentC
    [System.Windows.Forms.Application]::DoEvents()
    $rows = Get-JavaProcessModules
    if ($rows.Count -eq 0) {
        $statusLbl.Text = "  No running java/javaw process found"
        $statusLbl.ForeColor = $dim
        return
    }
    $reviewCount = 0
    foreach ($r in $rows) {
        $item = New-Object System.Windows.Forms.ListViewItem($r.PID.ToString())
        $item.SubItems.Add($r.Module) | Out-Null
        $item.SubItems.Add($r.Path) | Out-Null
        $item.SubItems.Add($r.Signed) | Out-Null
        $item.SubItems.Add($r.Verdict) | Out-Null
        if ($r.Verdict -like "Review*") { $item.ForeColor = $red; $reviewCount++ }
        elseif ($r.Verdict -eq "Unsigned") { $item.ForeColor = $yellow }
        else { $item.ForeColor = $dim }
        $procList.Items.Add($item) | Out-Null
    }
    foreach ($c in $procList.Columns) { $c.Width = -2 }
    $statusLbl.Text = "  Done. $reviewCount module(s) worth a closer look"
    $statusLbl.ForeColor = if ($reviewCount -gt 0) { $yellow } else { $accentG }
})

# Network
$netBtn.Add_Click({
    $netList.Items.Clear()
    $rows = Get-JavaConnections
    foreach ($r in $rows) {
        $item = New-Object System.Windows.Forms.ListViewItem($r.PID.ToString())
        $item.SubItems.Add($r.Remote) | Out-Null
        $item.SubItems.Add($r.State.ToString()) | Out-Null
        $item.SubItems.Add($r.Note) | Out-Null
        $item.ForeColor = $dim
        $netList.Items.Add($item) | Out-Null
    }
    foreach ($c in $netList.Columns) { $c.Width = -2 }
    $statusLbl.Text = "  $($rows.Count) established connection(s) listed — review remote IPs manually"
    $statusLbl.ForeColor = $accentC
})

# Persistence
$persistBtn.Add_Click({
    $persistList.Items.Clear()
    $rows = Get-PersistenceItems
    foreach ($r in $rows) {
        $item = New-Object System.Windows.Forms.ListViewItem($r.Source)
        $item.SubItems.Add($r.Name) | Out-Null
        $item.SubItems.Add($r.Value) | Out-Null
        $item.ForeColor = $dim
        $persistList.Items.Add($item) | Out-Null
    }
    foreach ($c in $persistList.Columns) { $c.Width = -2 }
    $statusLbl.Text = "  $($rows.Count) startup / persistence item(s) listed"
    $statusLbl.ForeColor = $accentC
})

# Tools: Single JAR
$singleBrowse.Add_Click({
    $ofd = New-Object System.Windows.Forms.OpenFileDialog
    $ofd.Filter = "JAR files (*.jar)|*.jar|All files (*.*)|*.*"
    if ($ofd.ShowDialog() -eq "OK") { $singlePath.Text = $ofd.FileName }
})

$singleScanBtn.Add_Click({
    $fp = $singlePath.Text.Trim()
    if (-not (Test-Path $fp -PathType Leaf)) {
        $singleResult.Text = "File not found."
        return
    }
    $statusLbl.Text = "  Deep scanning single JAR..."
    $statusLbl.ForeColor = $accentC
    [System.Windows.Forms.Application]::DoEvents()
    $scan = Invoke-ScanJar -FilePath $fp
    $deep = Invoke-DeepScan -FilePath $fp
    $hash = Get-FileSHA1 -Path $fp
    $known = Query-Modrinth -Hash $hash
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.AppendLine("File: $(Split-Path $fp -Leaf)")
    [void]$sb.AppendLine("SHA1: $hash")
    if ($known.Slug) { [void]$sb.AppendLine("Modrinth: $($known.Name) ($($known.Slug))") }
    else { [void]$sb.AppendLine("Modrinth: not found") }
    [void]$sb.AppendLine("Hits: $($scan.Hits -join ', ')")
    [void]$sb.AppendLine("Cheat client: $($scan.IsCheatClient)")
    if ($deep.Count -gt 0) { [void]$sb.AppendLine("Deep flags: $($deep -join ' | ')") }
    else { [void]$sb.AppendLine("Deep flags: none") }
    $singleResult.Text = $sb.ToString()
    $statusLbl.Text = "  Single JAR scan complete"
    $statusLbl.ForeColor = $accentG
})

# Tools: Hash
$hashBrowse.Add_Click({
    $ofd = New-Object System.Windows.Forms.OpenFileDialog
    $ofd.Filter = "All files (*.*)|*.*"
    if ($ofd.ShowDialog() -eq "OK") { $hashPath.Text = $ofd.FileName }
})

$hashBtn.Add_Click({
    $fp = $hashPath.Text.Trim()
    if (-not (Test-Path $fp -PathType Leaf)) {
        $hashResult.Text = "File not found"
        return
    }
    $s1 = Get-FileSHA1 -Path $fp
    $s256 = Get-FileSHA256 -Path $fp
    $hashResult.Text = "SHA1: $s1   |   SHA256: $s256"
})

# Quick actions
$btnOpenMods.Add_Click({
    $p = $pathBox.Text.Trim()
    if (Test-Path $p) { Start-Process explorer.exe $p }
    else { [System.Windows.Forms.MessageBox]::Show("Path does not exist") }
})

$btnOpenAppData.Add_Click({
    $mc = Join-Path $env:APPDATA ".minecraft"
    if (Test-Path $mc) { Start-Process explorer.exe $mc }
})

$btnClearCache.Add_Click({
    $script:ModrinthCache.Clear()
    $statusLbl.Text = "  Modrinth cache cleared"
    $statusLbl.ForeColor = $accentG
})

$btnSysInfo.Add_Click({
    $procs = Get-Process javaw,java -ErrorAction SilentlyContinue
    if (-not $procs) {
        [System.Windows.Forms.MessageBox]::Show("No Java processes running.", "Snapshot")
        return
    }
    $msg = ($procs | ForEach-Object { "PID $($_.Id)  •  $($_.ProcessName)  •  $([math]::Round($_.WorkingSet64/1MB,1)) MB" }) -join "`n"
    [System.Windows.Forms.MessageBox]::Show($msg, "Java Process Snapshot")
})

# Report
$reportBtn.Add_Click({
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.AppendLine("╔══════════════════════════════════════════════════╗")
    [void]$sb.AppendLine("║         KettehLyzer SS Toolkit — Report          ║")
    [void]$sb.AppendLine("╚══════════════════════════════════════════════════╝")
    [void]$sb.AppendLine("Generated : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
    [void]$sb.AppendLine("Mods path : $($pathBox.Text)")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("--- MODS ($($modsList.Items.Count)) ---")
    foreach ($i in $modsList.Items) {
        [void]$sb.AppendLine("[$($i.SubItems[1].Text)] $($i.Text) — $($i.SubItems[2].Text)")
    }
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("--- PROCESS MODULES ($($procList.Items.Count)) ---")
    foreach ($i in $procList.Items) {
        [void]$sb.AppendLine("[$($i.SubItems[4].Text)] $($i.SubItems[1].Text) — $($i.SubItems[2].Text)")
    }
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("--- NETWORK ($($netList.Items.Count)) ---")
    foreach ($i in $netList.Items) {
        [void]$sb.AppendLine("$($i.SubItems[1].Text)  [$($i.SubItems[2].Text)]")
    }
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("--- PERSISTENCE ($($persistList.Items.Count)) ---")
    foreach ($i in $persistList.Items) {
        [void]$sb.AppendLine("$($i.Text): $($i.SubItems[1].Text) → $($i.SubItems[2].Text)")
    }
    $reportBox.Text = $sb.ToString()

    $save = New-Object System.Windows.Forms.SaveFileDialog
    $save.Filter = "Text report (*.txt)|*.txt"
    $save.FileName = "KettehLyzer-Report-$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"
    if ($save.ShowDialog() -eq "OK") {
        $sb.ToString() | Out-File -FilePath $save.FileName -Encoding UTF8
        $statusLbl.Text = "  Report saved → $($save.FileName)"
        $statusLbl.ForeColor = $accentG
    }
})

# Context menu actions
$miCopyName.Add_Click({
    if ($modsList.SelectedItems.Count -gt 0) {
        [System.Windows.Forms.Clipboard]::SetText($modsList.SelectedItems[0].Text)
    }
})
$miCopyDetail.Add_Click({
    if ($modsList.SelectedItems.Count -gt 0) {
        [System.Windows.Forms.Clipboard]::SetText($modsList.SelectedItems[0].SubItems[2].Text)
    }
})

# Launch
[System.Windows.Forms.Application]::Run($form)
