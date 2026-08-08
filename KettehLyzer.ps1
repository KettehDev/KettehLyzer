Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.Windows.Forms.Application]::EnableVisualStyles()

# =============================================================================
# THEME - Refined Dark Gold / Cyber
# =============================================================================
$bg          = [System.Drawing.Color]::FromArgb(12, 11, 8)
$sidebarBg   = [System.Drawing.Color]::FromArgb(18, 16, 12)
$cardBg      = [System.Drawing.Color]::FromArgb(22, 20, 15)
$cardHover   = [System.Drawing.Color]::FromArgb(32, 28, 20)
$panelBg     = [System.Drawing.Color]::FromArgb(16, 15, 11)
$gold        = [System.Drawing.Color]::FromArgb(218, 175, 55)
$goldDim     = [System.Drawing.Color]::FromArgb(160, 130, 40)
$goldBright  = [System.Drawing.Color]::FromArgb(255, 210, 80)
$txt         = [System.Drawing.Color]::FromArgb(235, 225, 200)
$dim         = [System.Drawing.Color]::FromArgb(140, 130, 110)
$green       = [System.Drawing.Color]::FromArgb(100, 200, 120)
$red         = [System.Drawing.Color]::FromArgb(230, 90, 80)
$yellow      = [System.Drawing.Color]::FromArgb(230, 190, 60)

$fontTitle   = New-Object System.Drawing.Font("Segoe UI Semibold", 18)
$fontHeader  = New-Object System.Drawing.Font("Segoe UI Semibold", 11)
$fontUI      = New-Object System.Drawing.Font("Segoe UI", 9.5)
$fontSmall   = New-Object System.Drawing.Font("Segoe UI", 8.5)
$fontMono    = New-Object System.Drawing.Font("Consolas", 9)
$fontCat     = New-Object System.Drawing.Font("Consolas", 11)
$fontCard    = New-Object System.Drawing.Font("Segoe UI Semibold", 10)
$fontDesc    = New-Object System.Drawing.Font("Segoe UI", 8)

# =============================================================================
# DETECTION ENGINE (unchanged core logic)
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
    $r = @{ Name = ""; Spug = ""; Spug = ""; Slug = "" }
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
        if ($execHit)  { $flags.Add("Runtime.exec") }
        if ($dlHit)    { $flags.Add("HTTP download") }
        if ($exfilHit) { $flags.Add("HTTP upload") }
        if ($obfHit)   { $flags.Add("Obfuscated") }
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
            if ($signed -ne "Valid" -and -not $inExpected) { $verdict = "Review" }
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
        try { $conns = Get-NetTCPConnection -OwningProcess $p.Id -State Established -ErrorAction SilentlyContinue } catch { $conns = @() }
        foreach ($c in $conns) {
            $rows += [pscustomobject]@{ PID=$p.Id; Remote="$($c.RemoteAddress):$($c.RemotePort)"; State=$c.State }
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
                $rows += [pscustomobject]@{ Source="Startup"; Name=$_.Name; Value=$_.FullName }
            }
        }
    }
    return $rows
}

# =============================================================================
# LOGGING HELPER
# =============================================================================
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $ts = Get-Date -Format "HH:mm:ss"
    $color = switch ($Level) {
        "OK"    { $green }
        "WARN"  { $yellow }
        "ERR"   { $red }
        default { $gold }
    }
    $logBox.SelectionStart = $logBox.TextLength
    $logBox.SelectionColor = $dim
    $logBox.AppendText("[$ts] ")
    $logBox.SelectionColor = $color
    $logBox.AppendText("$Message`r`n")
    $logBox.ScrollToCaret()
}

# =============================================================================
# FORM
# =============================================================================
$form = New-Object System.Windows.Forms.Form
$form.Text = "KettehLyzer  —  SS Toolkit"
$form.Size = New-Object System.Drawing.Size(1180, 780)
$form.StartPosition = "CenterScreen"
$form.BackColor = $bg
$form.ForeColor = $txt
$form.Font = $fontUI
$form.MinimumSize = New-Object System.Drawing.Size(1050, 700)

