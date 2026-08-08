# ============================================================
#  ██╗  ██╗███████╗████████╗████████╗███████╗██╗  ██╗██╗  ██╗
#  ██║ ██╔╝██╔════╝╚══██╔══╝╚══██╔══╝██╔════╝██║  ██║██║  ╚██╗
#  █████╔╝ █████╗     ██║      ██║   █████╗  ███████║██║   ╚██╗
#  ██╔═██╗ ██╔══╝     ██║      ██║   ██╔══╝  ██╔══██║██║    ██║
#  ██║  ██╗███████╗   ██║      ██║   ███████╗██║  ██║███████╗██║
#  ╚═╝  ╚═╝╚══════╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝
#              KETTEH TOOLS PRO v2.0
#           NEXT-GEN JUSTICE SUITE 🔥
# ============================================================

# Clear PowerShell window
Clear-Host

# ─── LOAD ASSEMBLIES ──────────────────────────────────────────
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.IO.Compression.FileSystem
Add-Type -AssemblyName System.Net.Http

# ─── COLOR SCHEME ─────────────────────────────────────────────
$DarkBg = [System.Drawing.Color]::FromArgb(12, 12, 28)
$DarkCard = [System.Drawing.Color]::FromArgb(22, 22, 45)
$DarkHover = [System.Drawing.Color]::FromArgb(30, 30, 60)
$NeonPink = [System.Drawing.Color]::FromArgb(255, 45, 155)
$NeonCyan = [System.Drawing.Color]::FromArgb(0, 212, 255)
$NeonPurple = [System.Drawing.Color]::FromArgb(180, 77, 255)
$NeonGreen = [System.Drawing.Color]::FromArgb(0, 255, 157)
$TextColor = [System.Drawing.Color]::FromArgb(240, 240, 255)
$TextMuted = [System.Drawing.Color]::FromArgb(136, 136, 187)
$BorderColor = [System.Drawing.Color]::FromArgb(40, 40, 70)

# ─── MAIN FORM ─────────────────────────────────────────────────
$form = New-Object System.Windows.Forms.Form
$form.Text = "⚡ KETTEH TOOLS PRO ⚡"
$form.Size = New-Object System.Drawing.Size(1200, 800)
$form.StartPosition = "CenterScreen"
$form.BackColor = $DarkBg
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false
$form.MinimumSize = New-Object System.Drawing.Size(1000, 700)
$form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon((Get-Command powershell).Path)

# ─── TOP HEADER PANEL ──────────────────────────────────────────
$headerPanel = New-Object System.Windows.Forms.Panel
$headerPanel.Dock = "Top"
$headerPanel.Height = 65
$headerPanel.BackColor = $DarkCard
$headerPanel.BorderStyle = "FixedSingle"
$headerPanel.Padding = New-Object System.Windows.Forms.Padding(10, 0, 10, 0)
$form.Controls.Add($headerPanel)

# Logo
$logoLabel = New-Object System.Windows.Forms.Label
$logoLabel.Text = "⚡ KETTEH TOOLS PRO ⚡"
$logoLabel.Font = New-Object System.Drawing.Font("Consolas", 18, [System.Drawing.FontStyle]::Bold)
$logoLabel.ForeColor = $NeonPink
$logoLabel.BackColor = $DarkCard
$logoLabel.Location = New-Object System.Drawing.Point(20, 10)
$logoLabel.Size = New-Object System.Drawing.Size(400, 40)
$logoLabel.TextAlign = "MiddleLeft"
$headerPanel.Controls.Add($logoLabel)

# Version label
$versionLabel = New-Object System.Windows.Forms.Label
$versionLabel.Text = "v2.0  |  Justice Engine"
$versionLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
$versionLabel.ForeColor = $TextMuted
$versionLabel.BackColor = $DarkCard
$versionLabel.Location = New-Object System.Drawing.Point(20, 45)
$versionLabel.Size = New-Object System.Drawing.Size(300, 20)
$headerPanel.Controls.Add($versionLabel)

