# ============================================================
#  ██╗  ██╗███████╗████████╗████████╗███████╗██╗  ██╗██╗  ██╗
#  ██║ ██╔╝██╔════╝╚══██╔══╝╚══██╔══╝██╔════╝██║  ██║██║  ╚██╗
#  █████╔╝ █████╗     ██║      ██║   █████╗  ███████║██║   ╚██╗
#  ██╔═██╗ ██╔══╝     ██║      ██║   ██╔══╝  ██╔══██║██║    ██║
#  ██████╔╝███████╗   ██║      ██║   ███████╗██║  ██║███████╗██║
#  ╚═════╝ ╚══════╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝
#              KETTEH TOOLS PRO
#           NEXT-LEVEL JUSTICE SUITE 🔥
# ============================================================

Clear-Host
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.IO.Compression.FileSystem

# ─── COLORS ────────────────────────────────────────────────────
$DarkBg = [System.Drawing.Color]::FromArgb(12, 12, 28)
$DarkCard = [System.Drawing.Color]::FromArgb(22, 22, 45)
$DarkHover = [System.Drawing.Color]::FromArgb(35, 35, 65)
$NeonPink = [System.Drawing.Color]::FromArgb(255, 45, 155)
$NeonCyan = [System.Drawing.Color]::FromArgb(0, 212, 255)
$NeonPurple = [System.Drawing.Color]::FromArgb(160, 80, 255)
$NeonGreen = [System.Drawing.Color]::FromArgb(0, 255, 157)
$NeonYellow = [System.Drawing.Color]::FromArgb(255, 215, 0)
$TextColor = [System.Drawing.Color]::FromArgb(240, 240, 255)
$TextMuted = [System.Drawing.Color]::FromArgb(136, 136, 187)
$BorderGlow = [System.Drawing.Color]::FromArgb(255, 0, 100, 30)

# ─── MAIN FORM ─────────────────────────────────────────────────
$form = New-Object System.Windows.Forms.Form
$form.Text = "⚡ KETTEH TOOLS PRO ⚡"
$form.Size = New-Object System.Drawing.Size(1300, 850)
$form.StartPosition = "CenterScreen"
$form.BackColor = $DarkBg
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false
$form.MinimumSize = New-Object System.Drawing.Size(1100, 750)
$form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon((Get-Command powershell).Path)

# ─── SPLIT CONTAINER ──────────────────────────────────────────
$splitContainer = New-Object System.Windows.Forms.SplitContainer
$splitContainer.Dock = "Fill"
$splitContainer.BackColor = $DarkBg
$splitContainer.SplitterDistance = 280
$splitContainer.SplitterWidth = 2
$splitContainer.SplitterColor = $NeonPink
$form.Controls.Add($splitContainer)

# ─── LEFT PANEL ───────────────────────────────────────────────
$leftPanel = New-Object System.Windows.Forms.Panel
$leftPanel.Dock = "Fill"
$leftPanel.BackColor = $DarkBg
$leftPanel.Padding = New-Object System.Windows.Forms.Padding(10)
$splitContainer.Panel1.Controls.Add($leftPanel)

# Logo
$logoLabel = New-Object System.Windows.Forms.Label
$logoLabel.Text = "⚡ KETTEH TOOLS"
$logoLabel.Font = New-Object System.Drawing.Font("Consolas", 16, [System.Drawing.FontStyle]::Bold)
$logoLabel.ForeColor = $NeonPink
$logoLabel.Location = New-Object System.Drawing.Point(10, 10)
$logoLabel.Size = New-Object System.Drawing.Size(250, 40)
$logoLabel.TextAlign = "MiddleCenter"
$leftPanel.Controls.Add($logoLabel)

$versionLabel = New-Object System.Windows.Forms.Label
$versionLabel.Text = "v3.0  |  JUSTICE ENGINE"
$versionLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$versionLabel.ForeColor = $TextMuted
$versionLabel.Location = New-Object System.Drawing.Point(10, 50)
$versionLabel.Size = New-Object System.Drawing.Size(250, 20)
$versionLabel.TextAlign = "MiddleCenter"
$leftPanel.Controls.Add($versionLabel)

# ─── TOOL CATEGORIES ──────────────────────────────────────────
$categoryLabel = New-Object System.Windows.Forms.Label
$categoryLabel.Text = "📂 TOOLS"
$categoryLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$categoryLabel.ForeColor = $NeonCyan
$categoryLabel.Location = New-Object System.Drawing.Point(10, 85)
$categoryLabel.Size = New-Object System.Drawing.Size(250, 25)
$leftPanel.Controls.Add($categoryLabel)

