Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Xaml

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$installDir = "$env:USERPROFILE\Downloads\KettehSSTool"

# =============================================================================
# TOOL DATA
# =============================================================================
$ToolData = @(
    @{ Name="Ketteh Mod Analyzer"; Desc="Scans Minecraft mods for cheats, clients and rats"; Category="Ketteh"; Type="Builtin" },

    @{ Name="PrefetchView";          Desc="Parses prefetch, extracts file info";          Category="Orbdiff"; Type="GitHub"; URL="https://github.com/Orbdiff/PrefetchView/releases/latest" },
    @{ Name="BAMReveal";             Desc="Parses BAM forensic artefact";                 Category="Orbdiff"; Type="GitHub"; URL="https://github.com/Orbdiff/BAMReveal/releases/latest" },
    @{ Name="StringsParser";         Desc="Strings + YARA + signatures scanner";          Category="Orbdiff"; Type="GitHub"; URL="https://github.com/Orbdiff/StringsParser/releases/latest" },
    @{ Name="Fileless";              Desc="Detects fileless via eventlog + memdump";      Category="Orbdiff"; Type="GitHub"; URL="https://github.com/Orbdiff/Fileless/releases/latest" },
    @{ Name="DPS-Analyzer";          Desc="Analyzes DPS memory";                          Category="Orbdiff"; Type="GitHub"; URL="https://github.com/Orbdiff/DPS-Analyzer/releases/latest" },
    @{ Name="UserAssistView";        Desc="Parses UserAssist registry artifact";          Category="Orbdiff"; Type="GitHub"; URL="https://github.com/Orbdiff/UserAssistView/releases/latest" },
    @{ Name="JournalParser";         Desc="Parses NTFS USNJournal entries";               Category="Orbdiff"; Type="GitHub"; URL="https://github.com/Orbdiff/JournalParser/releases/latest" },
    @{ Name="InjGen";                Desc="Detects JNI/JVMTI memory injections";         Category="Orbdiff"; Type="GitHub"; URL="https://github.com/Orbdiff/InjGen/releases/latest" },
    @{ Name="USBDetector";           Desc="Detects USB device history";                   Category="Orbdiff"; Type="GitHub"; URL="https://github.com/Orbdiff/USBDetector/releases/latest" },
    @{ Name="PFTrace";               Desc="Rundll32/Regsvr32 prefetch analysis";          Category="Orbdiff"; Type="GitHub"; URL="https://github.com/Orbdiff/PFTrace/releases/latest" },
    @{ Name="CheckDeletedUSN";       Desc="Compares USN timestamp vs boot time";          Category="Orbdiff"; Type="GitHub"; URL="https://github.com/Orbdiff/CheckDeletedUSN/releases/latest" },
    @{ Name="JARParser";             Desc="Parses JAR prefetch, DcomLaunch strings";      Category="Orbdiff"; Type="GitHub"; URL="https://github.com/Orbdiff/JARParser/releases/latest" },

    @{ Name="BAM-parser";            Desc="Parses BAM entries for execution history";     Category="Spokwn"; Type="GitHub"; URL="https://github.com/spokwn/BAM-parser/releases/latest" },
    @{ Name="PathsParser";           Desc="Extracts and analyzes executable paths";       Category="Spokwn"; Type="GitHub"; URL="https://github.com/spokwn/PathsParser/releases/latest" },
    @{ Name="JournalTrace";          Desc="Traces file activity via USN journal";         Category="Spokwn"; Type="GitHub"; URL="https://github.com/spokwn/JournalTrace/releases/latest" },
    @{ Name="KernelLiveDumpTool";    Desc="Captures live kernel memory dump";             Category="Spokwn"; Type="GitHub"; URL="https://github.com/spokwn/KernelLiveDumpTool/releases/latest" },
    @{ Name="BamDeletedKeys";        Desc="Finds deleted BAM registry keys";              Category="Spokwn"; Type="GitHub"; URL="https://github.com/spokwn/BamDeletedKeys/releases/latest" },
    @{ Name="Espouken Tool";         Desc="All-in-one SS forensics toolkit";              Category="Spokwn"; Type="GitHub"; URL="https://github.com/spokwn/Tool/releases/latest" },
    @{ Name="pcasvc-executed";       Desc="Extracts PCA service execution records";       Category="Spokwn"; Type="GitHub"; URL="https://github.com/spokwn/pcasvc-executed/releases/latest" },
    @{ Name="process-parser";        Desc="Parses process execution artefacts";           Category="Spokwn"; Type="GitHub"; URL="https://github.com/spokwn/process-parser/releases/latest" },
    @{ Name="prefetch-parser";       Desc="Parses Windows prefetch files";                Category="Spokwn"; Type="GitHub"; URL="https://github.com/spokwn/prefetch-parser/releases/latest" },
    @{ Name="ActivitiesCache";       Desc="Parses ActivitiesCache execution history";     Category="Spokwn"; Type="GitHub"; URL="https://github.com/spokwn/ActivitiesCache-execution/releases/latest" },

    @{ Name="MeowDoomsdayFucker";    Desc="Detects Doomsday cheat artefacts";             Category="Tonynoh"; Type="GitHub"; URL="https://github.com/MeowTonynoh/MeowDoomsdayFucker/releases/latest" },
    @{ Name="MeowModAnalyzer";       Desc="Analyzes mod files for suspicious content";    Category="Tonynoh"; Type="Cmd"; Command="Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/MeowTonynoh/MeowModAnalyzer/main/MeowModAnalyzer.ps1')" },
    @{ Name="MeowResolver";          Desc="Resolves obfuscated strings in binaries";      Category="Tonynoh"; Type="GitHub"; URL="https://github.com/MeowTonynoh/MeowResolver/releases/latest" },
    @{ Name="MeowNovowareFucker";    Desc="Detects Novoware cheat artefacts";             Category="Tonynoh"; Type="GitHub"; URL="https://github.com/MeowTonynoh/MeowNovowareFucker/releases/latest" },
    @{ Name="MeowImportsChecker";    Desc="Checks PE imports for suspicious DLLs";        Category="Tonynoh"; Type="GitHub"; URL="https://github.com/MeowTonynoh/MeowImportsChecker/releases/latest" },
    @{ Name="MeowClientsFucker";     Desc="Detects known cheat client artefacts";         Category="Tonynoh"; Type="GitHub"; URL="https://github.com/MeowTonynoh/MeowClientFucker/releases/latest" },

    @{ Name="PSHunter";              Desc="Hunts suspicious PowerShell activity";         Category="Praiselily"; Type="GitHub"; URL="https://github.com/praiselily/PSHunter/releases/latest" },
    @{ Name="AltDetector";           Desc="Detects alternate account artefacts";          Category="Praiselily"; Type="GitHub"; URL="https://github.com/praiselily/AltDetector/releases/latest" },
    @{ Name="WeHateFakers";          Desc="Checks hotspot / tethering logs";              Category="Praiselily"; Type="Cmd"; Command="iwr https://raw.githubusercontent.com/praiselily/WeHateFakers/refs/heads/main/HotspotLogs.ps1 | iex" },
    @{ Name="CommonDirectories";     Desc="Lists files in common suspicious dirs";        Category="Praiselily"; Type="Cmd"; Command="Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/praiselily/lilith-ps/refs/heads/main/CommonDirectories.ps1')" },
    @{ Name="HarddiskConverter";     Desc="Converts harddisk identifiers for review";     Category="Praiselily"; Type="Cmd"; Command="Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/praiselily/lilith-ps/refs/heads/main/HarddiskConverter.ps1')" },
    @{ Name="Services";              Desc="Lists and analyzes running services";          Category="Praiselily"; Type="Cmd"; Command="Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/praiselily/lilith-ps/refs/heads/main/Services.ps1')" },
    @{ Name="SignedScheduledTasks";  Desc="Finds unsigned / suspicious scheduled tasks"; Category="Praiselily"; Type="Cmd"; Command="Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/praiselily/lilith-ps/refs/heads/main/Signed-Scheduled-Tasks.ps1')" },

    @{ Name="RL ModAnalyzer";        Desc="Analyzes mod files for cheat indicators";     Category="RedLotus"; Type="GitHub"; URL="https://github.com/ItzIceHere/RedLotus-Mod-Analyzer/releases/latest" },
    @{ Name="RL TaskSentinel";       Desc="Monitors scheduled tasks for anomalies";      Category="RedLotus"; Type="GitHub"; URL="https://github.com/ItzIceHere/RedLotus-Task-Sentinel/releases/latest" },
    @{ Name="RL AltChecker";         Desc="Checks for alternate account indicators";     Category="RedLotus"; Type="GitHub"; URL="https://github.com/ItzIceHere/RedLotusAltChecker/releases/latest" },

    @{ Name="ComputerActivityView";  Desc="Timeline of computer activity events";        Category="Others"; Type="Web"; URL="https://www.nirsoft.net/utils/computer_activity_view.html" },
    @{ Name="AmcacheParser";         Desc="Parses AMCache with YARA + signatures";       Category="Others"; Type="Web"; URL="https://download.ericzimmermanstools.com/net9/AmcacheParser.zip" },
    @{ Name="SystemInformer";        Desc="Advanced process and kernel inspector";        Category="Others"; Type="Link"; URL="https://www.systeminformer.com/canary" },
    @{ Name="DIE-engine";            Desc="Detects file type, packer, compiler";         Category="Others"; Type="Web"; URL="https://github.com/horsicq/DIE-engine/releases" },
    @{ Name="MacroDetector";         Desc="Detects macro / clicker software traces";     Category="Others"; Type="Cmd"; Command="Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/NiccBlahh/MacroDetector/refs/heads/main/MacroDetector.ps1')" },
    @{ Name="Jarabel";               Desc="Locates .jar files with detailed checks";     Category="Others"; Type="GitHub"; URL="https://github.com/nay-cat/Jarabel/releases/latest" },
    @{ Name="Luyten";                Desc="Open source Java decompiler GUI";             Category="Others"; Type="GitHub"; URL="https://github.com/deathmarine/Luyten/releases/latest" },
    @{ Name="VMAware";               Desc="Advanced VM detection library and tool";      Category="Others"; Type="GitHub"; URL="https://github.com/kernelwernel/VMAware/releases/latest" },
    @{ Name="Velociraptor";          Desc="Endpoint DFIR and threat hunting agent";      Category="Others"; Type="GitHub"; URL="https://github.com/Velocidex/velociraptor/releases/latest" },
    @{ Name="NTFS Parser";           Desc="NTFS forensics: MFT, Bitlocker, USN";        Category="Others"; Type="GitHub"; URL="https://github.com/thewhiteninja/ntfstool/releases/latest" },
    @{ Name="Hayabusa";              Desc="Fast forensics timeline generator";           Category="Others"; Type="GitHub"; URL="https://github.com/Yamato-Security/hayabusa/releases/latest" },
    @{ Name="Everything";            Desc="Instant filename search engine for Windows";  Category="Others"; Type="Link"; URL="https://www.voidtools.com/downloads/" },
    @{ Name="HxD";                   Desc="Fast hex editor with disk and RAM editing";   Category="Others"; Type="Link"; URL="https://mh-nexus.de/en/hxd/" },

    @{ Name="bstrings";              Desc="Searches strings with regex + YARA";          Category="Zimmerman"; Type="Web"; URL="https://download.ericzimmermanstools.com/net9/bstrings.zip" },
    @{ Name="JLECmd";                Desc="Parses Jump List files (CLI)";                Category="Zimmerman"; Type="Web"; URL="https://download.ericzimmermanstools.com/net9/JLECmd.zip" },
    @{ Name="JumpListExplorer";      Desc="GUI explorer for Jump List artefacts";        Category="Zimmerman"; Type="Web"; URL="https://download.ericzimmermanstools.com/net9/JumpListExplorer.zip" },
    @{ Name="MFTECmd";               Desc="Parses MFT, UsnJrnl, LogFile, Boot";         Category="Zimmerman"; Type="Web"; URL="https://download.ericzimmermanstools.com/net9/MFTECmd.zip" },
    @{ Name="PECmd";                 Desc="Parses Windows prefetch files (CLI)";         Category="Zimmerman"; Type="Web"; URL="https://download.ericzimmermanstools.com/net9/PECmd.zip" },
    @{ Name="RecentFileCacheParser"; Desc="Parses RecentFileCache.bcf artefact";         Category="Zimmerman"; Type="Web"; URL="https://download.ericzimmermanstools.com/net9/RecentFileCacheParser.zip" },
    @{ Name="RegistryExplorer";      Desc="GUI explorer for registry hives";             Category="Zimmerman"; Type="Web"; URL="https://download.ericzimmermanstools.com/net9/RegistryExplorer.zip" },
    @{ Name="ShellBagsExplorer";     Desc="GUI explorer for ShellBags artefacts";        Category="Zimmerman"; Type="Web"; URL="https://download.ericzimmermanstools.com/net9/ShellBagsExplorer.zip" },
    @{ Name="SrumECmd";              Desc="Parses SRUM database for usage data";         Category="Zimmerman"; Type="Web"; URL="https://download.ericzimmermanstools.com/net9/SrumECmd.zip" },
    @{ Name="TimelineExplorer";      Desc="GUI viewer for CSV timeline output";          Category="Zimmerman"; Type="Web"; URL="https://download.ericzimmermanstools.com/net9/TimelineExplorer.zip" },

    @{ Name="FullEventLogView";      Desc="Views all Windows event log entries";         Category="NirSoft"; Type="Web"; URL="https://www.nirsoft.net/utils/fulleventlogview.zip" },
    @{ Name="NetworkUsageView";      Desc="Shows network usage per process";             Category="NirSoft"; Type="Web"; URL="https://www.nirsoft.net/utils/networkusageview.zip" },
    @{ Name="BrowserDownloadsView";  Desc="Lists all browser download history";          Category="NirSoft"; Type="Web"; URL="https://www.nirsoft.net/utils/browserdownloadsview.zip" },
    @{ Name="AlternateStreamView";   Desc="Reveals hidden NTFS alternate streams";       Category="NirSoft"; Type="Web"; URL="https://www.nirsoft.net/utils/alternatestreamview.zip" },
    @{ Name="USBDeview";             Desc="Lists all USB devices ever connected";        Category="NirSoft"; Type="Web"; URL="https://www.nirsoft.net/utils/usbdeview.zip" },
    @{ Name="OpenSaveFilesView";     Desc="Shows files opened/saved via dialogs";        Category="NirSoft"; Type="Web"; URL="https://www.nirsoft.net/utils/opensavefilesview.zip" },
    @{ Name="ExecutedProgramsList";  Desc="Lists programs run from various sources";     Category="NirSoft"; Type="Web"; URL="https://www.nirsoft.net/utils/executedprogramslist.zip" },
    @{ Name="TaskSchedulerView";     Desc="Views all scheduled tasks and history";       Category="NirSoft"; Type="Web"; URL="https://www.nirsoft.net/utils/taskschedulerview.zip" },
    @{ Name="JumpListsView";         Desc="Views Jump List recent/frequent files";       Category="NirSoft"; Type="Web"; URL="https://www.nirsoft.net/utils/jumplistsview.zip" },
    @{ Name="WinPrefetchView";       Desc="Views Windows prefetch file details";         Category="NirSoft"; Type="Web"; URL="https://www.nirsoft.net/utils/winprefetchview.zip" },
    @{ Name="RegScanner";            Desc="Scans registry for values / patterns";        Category="NirSoft"; Type="Web"; URL="https://www.nirsoft.net/utils/regscanner.zip" },
    @{ Name="ShellBagsView";         Desc="Views ShellBags folder access history";       Category="NirSoft"; Type="Web"; URL="https://www.nirsoft.net/utils/shellbagsview.zip" },

    @{ Name="NET 9.0";               Desc="Microsoft .NET 9 SDK runtime";                Category="Dependencies"; Type="Web"; URL="https://download.visualstudio.microsoft.com/download/pr/92dba916-bc51-4e76-8b0e-d41d37ce5fa4/ab08f3e95bf7a3d3da336a7e8c8eca63/dotnet-sdk-9.0.203-win-x64.exe" },
    @{ Name="VSRedist";              Desc="Visual C++ redistributable (x64)";            Category="Dependencies"; Type="Web"; URL="https://aka.ms/vs/17/release/vc_redist.x64.exe" }
)

