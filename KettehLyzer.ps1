# ============================================================
#  ██╗  ██╗███████╗████████╗████████╗███████╗██╗  ██╗██╗  ██╗
#  ██║ ██╔╝██╔════╝╚══██╔══╝╚══██╔══╝██╔════╝██║  ██║██║  ╚██╗
#  █████╔╝ █████╗     ██║      ██║   █████╗  ███████║██║   ╚██╗
#  ██╔═██╗ ██╔══╝     ██║      ██║   ██╔══╝  ██╔══██║██║    ██║
#  ██║  ██╗███████╗   ██║      ██║   ███████╗██║  ██║███████╗██║
#  ╚═╝  ╚═╝╚══════╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝
#              KETTEH TOOLS CYBER v3.0
#           NEXT-LEVEL JUSTICE SUITE 🔥
# ============================================================

# Clear PowerShell window
Clear-Host

# ─── LOAD ASSEMBLIES ──────────────────────────────────────────
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.IO.Compression.FileSystem
Add-Type -AssemblyName System.Net.Http

# ─── COLOR SCHEME ─────────────────────────────────────────────
$DarkBg = [System.Drawing.Color]::FromArgb(8, 8, 20)
$DarkCard = [System.Drawing.Color]::FromArgb(18, 18, 40)
$DarkHover = [System.Drawing.Color]::FromArgb(28, 28, 55)
$NeonPink = [System.Drawing.Color]::FromArgb(255, 0, 100)
$NeonCyan = [System.Drawing.Color]::FromArgb(0, 212, 255)
$NeonPurple = [System.Drawing.Color]::FromArgb(160, 80, 255)
$NeonGreen = [System.Drawing.Color]::FromArgb(0, 255, 157)
$NeonYellow = [System.Drawing.Color]::FromArgb(255, 215, 0)
$TextColor = [System.Drawing.Color]::FromArgb(240, 240, 255)
$TextMuted = [System.Drawing.Color]::FromArgb(136, 136, 187)
$BorderGlow = [System.Drawing.Color]::FromArgb(255, 0, 100, 50)

# ─── MAIN FORM ─────────────────────────────────────────────────
$form = New-Object System.Windows.Forms.Form
$form.Text = "⚡ KETTEH TOOLS CYBER ⚡"
$form.Size = New-Object System.Drawing.Size(1250, 850)
$form.StartPosition = "CenterScreen"
$form.BackColor = $DarkBg
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false
$form.MinimumSize = New-Object System.Drawing.Size(1100, 750)
$form.Opacity = 0.98
$form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon((Get-Command powershell).Path)

# ─── GLOW BACKGROUND ──────────────────────────────────────────
$bgPanel = New-Object System.Windows.Forms.Panel
$bgPanel.Dock = "Fill"
$bgPanel.BackColor = $DarkBg
$form.Controls.Add($bgPanel)

# ─── TOP HEADER WITH GLOW ─────────────────────────────────────
$headerPanel = New-Object System.Windows.Forms.Panel
$headerPanel.Dock = "Top"
$headerPanel.Height = 80
$headerPanel.BackColor = $DarkCard
$headerPanel.BorderStyle = "FixedSingle"
$headerPanel.Padding = New-Object System.Windows.Forms.Padding(15, 0, 15, 0)
$bgPanel.Controls.Add($headerPanel)

# Logo with gradient
$logoLabel = New-Object System.Windows.Forms.Label
$logoLabel.Text = "⚡ KETTEH TOOLS CYBER ⚡"
$logoLabel.Font = New-Object System.Drawing.Font("Consolas", 22, [System.Drawing.FontStyle]::Bold)
$logoLabel.ForeColor = $NeonPink
$logoLabel.BackColor = $DarkCard
$logoLabel.Location = New-Object System.Drawing.Point(20, 10)
$logoLabel.Size = New-Object System.Drawing.Size(500, 50)
$logoLabel.TextAlign = "MiddleLeft"
$headerPanel.Controls.Add($logoLabel)

