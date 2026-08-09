Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Xaml
Add-Type -AssemblyName System.IO.Compression.FileSystem

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# =============================================================================
# XAML - Modern Analyzer UI
# =============================================================================
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Ketteh Mod Analyzer" Width="920" Height="640"
        WindowStartupLocation="CenterScreen" WindowStyle="None"
        AllowsTransparency="True" Background="Transparent"
        FontFamily="Segoe UI">

    <Border Background="#0B0B12" CornerRadius="14" BorderBrush="#222233" BorderThickness="1">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="52"/>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="110"/>
            </Grid.RowDefinitions>

            <!-- Title bar -->
            <Border Grid.Row="0" Background="#12121C" CornerRadius="14,14,0,0">
                <Grid Margin="20,0">
                    <TextBlock VerticalAlignment="Center">
                        <Run Text="KETTEH" FontSize="16" FontWeight="Bold" Foreground="#FF4B8B"/>
                        <Run Text="  MOD ANALYZER" FontSize="14" Foreground="#8888AA"/>
                    </TextBlock>
                    <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Center">
                        <Button x:Name="MinBtn" Content="─" Width="36" Height="30" Background="Transparent" Foreground="#666688" BorderThickness="0" Cursor="Hand"/>
                        <Button x:Name="CloseBtn" Content="✕" Width="36" Height="30" Background="Transparent" Foreground="#666688" BorderThickness="0" Cursor="Hand"/>
                    </StackPanel>
                </Grid>
            </Border>

            <!-- Path + Scan -->
            <Border Grid.Row="1" Background="#0F0F18" Padding="20,14">
                <Grid>
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="Auto"/>
                        <ColumnDefinition Width="Auto"/>
                    </Grid.ColumnDefinitions>

                    <TextBox x:Name="PathBox" Height="36" VerticalContentAlignment="Center" Padding="12,0"
                             Background="#1A1A2A" Foreground="#EEEEFF" BorderBrush="#2A2A44" BorderThickness="1"
                             FontSize="13" Text="$env:APPDATA\.minecraft\mods"/>

                    <Button x:Name="BrowseBtn" Grid.Column="1" Content="Browse" Width="90" Height="36" Margin="10,0,0,0"
                            Background="#1A1A2A" Foreground="#DDDDFF" BorderThickness="0" Cursor="Hand" FontSize="13"/>

                    <Button x:Name="ScanBtn" Grid.Column="2" Content="SCAN" Width="100" Height="36" Margin="10,0,0,0"
                            Background="#FF4B8B" Foreground="White" BorderThickness="0" Cursor="Hand" FontSize="13" FontWeight="SemiBold"/>
                </Grid>
            </Border>

            <!-- Results -->
            <Grid Grid.Row="2" Margin="16,8,16,8">
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="*"/>
                </Grid.RowDefinitions>

                <StackPanel Orientation="Horizontal" Margin="0,0,0,10">
                    <Border Background="#1A2A1A" CornerRadius="8" Padding="12,6" Margin="0,0,8,0">
                        <TextBlock x:Name="VerifiedCount" Text="Verified: 0" Foreground="#66FF99" FontSize="12"/>
                    </Border>
                    <Border Background="#2A2A1A" CornerRadius="8" Padding="12,6" Margin="0,0,8,0">
                        <TextBlock x:Name="UnknownCount" Text="Unknown: 0" Foreground="#AAAAAA" FontSize="12"/>
                    </Border>
                    <Border Background="#2A2A0A" CornerRadius="8" Padding="12,6" Margin="0,0,8,0">
                        <TextBlock x:Name="SuspiciousCount" Text="Suspicious: 0" Foreground="#FFCC44" FontSize="12"/>
                    </Border>
                    <Border Background="#2A0A0A" CornerRadius="8" Padding="12,6">
                        <TextBlock x:Name="CheatCount" Text="Cheats: 0" Foreground="#FF6666" FontSize="12"/>
                    </Border>
                </StackPanel>

                <ListView x:Name="ResultList" Grid.Row="1" Background="#12121C" BorderThickness="0"
                          Foreground="#DDDDFF" FontFamily="Consolas" FontSize="12">
                    <ListView.View>
                        <GridView>
                            <GridViewColumn Header="Status" Width="100"/>
                            <GridViewColumn Header="File" Width="280"/>
                            <GridViewColumn Header="Detail" Width="460"/>
                        </GridView>
                    </ListView.View>
                </ListView>
            </Grid>

            <!-- Bottom status -->
            <Border Grid.Row="3" Background="#08080F" CornerRadius="0,0,14,14" BorderBrush="#1C1C2C" BorderThickness="0,1,0,0">
                <Grid Margin="20,12">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    <TextBlock x:Name="ProgressText" Text="Ready to scan" Foreground="#8888AA" FontSize="12" Margin="0,0,0,6"/>
                    <ProgressBar x:Name="ProgressBar" Grid.Row="1" Height="8" Background="#1A1A2A" 
                                 Foreground="#FF4B8B" BorderThickness="0" Value="0"/>
                </Grid>
            </Border>
        </Grid>
    </Border>