# =============================================================================
# LEFT SIDEBAR
# =============================================================================
$sidebar = New-Object System.Windows.Forms.Panel
$sidebar.Dock = "Left"
$sidebar.Width = 220
$sidebar.BackColor = $sidebarBg

# Logo area
$logoPanel = New-Object System.Windows.Forms.Panel
$logoPanel.Size = New-Object System.Drawing.Size(220, 110)
$logoPanel.Location = New-Object System.Drawing.Point(0, 0)
$logoPanel.BackColor = [System.Drawing.Color]::FromArgb(28, 24, 16)

$catLbl = New-Object System.Windows.Forms.Label
$catLbl.Text = "  /\_/\`n ( o.o )`n  > ^ <"
$catLbl.Font = $fontCat
$catLbl.ForeColor = $gold
$catLbl.Location = New-Object System.Drawing.Point(55, 18)
$catLbl.AutoSize = $true
$logoPanel.Controls.Add($catLbl)

# Actions section
$actLbl = New-Object System.Windows.Forms.Label
$actLbl.Text = "ACTIONS"
$actLbl.Font = $fontSmall
$actLbl.ForeColor = $goldDim
$actLbl.Location = New-Object System.Drawing.Point(18, 125)
$actLbl.AutoSize = $true

function New-SideAction {
    param([string]$Text, [int]$Y)
    $b = New-Object System.Windows.Forms.Button
    $b.Text = "  $Text"
    $b.Location = New-Object System.Drawing.Point(12, $Y)
    $b.Size = New-Object System.Drawing.Size(196, 34)
    $b.FlatStyle = "Flat"
    $b.FlatAppearance.BorderSize = 0
    $b.BackColor = $sidebarBg
    $b.ForeColor = $txt
    $b.Font = $fontUI
    $b.TextAlign = "MiddleLeft"
    $b.Cursor = [System.Windows.Forms.Cursors]::Hand
    return $b
}

$btnOpenMods   = New-SideAction "Open Mods Folder"   155
$btnOpenMC     = New-SideAction "Open .minecraft"    193
$btnClearCache = New-SideAction "Clear Cache"        231
$btnOpenCMD    = New-SideAction "Open PowerShell"    269

# Credits
$credLbl = New-Object System.Windows.Forms.Label
$credLbl.Text = "CREDITS"
$credLbl.Font = $fontSmall
$credLbl.ForeColor = $goldDim
$credLbl.Location = New-Object System.Drawing.Point(18, 330)
$credLbl.AutoSize = $true

$credText = New-Object System.Windows.Forms.Label
$credText.Text = "Made by cheese cat`nDiscord: cheese_cat0`nGitHub: cheesecatol"
$credText.Font = $fontSmall
$credText.ForeColor = $dim
$credText.Location = New-Object System.Drawing.Point(18, 352)
$credText.Size = New-Object System.Drawing.Size(190, 60)

$pathInfo = New-Object System.Windows.Forms.Label
$pathInfo.Text = "Mods path:`n$env:APPDATA\.minecraft\mods"
$pathInfo.Font = New-Object System.Drawing.Font("Segoe UI", 7.5)
$pathInfo.ForeColor = $dim
$pathInfo.Location = New-Object System.Drawing.Point(18, 680)
$pathInfo.Size = New-Object System.Drawing.Size(190, 50)

$sidebar.Controls.AddRange(@(
    $logoPanel, $actLbl, $btnOpenMods, $btnOpenMC, $btnClearCache, $btnOpenCMD,
    $credLbl, $credText, $pathInfo
))

# =============================================================================
# MAIN CONTENT AREA
# =============================================================================
$main = New-Object System.Windows.Forms.Panel
$main.Dock = "Fill"
$main.BackColor = $bg
$main.Padding = New-Object System.Windows.Forms.Padding(0)

# Top header bar
$header = New-Object System.Windows.Forms.Panel
$header.Dock = "Top"
$header.Height = 78
$header.BackColor = $bg

