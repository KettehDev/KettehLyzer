Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.Windows.Forms.Application]::EnableVisualStyles()

# =============================================================================
# THEME - Clean Dark + Soft Gold
# =============================================================================
$bg          = [System.Drawing.Color]::FromArgb(14, 14, 16)
$sidebarBg   = [System.Drawing.Color]::FromArgb(18, 18, 22)
$cardBg      = [System.Drawing.Color]::FromArgb(24, 24, 28)
$cardHover   = [System.Drawing.Color]::FromArgb(34, 34, 40)
$gold        = [System.Drawing.Color]::FromArgb(212, 168, 65)
$goldSoft    = [System.Drawing.Color]::FromArgb(180, 145, 55)
$txt         = [System.Drawing.Color]::FromArgb(235, 235, 240)
$dim         = [System.Drawing.Color]::FromArgb(130, 130, 145)
$green       = [System.Drawing.Color]::FromArgb(90, 200, 130)
$red         = [System.Drawing.Color]::FromArgb(230, 90, 90)
$yellow      = [System.Drawing.Color]::FromArgb(230, 190, 70)

$fontTitle   = New-Object System.Drawing.Font("Segoe UI Semibold", 20)
$fontUI      = New-Object System.Drawing.Font("Segoe UI", 9.5)
$fontSmall   = New-Object System.Drawing.Font("Segoe UI", 8.5)
$fontMono    = New-Object System.Drawing.Font("Consolas", 9)
$fontCard    = New-Object System.Drawing.Font("Segoe UI Semibold", 11)
$fontDesc    = New-Object System.Drawing.Font("Segoe UI", 8.5)

# =============================================================================
# DETECTION ENGINE
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
    $r = @{ Name = ""; Slug = "" }
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
# LOGGING
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
$form.Text = "KettehLyzer"
$form.Size = New-Object System.Drawing.Size(1160, 760)
$form.StartPosition = "CenterScreen"
$form.BackColor = $bg
$form.ForeColor = $txt
$form.Font = $fontUI
$form.MinimumSize = New-Object System.Drawing.Size(1020, 680)

# =============================================================================
# SIDEBAR
# =============================================================================
$sidebar = New-Object System.Windows.Forms.Panel
$sidebar.Dock = "Left"
$sidebar.Width = 210
$sidebar.BackColor = $sidebarBg

# Logo
$logoPanel = New-Object System.Windows.Forms.Panel
$logoPanel.Size = New-Object System.Drawing.Size(210, 100)
$logoPanel.Location = New-Object System.Drawing.Point(0, 0)
$logoPanel.BackColor = $sidebarBg

$logoLbl = New-Object System.Windows.Forms.Label
$logoLbl.Text = "Ketteh"
$logoLbl.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 18)
$logoLbl.ForeColor = $gold
$logoLbl.Location = New-Object System.Drawing.Point(22, 28)
$logoLbl.AutoSize = $true

$logoSub = New-Object System.Windows.Forms.Label
$logoSub.Text = "SS Toolkit"
$logoSub.Font = $fontSmall
$logoSub.ForeColor = $dim
$logoSub.Location = New-Object System.Drawing.Point(24, 58)
$logoSub.AutoSize = $true

$logoPanel.Controls.AddRange(@($logoLbl, $logoSub))

# Actions
$actLbl = New-Object System.Windows.Forms.Label
$actLbl.Text = "QUICK ACTIONS"
$actLbl.Font = $fontSmall
$actLbl.ForeColor = $goldSoft
$actLbl.Location = New-Object System.Drawing.Point(22, 120)
$actLbl.AutoSize = $true

function New-SideBtn {
    param([string]$Text, [int]$Y)
    $b = New-Object System.Windows.Forms.Button
    $b.Text = $Text
    $b.Location = New-Object System.Drawing.Point(16, $Y)
    $b.Size = New-Object System.Drawing.Size(178, 36)
    $b.FlatStyle = "Flat"
    $b.FlatAppearance.BorderSize = 0
    $b.BackColor = $cardBg
    $b.ForeColor = $txt
    $b.Font = $fontUI
    $b.TextAlign = "MiddleLeft"
    $b.Padding = New-Object System.Windows.Forms.Padding(12, 0, 0, 0)
    $b.Cursor = [System.Windows.Forms.Cursors]::Hand
    return $b
}