</Window>
"@

$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

$MinBtn          = $window.FindName("MinBtn")
$CloseBtn        = $window.FindName("CloseBtn")
$PathBox         = $window.FindName("PathBox")
$BrowseBtn       = $window.FindName("BrowseBtn")
$ScanBtn         = $window.FindName("ScanBtn")
$ResultList      = $window.FindName("ResultList")
$VerifiedCount   = $window.FindName("VerifiedCount")
$UnknownCount    = $window.FindName("UnknownCount")
$SuspiciousCount = $window.FindName("SuspiciousCount")
$CheatCount      = $window.FindName("CheatCount")
$ProgressText    = $window.FindName("ProgressText")
$ProgressBar     = $window.FindName("ProgressBar")

# Set default path
$PathBox.Text = Join-Path $env:APPDATA ".minecraft\mods"

# =============================================================================
# SCAN LOGIC
# =============================================================================
$patterns = @(
    "wurst","meteor","impact","liquidbounce","aristois","future","sigma","vape",
    "dqrkis","grim","prestige","asteria","catlean","vengeance","exhibition",
    "rusherhack","novoline","ghostclient","kamiblue","salhack","clickcrystals",
    "baritone","doomsday","kuro","rise","flux","zero","astolfo","xenon",
    "autocrystal","crystalaura","anchoraura","bedaura","killaura","aimassist",
    "reach","hitbox","triggerbot","nofall","bhop","flight","phase","blink",
    "freecam","scaffold","xray","esp","nametags","chams","tracers",
    "sessionstealer","tokenlogger","tokengrabber","discordtoken","backdoor",
    "meteordevelopment","cc/novoline","com/alan/clients","net/ccbluex"
)

function Get-SHA1([string]$file) {
    try { return (Get-FileHash -LiteralPath $file -Algorithm SHA1 -ErrorAction Stop).Hash }
    catch { return $null }
}

function Query-Modrinth([string]$hash) {
    if (-not $hash) { return $null }
    try {
        $ver = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/version_file/$hash" -TimeoutSec 6 -ErrorAction Stop
        if ($ver.project_id) {
            $proj = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/project/$($ver.project_id)" -TimeoutSec 6 -ErrorAction Stop
            return $proj.title
        }
    } catch {}
    return $null
}

function Scan-Jar([string]$file) {
    $hits = New-Object System.Collections.Generic.List[string]
    $isClient = $false
    try {
        $zip = [System.IO.Compression.ZipFile]::OpenRead($file)
        foreach ($entry in $zip.Entries) {
            $name = $entry.FullName.ToLowerInvariant()
            foreach ($p in $patterns) {
                if ($name.Contains($p)) {
                    if (-not $hits.Contains($p)) { $hits.Add($p) }
                    if ($p -match "wurst|meteor|impact|sigma|vengeance|dqrkis|grim|prestige|exhibition|rusherhack|novoline") {
                        $isClient = $true
                    }
                }
            }
            if ($name.EndsWith(".class")) {
                try {
                    $stream = $entry.Open()
                    $ms = New-Object System.IO.MemoryStream
                    $stream.CopyTo($ms)
                    $stream.Close()
                    $text = [System.Text.Encoding]::ASCII.GetString($ms.ToArray()).ToLowerInvariant()
                    $ms.Dispose()
                    foreach ($p in $patterns) {
                        if ($p.Length -gt 4 -and $text.Contains($p)) {
                            if (-not $hits.Contains($p)) { $hits.Add($p) }
                            if ($p -match "wurst|meteor|impact|sigma|vengeance|dqrkis|grim|prestige|exhibition|rusherhack|novoline") {
                                $isClient = $true
                            }
                        }
                    }
                } catch {}
            }
        }
        $zip.Dispose()
    } catch {}
    return @{ Hits = $hits; IsClient = $isClient }
}