$titleLbl = New-Object System.Windows.Forms.Label
$titleLbl.Text = "Ready"
$titleLbl.Font = $fontTitle
$titleLbl.ForeColor = $txt
$titleLbl.Location = New-Object System.Drawing.Point(28, 14)
$titleLbl.AutoSize = $true

$subLbl = New-Object System.Windows.Forms.Label
$subLbl.Text = "Select a tool below to run a check"
$subLbl.Font = $fontUI
$subLbl.ForeColor = $dim
$subLbl.Location = New-Object System.Drawing.Point(30, 46)
$subLbl.AutoSize = $true

$statusBadge = New-Object System.Windows.Forms.Label
$statusBadge.Text = "  IDLE  "
$statusBadge.Font = $fontSmall
$statusBadge.ForeColor = [System.Drawing.Color]::Black
$statusBadge.BackColor = $gold
$statusBadge.Location = New-Object System.Drawing.Point(860, 22)
$statusBadge.AutoSize = $true
$statusBadge.Padding = New-Object System.Windows.Forms.Padding(8, 4, 8, 4)

$header.Controls.AddRange(@($titleLbl, $subLbl, $statusBadge))

# Category pills
$catBar = New-Object System.Windows.Forms.Panel
$catBar.Dock = "Top"
$catBar.Height = 48
$catBar.BackColor = $bg

$categories = @("All", "Mods", "Process", "Network", "Persistence", "Tools")
$script:ActiveCat = "All"
$catButtons = @{}

$xPos = 28
foreach ($cat in $categories) {
    $b = New-Object System.Windows.Forms.Button
    $b.Text = $cat
    $b.Location = New-Object System.Drawing.Point($xPos, 10)
    $b.Size = New-Object System.Drawing.Size(90, 28)
    $b.FlatStyle = "Flat"
    $b.FlatAppearance.BorderSize = 0
    $b.Font = $fontSmall
    $b.Cursor = [System.Windows.Forms.Cursors]::Hand
    if ($cat -eq "All") {
        $b.BackColor = $gold
        $b.ForeColor = [System.Drawing.Color]::Black
    } else {
        $b.BackColor = $cardBg
        $b.ForeColor = $txt
    }
    $catButtons[$cat] = $b
    $catBar.Controls.Add($b)
    $xPos += 98
}

# Card grid area
$cardHost = New-Object System.Windows.Forms.Panel
$cardHost.Dock = "Fill"
$cardHost.BackColor = $bg
$cardHost.AutoScroll = $true
$cardHost.Padding = New-Object System.Windows.Forms.Padding(20)

function New-ToolCard {
    param(
        [string]$Title,
        [string]$Desc,
        [string]$Category,
        [scriptblock]$Action,
        [int]$X,
        [int]$Y
    )
    $card = New-Object System.Windows.Forms.Panel
    $card.Size = New-Object System.Drawing.Size(210, 110)
    $card.Location = New-Object System.Drawing.Point($X, $Y)
    $card.BackColor = $cardBg
    $card.Cursor = [System.Windows.Forms.Cursors]::Hand
    $card.Tag = $Category

    $t = New-Object System.Windows.Forms.Label
    $t.Text = $Title
    $t.Font = $fontCard
    $t.ForeColor = $goldBright
    $t.Location = New-Object System.Drawing.Point(14, 16)
    $t.AutoSize = $true
    $t.Cursor = [System.Windows.Forms.Cursors]::Hand

    $d = New-Object System.Windows.Forms.Label
    $d.Text = $Desc
    $d.Font = $fontDesc
    $d.ForeColor = $dim
    $d.Location = New-Object System.Drawing.Point(14, 44)
    $d.Size = New-Object System.Drawing.Size(180, 50)
    $d.Cursor = [System.Windows.Forms.Cursors]::Hand

    $card.Controls.AddRange(@($t, $d))

    $click = {
        & $Action
    }.GetNewClosure()

    $card.Add_Click($click)
    $t.Add_Click($click)
    $d.Add_Click($click)

    # Hover effect
    $card.Add_MouseEnter({ $this.BackColor = $cardHover })
    $card.Add_MouseLeave({ $this.BackColor = $cardBg })
    $t.Add_MouseEnter({ $card.BackColor = $cardHover })
    $t.Add_MouseLeave({ $card.BackColor = $cardBg })
    $d.Add_MouseEnter({ $card.BackColor = $cardHover })
    $d.Add_MouseLeave({ $card.BackColor = $cardBg })

    return $card
}

