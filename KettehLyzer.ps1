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
        $expectedDirs = @($p.Path | Split-Path -Parent, "$env:WINDIR\System32", "$env:WINDIR\SysWOW64", "${env:ProgramFiles}", "${env:ProgramFiles(x86)}")
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

# =============================================================================
# FORM
# =============================================================================
$form = New-Object System.Windows.Forms.Form
$form.Text = "KettehLyzer — SS Toolkit"
$form.Size = New-Object System.Drawing.Size(1000,720)
$form.StartPosition = "CenterScreen"
$form.BackColor = $bg
$form.ForeColor = $txt
$form.Font = $fontUI

# --- Header ---
$header = New-Object System.Windows.Forms.Panel
$header.Dock = "Top"; $header.Height = 90; $header.BackColor = $panelBg
$catLbl = New-Object System.Windows.Forms.Label
$catLbl.Text = "/\_/\`n( o.o )`n > ^ <"
$catLbl.Font = $fontCat; $catLbl.ForeColor = $accentM
$catLbl.Location = New-Object System.Drawing.Point(18,8); $catLbl.AutoSize = $true
$titleLbl = New-Object System.Windows.Forms.Label
$titleLbl.Text = "KETTEHLYZER — SS TOOLKIT"
$titleLbl.Font = $fontTitle; $titleLbl.ForeColor = $accentC
$titleLbl.Location = New-Object System.Drawing.Point(110,14); $titleLbl.AutoSize = $true
$subLbl = New-Object System.Windows.Forms.Label
$subLbl.Text = "Layered mod / process / network / persistence checks. Read-only — nothing here kills processes or hides itself. No detection tool is unbypassable; use this as one part of an SS, not the whole thing."
$subLbl.Font = $fontSub; $subLbl.ForeColor = $dim
$subLbl.Location = New-Object System.Drawing.Point(112,46); $subLbl.Size = New-Object System.Drawing.Size(860,36)
$header.Controls.AddRange(@($catLbl,$titleLbl,$subLbl))

# --- Path bar ---
$pathBar = New-Object System.Windows.Forms.Panel
$pathBar.Dock = "Top"; $pathBar.Height = 44; $pathBar.BackColor = $bg
$pathLbl = New-Object System.Windows.Forms.Label
$pathLbl.Text = "Mods folder:"; $pathLbl.ForeColor = $txt
$pathLbl.Location = New-Object System.Drawing.Point(18,12); $pathLbl.AutoSize = $true
$pathBox = New-Object System.Windows.Forms.TextBox
$pathBox.Text = Join-Path $env:APPDATA ".minecraft\mods"
$pathBox.Location = New-Object System.Drawing.Point(100,9); $pathBox.Size = New-Object System.Drawing.Size(560,24)
$pathBox.BackColor = $boxBg; $pathBox.ForeColor = $txt; $pathBox.BorderStyle = "FixedSingle"
$browseBtn = New-Object System.Windows.Forms.Button
$browseBtn.Text = "Browse..."; $browseBtn.Location = New-Object System.Drawing.Point(668,8); $browseBtn.Size = New-Object System.Drawing.Size(80,26)
$browseBtn.BackColor = $panelBg; $browseBtn.ForeColor = $txt; $browseBtn.FlatStyle = "Flat"
$scanBtn = New-Object System.Windows.Forms.Button
$scanBtn.Text = "Run Full Mod Scan"; $scanBtn.Location = New-Object System.Drawing.Point(758,8); $scanBtn.Size = New-Object System.Drawing.Size(150,26)
$scanBtn.BackColor = $accentM; $scanBtn.ForeColor = [System.Drawing.Color]::Black; $scanBtn.FlatStyle = "Flat"
$pathBar.Controls.AddRange(@($pathLbl,$pathBox,$browseBtn,$scanBtn))

