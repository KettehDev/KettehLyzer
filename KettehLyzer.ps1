# ============================================================
#  ██╗  ██╗███████╗████████╗████████╗███████╗██╗  ██╗██╗  ██╗
#  ██║ ██╔╝██╔════╝╚══██╔══╝╚══██╔══╝██╔════╝██║  ██║██║  ╚██╗
#  █████╔╝ █████╗     ██║      ██║   █████╗  ███████║██║   ╚██╗
#  ██╔═██╗ ██╔══╝     ██║      ██║   ██╔══╝  ██╔══██║██║    ██║
#  ██║  ██╗███████╗   ██║      ██║   ███████╗██║  ██║███████╗██║
#  ╚═╝  ╚═╝╚══════╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝
#              KETTEH TOOLS GUI v1.0
#           MULTI-TOOL JUSTICE SUITE 🔥
# ============================================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.IO.Compression.FileSystem

# ─── COLOR SCHEME ─────────────────────────────────────────────
$DarkBg = [System.Drawing.Color]::FromArgb(10, 10, 20)
$DarkCard = [System.Drawing.Color]::FromArgb(20, 20, 40)
$NeonPink = [System.Drawing.Color]::FromArgb(255, 45, 155)
$NeonCyan = [System.Drawing.Color]::FromArgb(0, 212, 255)
$NeonPurple = [System.Drawing.Color]::FromArgb(180, 77, 255)
$TextColor = [System.Drawing.Color]::FromArgb(240, 240, 255)
$TextMuted = [System.Drawing.Color]::FromArgb(136, 136, 187)

# ─── MAIN FORM ─────────────────────────────────────────────────
$form = New-Object System.Windows.Forms.Form
$form.Text = "⚡ KETTEH TOOLS ⚡"
$form.Size = New-Object System.Drawing.Size(1100, 750)
$form.StartPosition = "CenterScreen"
$form.BackColor = $DarkBg
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false
$form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon((Get-Command powershell).Path)

# ─── HEADER ────────────────────────────────────────────────────
$header = New-Object System.Windows.Forms.Label
$header.Text = "⚡ KETTEH TOOLS ⚡"
$header.Font = New-Object System.Drawing.Font("Consolas", 18, [System.Drawing.FontStyle]::Bold)
$header.ForeColor = $NeonPink
$header.BackColor = $DarkBg
$header.Dock = "Top"
$header.Height = 50
$header.TextAlign = "MiddleCenter"
$form.Controls.Add($header)

# ─── TAB CONTROL ──────────────────────────────────────────────
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Dock = "Fill"
$tabControl.BackColor = $DarkBg
$tabControl.ForeColor = $TextColor
$tabControl.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$tabControl.Padding = New-Object System.Drawing.Point(10, 5)
$tabControl.Top = 50
$form.Controls.Add($tabControl)

# ============================================================
#  TAB 1: MOD SCANNER
# ============================================================
$tabModScanner = New-Object System.Windows.Forms.TabPage
$tabModScanner.Text = "🔍 Mod Scanner"
$tabModScanner.BackColor = $DarkBg
$tabControl.TabPages.Add($tabModScanner)

# Path input
$pathLabel = New-Object System.Windows.Forms.Label
$pathLabel.Text = "📂 Mods Folder:"
$pathLabel.ForeColor = $TextColor
$pathLabel.Location = New-Object System.Drawing.Point(20, 20)
$pathLabel.Size = New-Object System.Drawing.Size(100, 25)
$pathLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$tabModScanner.Controls.Add($pathLabel)

$modPathBox = New-Object System.Windows.Forms.TextBox
$modPathBox.Location = New-Object System.Drawing.Point(130, 20)
$modPathBox.Size = New-Object System.Drawing.Size(600, 25)
$modPathBox.BackColor = $DarkCard
$modPathBox.ForeColor = $TextColor
$modPathBox.BorderStyle = "FixedSingle"
$modPathBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$modPathBox.Text = Join-Path $env:APPDATA ".minecraft\mods"
$tabModScanner.Controls.Add($modPathBox)