$categoryList = New-Object System.Windows.Forms.ListBox
$categoryList.Location = New-Object System.Drawing.Point(10, 115)
$categoryList.Size = New-Object System.Drawing.Size(250, 200)
$categoryList.BackColor = $DarkCard
$categoryList.ForeColor = $TextColor
$categoryList.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$categoryList.BorderStyle = "FixedSingle"
$categoryList.Items.AddRange(@("🔍 MOD SCANNER", "🛠 FILE TOOLS", "🖥️ PROCESS SCANNER", "📊 SYSTEM INFO", "🔐 SECURITY TOOLS", "⚡ CHEAT DETECTOR"))
$categoryList.SelectedIndex = 0
$leftPanel.Controls.Add($categoryList)

# ─── STATUS ────────────────────────────────────────────────────
$statusPanel = New-Object System.Windows.Forms.Panel
$statusPanel.Location = New-Object System.Drawing.Point(10, 330)
$statusPanel.Size = New-Object System.Drawing.Size(250, 60)
$statusPanel.BackColor = $DarkCard
$statusPanel.BorderStyle = "FixedSingle"
$leftPanel.Controls.Add($statusPanel)

$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = "● READY"
$statusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$statusLabel.ForeColor = $NeonGreen
$statusLabel.Location = New-Object System.Drawing.Point(10, 10)
$statusLabel.Size = New-Object System.Drawing.Size(230, 40)
$statusLabel.TextAlign = "MiddleCenter"
$statusPanel.Controls.Add($statusLabel)

# ─── ACTION BUTTONS ────────────────────────────────────────────
$actionPanel = New-Object System.Windows.Forms.Panel
$actionPanel.Location = New-Object System.Drawing.Point(10, 400)
$actionPanel.Size = New-Object System.Drawing.Size(250, 180)
$actionPanel.BackColor = $DarkCard
$actionPanel.BorderStyle = "FixedSingle"
$leftPanel.Controls.Add($actionPanel)

$actionLabel = New-Object System.Windows.Forms.Label
$actionLabel.Text = "⚡ ACTIONS"
$actionLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$actionLabel.ForeColor = $NeonYellow
$actionLabel.Location = New-Object System.Drawing.Point(10, 5)
$actionLabel.Size = New-Object System.Drawing.Size(230, 25)
$actionPanel.Controls.Add($actionLabel)

$actions = @(
    @{Text = "📂 Open Install Folder"; Y = 35},
    @{Text = "🧹 Clear Downloaded Files"; Y = 65},
    @{Text = "💻 Open CMD"; Y = 95},
    @{Text = "📋 CREDITS"; Y = 125}
)

foreach ($action in $actions) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $action.Text
    $btn.Location = New-Object System.Drawing.Point(10, $action.Y)
    $btn.Size = New-Object System.Drawing.Size(230, 28)
    $btn.BackColor = $DarkBg
    $btn.ForeColor = $TextColor
    $btn.FlatStyle = "Flat"
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $btn.FlatAppearance.BorderColor = $TextMuted
    $btn.FlatAppearance.BorderSize = 1
    $btn.Cursor = [System.Windows.Forms.Cursors]::Hand
    $btn.Add_Click({
        if ($this.Text -eq "📂 Open Install Folder") {
            $folder = Join-Path $env:USERPROFILE "Downloads\KettehTools"
            if (-not (Test-Path $folder)) { New-Item -ItemType Directory -Path $folder -Force | Out-Null }
            Start-Process $folder
        } elseif ($this.Text -eq "💻 Open CMD") {
            Start-Process cmd
        } elseif ($this.Text -eq "📋 CREDITS") {
            [System.Windows.Forms.MessageBox]::Show("🔥 KETTEH TOOLS PRO v3.0`n`nMade by Ketteh`nDiscord: Ketteh`nGitHub: KettehDev`n`n⚡ Justice Served ⚡", "CREDITS", "OK", "Information")
        } elseif ($this.Text -eq "🧹 Clear Downloaded Files") {
            $folder = Join-Path $env:USERPROFILE "Downloads\KettehTools"
            if (Test-Path $folder) {
                Remove-Item -Path "$folder\*" -Recurse -Force -ErrorAction SilentlyContinue
                [System.Windows.Forms.MessageBox]::Show("Cleared downloaded files!", "Success", "OK", "Information")
            }
        }
    })
    $actionPanel.Controls.Add($btn)
}

# ─── RIGHT PANEL ──────────────────────────────────────────────
$rightPanel = New-Object System.Windows.Forms.Panel
$rightPanel.Dock = "Fill"
$rightPanel.BackColor = $DarkBg
$rightPanel.Padding = New-Object System.Windows.Forms.Padding(15)
$splitContainer.Panel2.Controls.Add($rightPanel)