# =============================================================================
# UI
# =============================================================================
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Ketteh" Width="1280" Height="800"
        WindowStartupLocation="CenterScreen" WindowStyle="None"
        AllowsTransparency="True" Background="Transparent"
        FontFamily="Segoe UI">

    <Border Background="#0B0B12" CornerRadius="16" BorderBrush="#222233" BorderThickness="1">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="60"/>
                <RowDefinition Height="50"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="130"/>
            </Grid.RowDefinitions>

            <!-- Header -->
            <Border Grid.Row="0" Background="#12121C" CornerRadius="16,16,0,0">
                <Grid Margin="24,0">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="Auto"/>
                        <ColumnDefinition Width="Auto"/>
                    </Grid.ColumnDefinitions>

                    <TextBlock VerticalAlignment="Center">
                        <Run Text="KETTEH" FontSize="20" FontWeight="Bold" Foreground="#FF4B8B"/>
                        <Run Text="  SS" FontSize="14" Foreground="#555577"/>
                    </TextBlock>

                    <Border Grid.Column="1" x:Name="BadgeHost" CornerRadius="20" Padding="14,5" VerticalAlignment="Center" Margin="0,0,16,0" Background="#1A1A2A">
                        <TextBlock x:Name="StatusBadge" Text="IDLE" FontSize="11" FontWeight="Bold" Foreground="#00E5FF"/>
                    </Border>

                    <StackPanel Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Center">
                        <Button x:Name="MinBtn" Content="─" Width="36" Height="32" Background="Transparent" Foreground="#666688" BorderThickness="0" Cursor="Hand"/>
                        <Button x:Name="CloseBtn" Content="✕" Width="36" Height="32" Background="Transparent" Foreground="#666688" BorderThickness="0" Cursor="Hand"/>
                    </StackPanel>
                </Grid>
            </Border>

            <!-- Categories -->
            <Border Grid.Row="1" Background="#0F0F18" BorderBrush="#1C1C2C" BorderThickness="0,0,0,1">
                <ScrollViewer HorizontalScrollBarVisibility="Hidden" VerticalScrollBarVisibility="Disabled">
                    <StackPanel x:Name="CatBar" Orientation="Horizontal" Margin="20,0" VerticalAlignment="Center"/>
                </ScrollViewer>
            </Border>

            <!-- Body -->
            <Grid Grid.Row="2">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="200"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>

                <Border Grid.Column="0" Background="#0F0F18" BorderBrush="#1C1C2C" BorderThickness="0,0,1,0">
                    <StackPanel Margin="16,20">
                        <TextBlock Text="ACTIONS" FontSize="10" FontWeight="Bold" Foreground="#444466" Margin="4,0,0,12"/>

                        <Button x:Name="OpenFolderBtn" Content="Open Folder" Height="40" Margin="0,0,0,8"
                                Background="#1A1A2A" Foreground="#DDDDFF" BorderThickness="0" Cursor="Hand"
                                FontSize="13" HorizontalContentAlignment="Left" Padding="14,0"/>
                        <Button x:Name="ClearCacheBtn" Content="Clear Cache" Height="40" Margin="0,0,0,8"
                                Background="#1A1A2A" Foreground="#DDDDFF" BorderThickness="0" Cursor="Hand"
                                FontSize="13" HorizontalContentAlignment="Left" Padding="14,0"/>
                        <Button x:Name="OpenPsBtn" Content="PowerShell" Height="40" Margin="0,0,0,8"
                                Background="#1A1A2A" Foreground="#DDDDFF" BorderThickness="0" Cursor="Hand"
                                FontSize="13" HorizontalContentAlignment="Left" Padding="14,0"/>

                        <TextBlock Text="STATUS" FontSize="10" FontWeight="Bold" Foreground="#444466" Margin="4,24,0,8"/>
                        <TextBlock x:Name="StatusTitle" Text="Ready" FontSize="16" FontWeight="SemiBold" Foreground="#EEEEFF" Margin="4,0,0,4"/>
                        <TextBlock x:Name="StatusSub" Text="Select a tool" FontSize="12" Foreground="#666688" TextWrapping="Wrap" Margin="4,0,0,0"/>
                    </StackPanel>
                </Border>

                <ScrollViewer Grid.Column="1" VerticalScrollBarVisibility="Auto" Background="#0B0B12">
                    <WrapPanel x:Name="CardPanel" Margin="16"/>
                </ScrollViewer>
            </Grid>

            <!-- Console -->
            <Border Grid.Row="3" Background="#08080F" CornerRadius="0,0,16,16" BorderBrush="#1C1C2C" BorderThickness="0,1,0,0">
                <Grid Margin="20,10">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    <TextBlock Text="CONSOLE" FontSize="10" FontWeight="Bold" Foreground="#444466" Margin="0,0,0,4"/>
                    <TextBox x:Name="LogBox" Grid.Row="1" Background="Transparent" Foreground="#00E5FF"
                             BorderThickness="0" FontFamily="Consolas" FontSize="12"
                             IsReadOnly="True" VerticalScrollBarVisibility="Auto" TextWrapping="Wrap"/>
                </Grid>
            </Border>
        </Grid>
    </Border>