# Status indicator
$statusIndicator = New-Object System.Windows.Forms.Label
$statusIndicator.Text = "● READY"
$statusIndicator.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$statusIndicator.ForeColor = $NeonGreen
$statusIndicator.BackColor = $DarkCard
$statusIndicator.Location = New-Object System.Drawing.Point(1000, 20)
$statusIndicator.Size = New-Object System.Drawing.Size(150, 30)
$statusIndicator.TextAlign = "MiddleRight"
$headerPanel.Controls.Add($statusIndicator)

# ─── TAB CONTROL ──────────────────────────────────────────────
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Dock = "Fill"
$tabControl.BackColor = $DarkBg
$tabControl.ForeColor = $TextColor
$tabControl.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
$tabControl.Padding = New-Object System.Drawing.Point(12, 8)
$tabControl.SizeMode = "Fixed"
$tabControl.ItemSize = New-Object System.Drawing.Size(120, 35)
$form.Controls.Add($tabControl)

# ─── TAB STYLING ──────────────────────────────────────────────
$tabControl.Add_DrawItem({
    param($sender, $e)
    $tabPage = $sender.TabPages[$e.Index]
    $rect = $e.Bounds
    $rect.Inflate(2, 2)
    
    if ($e.Index -eq $sender.SelectedIndex) {
        $e.Graphics.FillRectangle([System.Drawing.Brushes]::FromColor($DarkHover), $rect)
        $e.Graphics.DrawRectangle([System.Drawing.Pen]::new($NeonPink, 2), $rect)
        $e.Graphics.DrawString($tabPage.Text, $tabPage.Font, [System.Drawing.Brushes]::White, $rect, [System.Drawing.StringFormat]::GenericDefault)
    } else {
        $e.Graphics.FillRectangle([System.Drawing.Brushes]::FromColor($DarkCard), $rect)
        $e.Graphics.DrawString($tabPage.Text, $tabPage.Font, [System.Drawing.Brushes]::FromColor($TextMuted), $rect, [System.Drawing.StringFormat]::GenericDefault)
    }
})

# ============================================================
#  TAB 1: MOD SCANNER
# ============================================================
$tabModScanner = New-Object System.Windows.Forms.TabPage
$tabModScanner.Text = "🔍  MOD SCANNER"
$tabModScanner.BackColor = $DarkBg
$tabModScanner.UseVisualStyleBackColor = $false
$tabControl.TabPages.Add($tabModScanner)

# ─── MOD SCANNER LAYOUT ──────────────────────────────────────
$modPanel = New-Object System.Windows.Forms.Panel
$modPanel.Dock = "Fill"
$modPanel.BackColor = $DarkBg
$modPanel.Padding = New-Object System.Windows.Forms.Padding(15)
$tabModScanner.Controls.Add($modPanel)

# Path input group
$pathGroup = New-Object System.Windows.Forms.GroupBox
$pathGroup.Text = "📂 Target Directory"
$pathGroup.ForeColor = $NeonCyan
$pathGroup.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$pathGroup.Location = New-Object System.Drawing.Point(15, 15)
$pathGroup.Size = New-Object System.Drawing.Size(1130, 75)
$pathGroup.BackColor = $DarkCard
$pathGroup.FlatStyle = "Flat"
$modPanel.Controls.Add($pathGroup)

$modPathBox = New-Object System.Windows.Forms.TextBox
$modPathBox.Location = New-Object System.Drawing.Point(15, 30)
$modPathBox.Size = New-Object System.Drawing.Size(850, 30)
$modPathBox.BackColor = $DarkBg
$modPathBox.ForeColor = $TextColor
$modPathBox.BorderStyle = "FixedSingle"
$modPathBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$modPathBox.Text = Join-Path $env:APPDATA ".minecraft\mods"
$pathGroup.Controls.Add($modPathBox)