# Define cards
$cards = @()

# Mods
$cards += New-ToolCard "Full Mod Scan" "Scan mods folder against known cheat signatures + Modrinth" "Mods" {
    Show-Results "Mods"
    Start-ModScan
} 28 20

$cards += New-ToolCard "Single JAR Scan" "Deep inspect one JAR for cheats + dangerous behaviour" "Mods" {
    Show-Results "Single"
} 250 20

$cards += New-ToolCard "Hash Lookup" "Calculate SHA1 / SHA256 and query Modrinth" "Mods" {
    Show-Results "Hash"
} 472 20

$cards += New-ToolCard "Open Mods Folder" "Open the current mods directory in Explorer" "Mods" {
    $p = Join-Path $env:APPDATA ".minecraft\mods"
    if (Test-Path $p) { Start-Process explorer $p }
    Write-Log "Opened mods folder" "OK"
} 694 20

# Process
$cards += New-ToolCard "Process Modules" "List modules loaded by java/javaw + signature check" "Process" {
    Show-Results "Process"
    Start-ProcScan
} 28 150

$cards += New-ToolCard "Java Snapshot" "Quick overview of running Java processes" "Process" {
    $procs = Get-Process javaw,java -ErrorAction SilentlyContinue
    if (-not $procs) { Write-Log "No Java processes running" "WARN"; return }
    $msg = ($procs | ForEach-Object { "PID $($_.Id)  $($_.ProcessName)  $([math]::Round($_.WorkingSet64/1MB,1)) MB" }) -join "`n"
    [System.Windows.Forms.MessageBox]::Show($msg, "Java Snapshot")
    Write-Log "Java process snapshot shown" "OK"
} 250 150

# Network
$cards += New-ToolCard "Network Connections" "List established TCP connections from Java processes" "Network" {
    Show-Results "Network"
    Start-NetScan
} 28 280

# Persistence
$cards += New-ToolCard "Persistence Check" "Run keys, Startup folder, recent scheduled tasks" "Persistence" {
    Show-Results "Persistence"
    Start-PersistScan
} 28 410

# Tools
$cards += New-ToolCard "Generate Report" "Export full results to a timestamped .txt report" "Tools" {
    Generate-Report
} 250 410

$cards += New-ToolCard "Clear Cache" "Clear Modrinth hash cache" "Tools" {
    $script:ModrinthCache.Clear()
    Write-Log "Modrinth cache cleared" "OK"
} 472 410

foreach ($c in $cards) { $cardHost.Controls.Add($c) }

# Results area (hidden by default, shown when a scan runs)
$resultsPanel = New-Object System.Windows.Forms.Panel
$resultsPanel.Dock = "Fill"
$resultsPanel.BackColor = $bg
$resultsPanel.Visible = $false

$backBtn = New-Object System.Windows.Forms.Button
$backBtn.Text = "←  Back to tools"
$backBtn.Location = New-Object System.Drawing.Point(28, 12)
$backBtn.Size = New-Object System.Drawing.Size(140, 28)
$backBtn.FlatStyle = "Flat"
$backBtn.FlatAppearance.BorderSize = 0
$backBtn.BackColor = $cardBg
$backBtn.ForeColor = $txt
$backBtn.Cursor = [System.Windows.Forms.Cursors]::Hand

$resultsList = New-Object System.Windows.Forms.ListView
$resultsList.View = "Details"
$resultsList.FullRowSelect = $true
$resultsList.Location = New-Object System.Drawing.Point(28, 50)
$resultsList.Size = New-Object System.Drawing.Size(880, 420)
$resultsList.BackColor = $cardBg
$resultsList.ForeColor = $txt
$resultsList.Font = $fontMono
$resultsList.BorderStyle = "None"
$resultsList.GridLines = $false