</Window>
"@

# =============================================================================
# DISCLAIMER (FIXED COLOR)
# =============================================================================
[xml]$discXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Ketteh" Width="440" Height="280"
        WindowStartupLocation="CenterScreen" WindowStyle="None"
        AllowsTransparency="True" Background="Transparent" FontFamily="Segoe UI">
    <Border Background="#12121C" CornerRadius="14" BorderBrush="#222233" BorderThickness="1" Padding="28">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="*"/>
                <RowDefinition Height="48"/>
            </Grid.RowDefinitions>
            <StackPanel>
                <TextBlock Text="KETTEH" FontSize="20" FontWeight="Bold" Foreground="#FF4B8B" Margin="0,0,0,14"/>
                <TextBlock TextWrapping="Wrap" Foreground="#CCCCEE" FontSize="13" Margin="0,0,0,8"
                           Text="Tools are downloaded from official sources and stored locally."/>
                <TextBlock TextWrapping="Wrap" Foreground="#CCCCEE" FontSize="13" Margin="0,0,0,8"
                           Text="Use at your own risk."/>
            </StackPanel>
            <Grid Grid.Row="1">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="10"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>
                <Button x:Name="CancelBtn" Grid.Column="0" Content="Cancel" Height="38"
                        Background="Transparent" Foreground="#AAAACC" BorderBrush="#333344" BorderThickness="1" Cursor="Hand"/>
                <Button x:Name="AcceptBtn" Grid.Column="2" Content="Accept" Height="38"
                        Background="#1A1A2A" Foreground="#00E5FF" BorderThickness="0" Cursor="Hand"/>
            </Grid>
        </Grid>
    </Border>