# =============================================================================
# EVENTS
# =============================================================================
$window.Add_MouseLeftButtonDown({ try { $window.DragMove() } catch {} })
$CloseBtn.Add_Click({ $window.Close() })
$MinBtn.Add_Click({ $window.WindowState = "Minimized" })

$BrowseBtn.Add_Click({
    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $dialog.Description = "Select Minecraft mods folder"
    if ($dialog.ShowDialog() -eq "OK") {
        $PathBox.Text = $dialog.SelectedPath
    }
})

$ScanBtn.Add_Click({
    $path = $PathBox.Text.Trim()
    if (-not (Test-Path -LiteralPath $path -PathType Container)) {
        $ProgressText.Text = "Invalid folder path"
        return
    }

    $ResultList.Items.Clear()
    $ScanBtn.IsEnabled = $false
    $ProgressText.Text = "Starting scan..."
    $ProgressBar.Value = 0

    $jars = @(Get-ChildItem -LiteralPath $path -Filter "*.jar" -File -ErrorAction SilentlyContinue)
    $total = $jars.Count

    if ($total -eq 0) {
        $ProgressText.Text = "No .jar files found"
        $ScanBtn.IsEnabled = $true
        return
    }

    $v = 0; $u = 0; $s = 0; $c = 0
    $i = 0

    foreach ($jar in $jars) {
        $i++
        $ProgressBar.Value = ($i / $total) * 100
        $ProgressText.Text = "Scanning $i / $total  —  $($jar.Name)"
        [System.Windows.Forms.Application]::DoEvents()

        $hash = Get-SHA1 $jar.FullName
        $modName = Query-Modrinth $hash

        $item = New-Object System.Windows.Controls.ListViewItem

        if ($modName) {
            $item.Content = [PSCustomObject]@{ Status="Verified"; File=$jar.Name; Detail=$modName }
            $item.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#66FF99")
            $v++
        }
        else {
            $result = Scan-Jar $jar.FullName
            if ($result.IsClient) {
                $item.Content = [PSCustomObject]@{ Status="CHEAT"; File=$jar.Name; Detail=($result.Hits -join ", ") }
                $item.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#FF6666")
                $c++
            }
            elseif ($result.Hits.Count -gt 0) {
                $item.Content = [PSCustomObject]@{ Status="Suspicious"; File=$jar.Name; Detail=($result.Hits -join ", ") }
                $item.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#FFCC44")
                $s++
            }
            else {
                $item.Content = [PSCustomObject]@{ Status="Unknown"; File=$jar.Name; Detail="No matches" }
                $item.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#888888")
                $u++
            }
        }

        # Simple display
        $block = New-Object System.Windows.Controls.TextBlock
        $block.Text = "$($item.Content.Status)   $($item.Content.File)   $($item.Content.Detail)"
        $block.Foreground = $item.Foreground
        $block.Margin = "4,2"
        [void]$ResultList.Items.Add($block)

        $VerifiedCount.Text   = "Verified: $v"
        $UnknownCount.Text    = "Unknown: $u"
        $SuspiciousCount.Text = "Suspicious: $s"
        $CheatCount.Text      = "Cheats: $c"
    }

    $ProgressBar.Value = 100
    $ProgressText.Text = "Scan complete — $total files"
    $ScanBtn.IsEnabled = $true
})

# Need Forms for FolderBrowserDialog
Add-Type -AssemblyName System.Windows.Forms

$window.ShowDialog() | Out-Null