$btnOpenMods   = New-SideBtn "  Open Mods Folder"  150
$btnOpenMC     = New-SideBtn "  Open .minecraft"   194
$btnClearCache = New-SideBtn "  Clear Cache"       238
$btnOpenPS     = New-SideBtn "  Open PowerShell"   282

$sidebar.Controls.AddRange(@($logoPanel, $actLbl, $btnOpenMods, $btnOpenMC, $btnClearCache, $btnOpenPS))

# =============================================================================
# MAIN
# =============================================================================
$main = New-Object System.Windows.Forms.Panel
$main.Dock = "Fill"
$main.BackColor = $bg

# Header
$header = New-Object System.Windows.Forms.Panel
$header.Dock = "Top"
$header.Height = 82
$header.BackColor = $bg

$titleLbl = New-Object System.Windows.Forms.Label
$titleLbl.Text = "Ready"
$titleLbl.Font = $fontTitle
$titleLbl.ForeColor = $txt
$titleLbl.Location = New-Object System.Drawing.Point(32, 18)
$titleLbl.AutoSize = $true

$subLbl = New-Object System.Windows.Forms.Label
$subLbl.Text = "Select a tool to begin"
$subLbl.Font = $fontUI
$subLbl.ForeColor = $dim
$subLbl.Location = New-Object System.Drawing.Point(34, 52)
$subLbl.AutoSize = $true

$statusBadge = New-Object System.Windows.Forms.Label
$statusBadge.Text = "  IDLE  "
$statusBadge.Font = $fontSmall
$statusBadge.ForeColor = [System.Drawing.Color]::Black
$statusBadge.BackColor = $gold
$statusBadge.Location = New-Object System.Drawing.Point(820, 28)
$statusBadge.AutoSize = $true
$statusBadge.Padding = New-Object System.Windows.Forms.Padding(10, 5, 10, 5)

$header.Controls.AddRange(@($titleLbl, $subLbl, $statusBadge))

# Category pills
$catBar = New-Object System.Windows.Forms.Panel
$catBar.Dock = "Top"
$catBar.Height = 52
$catBar.BackColor = $bg

$categories = @("All", "Mods", "Process", "Network", "Persistence", "Tools")
$script:ActiveCat = "All"
$catButtons = @{}

$xPos = 32
foreach ($cat in $categories) {
    $b = New-Object System.Windows.Forms.Button
    $b.Text = $cat
    $b.Location = New-Object System.Drawing.Point($xPos, 12)
    $b.Size = New-Object System.Drawing.Size(88, 30)
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
    $xPos += 96
}

# Card host
$cardHost = New-Object System.Windows.Forms.Panel
$cardHost.Dock = "Fill"
$cardHost.BackColor = $bg
$cardHost.AutoScroll = $true

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
    $card.Size = New-Object System.Drawing.Size(215, 118)
    $card.Location = New-Object System.Drawing.Point($X, $Y)
    $card.BackColor = $cardBg
    $card.Cursor = [System.Windows.Forms.Cursors]::Hand
    $card.Tag = $Category

    $t = New-Object System.Windows.Forms.Label
    $t.Text = $Title
    $t.Font = $fontCard
    $t.ForeColor = $gold
    $t.Location = New-Object System.Drawing.Point(18, 20)
    $t.AutoSize = $true
    $t.Cursor = [System.Windows.Forms.Cursors]::Hand

    $d = New-Object System.Windows.Forms.Label
    $d.Text = $Desc
    $d.Font = $fontDesc
    $d.ForeColor = $dim
    $d.Location = New-Object System.Drawing.Point(18, 50)
    $d.Size = New-Object System.Drawing.Size(180, 52)
    $d.Cursor = [System.Windows.Forms.Cursors]::Hand

    $card.Controls.AddRange(@($t, $d))

    $click = { & $Action }.GetNewClosure()
    $card.Add_Click($click)
    $t.Add_Click($click)
    $d.Add_Click($click)

    $card.Add_MouseEnter({ $this.BackColor = $cardHover })
    $card.Add_MouseLeave({ $this.BackColor = $cardBg })
    $t.Add_MouseEnter({ $card.BackColor = $cardHover })
    $t.Add_MouseLeave({ $card.BackColor = $cardBg })
    $d.Add_MouseEnter({ $card.BackColor = $cardHover })
    $d.Add_MouseLeave({ $card.BackColor = $cardBg })

    return $card
}

$cards = @()