</Window>
"@

$discReader = New-Object System.Xml.XmlNodeReader $discXaml
$discWin = [Windows.Markup.XamlReader]::Load($discReader)
$discWin.Add_MouseLeftButtonDown({ try { $discWin.DragMove() } catch {} })
$script:ok = $false
$discWin.FindName("AcceptBtn").Add_Click({ $script:ok = $true; $discWin.Close() })
$discWin.FindName("CancelBtn").Add_Click({ $script:ok = $false; $discWin.Close() })
$discWin.ShowDialog() | Out-Null
if (-not $script:ok) { exit }

# =============================================================================
# LOAD MAIN WINDOW
# =============================================================================
$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

$MinBtn        = $window.FindName("MinBtn")
$CloseBtn      = $window.FindName("CloseBtn")
$StatusTitle   = $window.FindName("StatusTitle")
$StatusSub     = $window.FindName("StatusSub")
$StatusBadge   = $window.FindName("StatusBadge")
$BadgeHost     = $window.FindName("BadgeHost")
$LogBox        = $window.FindName("LogBox")
$CatBar        = $window.FindName("CatBar")
$CardPanel     = $window.FindName("CardPanel")
$OpenFolderBtn = $window.FindName("OpenFolderBtn")
$ClearCacheBtn = $window.FindName("ClearCacheBtn")
$OpenPsBtn     = $window.FindName("OpenPsBtn")

