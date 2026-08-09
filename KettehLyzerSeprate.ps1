Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Xaml
Add-Type -AssemblyName System.IO.Compression.FileSystem
Add-Type -AssemblyName System.Windows.Forms

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# =============================================================================
# XAML - Premium
# =============================================================================
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Ketteh Mod Analyzer" Width="1020" Height="700"
        WindowStartupLocation="CenterScreen" WindowStyle="None"
        AllowsTransparency="True" Background="Transparent"
        FontFamily="Segoe UI">

    <Border x:Name="MainBorder" Background="#07070E" CornerRadius="18" BorderBrush="#1A1A2E" BorderThickness="1">
        <Grid>
            <!-- Ambient glow layers -->
            <Ellipse x:Name="Glow1" Width="420" Height="420" HorizontalAlignment="Left" VerticalAlignment="Top" 
                     Margin="-120,-100,0,0" Opacity="0.18" IsHitTestVisible="False">
                <Ellipse.Fill>
                    <RadialGradientBrush>
                        <GradientStop Color="#FF2D6A" Offset="0"/>
                        <GradientStop Color="#00000000" Offset="1"/>
                    </RadialGradientBrush>
                </Ellipse.Fill>
            </Ellipse>

            <Ellipse x:Name="Glow2" Width="380" Height="380" HorizontalAlignment="Right" VerticalAlignment="Bottom" 
                     Margin="0,0,-100,-80" Opacity="0.14" IsHitTestVisible="False">
                <Ellipse.Fill>
                    <RadialGradientBrush>
                        <GradientStop Color="#00E5FF" Offset="0"/>
                        <GradientStop Color="#00000000" Offset="1"/>
                    </RadialGradientBrush>
                </Ellipse.Fill>
            </Ellipse>

            <Grid>
                <Grid.RowDefinitions>
                    <RowDefinition Height="58"/>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="*"/>
                    <RowDefinition Height="76"/>
                </Grid.RowDefinitions>

                <!-- HEADER -->
                <Border Grid.Row="0" Background="#0C0C16" CornerRadius="18,18,0,0">
                    <Grid Margin="24,0">
                        <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
                            <TextBlock FontSize="18" FontWeight="Bold">
                                <TextBlock.Foreground>
                                    <LinearGradientBrush StartPoint="0,0.5" EndPoint="1,0.5">
                                        <GradientStop Color="#FF3D7F" Offset="0"/>
                                        <GradientStop Color="#00E5FF" Offset="1"/>
                                    </LinearGradientBrush>
                                </TextBlock.Foreground>
                                KETTEH
                            </TextBlock>
                            <TextBlock Text="  MOD ANALYZER" FontSize="13" Foreground="#4A4A6A" VerticalAlignment="Center" Margin="6,2,0,0"/>
                        </StackPanel>

                        <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Center">
                            <Button x:Name="MinBtn" Content="─" Width="40" Height="34" Background="Transparent" 
                                    Foreground="#5A5A7A" BorderThickness="0" Cursor="Hand" FontSize="14"/>
                            <Button x:Name="CloseBtn" Content="✕" Width="40" Height="34" Background="Transparent" 
                                    Foreground="#5A5A7A" BorderThickness="0" Cursor="Hand" FontSize="14"/>
                        </StackPanel>
                    </Grid>
                </Border>

                <!-- PATH -->
                <Border Grid.Row="1" Background="#0A0A14" Padding="22,16" BorderBrush="#141424" BorderThickness="0,0,0,1">
                    <Grid>
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="Auto"/>
                            <ColumnDefinition Width="Auto"/>
                        </Grid.ColumnDefinitions>

                        <Border Background="#12121E" CornerRadius="12" BorderBrush="#252540" BorderThickness="1">
                            <TextBox x:Name="PathBox" Height="42" VerticalContentAlignment="Center" Padding="16,0"
                                     Background="Transparent" Foreground="#E8E8FF" BorderThickness="0"
                                     FontSize="13.5" CaretBrush="#00E5FF"/>
                        </Border>

                        <Button x:Name="BrowseBtn" Grid.Column="1" Content="Browse" Width="104" Height="42" Margin="12,0,0,0"
                                Background="#16162A" Foreground="#C8C8E8" BorderThickness="0" Cursor="Hand" FontSize="13">
                            <Button.Template>
                                <ControlTemplate TargetType="Button">
                                    <Border x:Name="bd" Background="{TemplateBinding Background}" CornerRadius="12">
                                        <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                    </Border>
                                    <ControlTemplate.Triggers>
                                        <Trigger Property="IsMouseOver" Value="True">
                                            <Setter TargetName="bd" Property="Background" Value="#1E1E3A"/>
                                        </Trigger>
                                    </ControlTemplate.Triggers>
                                </ControlTemplate>
                            </Button.Template>
                        </Button>

                        <Button x:Name="ScanBtn" Grid.Column="2" Content="SCAN" Width="116" Height="42" Margin="12,0,0,0"
                                Background="#FF3D7F" Foreground="White" BorderThickness="0" Cursor="Hand" 
                                FontSize="13" FontWeight="Bold">
                            <Button.Template>
                                <ControlTemplate TargetType="Button">
                                    <Border x:Name="bd" Background="{TemplateBinding Background}" CornerRadius="12">
                                        <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                    </Border>
                                    <ControlTemplate.Triggers>
                                        <Trigger Property="IsMouseOver" Value="True">
                                            <Setter TargetName="bd" Property="Background" Value="#FF5A95"/>
                                        </Trigger>
                                        <Trigger Property="IsEnabled" Value="False">
                                            <Setter TargetName="bd" Property="Opacity" Value="0.5"/>
                                        </Trigger>
                                    </ControlTemplate.Triggers>
                                </ControlTemplate>
                            </Button.Template>
                        </Button>
                    </Grid>
                </Border>

                <!-- STATS -->
                <Border Grid.Row="2" Background="#0A0A14" Padding="22,14">
                    <UniformGrid Columns="4" Height="64">
                        <!-- Verified -->
                        <Border Background="#0C1810" CornerRadius="12" Margin="0,0,10,0" BorderBrush="#1A2E1A" BorderThickness="1">
                            <StackPanel VerticalAlignment="Center" HorizontalAlignment="Center">
                                <TextBlock x:Name="VerifiedCount" Text="0" FontSize="22" FontWeight="Bold" 
                                           Foreground="#55FF99" HorizontalAlignment="Center"/>
                                <TextBlock Text="VERIFIED" FontSize="10" FontWeight="SemiBold" 
                                           Foreground="#3A6A4A" HorizontalAlignment="Center" Margin="0,2,0,0"/>
                            </StackPanel>
                        </Border>
                        <!-- Unknown -->
                        <Border Background="#12121A" CornerRadius="12" Margin="0,0,10,0" BorderBrush="#22222E" BorderThickness="1">
                            <StackPanel VerticalAlignment="Center" HorizontalAlignment="Center">
                                <TextBlock x:Name="UnknownCount" Text="0" FontSize="22" FontWeight="Bold" 
                                           Foreground="#AAAAAA" HorizontalAlignment="Center"/>
                                <TextBlock Text="UNKNOWN" FontSize="10" FontWeight="SemiBold" 
                                           Foreground="#555555" HorizontalAlignment="Center" Margin="0,2,0,0"/>
                            </StackPanel>
                        </Border>
                        <!-- Suspicious -->
                        <Border Background="#18150A" CornerRadius="12" Margin="0,0,10,0" BorderBrush="#2A2812" BorderThickness="1">
                            <StackPanel VerticalAlignment="Center" HorizontalAlignment="Center">
                                <TextBlock x:Name="SuspiciousCount" Text="0" FontSize="22" FontWeight="Bold" 
                                           Foreground="#FFCC44" HorizontalAlignment="Center"/>
                                <TextBlock Text="SUSPICIOUS" FontSize="10" FontWeight="SemiBold" 
                                           Foreground="#6A5A22" HorizontalAlignment="Center" Margin="0,2,0,0"/>
                            </StackPanel>
                        </Border>
                        <!-- Cheats -->
                        <Border Background="#180A0A" CornerRadius="12" BorderBrush="#2A1212" BorderThickness="1">
                            <StackPanel VerticalAlignment="Center" HorizontalAlignment="Center">
                                <TextBlock x:Name="CheatCount" Text="0" FontSize="22" FontWeight="Bold" 
                                           Foreground="#FF5555" HorizontalAlignment="Center"/>
                                <TextBlock Text="CHEATS" FontSize="10" FontWeight="SemiBold" 
                                           Foreground="#6A2222" HorizontalAlignment="Center" Margin="0,2,0,0"/>
                            </StackPanel>
                        </Border>
                    </UniformGrid>
                </Border>

                <!-- RESULTS -->
                <Border Grid.Row="3" Margin="18,4,18,8" Background="#0A0A12" CornerRadius="14" BorderBrush="#161628" BorderThickness="1">
                    <Grid>
                        <Grid.RowDefinitions>
                            <RowDefinition Height="40"/>
                            <RowDefinition Height="*"/>
                        </Grid.RowDefinitions>

                        <Border Grid.Row="0" Background="#0E0E18" CornerRadius="14,14,0,0">
                            <Grid Margin="18,0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="300"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <TextBlock Text="STATUS" FontSize="11" FontWeight="SemiBold" Foreground="#4A4A6A" VerticalAlignment="Center"/>
                                <TextBlock Grid.Column="1" Text="FILE" FontSize="11" FontWeight="SemiBold" Foreground="#4A4A6A" VerticalAlignment="Center"/>
                                <TextBlock Grid.Column="2" Text="DETAIL" FontSize="11" FontWeight="SemiBold" Foreground="#4A4A6A" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>

                        <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto" Background="Transparent">
                            <StackPanel x:Name="ResultPanel" Margin="0,6,0,8"/>
                        </ScrollViewer>
                    </Grid>
                </Border>

                <!-- FOOTER -->
                <Border Grid.Row="4" Background="#0A0A12" CornerRadius="0,0,18,18" BorderBrush="#161628" BorderThickness="0,1,0,0">
                    <Grid Margin="22,0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="Auto"/>
                        </Grid.ColumnDefinitions>
                        <StackPanel VerticalAlignment="Center">
                            <TextBlock x:Name="ProgressText" Text="Ready to scan" FontSize="12.5" Foreground="#666688" Margin="0,0,0,8"/>
                            <ProgressBar x:Name="ProgressBar" Height="5" Background="#161628" Foreground="#FF3D7F" 
                                         BorderThickness="0" Value="0" Maximum="100"/>
                        </StackPanel>
                        <TextBlock x:Name="FileCountText" Grid.Column="1" Text="" FontSize="12" Foreground="#4A4A6A" 
                                   VerticalAlignment="Center" Margin="24,0,0,0"/>
                    </Grid>
                </Border>
            </Grid>
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
$ResultPanel     = $window.FindName("ResultPanel")
$VerifiedCount   = $window.FindName("VerifiedCount")
$UnknownCount    = $window.FindName("UnknownCount")
$SuspiciousCount = $window.FindName("SuspiciousCount")
$CheatCount      = $window.FindName("CheatCount")
$ProgressText    = $window.FindName("ProgressText")
$ProgressBar     = $window.FindName("ProgressBar")
$FileCountText   = $window.FindName("FileCountText")
$Glow1           = $window.FindName("Glow1")
$Glow2           = $window.FindName("Glow2")