$resultsPanel.Controls.AddRange(@($backBtn, $resultsList))

# Activity console
$consolePanel = New-Object System.Windows.Forms.Panel
$consolePanel.Dock = "Bottom"
$consolePanel.Height = 140
$consolePanel.BackColor = [System.Drawing.Color]::FromArgb(8, 7, 5)

$consoleLbl = New-Object System.Windows.Forms.Label
$consoleLbl.Text = "ACTIVITY CONSOLE"
$consoleLbl.Font = $fontSmall
$consoleLbl.ForeColor = $goldDim
$consoleLbl.Location = New-Object System.Drawing.Point(16, 6)
$consoleLbl.AutoSize = $true

$logBox = New-Object System.Windows.Forms.RichTextBox
$logBox.Location = New-Object System.Drawing.Point(12, 26)
$logBox.Size = New-Object System.Drawing.Size(920, 100)
$logBox.BackColor = [System.Drawing.Color]::FromArgb(8, 7, 5)
$logBox.ForeColor = $txt
$logBox.Font = $fontMono
$logBox.BorderStyle = "None"
$logBox.ReadOnly = $true
$logBox.ScrollBars = "Vertical"

$consolePanel.Controls.AddRange(@($consoleLbl, $logBox))

# Assemble main
$main.Controls.Add($cardHost)
$main.Controls.Add($resultsPanel)
$main.Controls.Add($catBar)
$main.Controls.Add($header)
$main.Controls.Add($consolePanel)

$form.Controls.Add($main)
$form.Controls.Add($sidebar)

# =============================================================================
# HELPER FUNCTIONS
# =============================================================================
function Set-Status {
    param([string]$Title, [string]$Sub, [string]$Badge, [System.Drawing.Color]$BadgeColor)
    $titleLbl.Text = $Title
    $subLbl.Text = $Sub
    $statusBadge.Text = "  $Badge  "
    $statusBadge.BackColor = $BadgeColor
}

function Show-Results {
    param([string]$Mode)
    $cardHost.Visible = $false
    $resultsPanel.Visible = $true
    $resultsList.Items.Clear()
    $resultsList.Columns.Clear()
}

function Show-Cards {
    $resultsPanel.Visible = $false
    $cardHost.Visible = $true
    Set-Status "Ready" "Select a tool below to run a check" "IDLE" $gold
}

$backBtn.Add_Click({ Show-Cards })

# Category filter
foreach ($key in $catButtons.Keys) {
    $catButtons[$key].Add_Click({
        $script:ActiveCat = $this.Text
        foreach ($k in $catButtons.Keys) {
            if ($k -eq $this.Text) {
                $catButtons[$k].BackColor = $gold
                $catButtons[$k].ForeColor = [System.Drawing.Color]::Black
            } else {
                $catButtons[$k].BackColor = $cardBg
                $catButtons[$k].ForeColor = $txt
            }
        }
        foreach ($c in $cards) {
            if ($script:ActiveCat -eq "All" -or $c.Tag -eq $script:ActiveCat) {
                $c.Visible = $true
            } else {
                $c.Visible = $false
            }
        }
    }.GetNewClosure())
}