# --- Progress + status ---
$progress = New-Object System.Windows.Forms.ProgressBar
$progress.Dock = "Top"; $progress.Height = 6
$statusLbl = New-Object System.Windows.Forms.Label
$statusLbl.Dock = "Bottom"; $statusLbl.Height = 30; $statusLbl.TextAlign = "MiddleLeft"
$statusLbl.Text = "  Ready."; $statusLbl.ForeColor = $dim; $statusLbl.BackColor = $panelBg

# --- Tabs ---
$tabs = New-Object System.Windows.Forms.TabControl
$tabs.Dock = "Fill"

function New-ResultListView {
    param([string[]]$Columns)
    $lv = New-Object System.Windows.Forms.ListView
    $lv.View = "Details"; $lv.FullRowSelect = $true; $lv.GridLines = $true
    $lv.Dock = "Fill"; $lv.BackColor = $boxBg; $lv.ForeColor = $txt; $lv.Font = $fontMono
    foreach ($c in $Columns) { $lv.Columns.Add($c, 200) | Out-Null }
    return $lv
}

# Tab: Mods
$tabMods = New-Object System.Windows.Forms.TabPage; $tabMods.Text = "Mods"; $tabMods.BackColor = $bg
$modsList = New-ResultListView -Columns @("File","Status","Detail")
$tabMods.Controls.Add($modsList)

# Tab: Process
$tabProc = New-Object System.Windows.Forms.TabPage; $tabProc.Text = "Process && Injection"; $tabProc.BackColor = $bg
$procBtn = New-Object System.Windows.Forms.Button
$procBtn.Text = "Scan Java Process Modules"; $procBtn.Dock = "Top"; $procBtn.Height = 30
$procBtn.BackColor = $panelBg; $procBtn.ForeColor = $txt; $procBtn.FlatStyle = "Flat"
$procList = New-ResultListView -Columns @("PID","Module","Path","Signed","Verdict")
$tabProc.Controls.Add($procList); $tabProc.Controls.Add($procBtn)

# Tab: Network
$tabNet = New-Object System.Windows.Forms.TabPage; $tabNet.Text = "Network"; $tabNet.BackColor = $bg
$netBtn = New-Object System.Windows.Forms.Button
$netBtn.Text = "List Java Process Connections"; $netBtn.Dock = "Top"; $netBtn.Height = 30
$netBtn.BackColor = $panelBg; $netBtn.ForeColor = $txt; $netBtn.FlatStyle = "Flat"
$netList = New-ResultListView -Columns @("PID","Remote","State","Note")
$tabNet.Controls.Add($netList); $tabNet.Controls.Add($netBtn)

# Tab: Persistence
$tabPersist = New-Object System.Windows.Forms.TabPage; $tabPersist.Text = "Persistence"; $tabPersist.BackColor = $bg
$persistBtn = New-Object System.Windows.Forms.Button
$persistBtn.Text = "Check Startup Items"; $persistBtn.Dock = "Top"; $persistBtn.Height = 30
$persistBtn.BackColor = $panelBg; $persistBtn.ForeColor = $txt; $persistBtn.FlatStyle = "Flat"
$persistList = New-ResultListView -Columns @("Source","Name","Value")
$tabPersist.Controls.Add($persistList); $tabPersist.Controls.Add($persistBtn)

# Tab: Report
$tabReport = New-Object System.Windows.Forms.TabPage; $tabReport.Text = "Report"; $tabReport.BackColor = $bg
$reportBtn = New-Object System.Windows.Forms.Button
$reportBtn.Text = "Generate + Save Report (.txt)"; $reportBtn.Dock = "Top"; $reportBtn.Height = 30
$reportBtn.BackColor = $accentC; $reportBtn.ForeColor = [System.Drawing.Color]::Black; $reportBtn.FlatStyle = "Flat"
$reportBox = New-Object System.Windows.Forms.RichTextBox
$reportBox.Dock = "Fill"; $reportBox.BackColor = $boxBg; $reportBox.ForeColor = $txt; $reportBox.Font = $fontMono; $reportBox.ReadOnly = $true
$tabReport.Controls.Add($reportBox); $tabReport.Controls.Add($reportBtn)