$PathBox.Text = Join-Path $env:APPDATA ".minecraft\mods"

# =============================================================================
# AMBIENT ANIMATION
# =============================================================================
$animTimer = New-Object System.Windows.Threading.DispatcherTimer
$animTimer.Interval = [TimeSpan]::FromMilliseconds(40)
$script:t = 0.0

$animTimer.Add_Tick({
    $script:t += 0.04
    $Glow1.Opacity = 0.12 + [Math]::Sin($script:t) * 0.08
    $Glow2.Opacity = 0.10 + [Math]::Cos($script:t * 0.8) * 0.07
})
$animTimer.Start()

# =============================================================================
# SCAN ENGINE
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

function Add-ResultRow([string]$status, [string]$file, [string]$detail, [string]$color) {
    $row = New-Object System.Windows.Controls.Border
    $row.Height = 36
    $row.Margin = "0,1"
    $row.Background = "Transparent"
    $row.Padding = "18,0"
    $row.Cursor = "Hand"

    $grid = New-Object System.Windows.Controls.Grid
    $c1 = New-Object System.Windows.Controls.ColumnDefinition; $c1.Width = "120"
    $c2 = New-Object System.Windows.Controls.ColumnDefinition; $c2.Width = "300"
    $c3 = New-Object System.Windows.Controls.ColumnDefinition; $c3.Width = "*"
    [void]$grid.ColumnDefinitions.Add($c1)
    [void]$grid.ColumnDefinitions.Add($c2)
    [void]$grid.ColumnDefinitions.Add($c3)

    $s = New-Object System.Windows.Controls.TextBlock
    $s.Text = $status
    $s.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString($color)
    $s.FontSize = 12.5
    $s.FontWeight = "SemiBold"
    $s.VerticalAlignment = "Center"

    $f = New-Object System.Windows.Controls.TextBlock
    $f.Text = $file
    $f.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#D0D0F0")
    $f.FontSize = 12.5
    $f.VerticalAlignment = "Center"
    $f.TextTrimming = "CharacterEllipsis"
    [System.Windows.Controls.Grid]::SetColumn($f, 1)

    $d = New-Object System.Windows.Controls.TextBlock
    $d.Text = $detail
    $d.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#5A5A7A")
    $d.FontSize = 12.5
    $d.VerticalAlignment = "Center"
    $d.TextTrimming = "CharacterEllipsis"
    [System.Windows.Controls.Grid]::SetColumn($d, 2)

    [void]$grid.Children.Add($s)
    [void]$grid.Children.Add($f)
    [void]$grid.Children.Add($d)
    $row.Child = $grid

    $row.Add_MouseEnter({
        $this.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#12122A")
    })
    $row.Add_MouseLeave({
        $this.Background = [System.Windows.Media.Brushes]::Transparent
    })

    [void]$ResultPanel.Children.Add($row)
}