# ─── RIGHT PANEL HEADER ───────────────────────────────────────
$rightHeader = New-Object System.Windows.Forms.Label
$rightHeader.Text = "🔍 MOD SCANNER"
$rightHeader.Font = New-Object System.Drawing.Font("Consolas", 16, [System.Drawing.FontStyle]::Bold)
$rightHeader.ForeColor = $NeonCyan
$rightHeader.Location = New-Object System.Drawing.Point(15, 15)
$rightHeader.Size = New-Object System.Drawing.Size(900, 35)
$rightPanel.Controls.Add($rightHeader)

$rightSubHeader = New-Object System.Windows.Forms.Label
$rightSubHeader.Text = "Scan your mods folder for cheats and suspicious files"
$rightSubHeader.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$rightSubHeader.ForeColor = $TextMuted
$rightSubHeader.Location = New-Object System.Drawing.Point(15, 50)
$rightSubHeader.Size = New-Object System.Drawing.Size(900, 25)
$rightPanel.Controls.Add($rightSubHeader)

# ─── MAIN CONTENT PANEL ───────────────────────────────────────
$contentPanel = New-Object System.Windows.Forms.Panel
$contentPanel.Location = New-Object System.Drawing.Point(15, 85)
$contentPanel.Size = New-Object System.Drawing.Size(960, 650)
$contentPanel.BackColor = $DarkCard
$contentPanel.BorderStyle = "FixedSingle"
$rightPanel.Controls.Add($contentPanel)

# ─── MOD SCANNER CONTENT ──────────────────────────────────────
$modScannerPanel = New-Object System.Windows.Forms.Panel
$modScannerPanel.Dock = "Fill"
$modScannerPanel.BackColor = $DarkCard
$modScannerPanel.Padding = New-Object System.Windows.Forms.Padding(15)
$contentPanel.Controls.Add($modScannerPanel)

# Path input
$pathLabel = New-Object System.Windows.Forms.Label
$pathLabel.Text = "📂 Mods Folder:"
$pathLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$pathLabel.ForeColor = $TextColor
$pathLabel.Location = New-Object System.Drawing.Point(15, 15)
$pathLabel.Size = New-Object System.Drawing.Size(120, 25)
$modScannerPanel.Controls.Add($pathLabel)

$modPathBox = New-Object System.Windows.Forms.TextBox
$modPathBox.Location = New-Object System.Drawing.Point(140, 15)
$modPathBox.Size = New-Object System.Drawing.Size(580, 30)
$modPathBox.BackColor = $DarkBg
$modPathBox.ForeColor = $TextColor
$modPathBox.BorderStyle = "FixedSingle"
$modPathBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$modPathBox.Text = Join-Path $env:APPDATA ".minecraft\mods"
$modScannerPanel.Controls.Add($modPathBox)

$browseBtn = New-Object System.Windows.Forms.Button
$browseBtn.Text = "📂 Browse"
$browseBtn.Location = New-Object System.Drawing.Point(730, 13)
$browseBtn.Size = New-Object System.Drawing.Size(100, 34)
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
    }
})
$modScannerPanel.Controls.Add($browseBtn)

$scanBtn = New-Object System.Windows.Forms.Button
$scanBtn.Text = "🚀 SCAN"
$scanBtn.Location = New-Object System.Drawing.Point(840, 13)
$scanBtn.Size = New-Object System.Drawing.Size(100, 34)
$scanBtn.BackColor = $NeonPink
$scanBtn.ForeColor = [System.Drawing.Color]::White
$scanBtn.FlatStyle = "Flat"
$scanBtn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$scanBtn.FlatAppearance.BorderSize = 0
$scanBtn.Cursor = [System.Windows.Forms.Cursors]::Hand
$modScannerPanel.Controls.Add($scanBtn)

# Stats row
$statsRow = New-Object System.Windows.Forms.Panel
$statsRow.Location = New-Object System.Drawing.Point(15, 60)
$statsRow.Size = New-Object System.Drawing.Size(925, 35)
$statsRow.BackColor = $DarkBg
$modScannerPanel.Controls.Add($statsRow)

$statsLabels = @{}
$statsData = @(
    @{Text = "📦 Total: 0"; X = 20; Color = $TextColor},
    @{Text = "✅ Safe: 0"; X = 200; Color = $NeonGreen},
    @{Text = "❓ Unknown: 0"; X = 380; Color = $NeonYellow},
    @{Text = "🚨 Cheats: 0"; X = 560; Color = $NeonPink}
)

foreach ($stat in $statsData) {
    $label = New-Object System.Windows.Forms.Label
    $label.Text = $stat.Text
    $label.ForeColor = $stat.Color
    $label.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $label.Location = New-Object System.Drawing.Point($stat.X, 5)
    $label.Size = New-Object System.Drawing.Size(150, 25)
    $statsRow.Controls.Add($label)
    $statsLabels[$stat.Text] = $label
}