$tabs.TabPages.AddRange(@($tabMods,$tabProc,$tabNet,$tabPersist,$tabReport))

$form.Controls.Add($tabs)
$form.Controls.Add($statusLbl)
$form.Controls.Add($progress)
$form.Controls.Add($pathBar)
$form.Controls.Add($header)

# =============================================================================
# EVENTS
# =============================================================================
$browseBtn.Add_Click({
    $dlg = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($dlg.ShowDialog() -eq "OK") { $pathBox.Text = $dlg.SelectedPath }
})

$scanBtn.Add_Click({
    $modsList.Items.Clear()
    $modsPath = $pathBox.Text
    if (-not (Test-Path $modsPath -PathType Container)) {
        $statusLbl.Text = "  Invalid mods folder path."; $statusLbl.ForeColor = $red
        return
    }
    $jars = Get-ChildItem -Path $modsPath -Filter *.jar -File
    $total = $jars.Count
    $progress.Maximum = [math]::Max($total,1); $progress.Value = 0
    $script:VerifiedCount=0; $script:UnknownCount=0; $script:SuspiciousCount=0; $script:CheatCount=0; $script:DangerousCount=0
    $idx = 0
    foreach ($jar in $jars) {
        $idx++; $progress.Value = $idx
        $statusLbl.Text = "  Scanning $idx/$total — $($jar.Name)"; $statusLbl.ForeColor = $accentC
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
            if ($deep.Count -gt 0) { $script:DangerousCount++ } else { $script:CheatCount++ }
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
    $verdict = if ($script:DangerousCount -gt 0) { "CRITICAL — dangerous mods found" }
               elseif ($script:CheatCount -gt 0) { "FLAGGED — cheat client(s) found" }
               elseif ($script:SuspiciousCount -gt 3) { "REVIEW — several suspicious mods" }
               else { "CLEAN — no mod-based hits" }
    $statusLbl.Text = "  Done. $verdict   (V:$($script:VerifiedCount) U:$($script:UnknownCount) S:$($script:SuspiciousCount) C:$($script:CheatCount) D:$($script:DangerousCount))"
    $statusLbl.ForeColor = if ($script:DangerousCount -gt 0 -or $script:CheatCount -gt 0) { $red } elseif ($script:SuspiciousCount -gt 3) { $yellow } else { $green }
})

$procBtn.Add_Click({
    $procList.Items.Clear()
    $statusLbl.Text = "  Enumerating Java process modules..."; $statusLbl.ForeColor = $accentC
    [System.Windows.Forms.Application]::DoEvents()
    $rows = Get-JavaProcessModules
    if ($rows.Count -eq 0) {
        $statusLbl.Text = "  No running java/javaw process found."; $statusLbl.ForeColor = $dim
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
    $statusLbl.Text = "  Done. $reviewCount module(s) worth a manual look (unsigned + outside expected folders)."
    $statusLbl.ForeColor = if ($reviewCount -gt 0) { $yellow } else { $green }
})

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
    $statusLbl.Text = "  $($rows.Count) established connection(s) listed. Not auto-classified — check remote IPs manually."
    $statusLbl.ForeColor = $accentC
})

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
    $statusLbl.Text = "  $($rows.Count) startup/persistence item(s) listed for manual review."
    $statusLbl.ForeColor = $accentC
})

$reportBtn.Add_Click({
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
    $reportBox.Text = $sb.ToString()

    $save = New-Object System.Windows.Forms.SaveFileDialog
    $save.Filter = "Text report (*.txt)|*.txt"
    $save.FileName = "KettehLyzer-Report-$(Get-Date -Format yyyyMMdd-HHmmss).txt"
    if ($save.ShowDialog() -eq "OK") {
        $sb.ToString() | Out-File -FilePath $save.FileName -Encoding UTF8
        $statusLbl.Text = "  Report saved to $($save.FileName)"; $statusLbl.ForeColor = $green
    }
})

[System.Windows.Forms.Application]::Run($form)