# Glow effect on logo
$glowLabel = New-Object System.Windows.Forms.Label
$glowLabel.Text = "⚡ KETTEH TOOLS CYBER ⚡"
$glowLabel.Font = New-Object System.Drawing.Font("Consolas", 22, [System.Drawing.FontStyle]::Bold)
$glowLabel.ForeColor = $NeonPink
$glowLabel.BackColor = $DarkCard
$glowLabel.Location = New-Object System.Drawing.Point(22, 12)
$glowLabel.Size = New-Object System.Drawing.Size(500, 50)
$glowLabel.TextAlign = "MiddleLeft"
$glowLabel.Enabled = $false
$glowLabel.BackColor = [System.Drawing.Color]::Transparent
$headerPanel.Controls.Add($glowLabel)

# Version
$versionLabel = New-Object System.Windows.Forms.Label
$versionLabel.Text = "v3.0  |  CYBER JUSTICE ENGINE"
$versionLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
$versionLabel.ForeColor = $TextMuted
$versionLabel.BackColor = $DarkCard
$versionLabel.Location = New-Object System.Drawing.Point(20, 55)
$versionLabel.Size = New-Object System.Drawing.Size(400, 20)
$headerPanel.Controls.Add($versionLabel)

# Status with pulse animation
$statusPanel = New-Object System.Windows.Forms.Panel
$statusPanel.Location = New-Object System.Drawing.Point(1040, 20)
$statusPanel.Size = New-Object System.Drawing.Size(170, 40)
$statusPanel.BackColor = [System.Drawing.Color]::FromArgb(0, 40, 20)
$statusPanel.BorderStyle = "FixedSingle"
$headerPanel.Controls.Add($statusPanel)

$statusIndicator = New-Object System.Windows.Forms.Label
$statusIndicator.Text = "● ONLINE"
$statusIndicator.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$statusIndicator.ForeColor = $NeonGreen
$statusIndicator.BackColor = [System.Drawing.Color]::Transparent
$statusIndicator.Location = New-Object System.Drawing.Point(10, 5)
$statusIndicator.Size = New-Object System.Drawing.Size(150, 30)
$statusIndicator.TextAlign = "MiddleCenter"
$statusPanel.Controls.Add($statusIndicator)

# ─── TAB CONTROL ──────────────────────────────────────────────
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Dock = "Fill"
$tabControl.BackColor = $DarkBg
$tabControl.ForeColor = $TextColor
$tabControl.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$tabControl.Padding = New-Object System.Drawing.Point(15, 10)
$tabControl.SizeMode = "Fixed"
$tabControl.ItemSize = New-Object System.Drawing.Size(140, 40)
$tabControl.Alignment = "Top"
$bgPanel.Controls.Add($tabControl)

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

$modPanel = New-Object System.Windows.Forms.Panel
$modPanel.Dock = "Fill"
$modPanel.BackColor = $DarkBg
$modPanel.Padding = New-Object System.Windows.Forms.Padding(20)
$tabModScanner.Controls.Add($modPanel)

# ─── PATH SECTION ─────────────────────────────────────────────
$pathGroup = New-Object System.Windows.Forms.Panel
$pathGroup.Location = New-Object System.Drawing.Point(20, 20)
$pathGroup.Size = New-Object System.Drawing.Size(1160, 80)
$pathGroup.BackColor = $DarkCard
$pathGroup.BorderStyle = "FixedSingle"
$pathGroup.Padding = New-Object System.Windows.Forms.Padding(10)
$modPanel.Controls.Add($pathGroup)

$pathLabel = New-Object System.Windows.Forms.Label
$pathLabel.Text = "📂 TARGET DIRECTORY"
$pathLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$pathLabel.ForeColor = $NeonCyan
$pathLabel.Location = New-Object System.Drawing.Point(15, 5)
$pathLabel.Size = New-Object System.Drawing.Size(300, 25)
$pathGroup.Controls.Add($pathLabel)

$modPathBox = New-Object System.Windows.Forms.TextBox
$modPathBox.Location = New-Object System.Drawing.Point(15, 35)
$modPathBox.Size = New-Object System.Drawing.Size(850, 30)
$modPathBox.BackColor = $DarkBg
$modPathBox.ForeColor = $TextColor
$modPathBox.BorderStyle = "FixedSingle"
$modPathBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$modPathBox.Text = Join-Path $env:APPDATA ".minecraft\mods"
$pathGroup.Controls.Add($modPathBox)