# Browse button
$browseBtn = New-Object System.Windows.Forms.Button
$browseBtn.Text = "📁 Browse"
$browseBtn.Location = New-Object System.Drawing.Point(740, 18)
$browseBtn.Size = New-Object System.Drawing.Size(100, 30)
$browseBtn.BackColor = $DarkCard
$browseBtn.ForeColor = $NeonCyan
$browseBtn.FlatStyle = "Flat"
$browseBtn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$browseBtn.FlatAppearance.BorderColor = $NeonCyan
$browseBtn.FlatAppearance.BorderSize = 1
$browseBtn.Add_Click({
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Select your Minecraft mods folder"
    $folderBrowser.SelectedPath = $modPathBox.Text
    if ($folderBrowser.ShowDialog() -eq "OK") {
        $modPathBox.Text = $folderBrowser.SelectedPath
    }
})
$tabModScanner.Controls.Add($browseBtn)

# Scan button
$scanBtn = New-Object System.Windows.Forms.Button
$scanBtn.Text = "🚀 SCAN"
$scanBtn.Location = New-Object System.Drawing.Point(850, 18)
$scanBtn.Size = New-Object System.Drawing.Size(120, 30)
$scanBtn.BackColor = $NeonPink
$scanBtn.ForeColor = [System.Drawing.Color]::White
$scanBtn.FlatStyle = "Flat"
$scanBtn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$scanBtn.FlatAppearance.BorderSize = 0
$tabModScanner.Controls.Add($scanBtn)

# Status labels
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = "Ready"
$statusLabel.ForeColor = $TextMuted
$statusLabel.Location = New-Object System.Drawing.Point(20, 60)
$statusLabel.Size = New-Object System.Drawing.Size(300, 20)
$statusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$tabModScanner.Controls.Add($statusLabel)

$modCountLabel = New-Object System.Windows.Forms.Label
$modCountLabel.Text = "Mods: 0"
$modCountLabel.ForeColor = $TextMuted
$modCountLabel.Location = New-Object System.Drawing.Point(350, 60)
$modCountLabel.Size = New-Object System.Drawing.Size(200, 20)
$modCountLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$tabModScanner.Controls.Add($modCountLabel)

# Progress bar
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(20, 85)
$progressBar.Size = New-Object System.Drawing.Size(950, 20)
$progressBar.Style = "Continuous"
$progressBar.ForeColor = $NeonPink
$progressBar.BackColor = $DarkCard
$tabModScanner.Controls.Add($progressBar)

# Results ListView
$resultListView = New-Object System.Windows.Forms.ListView
$resultListView.Location = New-Object System.Drawing.Point(20, 115)
$resultListView.Size = New-Object System.Drawing.Size(950, 300)
$resultListView.BackColor = $DarkCard
$resultListView.ForeColor = $TextColor
$resultListView.Font = New-Object System.Drawing.Font("Consolas", 9)
$resultListView.BorderStyle = "FixedSingle"
$resultListView.FullRowSelect = $true
$resultListView.GridLines = $true
$resultListView.View = "Details"
$resultListView.Columns.Add("Mod Name", 300)
$resultListView.Columns.Add("Status", 150)
$resultListView.Columns.Add("Reason", 450)
$tabModScanner.Controls.Add($resultListView)

# Output box
$outputBox = New-Object System.Windows.Forms.RichTextBox
$outputBox.Location = New-Object System.Drawing.Point(20, 425)
$outputBox.Size = New-Object System.Drawing.Size(950, 180)
$outputBox.BackColor = $DarkCard
$outputBox.ForeColor = $TextColor
$outputBox.Font = New-Object System.Drawing.Font("Consolas", 9)
$outputBox.BorderStyle = "FixedSingle"
$outputBox.ReadOnly = $true
$outputBox.WordWrap = $true
$tabModScanner.Controls.Add($outputBox)

