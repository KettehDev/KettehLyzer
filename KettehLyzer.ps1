Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.Windows.Forms.Application]::EnableVisualStyles()

# =============================================================================
# THEME
# =============================================================================
$bg      = [System.Drawing.Color]::FromArgb(10,10,18)
$panelBg = [System.Drawing.Color]::FromArgb(18,18,28)
$boxBg   = [System.Drawing.Color]::FromArgb(14,14,22)
$accentM = [System.Drawing.Color]::FromArgb(255,90,220)
$accentC = [System.Drawing.Color]::FromArgb(90,220,255)
$txt     = [System.Drawing.Color]::FromArgb(230,230,240)
$dim     = [System.Drawing.Color]::FromArgb(140,140,160)
$green   = [System.Drawing.Color]::FromArgb(90,220,140)
$yellow  = [System.Drawing.Color]::FromArgb(240,210,90)
$red     = [System.Drawing.Color]::FromArgb(240,90,90)
$darkred = [System.Drawing.Color]::FromArgb(180,40,40)

$fontTitle = New-Object System.Drawing.Font("Consolas",18,[System.Drawing.FontStyle]::Bold)
$fontSub   = New-Object System.Drawing.Font("Consolas",9)
$fontCat   = New-Object System.Drawing.Font("Consolas",9)
$fontUI    = New-Object System.Drawing.Font("Segoe UI",9)
$fontMono  = New-Object System.Drawing.Font("Consolas",9)

# =============================================================================
# DETECTION ENGINE  (same logic as the console version, called from GUI events)
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

function Get-FileSHA1 { param([string]$Path) (Get-FileHash -Path $Path -Algorithm SHA1).Hash }

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
        if ($execHit)  { $flags.Add("Runtime.exec — can run OS commands") }
        if ($dlHit)    { $flags.Add("HTTP download — fetches files from a remote server") }
        if ($exfilHit) { $flags.Add("HTTP upload — sends data to a remote server") }
        if ($obfHit)   { $flags.Add("Obfuscated — packed with a known obfuscator") }
    } catch {}
    return $flags
}

# --- Process / injection check ---------------------------------------------
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

# --- Network check ------------------------------------------------------
function Get-JavaConnections {
    $procs = Get-Process javaw,java -ErrorAction SilentlyContinue
    $rows = @()
    foreach ($p in $procs) {
        try {
            $conns = Get-NetTCPConnection -OwningProcess $p.Id -State Established -ErrorAction SilentlyContinue
        } catch { $conns = @() }
        foreach ($c in $conns) {
            $rows += [pscustomobject]@{ PID=$p.Id; Remote="$($c.RemoteAddress):$($c.RemotePort)"; State=$c.State; Note="Review manually — not auto-classified" }
        }
    }
    return $rows
}