$browseBtn = New-Object System.Windows.Forms.Button
$browseBtn.Text = "📂 Browse"
$browseBtn.Location = New-Object System.Drawing.Point(875, 28)
$browseBtn.Size = New-Object System.Drawing.Size(110, 34)
$browseBtn.BackColor = $DarkCard
$browseBtn.ForeColor = $NeonCyan
$browseBtn.FlatStyle = "Flat"
$browseBtn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$browseBtn.FlatAppearance.BorderColor = $NeonCyan
$browseBtn.FlatAppearance.BorderSize = 2
$browseBtn.Cursor = [System.Windows.Forms.Cursors]::Hand
$browseBtn.Add_Click({
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Select your Minecraft mods folder"
    $folderBrowser.SelectedPath = $modPathBox.Text
    if ($folderBrowser.ShowDialog() -eq "OK") {
        $modPathBox.Text = $folderBrowser.SelectedPath
        $statusIndicator.Text = "● READY"
        $statusIndicator.ForeColor = $NeonGreen
    }
})
$pathGroup.Controls.Add($browseBtn)

$scanBtn = New-Object System.Windows.Forms.Button
$scanBtn.Text = "🚀 SCAN NOW"
$scanBtn.Location = New-Object System.Drawing.Point(995, 28)
$scanBtn.Size = New-Object System.Drawing.Size(120, 34)
$scanBtn.BackColor = $NeonPink
$scanBtn.ForeColor = [System.Drawing.Color]::White
$scanBtn.FlatStyle = "Flat"
$scanBtn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$scanBtn.FlatAppearance.BorderSize = 0
$scanBtn.Cursor = [System.Windows.Forms.Cursors]::Hand
$pathGroup.Controls.Add($scanBtn)

# Stats bar
$statsPanel = New-Object System.Windows.Forms.Panel
$statsPanel.Location = New-Object System.Drawing.Point(15, 105)
$statsPanel.Size = New-Object System.Drawing.Size(1130, 40)
$statsPanel.BackColor = $DarkCard
$modPanel.Controls.Add($statsPanel)

$statsLabels = @()
$statsData = @(
    @{Text = "📦 Total"; Id = "totalLabel"},
    @{Text = "✅ Safe"; Id = "safeLabel"},
    @{Text = "❓ Unknown"; Id = "unknownLabel"},
    @{Text = "🚨 Cheats"; Id = "cheatLabel"}
)

for ($i = 0; $i -lt $statsData.Count; $i++) {
    $label = New-Object System.Windows.Forms.Label
    $label.Text = "$($statsData[$i].Text): 0"
    $label.ForeColor = $TextColor
    $label.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $label.Location = New-Object System.Drawing.Point(20 + ($i * 250), 8)
    $label.Size = New-Object System.Drawing.Size(200, 25)
    $label.Name = $statsData[$i].Id
    $statsPanel.Controls.Add($label)
    $statsLabels += $label
}

# Progress bar
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(15, 150)
$progressBar.Size = New-Object System.Drawing.Size(1130, 25)
$progressBar.Style = "Continuous"
$progressBar.ForeColor = $NeonPink
$progressBar.BackColor = $DarkCard
$progressBar.Value = 0
$modPanel.Controls.Add($progressBar)

# Results ListView
$resultListView = New-Object System.Windows.Forms.ListView
$resultListView.Location = New-Object System.Drawing.Point(15, 185)
$resultListView.Size = New-Object System.Drawing.Size(1130, 280)
$resultListView.BackColor = $DarkCard
$resultListView.ForeColor = $TextColor
$resultListView.Font = New-Object System.Drawing.Font("Consolas", 10)
$resultListView.BorderStyle = "FixedSingle"
$resultListView.FullRowSelect = $true
$resultListView.GridLines = $true
$resultListView.View = "Details"
$resultListView.OwnerDraw = $true
$resultListView.Columns.Add("Mod Name", 350)
$resultListView.Columns.Add("Status", 150)
$resultListView.Columns.Add("Reason", 500)
$resultListView.MultiSelect = $false

# Custom drawing for ListView
$resultListView.Add_DrawColumnHeader({
    param($sender, $e)
    $e.Graphics.FillRectangle([System.Drawing.Brushes]::FromColor($DarkCard), $e.Bounds)
    $e.Graphics.DrawRectangle([System.Drawing.Pen]::new($BorderColor, 1), $e.Bounds)
    $e.Graphics.DrawString($e.Header.Text, $e.Font, [System.Drawing.Brushes]::White, $e.Bounds, [System.Drawing.StringFormat]::GenericDefault)
})