# Progress bar
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(15, 105)
$progressBar.Size = New-Object System.Drawing.Size(925, 15)
$progressBar.Style = "Continuous"
$progressBar.ForeColor = $NeonPink
$progressBar.BackColor = $DarkBg
$progressBar.Value = 0
$modScannerPanel.Controls.Add($progressBar)

# Results ListView
$resultListView = New-Object System.Windows.Forms.ListView
$resultListView.Location = New-Object System.Drawing.Point(15, 130)
$resultListView.Size = New-Object System.Drawing.Size(925, 270)
$resultListView.BackColor = $DarkBg
$resultListView.ForeColor = $TextColor
$resultListView.Font = New-Object System.Drawing.Font("Consolas", 9)
$resultListView.BorderStyle = "FixedSingle"
$resultListView.FullRowSelect = $true
$resultListView.GridLines = $true
$resultListView.View = "Details"
$resultListView.Columns.Add("Mod Name", 350)
$resultListView.Columns.Add("Status", 120)
$resultListView.Columns.Add("Reason", 400)
$modScannerPanel.Controls.Add($resultListView)

# Output box
$outputBox = New-Object System.Windows.Forms.RichTextBox
$outputBox.Location = New-Object System.Drawing.Point(15, 410)
$outputBox.Size = New-Object System.Drawing.Size(925, 200)
$outputBox.BackColor = $DarkBg
$outputBox.ForeColor = $TextColor
$outputBox.Font = New-Object System.Drawing.Font("Consolas", 9)
$outputBox.BorderStyle = "FixedSingle"
$outputBox.ReadOnly = $true
$outputBox.WordWrap = $true
$outputBox.ScrollBars = "Vertical"
$modScannerPanel.Controls.Add($outputBox)

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
    $statusLabel.Text = "● SCANNING"
    $statusLabel.ForeColor = $NeonCyan
    
    $statsLabels["📦 Total: 0"].Text = "📦 Total: 0"
    $statsLabels["✅ Safe: 0"].Text = "✅ Safe: 0"
    $statsLabels["❓ Unknown: 0"].Text = "❓ Unknown: 0"
    $statsLabels["🚨 Cheats: 0"].Text = "🚨 Cheats: 0"
    
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
        'client','hack','cheat','module','exploit'
    )
    
    $legitMods = @(
        'fabric','forge','sodium','lithium','phosphor','iris',
        'modmenu','worldedit','jei','rei','emi','xaero','journeymap',
        'anchoroptimizer','crystaloptimizer','crossbowoptimizer',
        'consumableoptimizer','optimizer','glow','polytone'
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
        $statusLabel.Text = "● SCANNING $($counter)/$total"
        
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
        
        $statsLabels["📦 Total: 0"].Text = "📦 Total: $counter"
        $statsLabels["✅ Safe: 0"].Text = "✅ Safe: $safeCount"
        $statsLabels["❓ Unknown: 0"].Text = "❓ Unknown: $unknownCount"
        $statsLabels["🚨 Cheats: 0"].Text = "🚨 Cheats: $cheatCount"
    }
    
    $statusLabel.Text = "● COMPLETE"
    $statusLabel.ForeColor = $NeonGreen
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

# ─── CATEGORY SWITCHING ───────────────────────────────────────
$categoryList.Add_SelectedIndexChanged({
    $selected = $categoryList.SelectedItem
    if ($selected -match "MOD SCANNER") {
        $rightHeader.Text = "🔍 MOD SCANNER"
        $rightSubHeader.Text = "Scan your mods folder for cheats and suspicious files"
        $modScannerPanel.Visible = $true
    } elseif ($selected -match "FILE TOOLS") {
        $rightHeader.Text = "🛠 FILE TOOLS"
        $rightSubHeader.Text = "Calculate SHA1 and MD5 hashes of any file"
        $modScannerPanel.Visible = $false
    } elseif ($selected -match "PROCESS SCANNER") {
        $rightHeader.Text = "🖥️ PROCESS SCANNER"
        $rightSubHeader.Text = "View all running processes on your system"
        $modScannerPanel.Visible = $false
    } elseif ($selected -match "SYSTEM INFO") {
        $rightHeader.Text = "📊 SYSTEM INFO"
        $rightSubHeader.Text = "View detailed system information"
        $modScannerPanel.Visible = $false
    } elseif ($selected -match "SECURITY TOOLS") {
        $rightHeader.Text = "🔐 SECURITY TOOLS"
        $rightSubHeader.Text = "Security and privacy tools"
        $modScannerPanel.Visible = $false
    } elseif ($selected -match "CHEAT DETECTOR") {
        $rightHeader.Text = "⚡ CHEAT DETECTOR"
        $rightSubHeader.Text = "Advanced cheat detection tools"
        $modScannerPanel.Visible = $false
    }
})

# ─── RUN ──────────────────────────────────────────────────────
$form.Add_Shown({ $form.Activate() })
[System.Windows.Forms.Application]::Run($form)