# --- Persistence check ------------------------------------------------
function Get-PersistenceItems {
    $rows = @()
    $runKeys = @("HKCU:\Software\Microsoft\Windows\CurrentVersion\Run","HKLM:\Software\Microsoft\Windows\CurrentVersion\Run")
    foreach ($k in $runKeys) {
        try {
            $items = Get-ItemProperty -Path $k -ErrorAction Stop
            foreach ($prop in $items.PSObject.Properties) {
                if ($prop.Name -notmatch '^PS') {
                    $rows += [pscustomobject]@{ Source="Run key ($k)"; Name=$prop.Name; Value=$prop.Value }
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

# --- Forensics: Prefetch (evidence a program ran, even if later deleted) ---
function Get-PrefetchEvidence {
    $items = @()
    $pfDir = "$env:WINDIR\Prefetch"
    try {
        Get-ChildItem $pfDir -Filter *.pf -ErrorAction Stop | ForEach-Object {
            $items += [pscustomobject]@{ Source="Prefetch"; Name=$_.Name; Detail="Last run: $($_.LastWriteTime)  |  Created: $($_.CreationTime)" }
        }
    } catch {
        $items += [pscustomobject]@{ Source="Prefetch"; Name="(unavailable)"; Detail="Prefetch folder not readable — needs admin, or prefetch is disabled" }
    }
    return $items
}

# --- Forensics: UserAssist (recently launched GUI programs, ROT13-encoded key names) ---
function ConvertFrom-Rot13 {
    param([string]$Text)
    -join ($Text.ToCharArray() | ForEach-Object {
        if ($_ -match '[a-zA-Z]') {
            $off = if ([char]::IsUpper($_)) { 65 } else { 97 }
            [char]((([int][char]$_ - $off + 13) % 26) + $off)
        } else { $_ }
    })
}
function Get-UserAssistEvidence {
    $items = @()
    $base = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist"
    try {
        Get-ChildItem $base -ErrorAction Stop | ForEach-Object {
            $countPath = Join-Path $_.PSPath "Count"
            if (Test-Path $countPath) {
                $props = Get-ItemProperty -Path $countPath -ErrorAction SilentlyContinue
                foreach ($prop in $props.PSObject.Properties) {
                    if ($prop.Name -match '^PS') { continue }
                    $decoded = ConvertFrom-Rot13 -Text $prop.Name
                    $items += [pscustomobject]@{ Source="UserAssist"; Name=$decoded; Detail="raw key: $($prop.Name)" }
                }
            }
        }
    } catch {
        $items += [pscustomobject]@{ Source="UserAssist"; Name="(unavailable)"; Detail="UserAssist key not readable" }
    }
    return $items
}

# --- Forensics: USB device history ---
function Get-USBHistory {
    $items = @()
    $base = "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR"
    try {
        Get-ChildItem $base -ErrorAction Stop | ForEach-Object {
            $deviceClass = $_.PSChildName
            Get-ChildItem $_.PSPath -ErrorAction SilentlyContinue | ForEach-Object {
                $props = Get-ItemProperty -Path $_.PSPath -ErrorAction SilentlyContinue
                $friendly = if ($props.FriendlyName) { $props.FriendlyName } else { "(no friendly name)" }
                $items += [pscustomobject]@{ Source="USB History"; Name=$friendly; Detail="$deviceClass  |  serial: $($_.PSChildName)" }
            }
        }
    } catch {
        $items += [pscustomobject]@{ Source="USB History"; Name="(unavailable)"; Detail="USBSTOR key not readable — needs admin" }
    }
    return $items
}

# --- Forensics: Recycle Bin contents ---
function Get-RecycleBinItems {
    $items = @()
    try {
        $shell = New-Object -ComObject Shell.Application
        $recycle = $shell.Namespace(10)
        foreach ($item in $recycle.Items()) {
            $deleted = $recycle.GetDetailsOf($item, 2)
            $items += [pscustomobject]@{ Source="Recycle Bin"; Name=$item.Name; Detail="deleted: $deleted  |  was: $($item.Path)" }
        }
    } catch {
        $items += [pscustomobject]@{ Source="Recycle Bin"; Name="(unavailable)"; Detail="Could not access Recycle Bin via Shell COM object" }
    }
    return $items
}

# --- Forensics: Run dialog / Explorer typed-path history ---
function Get-RecentRunHistory {
    $items = @()
    $sources = @(
        @{ Key="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU"; Label="Run dialog history" },
        @{ Key="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths"; Label="Explorer typed paths" }
    )
    foreach ($s in $sources) {
        try {
            $props = Get-ItemProperty -Path $s.Key -ErrorAction Stop
            foreach ($prop in $props.PSObject.Properties) {
                if ($prop.Name -notmatch '^PS') {
                    $items += [pscustomobject]@{ Source=$s.Label; Name=$prop.Value; Detail="key: $($prop.Name)" }
                }
            }
        } catch {}
    }
    if ($items.Count -eq 0) { $items += [pscustomobject]@{ Source="Run History"; Name="(none found)"; Detail="No RunMRU/TypedPaths entries" } }
    return $items
}

# =============================================================================
# THEME (amber/black — restyled)
# =============================================================================
$bgDark   = [System.Drawing.Color]::FromArgb(10,9,7)
$panelBg  = [System.Drawing.Color]::FromArgb(22,19,12)
$boxBg    = [System.Drawing.Color]::FromArgb(15,13,8)
$amber    = [System.Drawing.Color]::FromArgb(255,190,60)
$amberDim = [System.Drawing.Color]::FromArgb(140,105,40)
$txt      = [System.Drawing.Color]::FromArgb(235,225,200)
$dim      = [System.Drawing.Color]::FromArgb(150,140,110)
$green    = [System.Drawing.Color]::FromArgb(120,220,140)
$yellow   = [System.Drawing.Color]::FromArgb(240,210,90)
$red      = [System.Drawing.Color]::FromArgb(240,90,90)
$darkred  = [System.Drawing.Color]::FromArgb(180,40,40)

$fontLogo  = New-Object System.Drawing.Font("Consolas",9,[System.Drawing.FontStyle]::Bold)
$fontTitle = New-Object System.Drawing.Font("Consolas",15,[System.Drawing.FontStyle]::Bold)
$fontSub   = New-Object System.Drawing.Font("Segoe UI",8)
$fontUI    = New-Object System.Drawing.Font("Segoe UI",9)
$fontUIBold= New-Object System.Drawing.Font("Segoe UI",9,[System.Drawing.FontStyle]::Bold)
$fontMono  = New-Object System.Drawing.Font("Consolas",9)
$fontBadge = New-Object System.Drawing.Font("Segoe UI",8,[System.Drawing.FontStyle]::Bold)

# =============================================================================
# FORM
# =============================================================================
$form = New-Object System.Windows.Forms.Form
$form.Text = "KettehLyzer — SS Toolkit"
$form.Size = New-Object System.Drawing.Size(1180,780)
$form.MinimumSize = New-Object System.Drawing.Size(980,600)
$form.StartPosition = "CenterScreen"
$form.BackColor = $bgDark
$form.ForeColor = $txt
$form.Font = $fontUI

# --- Sidebar ---
$sidebar = New-Object System.Windows.Forms.Panel
$sidebar.Dock = "Left"; $sidebar.Width = 220; $sidebar.BackColor = $panelBg

$logoLbl = New-Object System.Windows.Forms.Label
$logoLbl.Text = "/\_/\`n( o.o )`n > ^ <"
$logoLbl.Font = $fontLogo; $logoLbl.ForeColor = $amber
$logoLbl.Location = New-Object System.Drawing.Point(18,16); $logoLbl.AutoSize = $true

$nameLbl = New-Object System.Windows.Forms.Label
$nameLbl.Text = "KettehLyzer"
$nameLbl.Font = $fontUIBold; $nameLbl.ForeColor = $txt
$nameLbl.Location = New-Object System.Drawing.Point(70,20); $nameLbl.AutoSize = $true
$subNameLbl = New-Object System.Windows.Forms.Label
$subNameLbl.Text = "SS Toolkit"
$subNameLbl.Font = $fontSub; $subNameLbl.ForeColor = $dim
$subNameLbl.Location = New-Object System.Drawing.Point(70,40); $subNameLbl.AutoSize = $true

$sep1 = New-Object System.Windows.Forms.Panel
$sep1.Location = New-Object System.Drawing.Point(0,80); $sep1.Size = New-Object System.Drawing.Size(220,1); $sep1.BackColor = $amberDim

$actionsHdr = New-Object System.Windows.Forms.Label
$actionsHdr.Text = "ACTIONS"; $actionsHdr.Font = $fontSub; $actionsHdr.ForeColor = $amberDim
$actionsHdr.Location = New-Object System.Drawing.Point(18,92); $actionsHdr.AutoSize = $true

function New-SidebarLink {
    param([string]$Text, [int]$Y)
    $l = New-Object System.Windows.Forms.LinkLabel
    $l.Text = $Text; $l.LinkColor = $txt; $l.ActiveLinkColor = $amber; $l.VisitedLinkColor = $txt
    $l.LinkBehavior = "NeverUnderline"; $l.Font = $fontUI
    $l.Location = New-Object System.Drawing.Point(18,$Y); $l.AutoSize = $true
    return $l
}
$linkOpenFolder = New-SidebarLink -Text "Open script folder" -Y 118
$linkClearReports = New-SidebarLink -Text "Clear saved reports" -Y 146
$linkOpenPS = New-SidebarLink -Text "Open PowerShell here" -Y 174

$sep2 = New-Object System.Windows.Forms.Panel
$sep2.Location = New-Object System.Drawing.Point(0,214); $sep2.Size = New-Object System.Drawing.Size(220,1); $sep2.BackColor = $amberDim

$creditsHdr = New-Object System.Windows.Forms.Label
$creditsHdr.Text = "ABOUT"; $creditsHdr.Font = $fontSub; $creditsHdr.ForeColor = $amberDim
$creditsHdr.Location = New-Object System.Drawing.Point(18,226); $creditsHdr.AutoSize = $true
$creditsBody = New-Object System.Windows.Forms.Label
$creditsBody.Text = "KettehLyzer`nRead-only. Nothing here kills processes, hides itself, or downloads other people's binaries."
$creditsBody.Font = $fontSub; $creditsBody.ForeColor = $dim
$creditsBody.Location = New-Object System.Drawing.Point(18,246); $creditsBody.Size = New-Object System.Drawing.Size(186,60)

$pathHdr = New-Object System.Windows.Forms.Label
$pathHdr.Text = "MODS FOLDER"; $pathHdr.Font = $fontSub; $pathHdr.ForeColor = $amberDim
$pathHdr.Location = New-Object System.Drawing.Point(18,330); $pathHdr.AutoSize = $true
$pathBox = New-Object System.Windows.Forms.TextBox
$pathBox.Text = Join-Path $env:APPDATA ".minecraft\mods"
$pathBox.Location = New-Object System.Drawing.Point(18,350); $pathBox.Size = New-Object System.Drawing.Size(184,22)
$pathBox.BackColor = $boxBg; $pathBox.ForeColor = $txt; $pathBox.BorderStyle = "FixedSingle"
$browseBtn = New-Object System.Windows.Forms.Button
$browseBtn.Text = "Browse..."; $browseBtn.Location = New-Object System.Drawing.Point(18,378); $browseBtn.Size = New-Object System.Drawing.Size(184,26)
$browseBtn.BackColor = $boxBg; $browseBtn.ForeColor = $txt; $browseBtn.FlatStyle = "Flat"; $browseBtn.FlatAppearance.BorderColor = $amberDim

$sidebar.Controls.AddRange(@($logoLbl,$nameLbl,$subNameLbl,$sep1,$actionsHdr,$linkOpenFolder,$linkClearReports,$linkOpenPS,$sep2,$creditsHdr,$creditsBody,$pathHdr,$pathBox,$browseBtn))

# --- Top bar (title + status badge) ---
$topBar = New-Object System.Windows.Forms.Panel
$topBar.Dock = "Top"; $topBar.Height = 56; $topBar.BackColor = $bgDark
$titleLbl = New-Object System.Windows.Forms.Label
$titleLbl.Text = "Ready."; $titleLbl.Font = $fontTitle; $titleLbl.ForeColor = $txt
$titleLbl.Location = New-Object System.Drawing.Point(24,8); $titleLbl.AutoSize = $true
$titleSubLbl = New-Object System.Windows.Forms.Label
$titleSubLbl.Text = "Pick a card below to run a check."; $titleSubLbl.Font = $fontSub; $titleSubLbl.ForeColor = $dim
$titleSubLbl.Location = New-Object System.Drawing.Point(26,34); $titleSubLbl.AutoSize = $true

$badge = New-Object System.Windows.Forms.Label
$badge.Text = "  IDLE  "; $badge.Font = $fontBadge; $badge.ForeColor = [System.Drawing.Color]::Black
$badge.BackColor = $green; $badge.AutoSize = $true
$badge.Location = New-Object System.Drawing.Point(1080,18)
$badge.Anchor = "Top,Right"

function Set-Badge {
    param([string]$Text, [System.Drawing.Color]$Color)
    $badge.Text = "  $Text  "; $badge.BackColor = $Color
}
$topBar.Controls.AddRange(@($titleLbl,$titleSubLbl,$badge))

# --- Category pill tabs ---
$tabs = New-Object System.Windows.Forms.TabControl
$tabs.Dock = "Fill"
$tabs.DrawMode = [System.Windows.Forms.TabDrawMode]::OwnerDrawFixed
$tabs.ItemSize = New-Object System.Drawing.Size(130,30)
$tabs.SizeMode = "Fixed"
$tabs.Add_DrawItem({
    param($sender,$e)
    $page = $tabs.TabPages[$e.Index]
    $bounds = $tabs.GetTabRect($e.Index)
    $selected = ($e.Index -eq $tabs.SelectedIndex)
    $bgC = if ($selected) { $amber } else { $panelBg }
    $fgC = if ($selected) { [System.Drawing.Color]::Black } else { $dim }
    $b = New-Object System.Drawing.SolidBrush($bgC)
    $e.Graphics.FillRectangle($b, $bounds)
    $tb = New-Object System.Drawing.SolidBrush($fgC)
    $sf = New-Object System.Drawing.StringFormat
    $sf.Alignment = "Center"; $sf.LineAlignment = "Center"
    $e.Graphics.DrawString($page.Text, $fontUIBold, $tb, [System.Drawing.RectangleF]$bounds, $sf)
    $b.Dispose(); $tb.Dispose()
})

function New-ResultListView {
    param([string[]]$Columns)
    $lv = New-Object System.Windows.Forms.ListView
    $lv.View = "Details"; $lv.FullRowSelect = $true; $lv.GridLines = $true
    $lv.Dock = "Fill"; $lv.BackColor = $boxBg; $lv.ForeColor = $txt; $lv.Font = $fontMono
    $lv.BorderStyle = "None"
    foreach ($c in $Columns) { $lv.Columns.Add($c, 200) | Out-Null }
    return $lv
}

function New-CardButton {
    param([string]$Title, [string]$Desc)
    $card = New-Object System.Windows.Forms.Button
    $card.Text = "$Title`n$Desc"
    $card.Size = New-Object System.Drawing.Size(210,70)
    $card.Margin = New-Object System.Windows.Forms.Padding(8)
    $card.BackColor = $panelBg; $card.ForeColor = $txt
    $card.FlatStyle = "Flat"; $card.FlatAppearance.BorderColor = $amberDim; $card.FlatAppearance.BorderSize = 1
    $card.TextAlign = "TopLeft"; $card.Font = $fontUI
    $card.Padding = New-Object System.Windows.Forms.Padding(10,8,10,8)
    return $card
}

# ---- Tab: Mods ----
$tabMods = New-Object System.Windows.Forms.TabPage; $tabMods.Text = "Mods"; $tabMods.BackColor = $bgDark
$modsCardRow = New-Object System.Windows.Forms.FlowLayoutPanel
$modsCardRow.Dock = "Top"; $modsCardRow.Height = 90; $modsCardRow.BackColor = $bgDark; $modsCardRow.Padding = New-Object System.Windows.Forms.Padding(10)
$scanCard = New-CardButton -Title "Full Mod Scan" -Desc "Hash-verify + signature scan every jar"
$modsCardRow.Controls.Add($scanCard)
$modsList = New-ResultListView -Columns @("File","Status","Detail")
$tabMods.Controls.Add($modsList); $tabMods.Controls.Add($modsCardRow)

# ---- Tab: Process & Injection ----
$tabProc = New-Object System.Windows.Forms.TabPage; $tabProc.Text = "Process"; $tabProc.BackColor = $bgDark
$procCardRow = New-Object System.Windows.Forms.FlowLayoutPanel
$procCardRow.Dock = "Top"; $procCardRow.Height = 90; $procCardRow.BackColor = $bgDark; $procCardRow.Padding = New-Object System.Windows.Forms.Padding(10)
$procCard = New-CardButton -Title "InjChk" -Desc "Loaded modules in java(w).exe + signature check"
$procCardRow.Controls.Add($procCard)
$procList = New-ResultListView -Columns @("PID","Module","Path","Signed","Verdict")
$tabProc.Controls.Add($procList); $tabProc.Controls.Add($procCardRow)

# ---- Tab: Network ----
$tabNet = New-Object System.Windows.Forms.TabPage; $tabNet.Text = "Network"; $tabNet.BackColor = $bgDark
$netCardRow = New-Object System.Windows.Forms.FlowLayoutPanel
$netCardRow.Dock = "Top"; $netCardRow.Height = 90; $netCardRow.BackColor = $bgDark; $netCardRow.Padding = New-Object System.Windows.Forms.Padding(10)
$netCard = New-CardButton -Title "ConnScan" -Desc "Established TCP connections owned by java(w).exe"
$netCardRow.Controls.Add($netCard)
$netList = New-ResultListView -Columns @("PID","Remote","State","Note")
$tabNet.Controls.Add($netList); $tabNet.Controls.Add($netCardRow)

# ---- Tab: Persistence ----
$tabPersist = New-Object System.Windows.Forms.TabPage; $tabPersist.Text = "Persistence"; $tabPersist.BackColor = $bgDark
$persistCardRow = New-Object System.Windows.Forms.FlowLayoutPanel
$persistCardRow.Dock = "Top"; $persistCardRow.Height = 90; $persistCardRow.BackColor = $bgDark; $persistCardRow.Padding = New-Object System.Windows.Forms.Padding(10)
$persistCard = New-CardButton -Title "StartupChk" -Desc "Run keys, Startup folder, recent scheduled tasks"
$persistCardRow.Controls.Add($persistCard)
$persistList = New-ResultListView -Columns @("Source","Name","Value")
$tabPersist.Controls.Add($persistList); $tabPersist.Controls.Add($persistCardRow)

# ---- Tab: Forensics (new) ----
$tabForensics = New-Object System.Windows.Forms.TabPage; $tabForensics.Text = "Forensics"; $tabForensics.BackColor = $bgDark
$forensicsCardRow = New-Object System.Windows.Forms.FlowLayoutPanel
$forensicsCardRow.Dock = "Top"; $forensicsCardRow.Height = 90; $forensicsCardRow.BackColor = $bgDark; $forensicsCardRow.Padding = New-Object System.Windows.Forms.Padding(10); $forensicsCardRow.WrapContents = $true
$prefetchCard  = New-CardButton -Title "PrefetchChk" -Desc "Evidence a program ran, even if deleted since"
$userAssistCard= New-CardButton -Title "RunHistory"  -Desc "Recently launched GUI programs (UserAssist)"
$usbCard       = New-CardButton -Title "USBChk"      -Desc "Removable storage device history"
$recycleCard   = New-CardButton -Title "RecycleChk"  -Desc "Current Recycle Bin contents"
$typedCard     = New-CardButton -Title "TypedPaths"  -Desc "Run dialog + Explorer address-bar history"
$forensicsCardRow.Controls.AddRange(@($prefetchCard,$userAssistCard,$usbCard,$recycleCard,$typedCard))
$forensicsList = New-ResultListView -Columns @("Source","Name","Detail")
$tabForensics.Controls.Add($forensicsList); $tabForensics.Controls.Add($forensicsCardRow)

# ---- Tab: Report ----
$tabReport = New-Object System.Windows.Forms.TabPage; $tabReport.Text = "Report"; $tabReport.BackColor = $bgDark
$reportCardRow = New-Object System.Windows.Forms.FlowLayoutPanel
$reportCardRow.Dock = "Top"; $reportCardRow.Height = 90; $reportCardRow.BackColor = $bgDark; $reportCardRow.Padding = New-Object System.Windows.Forms.Padding(10)
$reportCard = New-CardButton -Title "Export Report" -Desc "Save everything found across all tabs to .txt"
$reportCardRow.Controls.Add($reportCard)
$reportBox = New-Object System.Windows.Forms.RichTextBox
$reportBox.Dock = "Fill"; $reportBox.BackColor = $boxBg; $reportBox.ForeColor = $txt; $reportBox.Font = $fontMono; $reportBox.ReadOnly = $true; $reportBox.BorderStyle = "None"
$tabReport.Controls.Add($reportBox); $tabReport.Controls.Add($reportCardRow)

$tabs.TabPages.AddRange(@($tabMods,$tabProc,$tabNet,$tabPersist,$tabForensics,$tabReport))

# --- Activity console (bottom) ---
$consolePanel = New-Object System.Windows.Forms.Panel
$consolePanel.Dock = "Bottom"; $consolePanel.Height = 160; $consolePanel.BackColor = $bgDark
$consoleHdr = New-Object System.Windows.Forms.Label
$consoleHdr.Text = "ACTIVITY CONSOLE"; $consoleHdr.Font = $fontSub; $consoleHdr.ForeColor = $amberDim
$consoleHdr.Dock = "Top"; $consoleHdr.Height = 20; $consoleHdr.Padding = New-Object System.Windows.Forms.Padding(10,4,0,0)
$consoleBox = New-Object System.Windows.Forms.RichTextBox
$consoleBox.Dock = "Fill"; $consoleBox.BackColor = [System.Drawing.Color]::FromArgb(4,4,3); $consoleBox.ForeColor = $amber
$consoleBox.Font = $fontMono; $consoleBox.ReadOnly = $true; $consoleBox.BorderStyle = "None"
$consolePanel.Controls.Add($consoleBox); $consolePanel.Controls.Add($consoleHdr)

function Write-Console {
    param([string]$Msg, [System.Drawing.Color]$Color = $amber)
    $ts = Get-Date -Format "HH:mm:ss"
    $consoleBox.SelectionStart = $consoleBox.TextLength
    $consoleBox.SelectionColor = $Color
    $consoleBox.AppendText("[$ts] $Msg`n")
    $consoleBox.ScrollToCaret()
}

$form.Controls.Add($tabs)
$form.Controls.Add($consolePanel)
$form.Controls.Add($topBar)
$form.Controls.Add($sidebar)

# =============================================================================
# EVENTS
# =============================================================================
$browseBtn.Add_Click({
    $dlg = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($dlg.ShowDialog() -eq "OK") { $pathBox.Text = $dlg.SelectedPath }
})

$linkOpenFolder.Add_Click({
    $dir = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
    Start-Process explorer.exe $dir
    Write-Console "Opened script folder: $dir" $dim
})
$linkClearReports.Add_Click({
    $dir = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
    $reports = Get-ChildItem -Path $dir -Filter "KettehLyzer-Report-*.txt" -ErrorAction SilentlyContinue
    $reports | Remove-Item -Force -ErrorAction SilentlyContinue
    Write-Console "Cleared $($reports.Count) saved report(s)" $dim
})
$linkOpenPS.Add_Click({
    $dir = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
    Start-Process powershell.exe -WorkingDirectory $dir
    Write-Console "Opened PowerShell at: $dir" $dim
})

$scanCard.Add_Click({
    $modsList.Items.Clear()
    $modsPath = $pathBox.Text
    if (-not (Test-Path $modsPath -PathType Container)) {
        Write-Console "Invalid mods folder: $modsPath" $red
        return
    }
    Set-Badge "SCANNING" $amber
    $titleLbl.Text = "Scanning mods..."
    $jars = Get-ChildItem -Path $modsPath -Filter *.jar -File
    $total = $jars.Count
    Write-Console "Found $total jar(s) in $modsPath"
    $script:VerifiedCount=0; $script:UnknownCount=0; $script:SuspiciousCount=0; $script:CheatCount=0; $script:DangerousCount=0
    $idx = 0
    foreach ($jar in $jars) {
        $idx++
        $titleSubLbl.Text = "Scanning $idx/$total — $($jar.Name)"
        [System.Windows.Forms.Application]::DoEvents()

        $hash = Get-FileSHA1 -Path $jar.FullName
        $known = Query-Modrinth -Hash $hash
        if ($known.Slug) {
            $item = New-Object System.Windows.Forms.ListViewItem($jar.Name)
            $item.SubItems.Add("Verified") | Out-Null; $item.SubItems.Add($known.Name) | Out-Null
            $item.ForeColor = $green
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
            $item.SubItems.Add((($scan.Hits -join ', ') + $(if($deep.Count -gt 0){" | " + ($deep -join '; ')}else{""}))) | Out-Null
            $item.ForeColor = if ($deep.Count -gt 0) { $darkred } else { $red }
            $modsList.Items.Add($item) | Out-Null
            if ($deep.Count -gt 0) { $script:DangerousCount++; Write-Console "DANGEROUS: $($jar.Name)" $darkred } else { $script:CheatCount++; Write-Console "CHEAT CLIENT: $($jar.Name)" $red }
        } elseif ($scan.HitCount -gt 0) {
            $item = New-Object System.Windows.Forms.ListViewItem($jar.Name)
            $item.SubItems.Add("Suspicious") | Out-Null; $item.SubItems.Add($scan.Hits -join ', ') | Out-Null
            $item.ForeColor = $yellow
            $modsList.Items.Add($item) | Out-Null
            $script:SuspiciousCount++
        } else {
            $item = New-Object System.Windows.Forms.ListViewItem($jar.Name)
            $item.SubItems.Add("Unknown") | Out-Null; $item.SubItems.Add("No hash match, no signature hits") | Out-Null
            $item.ForeColor = $dim
            $modsList.Items.Add($item) | Out-Null
            $script:UnknownCount++
        }
    }
    foreach ($c in $modsList.Columns) { $c.Width = -2 }
    $verdict = if ($script:DangerousCount -gt 0) { "CRITICAL" } elseif ($script:CheatCount -gt 0) { "FLAGGED" } elseif ($script:SuspiciousCount -gt 3) { "REVIEW" } else { "CLEAN" }
    $badgeColor = if ($script:DangerousCount -gt 0 -or $script:CheatCount -gt 0) { $red } elseif ($script:SuspiciousCount -gt 3) { $yellow } else { $green }
    Set-Badge $verdict $badgeColor
    $titleLbl.Text = "Mod scan complete."
    $titleSubLbl.Text = "V:$($script:VerifiedCount)  U:$($script:UnknownCount)  S:$($script:SuspiciousCount)  C:$($script:CheatCount)  D:$($script:DangerousCount)"
    Write-Console "Mod scan done — $verdict ($total jars)" $badgeColor
})

$procCard.Add_Click({
    $procList.Items.Clear()
    Set-Badge "SCANNING" $amber
    Write-Console "Enumerating java(w).exe process modules..."
    [System.Windows.Forms.Application]::DoEvents()
    $rows = Get-JavaProcessModules
    if ($rows.Count -eq 0) {
        Write-Console "No running java/javaw process found." $dim
        Set-Badge "IDLE" $green
        return
    }
    $reviewCount = 0
    foreach ($r in $rows) {
        $item = New-Object System.Windows.Forms.ListViewItem($r.PID.ToString())
        $item.SubItems.Add($r.Module) | Out-Null; $item.SubItems.Add($r.Path) | Out-Null
        $item.SubItems.Add($r.Signed) | Out-Null; $item.SubItems.Add($r.Verdict) | Out-Null
        if ($r.Verdict -like "Review*") { $item.ForeColor = $red; $reviewCount++ }
        elseif ($r.Verdict -eq "Unsigned") { $item.ForeColor = $yellow }
        else { $item.ForeColor = $dim }
        $procList.Items.Add($item) | Out-Null
    }
    foreach ($c in $procList.Columns) { $c.Width = -2 }
    $badgeColor = if ($reviewCount -gt 0) { $yellow } else { $green }
    Set-Badge $(if($reviewCount -gt 0){"REVIEW"}else{"CLEAN"}) $badgeColor
    Write-Console "Process scan done — $reviewCount module(s) worth a look" $badgeColor
})

$netCard.Add_Click({
    $netList.Items.Clear()
    $rows = Get-JavaConnections
    foreach ($r in $rows) {
        $item = New-Object System.Windows.Forms.ListViewItem($r.PID.ToString())
        $item.SubItems.Add($r.Remote) | Out-Null; $item.SubItems.Add($r.State.ToString()) | Out-Null; $item.SubItems.Add($r.Note) | Out-Null
        $item.ForeColor = $dim
        $netList.Items.Add($item) | Out-Null
    }
    foreach ($c in $netList.Columns) { $c.Width = -2 }
    Write-Console "Listed $($rows.Count) established connection(s) — review manually" $dim
    Set-Badge "IDLE" $green
})

$persistCard.Add_Click({
    $persistList.Items.Clear()
    $rows = Get-PersistenceItems
    foreach ($r in $rows) {
        $item = New-Object System.Windows.Forms.ListViewItem($r.Source)
        $item.SubItems.Add($r.Name) | Out-Null; $item.SubItems.Add($r.Value) | Out-Null
        $item.ForeColor = $dim
        $persistList.Items.Add($item) | Out-Null
    }
    foreach ($c in $persistList.Columns) { $c.Width = -2 }
    Write-Console "Listed $($rows.Count) startup/persistence item(s)" $dim
    Set-Badge "IDLE" $green
})

function Add-ForensicsRows {
    param($Rows)
    foreach ($r in $Rows) {
        $item = New-Object System.Windows.Forms.ListViewItem($r.Source)
        $item.SubItems.Add($r.Name) | Out-Null; $item.SubItems.Add($r.Detail) | Out-Null
        $item.ForeColor = $dim
        $forensicsList.Items.Add($item) | Out-Null
    }
    foreach ($c in $forensicsList.Columns) { $c.Width = -2 }
}
$prefetchCard.Add_Click({ Add-ForensicsRows (Get-PrefetchEvidence); Write-Console "Prefetch check done" $dim; Set-Badge "IDLE" $green })
$userAssistCard.Add_Click({ Add-ForensicsRows (Get-UserAssistEvidence); Write-Console "UserAssist check done" $dim; Set-Badge "IDLE" $green })
$usbCard.Add_Click({ Add-ForensicsRows (Get-USBHistory); Write-Console "USB history check done" $dim; Set-Badge "IDLE" $green })
$recycleCard.Add_Click({ Add-ForensicsRows (Get-RecycleBinItems); Write-Console "Recycle Bin check done" $dim; Set-Badge "IDLE" $green })
$typedCard.Add_Click({ Add-ForensicsRows (Get-RecentRunHistory); Write-Console "Run/typed-path history check done" $dim; Set-Badge "IDLE" $green })

$reportCard.Add_Click({
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.AppendLine("KettehLyzer SS Toolkit — Report")
    [void]$sb.AppendLine("Generated: $(Get-Date)")
    [void]$sb.AppendLine("Mods folder: $($pathBox.Text)")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("--- Mods ($($modsList.Items.Count)) ---")
    foreach ($i in $modsList.Items) { [void]$sb.AppendLine("[$($i.SubItems[1].Text)] $($i.Text) — $($i.SubItems[2].Text)") }
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("--- Process modules ($($procList.Items.Count)) ---")
    foreach ($i in $procList.Items) { [void]$sb.AppendLine("[$($i.SubItems[4].Text)] $($i.SubItems[1].Text) — $($i.SubItems[2].Text) (Signed: $($i.SubItems[3].Text))") }
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("--- Network connections ($($netList.Items.Count)) ---")
    foreach ($i in $netList.Items) { [void]$sb.AppendLine("$($i.SubItems[1].Text) [$($i.SubItems[2].Text)]") }
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("--- Persistence items ($($persistList.Items.Count)) ---")
    foreach ($i in $persistList.Items) { [void]$sb.AppendLine("$($i.Text): $($i.SubItems[1].Text) -> $($i.SubItems[2].Text)") }
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("--- Forensics ($($forensicsList.Items.Count)) ---")
    foreach ($i in $forensicsList.Items) { [void]$sb.AppendLine("[$($i.Text)] $($i.SubItems[1].Text) — $($i.SubItems[2].Text)") }
    $reportBox.Text = $sb.ToString()

    $dir = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
    $save = New-Object System.Windows.Forms.SaveFileDialog
    $save.InitialDirectory = $dir
    $save.Filter = "Text report (*.txt)|*.txt"
    $save.FileName = "KettehLyzer-Report-$(Get-Date -Format yyyyMMdd-HHmmss).txt"
    if ($save.ShowDialog() -eq "OK") {
        $sb.ToString() | Out-File -FilePath $save.FileName -Encoding UTF8
        Write-Console "Report saved to: $($save.FileName)" $green
    }
})

[System.Windows.Forms.Application]::Run($form)