$resultListView.Add_DrawItem({
    param($sender, $e)
    if ($e.Item.Selected) {
        $e.Graphics.FillRectangle([System.Drawing.Brushes]::FromColor($DarkHover), $e.Bounds)
    } else {
        $e.Graphics.FillRectangle([System.Drawing.Brushes]::FromColor($DarkCard), $e.Bounds)
    }
    $e.DrawDefault = $true
})

$modPanel.Controls.Add($resultListView)

# Output box
$outputBox = New-Object System.Windows.Forms.RichTextBox
$outputBox.Location = New-Object System.Drawing.Point(15, 475)
$outputBox.Size = New-Object System.Drawing.Size(1130, 200)
$outputBox.BackColor = $DarkCard
$outputBox.ForeColor = $TextColor
$outputBox.Font = New-Object System.Drawing.Font("Consolas", 9)
$outputBox.BorderStyle = "FixedSingle"
$outputBox.ReadOnly = $true
$outputBox.WordWrap = $true
$outputBox.ScrollBars = "Vertical"
$modPanel.Controls.Add($outputBox)

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
    $statusIndicator.Text = "● SCANNING"
    $statusIndicator.ForeColor = $NeonCyan
    
    # Reset stats
    $statsLabels[0].Text = "📦 Total: 0"
    $statsLabels[1].Text = "✅ Safe: 0"
    $statsLabels[2].Text = "❓ Unknown: 0"
    $statsLabels[3].Text = "🚨 Cheats: 0"
    
    $jarFiles = Get-ChildItem -Path $modsPath -Filter *.jar -File
    $total = $jarFiles.Count
    $counter = 0
    $cheatCount = 0
    $safeCount = 0
    $unknownCount = 0
    
    $cheatNames = @(
        'wurst','meteor','impact','liquidbounce','aristois','future',
        'sigma','vape','entropy','dqrkis','ketteh','eventplugin',
        'crystalaura','autocrystal','anchoraura','bedaura',
        'client','hack','cheat','module','exploit','bypass',
        'injection','obfuscate','crystalpvp','crystalfight'
    )
    
    $legitMods = @(
        'fabric','forge','sodium','lithium','phosphor','iris',
        'modmenu','worldedit','jei','rei','emi','xaero','journeymap',
        'anchoroptimizer','crystaloptimizer','crossbowoptimizer',
        'consumableoptimizer','optimizer','glow','polytone',
        'sodium-extra','placeholder-api','walksylib','yetanotherconfiglib',
        'collective','essential','borderlessfullscreen','autoreconnect',
        'fullbrightnesstoggle','naturalmotionblur','shieldfixes','shieldstatus'
    )
    
    $outputBox.AppendText("═══════════════════════════════════════════════════════════════════`n")
    $outputBox.AppendText("🔍 SCANNING MODS FOLDER`n")
    $outputBox.AppendText("═══════════════════════════════════════════════════════════════════`n")
    $outputBox.AppendText("📂 Path: $modsPath`n")
    $outputBox.AppendText("📦 Found $total mod files`n`n")
    
    foreach ($file in $jarFiles) {
        $counter++
        $pct = [math]::Round(100 * $counter / $total)
        $progressBar.Value = $pct
        $statusIndicator.Text = "● SCANNING $($counter)/$total"
        
        $isCheat = $false
        $isLegit = $false
        $reason = ""
        $fileName = $file.Name.ToLower()
        
        # Check legit mods
        foreach ($legit in $legitMods) {
            if ($fileName -match $legit) { 
                $isLegit = $true
                $reason = "Verified optimization mod"
                break 
            }
        }
        
        # Check cheats
        if (-not $isLegit) {
            foreach ($cheat in $cheatNames) {
                if ($fileName -match $cheat) {
                    $isCheat = $true
                    $reason = "BLATANT CHEAT: $cheat"
                    break
                }
            }
        }
        
        # Add to ListView
        $item = New-Object System.Windows.Forms.ListViewItem($file.Name)
        if ($isCheat) {
            $item.SubItems.Add("🚨 CHEAT")
            $item.SubItems.Add($reason)
            $item.BackColor = [System.Drawing.Color]::FromArgb(50, 0, 0)
            $item.ForeColor = [System.Drawing.Color]::Red
            $cheatCount++
        } elseif ($isLegit) {
            $item.SubItems.Add("✅ SAFE")
            $item.SubItems.Add($reason)
            $item.BackColor = [System.Drawing.Color]::FromArgb(0, 40, 0)
            $item.ForeColor = [System.Drawing.Color]::Green
            $safeCount++
        } else {
            $item.SubItems.Add("❓ UNKNOWN")
            $item.SubItems.Add("Manual review recommended")
            $item.BackColor = [System.Drawing.Color]::FromArgb(40, 40, 0)
            $item.ForeColor = [System.Drawing.Color]::Yellow
            $unknownCount++
        }
        $resultListView.Items.Add($item)
        
        # Update stats
        $statsLabels[0].Text = "📦 Total: $counter"
        $statsLabels[1].Text = "✅ Safe: $safeCount"
        $statsLabels[2].Text = "❓ Unknown: $unknownCount"
        $statsLabels[3].Text = "🚨 Cheats: $cheatCount"
    }
    
    $statusIndicator.Text = "● COMPLETE"
    $statusIndicator.ForeColor = $NeonGreen
    $progressBar.Value = 100
    $scanBtn.Enabled = $true
    
    $outputBox.AppendText("`n═══════════════════════════════════════════════════════════════════`n")
    $outputBox.AppendText("📊 SCAN COMPLETE`n")
    $outputBox.AppendText("═══════════════════════════════════════════════════════════════════`n")
    $outputBox.AppendText("🚨 Cheats Found: $cheatCount`n", [System.Drawing.Color]::Red)
    $outputBox.AppendText("✅ Safe Mods: $safeCount`n", [System.Drawing.Color]::Green)
    $outputBox.AppendText("❓ Unknown: $unknownCount`n", [System.Drawing.Color]::Yellow)
    $outputBox.AppendText("📦 Total: $total`n")
    
    if ($cheatCount -gt 0) {
        $outputBox.AppendText("`n🚨 CHEATS DETECTED:`n", [System.Drawing.Color]::Red)
        foreach ($item in $resultListView.Items) {
            if ($item.SubItems[1].Text -eq "🚨 CHEAT") {
                $outputBox.AppendText("  ⚡ $($item.Text)`n", [System.Drawing.Color]::Red)
            }
        }
    }
})