$cards += New-ToolCard "Full Mod Scan" "Scan all jars against known cheat signatures and Modrinth" "Mods" {
    Show-Results
    Start-ModScan
} 32 24

$cards += New-ToolCard "Process Modules" "Inspect modules loaded by Java processes" "Process" {
    Show-Results
    Start-ProcScan
} 262 24

$cards += New-ToolCard "Network" "List active TCP connections from Java" "Network" {
    Show-Results
    Start-NetScan
} 492 24

$cards += New-ToolCard "Persistence" "Check Run keys and Startup folder" "Persistence" {
    Show-Results
    Start-PersistScan
} 722 24

$cards += New-ToolCard "Java Snapshot" "Quick overview of running Java processes" "Process" {
    $procs = Get-Process javaw,java -ErrorAction SilentlyContinue
    if (-not $procs) { Write-Log "No Java processes running" "WARN"; return }
    $msg = ($procs | ForEach-Object { "PID $($_.Id)  •  $($_.ProcessName)  •  $([math]::Round($_.WorkingSet64/1MB,1)) MB" }) -join "`n"
    [System.Windows.Forms.MessageBox]::Show($msg, "Java Snapshot")
    Write-Log "Java snapshot shown" "OK"
} 32 160

$cards += New-ToolCard "Generate Report" "Export current results to a text file" "Tools" {
    Generate-Report
} 262 160

$cards += New-ToolCard "Clear Cache" "Clear Modrinth hash cache" "Tools" {
    $script:ModrinthCache.Clear()
    Write-Log "Cache cleared" "OK"
} 492 160

foreach ($c in $cards) { $cardHost.Controls.Add($c) }

# Results view
$resultsPanel = New-Object System.Windows.Forms.Panel
$resultsPanel.Dock = "Fill"
$resultsPanel.BackColor = $bg
$resultsPanel.Visible = $false

$backBtn = New-Object System.Windows.Forms.Button
$backBtn.Text = "  ←  Back"
$backBtn.Location = New-Object System.Drawing.Point(32, 16)
$backBtn.Size = New-Object System.Drawing.Size(110, 32)
$backBtn.FlatStyle = "Flat"
$backBtn.FlatAppearance.BorderSize = 0
$backBtn.BackColor = $cardBg
$backBtn.ForeColor = $txt
$backBtn.Cursor = [System.Windows.Forms.Cursors]::Hand

$resultsList = New-Object System.Windows.Forms.ListView
$resultsList.View = "Details"
$resultsList.FullRowSelect = $true
$resultsList.Location = New-Object System.Drawing.Point(32, 60)
$resultsList.Size = New-Object System.Drawing.Size(880, 400)
$resultsList.BackColor = $cardBg
$resultsList.ForeColor = $txt
$resultsList.Font = $fontMono
$resultsList.BorderStyle = "None"

$resultsPanel.Controls.AddRange(@($backBtn, $resultsList))

# Console
$consolePanel = New-Object System.Windows.Forms.Panel
$consolePanel.Dock = "Bottom"
$consolePanel.Height = 130
$consolePanel.BackColor = [System.Drawing.Color]::FromArgb(10, 10, 12)

$consoleLbl = New-Object System.Windows.Forms.Label
$consoleLbl.Text = "ACTIVITY"
$consoleLbl.Font = $fontSmall
$consoleLbl.ForeColor = $goldSoft
$consoleLbl.Location = New-Object System.Drawing.Point(20, 8)
$consoleLbl.AutoSize = $true

$logBox = New-Object System.Windows.Forms.RichTextBox
$logBox.Location = New-Object System.Drawing.Point(16, 28)
$logBox.Size = New-Object System.Drawing.Size(900, 88)
$logBox.BackColor = [System.Drawing.Color]::FromArgb(10, 10, 12)
$logBox.ForeColor = $txt
$logBox.Font = $fontMono
$logBox.BorderStyle = "None"
$logBox.ReadOnly = $true
$logBox.ScrollBars = "Vertical"

$consolePanel.Controls.AddRange(@($consoleLbl, $logBox))

$main.Controls.Add($cardHost)
$main.Controls.Add($resultsPanel)
$main.Controls.Add($catBar)
$main.Controls.Add($header)
$main.Controls.Add($consolePanel)

$form.Controls.Add($main)
$form.Controls.Add($sidebar)