# ─── SCAN FUNCTION ─────────────────────────────────────────────
$scanBtn.Add_Click({
    $modsPath = $modPathBox.Text
    
    if (-not (Test-Path $modsPath)) {
        [System.Windows.Forms.MessageBox]::Show("Invalid mods folder path!", "Error", "OK", "Error")
        return
    }
    
    $scanBtn.Enabled = $false
    $progressBar.Value = 0
    $resultListView.Items.Clear()
    $outputBox.Clear()
    $statusLabel.Text = "🔍 Scanning..."
    
    $jarFiles = Get-ChildItem -Path $modsPath -Filter *.jar -File
    $modCountLabel.Text = "Mods: $($jarFiles.Count)"
    
    $cheatMods = @()
    $verifiedMods = @()
    $unknownMods = @()
    
    $total = $jarFiles.Count
    $counter = 0
    
    $cheatNames = @(
        'wurst','meteor','impact','liquidbounce','aristois','future',
        'sigma','vape','entropy','dqrkis','ketteh','eventplugin',
        'crystalaura','autocrystal','anchoraura','bedaura',
        'client','hack','cheat','module'
    )
    
    $legitMods = @(
        'fabric','forge','sodium','lithium','phosphor','iris',
        'modmenu','worldedit','jei','anchoroptimizer','crystaloptimizer',
        'crossbowoptimizer','consumableoptimizer','optimizer','glow'
    )
    
    foreach ($file in $jarFiles) {
        $counter++
        $pct = [math]::Round(100 * $counter / $total)
        $progressBar.Value = $pct
        $statusLabel.Text = "🔍 Scanning $($file.Name) ($counter/$total)"
        
        $isCheat = $false
        $reason = ""
        $fileName = $file.Name.ToLower()
        
        # Check if legit
        $isLegit = $false
        foreach ($legit in $legitMods) {
            if ($fileName -match $legit) { $isLegit = $true; break }
        }
        
        if (-not $isLegit) {
            foreach ($cheat in $cheatNames) {
                if ($fileName -match $cheat) {
                    $isCheat = $true
                    $reason = "BLATANT CHEAT: $cheat"
                    break
                }
            }
        }
        
        if ($isCheat) {
            $item = New-Object System.Windows.Forms.ListViewItem($file.Name)
            $item.SubItems.Add("🚨 CHEAT")
            $item.SubItems.Add($reason)
            $item.BackColor = [System.Drawing.Color]::FromArgb(40, 0, 0)
            $item.ForeColor = [System.Drawing.Color]::Red
            $resultListView.Items.Add($item)
            $cheatMods += $file.Name
        } elseif ($isLegit) {
            $item = New-Object System.Windows.Forms.ListViewItem($file.Name)
            $item.SubItems.Add("✅ SAFE")
            $item.SubItems.Add("Legit optimization mod")
            $item.BackColor = [System.Drawing.Color]::FromArgb(0, 40, 0)
            $item.ForeColor = [System.Drawing.Color]::Green
            $resultListView.Items.Add($item)
            $verifiedMods += $file.Name
        } else {
            $item = New-Object System.Windows.Forms.ListViewItem($file.Name)
            $item.SubItems.Add("❓ UNKNOWN")
            $item.SubItems.Add("Manual review recommended")
            $item.BackColor = [System.Drawing.Color]::FromArgb(40, 40, 0)
            $item.ForeColor = [System.Drawing.Color]::Yellow
            $resultListView.Items.Add($item)
            $unknownMods += $file.Name
        }
    }
    
    $statusLabel.Text = "✅ Scan Complete!"
    $progressBar.Value = 100
    $scanBtn.Enabled = $true
    
    $outputBox.AppendText("═══════════════════════════════════════════════════════════════════`n")
    $outputBox.AppendText("📊 SCAN RESULTS`n")
    $outputBox.AppendText("═══════════════════════════════════════════════════════════════════`n`n")
    $outputBox.AppendText("🚨 Cheats Found: $($cheatMods.Count)`n", [System.Drawing.Color]::Red)
    $outputBox.AppendText("✅ Verified Safe: $($verifiedMods.Count)`n", [System.Drawing.Color]::Green)
    $outputBox.AppendText("❓ Unknown: $($unknownMods.Count)`n", [System.Drawing.Color]::Yellow)
    $outputBox.AppendText("📦 Total: $($total)`n`n")
    
    if ($cheatMods.Count -gt 0) {
        $outputBox.AppendText("🚨 CHEATS DETECTED:`n", [System.Drawing.Color]::Red)
        foreach ($cheat in $cheatMods) {
            $outputBox.AppendText("  ⚡ $cheat`n", [System.Drawing.Color]::Red)
        }
    }
})