# =============================================================================
# EVENTS
# =============================================================================
$window.Add_MouseLeftButtonDown({ try { $window.DragMove() } catch {} })
$CloseBtn.Add_Click({ $animTimer.Stop(); $window.Close() })
$MinBtn.Add_Click({ $window.WindowState = "Minimized" })

$BrowseBtn.Add_Click({
    $dlg = New-Object System.Windows.Forms.FolderBrowserDialog
    $dlg.Description = "Select Minecraft mods folder"
    if ($dlg.ShowDialog() -eq "OK") {
        $PathBox.Text = $dlg.SelectedPath
    }
})

$ScanBtn.Add_Click({
    $path = $PathBox.Text.Trim()
    if (-not (Test-Path -LiteralPath $path -PathType Container)) {
        $ProgressText.Text = "Invalid path"
        return
    }

    $ResultPanel.Children.Clear()
    $ScanBtn.IsEnabled = $false
    $ProgressBar.Value = 0
    $ProgressText.Text = "Starting scan..."

    $jars = @(Get-ChildItem -LiteralPath $path -Filter "*.jar" -File -ErrorAction SilentlyContinue)
    $total = $jars.Count
    $FileCountText.Text = "$total files"

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
        $ProgressText.Text = "Scanning  $i  /  $total"
        [System.Windows.Forms.Application]::DoEvents()

        $hash = Get-SHA1 $jar.FullName
        $modName = Query-Modrinth $hash

        if ($modName) {
            Add-ResultRow "Verified" $jar.Name $modName "#55FF99"
            $v++
        }
        else {
            $result = Scan-Jar $jar.FullName
            if ($result.IsClient) {
                Add-ResultRow "CHEAT" $jar.Name ($result.Hits -join ", ") "#FF5555"
                $c++
            }
            elseif ($result.Hits.Count -gt 0) {
                Add-ResultRow "Suspicious" $jar.Name ($result.Hits -join ", ") "#FFCC44"
                $s++
            }
            else {
                Add-ResultRow "Unknown" $jar.Name "No matches" "#777777"
                $u++
            }
        }

        $VerifiedCount.Text   = "$v"
        $UnknownCount.Text    = "$u"
        $SuspiciousCount.Text = "$s"
        $CheatCount.Text      = "$c"
    }

    $ProgressBar.Value = 100
    $ProgressText.Text = "Scan complete"
    $ScanBtn.IsEnabled = $true
})

$window.ShowDialog() | Out-Null