function Write-Log {
    param([string]$msg)
    $t = Get-Date -Format "HH:mm:ss"
    $LogBox.Dispatcher.Invoke([Action]{
        $LogBox.AppendText("[$t] $msg`r`n")
        $LogBox.ScrollToEnd()
    })
}

function Set-Status {
    param([string]$title, [string]$sub, [string]$badge = "BUSY")
    $window.Dispatcher.Invoke([Action]{
        $StatusTitle.Text = $title
        $StatusSub.Text   = $sub
        $StatusBadge.Text = $badge
        if ($badge -eq "BUSY") {
            $StatusBadge.Foreground = [System.Windows.Media.Brushes]::Orange
            $BadgeHost.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#2A1A0A")
        } elseif ($badge -eq "ERR") {
            $StatusBadge.Foreground = [System.Windows.Media.Brushes]::Red
            $BadgeHost.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#2A0A0A")
        } else {
            $StatusBadge.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#00E5FF")
            $BadgeHost.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#1A1A2A")
        }
    })
}

# =============================================================================
# MOD ANALYZER
# =============================================================================
function Start-KettehModAnalyzer {
    $code = @'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Ketteh Mod Analyzer"
Clear-Host

Write-Host ""
Write-Host "  ====================================" -ForegroundColor DarkCyan
Write-Host "       KETTEH MOD ANALYZER" -ForegroundColor Cyan
Write-Host "  ====================================" -ForegroundColor DarkCyan
Write-Host ""
Write-Host "  Enter path to your mods folder" -ForegroundColor White
Write-Host "  (press Enter for default .minecraft\mods)" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  Path: " -NoNewline -ForegroundColor Cyan
$path = Read-Host

if ([string]::IsNullOrWhiteSpace($path)) {
    $path = Join-Path $env:APPDATA ".minecraft\mods"
    Write-Host "  Using: $path" -ForegroundColor Yellow
}

if (-not (Test-Path -LiteralPath $path -PathType Container)) {
    Write-Host ""
    Write-Host "  [ERROR] Folder does not exist:" -ForegroundColor Red
    Write-Host "  $path" -ForegroundColor Red
    Write-Host ""
    Write-Host "  Press any key to exit..." -ForegroundColor DarkGray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

Add-Type -AssemblyName System.IO.Compression.FileSystem

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
        $ver = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/version_file/$hash" -TimeoutSec 8 -ErrorAction Stop
        if ($ver.project_id) {
            $proj = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/project/$($ver.project_id)" -TimeoutSec 8 -ErrorAction Stop
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

Write-Host ""
Write-Host "  Scanning..." -ForegroundColor Cyan
Write-Host ""

$jars = @(Get-ChildItem -LiteralPath $path -Filter "*.jar" -File -ErrorAction SilentlyContinue)
$total = $jars.Count

if ($total -eq 0) {
    Write-Host "  No .jar files found." -ForegroundColor Yellow
    Write-Host "  Press any key to exit..." -ForegroundColor DarkGray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

$verified = @(); $unknown = @(); $cheats = @(); $suspicious = @()
$i = 0

foreach ($jar in $jars) {
    $i++
    $percent = [math]::Round(($i / $total) * 100)
    Write-Host ("`r  [{0,3}%] {1}" -f $percent, $jar.Name.PadRight(50).Substring(0,[Math]::Min(50,$jar.Name.Length))) -NoNewline -ForegroundColor Cyan

    $hash = Get-SHA1 $jar.FullName
    $modName = Query-Modrinth $hash

    if ($modName) {
        $verified += [PSCustomObject]@{ File = $jar.Name; Name = $modName }
        continue
    }

    $result = Scan-Jar $jar.FullName
    if ($result.IsClient) {
        $cheats += [PSCustomObject]@{ File = $jar.Name; Hits = ($result.Hits -join ", ") }
    }
    elseif ($result.Hits.Count -gt 0) {
        $suspicious += [PSCustomObject]@{ File = $jar.Name; Hits = ($result.Hits -join ", ") }
    }
    else {
        $unknown += [PSCustomObject]@{ File = $jar.Name }
    }
}

Write-Host "`r" + (" " * 70) + "`r"
Write-Host ""
Write-Host "  RESULTS" -ForegroundColor White
Write-Host "  -------"
Write-Host ("  Verified   : {0}" -f $verified.Count) -ForegroundColor Green
Write-Host ("  Unknown    : {0}" -f $unknown.Count) -ForegroundColor Gray
Write-Host ("  Suspicious : {0}" -f $suspicious.Count) -ForegroundColor Yellow
Write-Host ("  Cheats     : {0}" -f $cheats.Count) -ForegroundColor Red
Write-Host ""

if ($cheats.Count -gt 0) {
    Write-Host "  CHEATS DETECTED" -ForegroundColor Red
    foreach ($c in $cheats) {
        Write-Host "  $($c.File)" -ForegroundColor Red
        Write-Host "    → $($c.Hits)" -ForegroundColor DarkRed
    }
    Write-Host ""
}

if ($suspicious.Count -gt 0) {
    Write-Host "  SUSPICIOUS" -ForegroundColor Yellow
    foreach ($s in $suspicious) {
        Write-Host "  $($s.File)" -ForegroundColor Yellow
        Write-Host "    → $($s.Hits)" -ForegroundColor DarkYellow
    }
    Write-Host ""
}

Write-Host "  Press any key to exit..." -ForegroundColor DarkGray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
'@

    $tmp = [System.IO.Path]::Combine($env:TEMP, "KettehModAnalyzer.ps1")
    Set-Content -LiteralPath $tmp -Value $code -Encoding UTF8 -Force
    Start-Process -FilePath "powershell.exe" -ArgumentList "-NoExit","-NoProfile","-ExecutionPolicy","Bypass","-File","`"$tmp`""
    Write-Log "Launched Mod Analyzer"
    Set-Status "Ready" "Mod Analyzer launched" "IDLE"
}

# =============================================================================
# BUILD UI
# =============================================================================
$script:ActiveCat = "All"
$Categories = @("All","Ketteh","Orbdiff","Spokwn","Tonynoh","Praiselily","RedLotus","Zimmerman","NirSoft","Others","Dependencies")

function New-CatBtn([string]$text, [bool]$active) {
    $b = New-Object System.Windows.Controls.Button
    $b.Content = $text
    $b.Height = 32
    $b.Margin = "0,0,8,0"
    $b.Padding = "14,0"
    $b.FontSize = 12
    $b.Cursor = "Hand"
    $b.BorderThickness = 0
    $b.Tag = $text

    if ($active) {
        $b.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#FF4B8B")
        $b.Foreground = [System.Windows.Media.Brushes]::White
        $b.FontWeight = "SemiBold"
    } else {
        $b.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#1A1A2A")
        $b.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#8888AA")
    }

    $b.Template = [Windows.Markup.XamlReader]::Parse(@"
<ControlTemplate xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" TargetType="Button">
  <Border Background="{TemplateBinding Background}" CornerRadius="16" Padding="{TemplateBinding Padding}">
    <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
  </Border>
</ControlTemplate>
"@)

    $b.Add_Click({
        $script:ActiveCat = $this.Tag
        Build-Cats
        Build-Cards
    })
    return $b
}

function Build-Cats {
    $CatBar.Children.Clear()
    foreach ($c in $Categories) {
        [void]$CatBar.Children.Add((New-CatBtn $c ($c -eq $script:ActiveCat)))
    }
}

function Build-Cards {
    $CardPanel.Children.Clear()
    $list = if ($script:ActiveCat -eq "All") { $ToolData } else { $ToolData | Where-Object Category -eq $script:ActiveCat }

    foreach ($tool in $list) {
        $card = New-Object System.Windows.Controls.Border
        $card.Width = 230
        $card.Height = 100
        $card.Margin = "7"
        $card.CornerRadius = 12
        $card.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#16162A")
        $card.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#2A2A44")
        $card.BorderThickness = 1
        $card.Cursor = "Hand"
        $card.Padding = "14,12"
        $card.Tag = $tool

        $scale = New-Object System.Windows.Media.ScaleTransform 1,1
        $card.RenderTransform = $scale
        $card.RenderTransformOrigin = "0.5,0.5"

        $sp = New-Object System.Windows.Controls.StackPanel
        $n = New-Object System.Windows.Controls.TextBlock
        $n.Text = $tool.Name
        $n.FontSize = 13
        $n.FontWeight = "SemiBold"
        $n.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#EEEEFF")
        $n.TextWrapping = "Wrap"

        $d = New-Object System.Windows.Controls.TextBlock
        $d.Text = $tool.Desc
        $d.FontSize = 11
        $d.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#666688")
        $d.TextWrapping = "Wrap"
        $d.Margin = "0,5,0,0"

        [void]$sp.Children.Add($n)
        [void]$sp.Children.Add($d)
        $card.Child = $sp

        $card.Add_MouseEnter({
            $this.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#00E5FF")
            $this.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#1E1E3A")
            $sc = $this.RenderTransform
            $ax = New-Object System.Windows.Media.Animation.DoubleAnimation 1.06, ([TimeSpan]::FromMilliseconds(120))
            $ay = New-Object System.Windows.Media.Animation.DoubleAnimation 1.06, ([TimeSpan]::FromMilliseconds(120))
            $sc.BeginAnimation([System.Windows.Media.ScaleTransform]::ScaleXProperty, $ax)
            $sc.BeginAnimation([System.Windows.Media.ScaleTransform]::ScaleYProperty, $ay)
        })

        $card.Add_MouseLeave({
            $this.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#2A2A44")
            $this.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#16162A")
            $sc = $this.RenderTransform
            $ax = New-Object System.Windows.Media.Animation.DoubleAnimation 1.0, ([TimeSpan]::FromMilliseconds(140))
            $ay = New-Object System.Windows.Media.Animation.DoubleAnimation 1.0, ([TimeSpan]::FromMilliseconds(140))
            $sc.BeginAnimation([System.Windows.Media.ScaleTransform]::ScaleXProperty, $ax)
            $sc.BeginAnimation([System.Windows.Media.ScaleTransform]::ScaleYProperty, $ay)
        })

        $card.Add_MouseLeftButtonUp({
            $td = $this.Tag
            if (-not $td) { return }

            switch ($td.Type) {
                "Builtin" { Start-KettehModAnalyzer }
                "Link" {
                    Start-Process $td.URL
                    Write-Log "Opened $($td.Name)"
                    Set-Status "Ready" "Opened browser" "IDLE"
                }
                "Cmd" {
                    Set-Status "Running" $td.Name "BUSY"
                    Write-Log "Launching $($td.Name)"
                    Start-Process powershell -ArgumentList "-NoExit","-NoProfile","-ExecutionPolicy","Bypass","-Command",$td.Command
                    Set-Status "Ready" "Launched" "IDLE"
                }
                default {
                    Set-Status "Downloading" $td.Name "BUSY"
                    Write-Log "Downloading $($td.Name)..."

                    $rs = [runspacefactory]::CreateRunspace()
                    $rs.Open()
                    $rs.SessionStateProxy.SetVariable("tool",$td)
                    $rs.SessionStateProxy.SetVariable("dir",$installDir)
                    $rs.SessionStateProxy.SetVariable("ui",$window.Dispatcher)
                    $rs.SessionStateProxy.SetVariable("titleC",$StatusTitle)
                    $rs.SessionStateProxy.SetVariable("subC",$StatusSub)
                    $rs.SessionStateProxy.SetVariable("badgeC",$StatusBadge)
                    $rs.SessionStateProxy.SetVariable("logC",$LogBox)

                    $ps = [powershell]::Create()
                    $ps.Runspace = $rs
                    [void]$ps.AddScript({
                        function L($m){ $ui.Invoke([Action]{ $logC.AppendText("[$(Get-Date -f HH:mm:ss)] $m`r`n"); $logC.ScrollToEnd() }) }
                        function S($t,$s,$b){ $ui.Invoke([Action]{ $titleC.Text=$t; $subC.Text=$s; $badgeC.Text=$b }) }
                        try {
                            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                            $target = Join-Path $dir "$($tool.Category)\$($tool.Name)"
                            if (-not (Test-Path $target)) { New-Item $target -ItemType Directory -Force | Out-Null }

                            if ($tool.Type -eq "GitHub") {
                                $parts = $tool.URL -replace "https://github.com/","" -split "/"
                                $api = "https://api.github.com/repos/$($parts[0])/$($parts[1])/releases/latest"
                                $rel = Invoke-RestMethod $api -Headers @{"User-Agent"="Ketteh"}
                                $asset = $rel.assets | Where-Object { $_.name -match "\.(zip|exe)$" } | Select-Object -First 1
                                if (-not $asset) { throw "No asset" }
                                $url = $asset.browser_download_url
                                $fn = $asset.name
                            } else {
                                $url = $tool.URL
                                $fn = ($url -split "/")[-1]
                            }

                            $out = Join-Path $target $fn
                            if (-not (Test-Path $out)) {
                                L "Downloading $fn..."
                                (New-Object Net.WebClient).DownloadFile($url,$out)
                                L "Done"
                            } else { L "Cached $fn" }

                            if ($fn -match "\.zip$") {
                                Expand-Archive $out $target -Force
                                $exe = Get-ChildItem $target -Filter *.exe -Recurse | Select-Object -First 1
                                if ($exe) { Start-Process $exe.FullName; L "Launched $($exe.Name)" }
                                else { Start-Process explorer $target }
                            } else {
                                Start-Process $out
                                L "Launched $fn"
                            }
                            S "Ready" "Done" "IDLE"
                        } catch {
                            L "Error: $_"
                            S "Error" "Failed" "ERR"
                        }
                    })
                    [void]$ps.BeginInvoke()
                }
            }
        })

        [void]$CardPanel.Children.Add($card)
    }
}

Build-Cats
Build-Cards

# =============================================================================
# EVENTS
# =============================================================================
$window.Add_MouseLeftButtonDown({ try { $window.DragMove() } catch {} })
$CloseBtn.Add_Click({ $window.Close() })
$MinBtn.Add_Click({ $window.WindowState = "Minimized" })

$OpenFolderBtn.Add_Click({
    if (-not (Test-Path $installDir)) { New-Item $installDir -ItemType Directory -Force | Out-Null }
    Start-Process explorer $installDir
    Write-Log "Opened folder"
})

$ClearCacheBtn.Add_Click({
    if (Test-Path $installDir) {
        $n = @(Get-ChildItem $installDir -Force -EA SilentlyContinue).Count
        Get-ChildItem $installDir -Force -EA SilentlyContinue | Remove-Item -Recurse -Force -EA SilentlyContinue
        Write-Log "Cleared $n items"
        Set-Status "Ready" "Cache cleared" "IDLE"
    }
})

$OpenPsBtn.Add_Click({
    Start-Process powershell
    Write-Log "Opened PowerShell"
})

Write-Log "Ketteh ready"
Set-Status "Ready" "Select a tool" "IDLE"

$window.ShowDialog() | Out-Null