# ============================================================
#  TAB 2: FILE TOOLS
# ============================================================
$tabFileTools = New-Object System.Windows.Forms.TabPage
$tabFileTools.Text = "🛠 File Tools"
$tabFileTools.BackColor = $DarkBg
$tabControl.TabPages.Add($tabFileTools)

# File Hasher
$hashLabel = New-Object System.Windows.Forms.Label
$hashLabel.Text = "🔒 File Hasher:"
$hashLabel.ForeColor = $TextColor
$hashLabel.Location = New-Object System.Drawing.Point(20, 20)
$hashLabel.Size = New-Object System.Drawing.Size(100, 25)
$hashLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$tabFileTools.Controls.Add($hashLabel)

$hashPathBox = New-Object System.Windows.Forms.TextBox
$hashPathBox.Location = New-Object System.Drawing.Point(130, 20)
$hashPathBox.Size = New-Object System.Drawing.Size(600, 25)
$hashPathBox.BackColor = $DarkCard
$hashPathBox.ForeColor = $TextColor
$hashPathBox.BorderStyle = "FixedSingle"
$hashPathBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$tabFileTools.Controls.Add($hashPathBox)

$hashBrowseBtn = New-Object System.Windows.Forms.Button
$hashBrowseBtn.Text = "📁 Browse"
$hashBrowseBtn.Location = New-Object System.Drawing.Point(740, 18)
$hashBrowseBtn.Size = New-Object System.Drawing.Size(100, 30)
$hashBrowseBtn.BackColor = $DarkCard
$hashBrowseBtn.ForeColor = $NeonCyan
$hashBrowseBtn.FlatStyle = "Flat"
$hashBrowseBtn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$hashBrowseBtn.FlatAppearance.BorderColor = $NeonCyan
$hashBrowseBtn.FlatAppearance.BorderSize = 1
$hashBrowseBtn.Add_Click({
    $openFile = New-Object System.Windows.Forms.OpenFileDialog
    if ($openFile.ShowDialog() -eq "OK") {
        $hashPathBox.Text = $openFile.FileName
        $hashOutputBox.Clear()
        $hashOutputBox.AppendText("═══════════════════════════════════════════════════════════════════`n")
        $hashOutputBox.AppendText("🔐 FILE HASH RESULTS`n")
        $hashOutputBox.AppendText("═══════════════════════════════════════════════════════════════════`n`n")
        $hashOutputBox.AppendText("📁 File: $(Split-Path $openFile.FileName -Leaf)`n")
        $hashOutputBox.AppendText("📂 Path: $($openFile.FileName)`n")
        $hashOutputBox.AppendText("📦 Size: $((Get-Item $openFile.FileName).Length) bytes`n`n")
        
        try {
            $sha1 = Get-FileHash -Path $openFile.FileName -Algorithm SHA1
            $md5 = Get-FileHash -Path $openFile.FileName -Algorithm MD5
            $hashOutputBox.AppendText("🔑 SHA1: $($sha1.Hash)`n")
            $hashOutputBox.AppendText("🔑 MD5:  $($md5.Hash)`n")
        } catch {
            $hashOutputBox.AppendText("❌ Error hashing file!`n")
        }
    }
})
$tabFileTools.Controls.Add($hashBrowseBtn)