$browseBtn = New-Object System.Windows.Forms.Button
$browseBtn.Text = "📂 BROWSE"
$browseBtn.Location = New-Object System.Drawing.Point(875, 33)
$browseBtn.Size = New-Object System.Drawing.Size(120, 35)
$browseBtn.BackColor = $DarkBg
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
$scanBtn.Location = New-Object System.Drawing.Point(1005, 33)
$scanBtn.Size = New-Object System.Drawing.Size(140, 35)
$scanBtn.BackColor = $NeonPink
$scanBtn.ForeColor = [System.Drawing.Color]::White
$scanBtn.FlatStyle = "Flat"
$scanBtn.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$scanBtn.FlatAppearance.BorderSize = 0
$scanBtn.Cursor = [System.Windows.Forms.Cursors]::Hand
$pathGroup.Controls.Add($scanBtn)

# ─── STATS SECTION ────────────────────────────────────────────
$statsPanel = New-Object System.Windows.Forms.Panel
$statsPanel.Location = New-Object System.Drawing.Point(20, 115)
$statsPanel.Size = New-Object System.Drawing.Size(1160, 50)
$statsPanel.BackColor = $DarkCard
$statsPanel.BorderStyle = "FixedSingle"
$modPanel.Controls.Add($statsPanel)

$statsData = @(
    @{Text = "📦 TOTAL"; Color = $TextColor; Id = "totalLabel"},
    @{Text = "✅ SAFE"; Color = $NeonGreen; Id = "safeLabel"},
    @{Text = "❓ UNKNOWN"; Color = $NeonYellow; Id = "unknownLabel"},
    @{Text = "🚨 CHEATS"; Color = $NeonPink; Id = "cheatLabel"}
)

$statsLabels = @{}
for ($i = 0; $i -lt $statsData.Count; $i++) {
    $panel = New-Object System.Windows.Forms.Panel
    $panel.Location = New-Object System.Drawing.Point(20 + ($i * 280), 5)
    $panel.Size = New-Object System.Drawing.Size(260, 40)
    $panel.BackColor = $DarkBg
    $statsPanel.Controls.Add($panel)
    
    $label = New-Object System.Windows.Forms.Label
    $label.Text = "$($statsData[$i].Text): 0"
    $label.ForeColor = $statsData[$i].Color
    $label.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
    $label.Location = New-Object System.Drawing.Point(10, 8)
    $label.Size = New-Object System.Drawing.Size(240, 25)
    $label.TextAlign = "MiddleCenter"
    $label.Name = $statsData[$i].Id
    $panel.Controls.Add($label)
    $statsLabels[$statsData[$i].Id] = $label
}

# ─── PROGRESS ──────────────────────────────────────────────────
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(20, 175)
$progressBar.Size = New-Object System.Drawing.Size(1160, 20)
$progressBar.Style = "Continuous"
$progressBar.ForeColor = $NeonPink
$progressBar.BackColor = $DarkCard
$progressBar.Value = 0
$modPanel.Controls.Add($progressBar)

# ─── RESULTS ──────────────────────────────────────────────────
$resultListView = New-Object System.Windows.Forms.ListView
$resultListView.Location = New-Object System.Drawing.Point(20, 205)
$resultListView.Size = New-Object System.Drawing.Size(1160, 280)
$resultListView.BackColor = $DarkCard
$resultListView.ForeColor = $TextColor
$resultListView.Font = New-Object System.Drawing.Font("Consolas", 10)
$resultListView.BorderStyle = "FixedSingle"
$resultListView.FullRowSelect = $true
$resultListView.GridLines = $true
$resultListView.View = "Details"
$resultListView.OwnerDraw = $true
$resultListView.Columns.Add("Mod Name", 380)
$resultListView.Columns.Add("Status", 150)
$resultListView.Columns.Add("Reason", 500)