# ============================================================
#  TAB 2: FILE TOOLS
# ============================================================
$tabFileTools = New-Object System.Windows.Forms.TabPage
$tabFileTools.Text = "🛠  FILE TOOLS"
$tabFileTools.BackColor = $DarkBg
$tabFileTools.UseVisualStyleBackColor = $false
$tabControl.TabPages.Add($tabFileTools)

$filePanel = New-Object System.Windows.Forms.Panel
$filePanel.Dock = "Fill"
$filePanel.BackColor = $DarkBg
$filePanel.Padding = New-Object System.Windows.Forms.Padding(15)
$tabFileTools.Controls.Add($filePanel)

# Hash group
$hashGroup = New-Object System.Windows.Forms.GroupBox
$hashGroup.Text = "🔐 File Hasher"
$hashGroup.ForeColor = $NeonCyan
$hashGroup.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$hashGroup.Location = New-Object System.Drawing.Point(15, 15)
$hashGroup.Size = New-Object System.Drawing.Size(1130, 80)
$hashGroup.BackColor = $DarkCard
$hashGroup.FlatStyle = "Flat"
$filePanel.Controls.Add($hashGroup)

$hashPathBox = New-Object System.Windows.Forms.TextBox
$hashPathBox.Location = New-Object System.Drawing.Point(15, 35)
$hashPathBox.Size = New-Object System.Drawing.Size(850, 30)
$hashPathBox.BackColor = $DarkBg
$hashPathBox.ForeColor = $TextColor
$hashPathBox.BorderStyle = "FixedSingle"
$hashPathBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$hashGroup.Controls.Add($hashPathBox)