$hashBtn = New-Object System.Windows.Forms.Button
$hashBtn.Text = "🔐 Hash It!"
$hashBtn.Location = New-Object System.Drawing.Point(850, 18)
$hashBtn.Size = New-Object System.Drawing.Size(100, 30)
$hashBtn.BackColor = $NeonPurple
$hashBtn.ForeColor = [System.Drawing.Color]::White
$hashBtn.FlatStyle = "Flat"
$hashBtn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$hashBtn.FlatAppearance.BorderSize = 0
$hashBtn.Add_Click({
    if ($hashPathBox.Text -and (Test-Path $hashPathBox.Text)) {
        $hashOutputBox.Clear()
        $hashOutputBox.AppendText("═══════════════════════════════════════════════════════════════════`n")
        $hashOutputBox.AppendText("🔐 FILE HASH RESULTS`n")
        $hashOutputBox.AppendText("═══════════════════════════════════════════════════════════════════`n`n")
        $hashOutputBox.AppendText("📁 File: $(Split-Path $hashPathBox.Text -Leaf)`n")
        $hashOutputBox.AppendText("📂 Path: $($hashPathBox.Text)`n")
        $hashOutputBox.AppendText("📦 Size: $((Get-Item $hashPathBox.Text).Length) bytes`n`n")
        
        try {
            $sha1 = Get-FileHash -Path $hashPathBox.Text -Algorithm SHA1
            $md5 = Get-FileHash -Path $hashPathBox.Text -Algorithm MD5
            $hashOutputBox.AppendText("🔑 SHA1: $($sha1.Hash)`n")
            $hashOutputBox.AppendText("🔑 MD5:  $($md5.Hash)`n")
        } catch {
            $hashOutputBox.AppendText("❌ Error hashing file!`n")
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please select a valid file!", "Error", "OK", "Error")
    }
})
$tabFileTools.Controls.Add($hashBtn)

$hashOutputBox = New-Object System.Windows.Forms.RichTextBox
$hashOutputBox.Location = New-Object System.Drawing.Point(20, 65)
$hashOutputBox.Size = New-Object System.Drawing.Size(930, 350)
$hashOutputBox.BackColor = $DarkCard
$hashOutputBox.ForeColor = $TextColor
$hashOutputBox.Font = New-Object System.Drawing.Font("Consolas", 9)
$hashOutputBox.BorderStyle = "FixedSingle"
$hashOutputBox.ReadOnly = $true
$hashOutputBox.WordWrap = $true
$tabFileTools.Controls.Add($hashOutputBox)

# ============================================================
#  TAB 3: PROCESS SCANNER
# ============================================================
$tabProcess = New-Object System.Windows.Forms.TabPage
$tabProcess.Text = "🖥️ Process Scanner"
$tabProcess.BackColor = $DarkBg
$tabControl.TabPages.Add($tabProcess)

$procScanBtn = New-Object System.Windows.Forms.Button
$procScanBtn.Text = "🔍 Scan Processes"
$procScanBtn.Location = New-Object System.Drawing.Point(20, 20)
$procScanBtn.Size = New-Object System.Drawing.Size(150, 35)
$procScanBtn.BackColor = $NeonCyan
$procScanBtn.ForeColor = [System.Drawing.Color]::White
$procScanBtn.FlatStyle = "Flat"
$procScanBtn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$procScanBtn.FlatAppearance.BorderSize = 0
$procScanBtn.Add_Click({
    $procOutputBox.Clear()
    $procOutputBox.AppendText("═══════════════════════════════════════════════════════════════════`n")
    $procOutputBox.AppendText("🖥️ RUNNING PROCESSES`n")
    $procOutputBox.AppendText("═══════════════════════════════════════════════════════════════════`n`n")
    
    $processes = Get-Process
    $mcProcesses = $processes | Where-Object { $_.ProcessName -match "java|javaw" }
    $otherProcesses = $processes | Where-Object { $_.ProcessName -notmatch "java|javaw" }
    
    $procOutputBox.AppendText("🎮 MINECRAFT PROCESSES:`n", [System.Drawing.Color]::Cyan)
    if ($mcProcesses) {
        foreach ($p in $mcProcesses) {
            try {
                $procOutputBox.AppendText("  ▶ $($p.ProcessName).exe (PID: $($p.Id)) — Running`n", [System.Drawing.Color]::Green)
            } catch {}
        }
    } else {
        $procOutputBox.AppendText("  ❌ No Minecraft processes found`n", [System.Drawing.Color]::Red)
    }
    
    $procOutputBox.AppendText("`n📊 OTHER PROCESSES (Top 20):`n", [System.Drawing.Color]::Cyan)
    $count = 0
    foreach ($p in $otherProcesses | Sort-Object ProcessName) {
        if ($count++ -gt 20) { break }
        try {
            $mem = [math]::Round($p.WorkingSet64 / 1MB, 1)
            $procOutputBox.AppendText("  ▸ $($p.ProcessName).exe (PID: $($p.Id)) — ${mem}MB`n", [System.Drawing.Color]::Gray)
        } catch {}
    }
    
    $procOutputBox.AppendText("`n═══════════════════════════════════════════════════════════════════`n")
    $procOutputBox.AppendText("✅ Total Processes: $($processes.Count)`n", [System.Drawing.Color]::Green)
    $procOutputBox.AppendText("✅ Minecraft Processes: $($mcProcesses.Count)`n", [System.Drawing.Color]::Green)
})
$tabProcess.Controls.Add($procScanBtn)

$procOutputBox = New-Object System.Windows.Forms.RichTextBox
$procOutputBox.Location = New-Object System.Drawing.Point(20, 70)
$procOutputBox.Size = New-Object System.Drawing.Size(930, 380)
$procOutputBox.BackColor = $DarkCard
$procOutputBox.ForeColor = $TextColor
$procOutputBox.Font = New-Object System.Drawing.Font("Consolas", 9)
$procOutputBox.BorderStyle = "FixedSingle"
$procOutputBox.ReadOnly = $true
$procOutputBox.WordWrap = $true
$tabProcess.Controls.Add($procOutputBox)

# ============================================================
#  TAB 4: ABOUT
# ============================================================
$tabAbout = New-Object System.Windows.Forms.TabPage
$tabAbout.Text = "ℹ About"
$tabAbout.BackColor = $DarkBg
$tabControl.TabPages.Add($tabAbout)

$aboutLabel = New-Object System.Windows.Forms.Label
$aboutLabel.Text = @"
⚡ KETTEH TOOLS v1.0 ⚡

🔍 Mod Scanner - Detect cheats in your mods folder
🔒 File Hasher - Get SHA1/MD5 of any file
🖥️ Process Scanner - Scan running processes

🔥 Made by Ketteh - Justice Served
"@
$aboutLabel.ForeColor = $TextColor
$aboutLabel.Location = New-Object System.Drawing.Point(50, 50)
$aboutLabel.Size = New-Object System.Drawing.Size(800, 250)
$aboutLabel.Font = New-Object System.Drawing.Font("Segoe UI", 12)
$aboutLabel.TextAlign = "MiddleCenter"
$tabAbout.Controls.Add($aboutLabel)

# ─── RUN THE FORM ─────────────────────────────────────────────
$form.Add_Shown({ $form.Activate() })
[System.Windows.Forms.Application]::Run($form)