# =============================================================================
# SCAN IMPLEMENTATIONS
# =============================================================================
function Start-ModScan {
    Set-Status "Scanning Mods..." "Checking jars against signatures + Modrinth" "RUNNING" $yellow
    Write-Log "Starting full mod scan..." "INFO"

    $resultsList.Columns.Add("File", 280) | Out-Null
    $resultsList.Columns.Add("Status", 120) | Out-Null
    $resultsList.Columns.Add("Detail", 450) | Out-Null

    $modsPath = Join-Path $env:APPDATA ".minecraft\mods"
    if (-not (Test-Path $modsPath)) {
        Write-Log "Mods folder not found: $modsPath" "ERR"
        Set-Status "Error" "Mods folder missing" "ERROR" $red
        return
    }

    $jars = Get-ChildItem $modsPath -Filter *.jar -File -ErrorAction SilentlyContinue
    $total = $jars.Count
    Write-Log "Found $total jar(s)" "INFO"

    $v=0;$u=0;$s=0;$c=0;$d=0
    $idx = 0
    foreach ($jar in $jars) {
        $idx++
        [System.Windows.Forms.Application]::DoEvents()
        $hash = Get-FileSHA1 $jar.FullName
        $known = Query-Modrinth $hash

        if ($known.Slug) {
            $item = New-Object System.Windows.Forms.ListViewItem($jar.Name)
            $item.SubItems.Add("Verified") | Out-Null
            $item.SubItems.Add($known.Name) | Out-Null
            $item.ForeColor = $green
            $resultsList.Items.Add($item) | Out-Null
            $v++
            continue
        }

        $scan = Invoke-ScanJar $jar.FullName
        if ($scan.IsCheatClient) {
            $deep = Invoke-DeepScan $jar.FullName
            $item = New-Object System.Windows.Forms.ListViewItem($jar.Name)
            $st = if ($deep.Count -gt 0) { "DANGEROUS" } else { "CHEAT" }
            $item.SubItems.Add($st) | Out-Null
            $det = ($scan.Hits -join ", ")
            if ($deep.Count -gt 0) { $det += " | " + ($deep -join ", ") }
            $item.SubItems.Add($det) | Out-Null
            $item.ForeColor = if ($deep.Count -gt 0) { $red } else { $yellow }
            $resultsList.Items.Add($item) | Out-Null
            if ($deep.Count -gt 0) { $d++ } else { $c++ }
        }
        elseif ($scan.HitCount -gt 0) {
            $item = New-Object System.Windows.Forms.ListViewItem($jar.Name)
            $item.SubItems.Add("Suspicious") | Out-Null
            $item.SubItems.Add(($scan.Hits -join ", ")) | Out-Null
            $item.ForeColor = $yellow
            $resultsList.Items.Add($item) | Out-Null
            $s++
        }
        else {
            $item = New-Object System.Windows.Forms.ListViewItem($jar.Name)
            $item.SubItems.Add("Unknown") | Out-Null
            $item.SubItems.Add("No matches") | Out-Null
            $item.ForeColor = $dim
            $resultsList.Items.Add($item) | Out-Null
            $u++
        }
    }

    foreach ($col in $resultsList.Columns) { $col.Width = -2 }
    $msg = "Done — V:$v  U:$u  S:$s  C:$c  D:$d"
    Write-Log $msg "OK"
    Set-Status "Scan Complete" $msg "DONE" $green
}

function Start-ProcScan {
    Set-Status "Scanning Process..." "Enumerating Java modules" "RUNNING" $yellow
    Write-Log "Scanning Java process modules..." "INFO"

    $resultsList.Columns.Add("PID", 70) | Out-Null
    $resultsList.Columns.Add("Module", 160) | Out-Null
    $resultsList.Columns.Add("Path", 420) | Out-Null
    $resultsList.Columns.Add("Signed", 90) | Out-Null
    $resultsList.Columns.Add("Verdict", 120) | Out-Null

    $rows = Get-JavaProcessModules
    if ($rows.Count -eq 0) {
        Write-Log "No Java processes found" "WARN"
        Set-Status "No Java" "No javaw/java process running" "IDLE" $gold
        return
    }

    $review = 0
    foreach ($r in $rows) {
        $item = New-Object System.Windows.Forms.ListViewItem($r.PID.ToString())
        $item.SubItems.Add($r.Module) | Out-Null
        $item.SubItems.Add($r.Path) | Out-Null
        $item.SubItems.Add($r.Signed) | Out-Null
        $item.SubItems.Add($r.Verdict) | Out-Null
        if ($r.Verdict -eq "Review") { $item.ForeColor = $red; $review++ }
        elseif ($r.Verdict -eq "Unsigned") { $item.ForeColor = $yellow }
        else { $item.ForeColor = $dim }
        $resultsList.Items.Add($item) | Out-Null
    }
    foreach ($col in $resultsList.Columns) { $col.Width = -2 }
    Write-Log "Found $($rows.Count) modules ($review need review)" "OK"
    Set-Status "Process Scan Done" "$review module(s) flagged for review" "DONE" $green
}