$hashBrowseBtn = New-Object System.Windows.Forms.Button
$hashBrowseBtn.Text = "📂 Browse"
$hashBrowseBtn.Location = New-Object System.Drawing.Point(875, 33)
$hashBrowseBtn.Size = New-Object System.Drawing.Size(110, 34)
$hashBrowseBtn.BackColor = $DarkCard
$hashBrowseBtn.ForeColor = $NeonCyan
$hashBrowseBtn.FlatStyle = "Flat"
$hashBrowseBtn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$hashBrowseBtn.FlatAppearance.BorderColor = $NeonCyan
$hashBrowseBtn.FlatAppearance.BorderSize = 2
$hashBrowseBtn.Cursor = [System.Windows.Forms.Cursors]::Hand
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
            $hashOutputBox.AppendText("`n✅ Hash calculation complete!", [System.Drawing.Color]::Green)
        } catch {
            $hashOutputBox.AppendText("❌ Error hashing file!", [System.Drawing.Color]::Red)
        }
    }
})
$hashGroup.Controls.Add($hashBrowseBtn)

$hashBtn = New-Object System.Windows.Forms.Button
$hashBtn.Text = "🔐 Hash It!"
$hashBtn.Location = New-Object System.Drawing.Point(995, 33)
$hashBtn.Size = New-Object System.Drawing.Size(120, 34)
$hashBtn.BackColor = $NeonPurple
$hashBtn.ForeColor = [System.Drawing.Color]::White
$hashBtn.FlatStyle = "Flat"
$hashBtn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$hashBtn.FlatAppearance.BorderSize = 0
$hashBtn.Cursor = [System.Windows.Forms.Cursors]::Hand
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
            $hashOutputBox.AppendText("`n✅ Hash calculation complete!", [System.Drawing.Color]::Green)
        } catch {
            $hashOutputBox.AppendText("❌ Error hashing file!", [System.Drawing.Color]::Red)
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please select a valid file!", "Error", "OK", "Error")
    }
})
$hashGroup.Controls.Add($hashBtn)

$hashOutputBox = New-Object System.Windows.Forms.RichTextBox
$hashOutputBox.Location = New-Object System.Drawing.Point(15, 110)
$hashOutputBox.Size = New-Object System.Drawing.Size(1130, 520)
$hashOutputBox.BackColor = $DarkCard
$hashOutputBox.ForeColor = $TextColor
$hashOutputBox.Font = New-Object System.Drawing.Font("Consolas", 10)
$hashOutputBox.BorderStyle = "FixedSingle"
$hashOutputBox.ReadOnly = $true
$hashOutputBox.WordWrap = $true
$hashOutputBox.ScrollBars = "Vertical"
$filePanel.Controls.Add($hashOutputBox)

# ============================================================
#  TAB 3: PROCESS SCANNER
# ============================================================
$tabProcess = New-Object System.Windows.Forms.TabPage
$tabProcess.Text = "🖥️  PROCESS SCANNER"
$tabProcess.BackColor = $DarkBg
$tabProcess.UseVisualStyleBackColor = $false
$tabControl.TabPages.Add($tabProcess)

$procPanel = New-Object System.Windows.Forms.Panel
$procPanel.Dock = "Fill"
$procPanel.BackColor = $DarkBg
$procPanel.Padding = New-Object System.Windows.Forms.Padding(15)
$tabProcess.Controls.Add($procPanel)