$resultListView.Add_DrawColumnHeader({
    param($sender, $e)
    $e.Graphics.FillRectangle([System.Drawing.Brushes]::FromColor($DarkCard), $e.Bounds)
    $e.Graphics.DrawRectangle([System.Drawing.Pen]::new($NeonPink, 1), $e.Bounds)
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

# ─── OUTPUT ────────────────────────────────────────────────────
$outputBox = New-Object System.Windows.Forms.RichTextBox
$outputBox.Location = New-Object System.Drawing.Point(20, 495)
$outputBox.Size = New-Object System.Drawing.Size(1160, 210)
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
    
    $statsLabels["totalLabel"].Text = "📦 TOTAL: 0"
    $statsLabels["safeLabel"].Text = "✅ SAFE: 0"
    $statsLabels["unknownLabel"].Text = "❓ UNKNOWN: 0"
    $statsLabels["cheatLabel"].Text = "🚨 CHEATS: 0"
    
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
        'injection','obfuscate','crystalpvp'
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
        
        foreach ($legit in $legitMods) {
            if ($fileName -match $legit) { 
                $isLegit = $true
                $reason = "Verified optimization mod"
                break 
            }
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
        
        $statsLabels["totalLabel"].Text = "📦 TOTAL: $counter"
        $statsLabels["safeLabel"].Text = "✅ SAFE: $safeCount"
        $statsLabels["unknownLabel"].Text = "❓ UNKNOWN: $unknownCount"
        $statsLabels["cheatLabel"].Text = "🚨 CHEATS: $cheatCount"
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
$filePanel.Padding = New-Object System.Windows.Forms.Padding(20)
$tabFileTools.Controls.Add($filePanel)

$hashGroup = New-Object System.Windows.Forms.Panel
$hashGroup.Location = New-Object System.Drawing.Point(20, 20)
$hashGroup.Size = New-Object System.Drawing.Size(1160, 80)
$hashGroup.BackColor = $DarkCard
$hashGroup.BorderStyle = "FixedSingle"
$hashGroup.Padding = New-Object System.Windows.Forms.Padding(10)
$filePanel.Controls.Add($hashGroup)

$hashLabel = New-Object System.Windows.Forms.Label
$hashLabel.Text = "🔐 FILE HASHER"
$hashLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$hashLabel.ForeColor = $NeonPurple
$hashLabel.Location = New-Object System.Drawing.Point(15, 5)
$hashLabel.Size = New-Object System.Drawing.Size(300, 25)
$hashGroup.Controls.Add($hashLabel)

$hashPathBox = New-Object System.Windows.Forms.TextBox
$hashPathBox.Location = New-Object System.Drawing.Point(15, 35)
$hashPathBox.Size = New-Object System.Drawing.Size(850, 30)
$hashPathBox.BackColor = $DarkBg
$hashPathBox.ForeColor = $TextColor
$hashPathBox.BorderStyle = "FixedSingle"
$hashPathBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$hashGroup.Controls.Add($hashPathBox)

$hashBrowseBtn = New-Object System.Windows.Forms.Button
$hashBrowseBtn.Text = "📂 BROWSE"
$hashBrowseBtn.Location = New-Object System.Drawing.Point(875, 33)
$hashBrowseBtn.Size = New-Object System.Drawing.Size(120, 35)
$hashBrowseBtn.BackColor = $DarkBg
$hashBrowseBtn.ForeColor = $NeonPurple
$hashBrowseBtn.FlatStyle = "Flat"
$hashBrowseBtn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$hashBrowseBtn.FlatAppearance.BorderColor = $NeonPurple
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
$hashBtn.Text = "🔐 HASH IT!"
$hashBtn.Location = New-Object System.Drawing.Point(1005, 33)
$hashBtn.Size = New-Object System.Drawing.Size(140, 35)
$hashBtn.BackColor = $NeonPurple
$hashBtn.ForeColor = [System.Drawing.Color]::White
$hashBtn.FlatStyle = "Flat"
$hashBtn.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
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
$hashOutputBox.Location = New-Object System.Drawing.Point(20, 115)
$hashOutputBox.Size = New-Object System.Drawing.Size(1160, 590)
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
$procPanel.Padding = New-Object System.Windows.Forms.Padding(20)
$tabProcess.Controls.Add($procPanel)

$procScanBtn = New-Object System.Windows.Forms.Button
$procScanBtn.Text = "🔍 SCAN PROCESSES"
$procScanBtn.Location = New-Object System.Drawing.Point(20, 20)
$procScanBtn.Size = New-Object System.Drawing.Size(220, 50)
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
            $procOutputBox.AppendText("  ▸ $($p.ProcessName).exe (PID: $