function Start-NetScan {
    Set-Status "Scanning Network..." "Listing Java TCP connections" "RUNNING" $yellow
    Write-Log "Listing Java network connections..." "INFO"

    $resultsList.Columns.Add("PID", 70) | Out-Null
    $resultsList.Columns.Add("Remote", 300) | Out-Null
    $resultsList.Columns.Add("State", 120) | Out-Null

    $rows = Get-JavaConnections
    foreach ($r in $rows) {
        $item = New-Object System.Windows.Forms.ListViewItem($r.PID.ToString())
        $item.SubItems.Add($r.Remote) | Out-Null
        $item.SubItems.Add($r.State.ToString()) | Out-Null
        $item.ForeColor = $dim
        $resultsList.Items.Add($item) | Out-Null
    }
    foreach ($col in $resultsList.Columns) { $col.Width = -2 }
    Write-Log "$($rows.Count) established connection(s)" "OK"
    Set-Status "Network Scan Done" "$($rows.Count) connection(s) listed" "DONE" $green
}

function Start-PersistScan {
    Set-Status "Checking Persistence..." "Run keys + Startup + recent tasks" "RUNNING" $yellow
    Write-Log "Checking persistence locations..." "INFO"

    $resultsList.Columns.Add("Source", 140) | Out-Null
    $resultsList.Columns.Add("Name", 200) | Out-Null
    $resultsList.Columns.Add("Value", 500) | Out-Null

    $rows = Get-PersistenceItems
    foreach ($r in $rows) {
        $item = New-Object System.Windows.Forms.ListViewItem($r.Source)
        $item.SubItems.Add($r.Name) | Out-Null
        $item.SubItems.Add($r.Value) | Out-Null
        $item.ForeColor = $dim
        $resultsList.Items.Add($item) | Out-Null
    }
    foreach ($col in $resultsList.Columns) { $col.Width = -2 }
    Write-Log "$($rows.Count) persistence item(s) found" "OK"
    Set-Status "Persistence Check Done" "$($rows.Count) item(s)" "DONE" $green
}

function Generate-Report {
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.AppendLine("KettehLyzer SS Toolkit Report")
    [void]$sb.AppendLine("Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine($resultsList.Items.Count -gt 0 ? "--- Current Results ---" : "No results in view")
    foreach ($i in $resultsList.Items) {
        $line = $i.Text
        for ($x=1; $x -lt $i.SubItems.Count; $x++) { $line += " | " + $i.SubItems[$x].Text }
        [void]$sb.AppendLine($line)
    }
    $save = New-Object System.Windows.Forms.SaveFileDialog
    $save.Filter = "Text (*.txt)|*.txt"
    $save.FileName = "KettehLyzer-$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"
    if ($save.ShowDialog() -eq "OK") {
        $sb.ToString() | Out-File $save.FileName -Encoding UTF8
        Write-Log "Report saved → $($save.FileName)" "OK"
    }
}

# Sidebar actions
$btnOpenMods.Add_Click({
    $p = Join-Path $env:APPDATA ".minecraft\mods"
    if (Test-Path $p) { Start-Process explorer $p; Write-Log "Opened mods folder" "OK" }
    else { Write-Log "Mods folder not found" "ERR" }
})
$btnOpenMC.Add_Click({
    $p = Join-Path $env:APPDATA ".minecraft"
    if (Test-Path $p) { Start-Process explorer $p; Write-Log "Opened .minecraft" "OK" }
})
$btnClearCache.Add_Click({
    $script:ModrinthCache.Clear()
    Write-Log "Cache cleared" "OK"
})
$btnOpenCMD.Add_Click({
    Start-Process powershell
    Write-Log "Opened PowerShell" "OK"
})

# Initial log
Write-Log "KettehLyzer ready" "OK"
Write-Log "Select a tool from the grid" "INFO"

[System.Windows.Forms.Application]::Run($form)