$procScanBtn = New-Object System.Windows.Forms.Button
$procScanBtn.Text = "🔍 SCAN PROCESSES"
$procScanBtn.Location = New-Object System.Drawing.Point(15, 15)
$procScanBtn.Size = New-Object System.Drawing.Size(200, 45)
$procScanBtn.BackColor = $NeonCyan
$procScanBtn.ForeColor = [System.Drawing.Color]::White
$procScanBtn.FlatStyle = "Flat"
$procScanBtn.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$procScanBtn.FlatAppearance.BorderSize = 0
$procScanBtn.Cursor = [System.Windows.Forms.Cursors]::Hand
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
    
    $procOutputBox.AppendText("`n📊 OTHER PROCESSES (Top 25):`n", [System.Drawing.Color]::Cyan)
    $count = 0
    foreach ($p in $otherProcesses | Sort-Object ProcessName) {
        if ($count++ -gt 25) { break }
        try {
            $mem = [math]::Round($p.WorkingSet64 / 1MB, 1)
            $cpu = [math]::Round($p.PrivilegedProcessorTime.TotalMilliseconds / 10, 1)
            $procOutputBox.AppendText("  ▸ $($p.ProcessName).exe (PID: $($p.Id)) — ${mem}MB`n", [System.Drawing.Color]::Gray)
        } catch {}
    }
    
    $procOutputBox.AppendText("`n═══════════════════════════════════════════════════════════════════`n")
    $procOutputBox.AppendText("✅ Total Processes: $($processes.Count)`n", [System.Drawing.Color]::Green)
    $procOutputBox.AppendText("✅ Minecraft Processes: $($mcProcesses.Count)`n", [System.Drawing.Color]::Green)
    $procOutputBox.AppendText("═══════════════════════════════════════════════════════════════════`n")
})
$procPanel.Controls.Add($procScanBtn)

$procOutputBox = New-Object System.Windows.Forms.RichTextBox
$procOutputBox.Location = New-Object System.Drawing.Point(15, 75)
$procOutputBox.Size = New-Object System.Drawing.Size(1130, 560)
$procOutputBox.BackColor = $DarkCard
$procOutputBox.ForeColor = $TextColor
$procOutputBox.Font = New-Object System.Drawing.Font("Consolas", 10)
$procOutputBox.BorderStyle = "FixedSingle"
$procOutputBox.ReadOnly = $true
$procOutputBox.WordWrap = $true
$procOutputBox.ScrollBars = "Vertical"
$procPanel.Controls.Add($procOutputBox)

# ============================================================
#  TAB 4: ABOUT
# ============================================================
$tabAbout = New-Object System.Windows.Forms.TabPage
$tabAbout.Text = "ℹ  ABOUT"
$tabAbout.BackColor = $DarkBg
$tabAbout.UseVisualStyleBackColor = $false
$tabControl.TabPages.Add($tabAbout)

$aboutPanel = New-Object System.Windows.Forms.Panel
$aboutPanel.Dock = "Fill"
$aboutPanel.BackColor = $DarkBg
$aboutPanel.Padding = New-Object System.Windows.Forms.Padding(50)
$tabAbout.Controls.Add($aboutPanel)

$aboutLabel = New-Object System.Windows.Forms.Label
$aboutLabel.Text = @"
⚡ KETTEH TOOLS PRO v2.0 ⚡

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔍 MOD SCANNER
  • Scan your Minecraft mods folder
  • Detect cheat clients and suspicious mods
  • Color-coded results (Red = Cheat, Green = Safe, Yellow = Unknown)
  • Real-time progress tracking

🛠 FILE TOOLS
  • Calculate SHA1 and MD5 hashes
  • Browse or paste file path
  • Instant hash results

🖥️ PROCESS SCANNER
  • View all running processes
  • Highlight Minecraft processes
  • Show memory usage

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔥 Made by Ketteh · Justice Served · No Mercy for Cheaters

"@
$aboutLabel.ForeColor = $TextColor
$aboutLabel.Location = New-Object System.Drawing.Point(50, 50)
$aboutLabel.Size = New-Object System.Drawing.Size(900, 500)
$aboutLabel.Font = New-Object System.Drawing.Font("Segoe UI", 11)
$aboutLabel.TextAlign = "TopLeft"
$aboutPanel.Controls.Add($aboutLabel)

# ─── RUN THE FORM ─────────────────────────────────────────────
$form.Add_Shown({ 
    $form.Activate()
    $statusIndicator.Text = "● READY"
    $statusIndicator.ForeColor = $NeonGreen
})

[System.Windows.Forms.Application]::Run($form)