# =============================================================================
# HELPERS
# =============================================================================
function Set-Status {
    param([string]$Title, [string]$Sub, [string]$Badge, [System.Drawing.Color]$BadgeColor)
    $titleLbl.Text = $Title
    $subLbl.Text = $Sub
    $statusBadge.Text = "  $Badge  "
    $statusBadge.BackColor = $BadgeColor
}

function Show-Results {
    $cardHost.Visible = $false
    $resultsPanel.Visible = $true
    $resultsList.Items.Clear()
    $resultsList.Columns.Clear()
}

function Show-Cards {
    $resultsPanel.Visible = $false
    $cardHost.Visible = $true
    Set-Status "Ready" "Select a tool to begin" "IDLE" $gold
}

$backBtn.Add_Click({ Show-Cards })

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
            $c.Visible = ($script:ActiveCat -eq "All" -or $c.Tag -eq $script:ActiveCat)
        }
    }.GetNewClosure())
}

# =============================================================================
# SCANS
# =============================================================================
function Start-ModScan {
    Set-Status "Scanning Mods" "Checking jars against signatures + Modrinth" "RUNNING" $yellow
    Write-Log "Starting full mod scan..." "INFO"

    $resultsList.Columns.Add("File", 280) | Out-Null
    $resultsList.Columns.Add("Status", 110) | Out-Null
    $resultsList.Columns.Add("Detail", 460) | Out-Null

    $modsPath = Join-Path $env:APPDATA ".minecraft\mods"
    if (-not (Test-Path $modsPath)) {
        Write-Log "Mods folder not found" "ERR"
        Set-Status "Error" "Mods folder missing" "ERROR" $red
        return
    }

    $jars = Get-ChildItem $modsPath -Filter *.jar -File -ErrorAction SilentlyContinue
    Write-Log "Found $($jars.Count) jar(s)" "INFO"

    $v=0; $u=0; $s=0; $c=0; $d=0
    foreach ($jar in $jars) {
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
    $msg = "V:$v  U:$u  S:$s  C:$c  D:$d"
    Write-Log "Scan complete — $msg" "OK"
    Set-Status "Scan Complete" $msg "DONE" $green
}

function Start-ProcScan {
    Set-Status "Scanning Process" "Enumerating Java modules" "RUNNING" $yellow
    Write-Log "Scanning Java process modules..." "INFO"

    $resultsList.Columns.Add("PID", 70) | Out-Null
    $resultsList.Columns.Add("Module", 160) | Out-Null
    $resultsList.Columns.Add("Path", 420) | Out-Null
    $resultsList.Columns.Add("Signed", 90) | Out-Null
    $resultsList.Columns.Add("Verdict", 110) | Out-Null

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
    Set-Status "Process Scan Done" "$review module(s) flagged" "DONE" $green
}

function Start-NetScan {
    Set-Status "Scanning Network" "Listing Java TCP connections" "RUNNING" $yellow
    Write-Log "Listing Java network connections..." "INFO"

    $resultsList.Columns.Add("PID", 70) | Out-Null
    $resultsList.Columns.Add("Remote", 320) | Out-Null
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
    Write-Log "$($rows.Count) connection(s) found" "OK"
    Set-Status "Network Scan Done" "$($rows.Count) connection(s)" "DONE" $green
}

function Start-PersistScan {
    Set-Status "Checking Persistence" "Run keys + Startup folder" "RUNNING" $yellow
    Write-Log "Checking persistence..." "INFO"

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
    Write-Log "$($rows.Count) item(s) found" "OK"
    Set-Status "Persistence Done" "$($rows.Count) item(s)" "DONE" $green
}

function Generate-Report {
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.AppendLine("KettehLyzer Report")
    [void]$sb.AppendLine("Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
    [void]$sb.AppendLine("")

    if ($resultsList.Items.Count -gt 0) {
        [void]$sb.AppendLine("--- Results ---")
    } else {
        [void]$sb.AppendLine("No results in view")
    }

    foreach ($i in $resultsList.Items) {
        $line = $i.Text
        for ($x = 1; $x -lt $i.SubItems.Count; $x++) {
            $line += " | " + $i.SubItems[$x].Text
        }
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
$btnOpenPS.Add_Click({
    Start-Process powershell
    Write-Log "Opened PowerShell" "OK"
})

Write-Log "KettehLyzer ready" "OK"

[System.Windows.Forms.Application]::Run($form)
