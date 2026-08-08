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
    @{ Name="Ketteh Mod Analyzer";   Desc="Full cheat + rat scanner for Minecraft mods"; Category="Ketteh"; Type="Builtin"; Command="ModAnalyzer" },

    @{ Name="PrefetchView";          Desc="Parses prefetch, extracts file info";          Category="Orbdiff";    Type="GitHub"; URL="https://github.com/Orbdiff/PrefetchView/releases/latest" },
    @{ Name="BAMReveal";             Desc="Parses BAM forensic artefact";                 Category="Orbdiff";    Type="GitHub"; URL="https://github.com/Orbdiff/BAMReveal/releases/latest" },
    @{ Name="StringsParser";         Desc="Strings + YARA + signatures scanner";          Category="Orbdiff";    Type="GitHub"; URL="https://github.com/Orbdiff/StringsParser/releases/latest" },
    @{ Name="Fileless";              Desc="Detects fileless via eventlog + memdump";      Category="Orbdiff";    Type="GitHub"; URL="https://github.com/Orbdiff/Fileless/releases/latest" },
    @{ Name="DPS-Analyzer";          Desc="Analyzes DPS memory";                          Category="Orbdiff";    Type="GitHub"; URL="https://github.com/Orbdiff/DPS-Analyzer/releases/latest" },
    @{ Name="UserAssistView";        Desc="Parses UserAssist registry artifact";          Category="Orbdiff";    Type="GitHub"; URL="https://github.com/Orbdiff/UserAssistView/releases/latest" },
    @{ Name="JournalParser";         Desc="Parses NTFS USNJournal entries";               Category="Orbdiff";    Type="GitHub"; URL="https://github.com/Orbdiff/JournalParser/releases/latest" },
    @{ Name="InjGen";                Desc="Detects JNI/JVMTI memory injections";         Category="Orbdiff";    Type="GitHub"; URL="https://github.com/Orbdiff/InjGen/releases/latest" },
    @{ Name="USBDetector";           Desc="Detects USB device history";                   Category="Orbdiff";    Type="GitHub"; URL="https://github.com/Orbdiff/USBDetector/releases/latest" },
    @{ Name="PFTrace";               Desc="Rundll32/Regsvr32 prefetch analysis";          Category="Orbdiff";    Type="GitHub"; URL="https://github.com/Orbdiff/PFTrace/releases/latest" },
    @{ Name="CheckDeletedUSN";       Desc="Compares USN timestamp vs boot time";          Category="Orbdiff";    Type="GitHub"; URL="https://github.com/Orbdiff/CheckDeletedUSN/releases/latest" },
    @{ Name="JARParser";             Desc="Parses JAR prefetch, DcomLaunch strings";      Category="Orbdiff";    Type="GitHub"; URL="https://github.com/Orbdiff/JARParser/releases/latest" },

    @{ Name="BAM-parser";            Desc="Parses BAM entries for execution history";     Category="Spokwn";     Type="GitHub"; URL="https://github.com/spokwn/BAM-parser/releases/latest" },
    @{ Name="PathsParser";           Desc="Extracts and analyzes executable paths";       Category="Spokwn";     Type="GitHub"; URL="https://github.com/spokwn/PathsParser/releases/latest" },
    @{ Name="JournalTrace";          Desc="Traces file activity via USN journal";         Category="Spokwn";     Type="GitHub"; URL="https://github.com/spokwn/JournalTrace/releases/latest" },
    @{ Name="KernelLiveDumpTool";    Desc="Captures live kernel memory dump";             Category="Spokwn";     Type="GitHub"; URL="https://github.com/spokwn/KernelLiveDumpTool/releases/latest" },
    @{ Name="BamDeletedKeys";        Desc="Finds deleted BAM registry keys";              Category="Spokwn";     Type="GitHub"; URL="https://github.com/spokwn/BamDeletedKeys/releases/latest" },
    @{ Name="Espouken Tool";         Desc="All-in-one SS forensics toolkit";              Category="Spokwn";     Type="GitHub"; URL="https://github.com/spokwn/Tool/releases/latest" },
    @{ Name="pcasvc-executed";       Desc="Extracts PCA service execution records";       Category="Spokwn";     Type="GitHub"; URL="https://github.com/spokwn/pcasvc-executed/releases/latest" },
    @{ Name="process-parser";        Desc="Parses process execution artefacts";           Category="Spokwn";     Type="GitHub"; URL="https://github.com/spokwn/process-parser/releases/latest" },
    @{ Name="prefetch-parser";       Desc="Parses Windows prefetch files";                Category="Spokwn";     Type="GitHub"; URL="https://github.com/spokwn/prefetch-parser/releases/latest" },
    @{ Name="ActivitiesCache";       Desc="Parses ActivitiesCache execution history";     Category="Spokwn";     Type="GitHub"; URL="https://github.com/spokwn/ActivitiesCache-execution/releases/latest" },

    @{ Name="MeowDoomsdayFucker";    Desc="Detects Doomsday cheat artefacts";             Category="Tonynoh";    Type="GitHub"; URL="https://github.com/MeowTonynoh/MeowDoomsdayFucker/releases/latest" },
    @{ Name="MeowModAnalyzer";       Desc="Analyzes mod files for suspicious content";    Category="Tonynoh";    Type="Cmd";    Command="Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/MeowTonynoh/MeowModAnalyzer/main/MeowModAnalyzer.ps1')" },
    @{ Name="MeowResolver";          Desc="Resolves obfuscated strings in binaries";      Category="Tonynoh";    Type="GitHub"; URL="https://github.com/MeowTonynoh/MeowResolver/releases/latest" },
    @{ Name="MeowNovowareFucker";    Desc="Detects Novoware cheat artefacts";             Category="Tonynoh";    Type="GitHub"; URL="https://github.com/MeowTonynoh/MeowNovowareFucker/releases/latest" },
    @{ Name="MeowImportsChecker";    Desc="Checks PE imports for suspicious DLLs";        Category="Tonynoh";    Type="GitHub"; URL="https://github.com/MeowTonynoh/MeowImportsChecker/releases/latest" },
    @{ Name="MeowClientsFucker";     Desc="Detects known cheat client artefacts";         Category="Tonynoh";    Type="GitHub"; URL="https://github.com/MeowTonynoh/MeowClientFucker/releases/latest" },

    @{ Name="PSHunter";              Desc="Hunts suspicious PowerShell activity";         Category="Praiselily"; Type="GitHub"; URL="https://github.com/praiselily/PSHunter/releases/latest" },
    @{ Name="AltDetector";           Desc="Detects alternate account artefacts";          Category="Praiselily"; Type="GitHub"; URL="https://github.com/praiselily/AltDetector/releases/latest" },
    @{ Name="WeHateFakers";          Desc="Checks hotspot / tethering logs";              Category="Praiselily"; Type="Cmd";    Command="iwr https://raw.githubusercontent.com/praiselily/WeHateFakers/refs/heads/main/HotspotLogs.ps1 | iex" },
    @{ Name="CommonDirectories";     Desc="Lists files in common suspicious dirs";        Category="Praiselily"; Type="Cmd";    Command="Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/praiselily/lilith-ps/refs/heads/main/CommonDirectories.ps1')" },
    @{ Name="HarddiskConverter";     Desc="Converts harddisk identifiers for review";     Category="Praiselily"; Type="Cmd";    Command="Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/praiselily/lilith-ps/refs/heads/main/HarddiskConverter.ps1')" },
    @{ Name="Services";              Desc="Lists and analyzes running services";          Category="Praiselily"; Type="Cmd";    Command="Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/praiselily/lilith-ps/refs/heads/main/Services.ps1')" },
    @{ Name="SignedScheduledTasks";  Desc="Finds unsigned / suspicious scheduled tasks"; Category="Praiselily"; Type="Cmd";    Command="Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/praiselily/lilith-ps/refs/heads/main/Signed-Scheduled-Tasks.ps1')" },

    @{ Name="RL ModAnalyzer";        Desc="Analyzes mod files for cheat indicators";     Category="RedLotus";   Type="GitHub"; URL="https://github.com/ItzIceHere/RedLotus-Mod-Analyzer/releases/latest" },
    @{ Name="RL TaskSentinel";       Desc="Monitors scheduled tasks for anomalies";      Category="RedLotus";   Type="GitHub"; URL="https://github.com/ItzIceHere/RedLotus-Task-Sentinel/releases/latest" },
    @{ Name="RL AltChecker";         Desc="Checks for alternate account indicators";     Category="RedLotus";   Type="GitHub"; URL="https://github.com/ItzIceHere/RedLotusAltChecker/releases/latest" },

    @{ Name="ComputerActivityView";  Desc="Timeline of computer activity events";        Category="Others";     Type="Web";    URL="https://www.nirsoft.net/utils/computer_activity_view.html" },
    @{ Name="AmcacheParser";         Desc="Parses AMCache with YARA + signatures";       Category="Others";     Type="Web";    URL="https://download.ericzimmermanstools.com/net9/AmcacheParser.zip" },
    @{ Name="SystemInformer";        Desc="Advanced process and kernel inspector";        Category="Others";     Type="Link";   URL="https://www.systeminformer.com/canary" },
    @{ Name="DIE-engine";            Desc="Detects file type, packer, compiler";         Category="Others";     Type="Web";    URL="https://github.com/horsicq/DIE-engine/releases" },
    @{ Name="MacroDetector";         Desc="Detects macro / clicker software traces";     Category="Others";     Type="Cmd";    Command="Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/NiccBlahh/MacroDetector/refs/heads/main/MacroDetector.ps1')" },
    @{ Name="Jarabel";               Desc="Locates .jar files with detailed checks";     Category="Others";     Type="GitHub"; URL="https://github.com/nay-cat/Jarabel/releases/latest" },
    @{ Name="Luyten";                Desc="Open source Java decompiler GUI";             Category="Others";     Type="GitHub"; URL="https://github.com/deathmarine/Luyten/releases/latest" },
    @{ Name="VMAware";               Desc="Advanced VM detection library and tool";      Category="Others";     Type="GitHub"; URL="https://github.com/kernelwernel/VMAware/releases/latest" },
    @{ Name="Velociraptor";          Desc="Endpoint DFIR and threat hunting agent";      Category="Others";     Type="GitHub"; URL="https://github.com/Velocidex/velociraptor/releases/latest" },
    @{ Name="NTFS Parser";           Desc="NTFS forensics: MFT, Bitlocker, USN";        Category="Others";     Type="GitHub"; URL="https://github.com/thewhiteninja/ntfstool/releases/latest" },
    @{ Name="Hayabusa";              Desc="Fast forensics timeline generator";           Category="Others";     Type="GitHub"; URL="https://github.com/Yamato-Security/hayabusa/releases/latest" },
    @{ Name="Everything";            Desc="Instant filename search engine for Windows";  Category="Others";     Type="Link";   URL="https://www.voidtools.com/downloads/" },
    @{ Name="HxD";                   Desc="Fast hex editor with disk and RAM editing";   Category="Others";     Type="Link";   URL="https://mh-nexus.de/en/hxd/" },

    @{ Name="bstrings";              Desc="Searches strings with regex + YARA";          Category="Zimmerman";  Type="Web";    URL="https://download.ericzimmermanstools.com/net9/bstrings.zip" },
    @{ Name="JLECmd";                Desc="Parses Jump List files (CLI)";                Category="Zimmerman";  Type="Web";    URL="https://download.ericzimmermanstools.com/net9/JLECmd.zip" },
    @{ Name="JumpListExplorer";      Desc="GUI explorer for Jump List artefacts";        Category="Zimmerman";  Type="Web";    URL="https://download.ericzimmermanstools.com/net9/JumpListExplorer.zip" },
    @{ Name="MFTECmd";               Desc="Parses MFT, UsnJrnl, LogFile, Boot";         Category="Zimmerman";  Type="Web";    URL="https://download.ericzimmermanstools.com/net9/MFTECmd.zip" },
    @{ Name="PECmd";                 Desc="Parses Windows prefetch files (CLI)";         Category="Zimmerman";  Type="Web";    URL="https://download.ericzimmermanstools.com/net9/PECmd.zip" },
    @{ Name="RecentFileCacheParser"; Desc="Parses RecentFileCache.bcf artefact";         Category="Zimmerman";  Type="Web";    URL="https://download.ericzimmermanstools.com/net9/RecentFileCacheParser.zip" },
    @{ Name="RegistryExplorer";      Desc="GUI explorer for registry hives";             Category="Zimmerman";  Type="Web";    URL="https://download.ericzimmermanstools.com/net9/RegistryExplorer.zip" },
    @{ Name="ShellBagsExplorer";     Desc="GUI explorer for ShellBags artefacts";        Category="Zimmerman";  Type="Web";    URL="https://download.ericzimmermanstools.com/net9/ShellBagsExplorer.zip" },
    @{ Name="SrumECmd";              Desc="Parses SRUM database for usage data";         Category="Zimmerman";  Type="Web";    URL="https://download.ericzimmermanstools.com/net9/SrumECmd.zip" },
    @{ Name="TimelineExplorer";      Desc="GUI viewer for CSV timeline output";          Category="Zimmerman";  Type="Web";    URL="https://download.ericzimmermanstools.com/net9/TimelineExplorer.zip" },

    @{ Name="FullEventLogView";      Desc="Views all Windows event log entries";         Category="NirSoft";    Type="Web";    URL="https://www.nirsoft.net/utils/fulleventlogview.zip" },
    @{ Name="NetworkUsageView";      Desc="Shows network usage per process";             Category="NirSoft";    Type="Web";    URL="https://www.nirsoft.net/utils/networkusageview.zip" },
    @{ Name="BrowserDownloadsView";  Desc="Lists all browser download history";          Category="NirSoft";    Type="Web";    URL="https://www.nirsoft.net/utils/browserdownloadsview.zip" },
    @{ Name="AlternateStreamView";   Desc="Reveals hidden NTFS alternate streams";       Category="NirSoft";    Type="Web";    URL="https://www.nirsoft.net/utils/alternatestreamview.zip" },
    @{ Name="USBDeview";             Desc="Lists all USB devices ever connected";        Category="NirSoft";    Type="Web";    URL="https://www.nirsoft.net/utils/usbdeview.zip" },
    @{ Name="OpenSaveFilesView";     Desc="Shows files opened/saved via dialogs";        Category="NirSoft";    Type="Web";    URL="https://www.nirsoft.net/utils/opensavefilesview.zip" },
    @{ Name="ExecutedProgramsList";  Desc="Lists programs run from various sources";     Category="NirSoft";    Type="Web";    URL="https://www.nirsoft.net/utils/executedprogramslist.zip" },
    @{ Name="TaskSchedulerView";     Desc="Views all scheduled tasks and history";       Category="NirSoft";    Type="Web";    URL="https://www.nirsoft.net/utils/taskschedulerview.zip" },
    @{ Name="JumpListsView";         Desc="Views Jump List recent/frequent files";       Category="NirSoft";    Type="Web";    URL="https://www.nirsoft.net/utils/jumplistsview.zip" },
    @{ Name="WinPrefetchView";       Desc="Views Windows prefetch file details";         Category="NirSoft";    Type="Web";    URL="https://www.nirsoft.net/utils/winprefetchview.zip" },
    @{ Name="RegScanner";            Desc="Scans registry for values / patterns";        Category="NirSoft";    Type="Web";    URL="https://www.nirsoft.net/utils/regscanner.zip" },
    @{ Name="ShellBagsView";         Desc="Views ShellBags folder access history";       Category="NirSoft";    Type="Web";    URL="https://www.nirsoft.net/utils/shellbagsview.zip" },

    @{ Name="NET 9.0";               Desc="Microsoft .NET 9 SDK runtime";                Category="Dependencies"; Type="Web"; URL="https://download.visualstudio.microsoft.com/download/pr/92dba916-bc51-4e76-8b0e-d41d37ce5fa4/ab08f3e95bf7a3d3da336a7e8c8eca63/dotnet-sdk-9.0.203-win-x64.exe" },
    @{ Name="VSRedist";              Desc="Visual C++ redistributable (x64)";            Category="Dependencies"; Type="Web"; URL="https://aka.ms/vs/17/release/vc_redist.x64.exe" }
)

# =============================================================================
# NEW UI - Completely different design
# =============================================================================
[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Ketteh"
    Width="1280" Height="820"
    MinWidth="1100" MinHeight="700"
    WindowStartupLocation="CenterScreen"
    WindowStyle="None"
    AllowsTransparency="True"
    Background="Transparent"
    FontFamily="Segoe UI">

    <Window.Resources>
        <SolidColorBrush x:Key="Bg"        Color="#07070C"/>
        <SolidColorBrush x:Key="Surface"   Color="#0F0F18"/>
        <SolidColorBrush x:Key="Card"      Color="#161622"/>
        <SolidColorBrush x:Key="CardHover" Color="#1E1E2E"/>
        <SolidColorBrush x:Key="Accent"    Color="#FF3CAC"/>
        <SolidColorBrush x:Key="Accent2"   Color="#00E5FF"/>
        <SolidColorBrush x:Key="Text"      Color="#F0F0F8"/>
        <SolidColorBrush x:Key="Muted"     Color="#6B6B85"/>
        <SolidColorBrush x:Key="Border"    Color="#252538"/>
    </Window.Resources>

    <Border Background="{StaticResource Bg}" CornerRadius="14" BorderBrush="{StaticResource Border}" BorderThickness="1">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="56"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="132"/>
            </Grid.RowDefinitions>

            <!-- TOP BAR -->
            <Border Grid.Row="0" Background="{StaticResource Surface}" CornerRadius="14,14,0,0">
                <Grid Margin="24,0">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="Auto"/>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="Auto"/>
                        <ColumnDefinition Width="Auto"/>
                    </Grid.ColumnDefinitions>

                    <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
                        <TextBlock Text="KETTEH" FontSize="18" FontWeight="Bold" Foreground="{StaticResource Accent}"/>
                        <TextBlock Text="  /  SS" FontSize="14" Foreground="{StaticResource Muted}" VerticalAlignment="Center" Margin="6,0,0,0"/>
                    </StackPanel>

                    <!-- Category pills -->
                    <ScrollViewer Grid.Column="1" HorizontalScrollBarVisibility="Hidden" VerticalScrollBarVisibility="Disabled" Margin="32,0">
                        <StackPanel x:Name="CatPills" Orientation="Horizontal" VerticalAlignment="Center"/>
                    </ScrollViewer>

                    <Border Grid.Column="2" Background="#1A1A28" CornerRadius="20" Padding="14,6" VerticalAlignment="Center" Margin="0,0,16,0">
                        <TextBlock x:Name="StatusBadge" Text="IDLE" FontSize="11" FontWeight="SemiBold" Foreground="{StaticResource Accent2}"/>
                    </Border>

                    <StackPanel Grid.Column="3" Orientation="Horizontal" VerticalAlignment="Center">
                        <Button x:Name="MinBtn" Content="─" Width="36" Height="32" Background="Transparent" Foreground="{StaticResource Muted}" BorderThickness="0" Cursor="Hand" FontSize="12"/>
                        <Button x:Name="CloseBtn" Content="✕" Width="36" Height="32" Background="Transparent" Foreground="{StaticResource Muted}" BorderThickness="0" Cursor="Hand" FontSize="12"/>
                    </StackPanel>
                </Grid>
            </Border>

            <!-- MAIN CONTENT -->
            <Grid Grid.Row="1" Margin="0">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="200"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>

                <!-- Left action rail -->
                <Border Grid.Column="0" Background="{StaticResource Surface}" BorderBrush="{StaticResource Border}" BorderThickness="0,0,1,0">
                    <StackPanel Margin="16,20">
                        <TextBlock Text="QUICK" FontSize="10" FontWeight="Bold" Foreground="{StaticResource Muted}" Margin="4,0,0,12"/>
                        
                        <Button x:Name="OpenFolderBtn" Content="Open Folder" Height="40" Margin="0,0,0,8"
                                Background="{StaticResource Card}" Foreground="{StaticResource Text}" BorderThickness="0"
                                Cursor="Hand" FontSize="12" HorizontalContentAlignment="Left" Padding="16,0"/>
                        <Button x:Name="ClearCacheBtn" Content="Clear Cache" Height="40" Margin="0,0,0,8"
                                Background="{StaticResource Card}" Foreground="{StaticResource Text}" BorderThickness="0"
                                Cursor="Hand" FontSize="12" HorizontalContentAlignment="Left" Padding="16,0"/>
                        <Button x:Name="OpenPsBtn" Content="PowerShell" Height="40" Margin="0,0,0,8"
                                Background="{StaticResource Card}" Foreground="{StaticResource Text}" BorderThickness="0"
                                Cursor="Hand" FontSize="12" HorizontalContentAlignment="Left" Padding="16,0"/>

                        <TextBlock Text="STATUS" FontSize="10" FontWeight="Bold" Foreground="{StaticResource Muted}" Margin="4,24,0,8"/>
                        <TextBlock x:Name="StatusTitle" Text="Ready" FontSize="16" FontWeight="SemiBold" Foreground="{StaticResource Text}" Margin="4,0,0,4"/>
                        <TextBlock x:Name="StatusSub" Text="Pick a tool" FontSize="11" Foreground="{StaticResource Muted}" TextWrapping="Wrap" Margin="4,0,0,0"/>
                    </StackPanel>
                </Border>

                <!-- Cards area -->
                <ScrollViewer Grid.Column="1" VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Disabled" Background="{StaticResource Bg}">
                    <WrapPanel x:Name="CardPanel" Margin="20" ItemWidth="230" ItemHeight="120"/>
                </ScrollViewer>
            </Grid>

            <!-- BOTTOM CONSOLE -->
            <Border Grid.Row="2" Background="#05050A" CornerRadius="0,0,14,14" BorderBrush="{StaticResource Border}" BorderThickness="0,1,0,0">
                <Grid Margin="20,12">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    <TextBlock Text="CONSOLE" FontSize="10" FontWeight="Bold" Foreground="{StaticResource Muted}" Margin="0,0,0,6"/>
                    <TextBox x:Name="LogBox" Grid.Row="1"
                             Background="Transparent" Foreground="{StaticResource Accent2}"
                             BorderThickness="0" FontFamily="Consolas" FontSize="12"
                             IsReadOnly="True" VerticalScrollBarVisibility="Auto" TextWrapping="Wrap"/>
                </Grid>
            </Border>
        </Grid>
    </Border>
</Window>
"@

# =============================================================================
# DISCLAIMER (simple)
# =============================================================================
[xml]$discXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Ketteh" Width="480" Height="320"
        WindowStartupLocation="CenterScreen" WindowStyle="None"
        AllowsTransparency="True" Background="Transparent" FontFamily="Segoe UI">
    <Border Background="#0F0F18" CornerRadius="12" BorderBrush="#252538" BorderThickness="1" Padding="28">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="*"/>
                <RowDefinition Height="52"/>
            </Grid.RowDefinitions>
            <StackPanel>
                <TextBlock Text="Ketteh" FontSize="22" FontWeight="Bold" Foreground="#FF3CAC" Margin="0,0,0,14"/>
                <TextBlock TextWrapping="Wrap" Foreground="#F0F0F8" FontSize="13" Margin="0,0,0,10"
                           Text="Tools are downloaded from official sources and stored locally. Nothing is collected."/>
                <TextBlock TextWrapping="Wrap" Foreground="#F0F0F8" FontSize="13" Margin="0,0,0,10"
                           Text="Each tool is maintained by its own author. Use at your own risk."/>
                <TextBlock TextWrapping="Wrap" Foreground="#6B6B85" FontSize="12" Text="Click Accept to continue."/>
            </StackPanel>
            <Grid Grid.Row="1">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="12"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>
                <Button x:Name="CancelBtn" Grid.Column="0" Content="Cancel" Height="40"
                        Background="Transparent" Foreground="#F0F0F8" BorderBrush="#252538" BorderThickness="1" Cursor="Hand"/>
                <Button x:Name="AcceptBtn" Grid.Column="2" Content="Accept" Height="40"
                        Background="#161622" Foreground="#FF3CAC" BorderBrush="#FF3CAC" BorderThickness="1" Cursor="Hand" FontWeight="SemiBold"/>
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
# LOAD WINDOW
# =============================================================================
$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

$MinBtn        = $window.FindName("MinBtn")
$CloseBtn      = $window.FindName("CloseBtn")
$StatusTitle   = $window.FindName("StatusTitle")
$StatusSub     = $window.FindName("StatusSub")
$StatusBadge   = $window.FindName("StatusBadge")
$LogBox        = $window.FindName("LogBox")
$CardPanel     = $window.FindName("CardPanel")
$CatPills      = $window.FindName("CatPills")
$OpenFolderBtn = $window.FindName("OpenFolderBtn")
$ClearCacheBtn = $window.FindName("ClearCacheBtn")
$OpenPsBtn     = $window.FindName("OpenPsBtn")

# =============================================================================
# HELPERS
# =============================================================================
function Write-Log {
    param([string]$msg)
    $t = Get-Date -Format "HH:mm:ss"
    $LogBox.Dispatcher.Invoke([Action]{
        $LogBox.AppendText("[$t] $msg`r`n")
        $LogBox.ScrollToEnd()
    })
}

function Set-Status {
    param($title, $sub, $badge = "BUSY")
    $window.Dispatcher.Invoke([Action]{
        $StatusTitle.Text = $title
        $StatusSub.Text   = $sub
        $StatusBadge.Text = $badge
    })
}

# =============================================================================
# MOD ANALYZER (embedded)
# =============================================================================
function Start-KettehModAnalyzer {
    $script = @'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Clear-Host
Write-Host @"
  KETTEH  MOD  ANALYZER
"@ -ForegroundColor Magenta
Write-Host ""
Write-Host "  Enter mods folder path (Enter = default):" -ForegroundColor White
Write-Host "  > " -ForegroundColor Cyan -NoNewline
$path = Read-Host
if ([string]::IsNullOrWhiteSpace($path)) { $path = "$env:APPDATA\.minecraft\mods" }
if (-not (Test-Path $path -PathType Container)) {
    Write-Host "  Invalid path." -ForegroundColor Red
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
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
    "sessionstealer","tokenlogger","tokengrabber","discordtoken","backdoor"
)

function Get-SHA1($p){ (Get-FileHash $p -Algorithm SHA1).Hash }
function Query-Modrinth($h){
    try {
        $v = Invoke-RestMethod "https://api.modrinth.com/v2/version_file/$h" -ErrorAction Stop
        if($v.project_id){
            $p = Invoke-RestMethod "https://api.modrinth.com/v2/project/$($v.project_id)" -ErrorAction Stop
            return @{Name=$p.title;Slug=$p.slug}
        }
    }catch{}
    return @{Name="";Slug=""}
}
function Scan-Jar($fp){
    $hits = [System.Collections.Generic.HashSet[string]]::new()
    $client = $false
    try {
        $z = [IO.Compression.ZipFile]::OpenRead($fp)
        foreach($e in $z.Entries){
            $n = $e.FullName.ToLower()
            foreach($p in $patterns){
                if($n -match [regex]::Escape($p)){ $hits.Add($p)|Out-Null; if($p -match "wurst|meteor|impact|sigma|vengeance|dqrkis|grim|prestige|exhibition|rusherhack|novoline"){$client=$true} }
            }
            if($n -match '\.class$'){
                try{
                    $s=$e.Open(); $m=New-Object IO.MemoryStream; $s.CopyTo($m); $s.Close()
                    $t=[Text.Encoding]::ASCII.GetString($m.ToArray()).ToLower(); $m.Dispose()
                    foreach($p in $patterns){ if($p.Length -gt 4 -and $t -match [regex]::Escape($p)){ $hits.Add($p)|Out-Null; if($p -match "wurst|meteor|impact|sigma|vengeance|dqrkis|grim|prestige|exhibition|rusherhack|novoline"){$client=$true} } }
                }catch{}
            }
        }
        $z.Dispose()
    }catch{}
    return @{Hits=$hits;IsClient=$client;Count=$hits.Count}
}

$jars = Get-ChildItem $path -Filter *.jar -File -EA SilentlyContinue
Write-Host "  Found $($jars.Count) jars`n" -ForegroundColor Green
$v=@(); $u=@(); $c=@(); $s=@()
$i=0
foreach($j in $jars){
    $i++
    Write-Host "`r  [$i/$($jars.Count)] $($j.Name)" -NoNewline -ForegroundColor Cyan
    $h = Get-SHA1 $j.FullName
    $m = Query-Modrinth $h
    if($m.Slug){ $v += [pscustomobject]@{File=$j.Name;Name=$m.Name}; continue }
    $r = Scan-Jar $j.FullName
    if($r.IsClient){ $c += [pscustomobject]@{File=$j.Name;Hits=$r.Hits} }
    elseif($r.Count -gt 0){ $s += [pscustomobject]@{File=$j.Name;Hits=$r.Hits} }
    else{ $u += [pscustomobject]@{File=$j.Name} }
}
Write-Host "`r" + (" "*80) + "`r"
Write-Host "`n  Verified: $($v.Count)  Unknown: $($u.Count)  Suspicious: $($s.Count)  Cheats: $($c.Count)`n" -ForegroundColor White
if($c.Count){ Write-Host "  CHEATS" -ForegroundColor Red; $c | %{ Write-Host "  $($_.File)  →  $($_.Hits -join ', ')" -ForegroundColor Red }; Write-Host "" }
if($s.Count){ Write-Host "  SUSPICIOUS" -ForegroundColor Yellow; $s | %{ Write-Host "  $($_.File)  →  $($_.Hits -join ', ')" -ForegroundColor Yellow }; Write-Host "" }
Write-Host "  Press any key to exit..." -ForegroundColor DarkGray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
'@
    $tmp = Join-Path $env:TEMP "KettehMA_$([guid]::NewGuid().ToString('N').Substring(0,8)).ps1"
    Set-Content $tmp $script -Encoding UTF8
    Start-Process powershell -ArgumentList "-NoExit","-NoProfile","-ExecutionPolicy","Bypass","-File","`"$tmp`""
    Write-Log "Launched Mod Analyzer"
    Set-Status "Ready" "Mod Analyzer running" "IDLE"
}

# =============================================================================
# BUILD CATEGORY PILLS + CARDS
# =============================================================================
$script:ActiveCat = "All"
$Categories = @("All","Ketteh","Orbdiff","Spokwn","Tonynoh","Praiselily","RedLotus","Zimmerman","NirSoft","Others","Dependencies")

function New-Pill($text, $active) {
    $b = New-Object System.Windows.Controls.Button
    $b.Content = $text
    $b.Height = 30
    $b.Margin = "0,0,8,0"
    $b.Padding = "14,0"
    $b.FontSize = 12
    $b.Cursor = "Hand"
    $b.BorderThickness = 0
    if ($active) {
        $b.Background = [Windows.Media.BrushConverter]::new().ConvertFrom("#FF3CAC")
        $b.Foreground = [Windows.Media.Brushes]::White
    } else {
        $b.Background = [Windows.Media.BrushConverter]::new().ConvertFrom("#161622")
        $b.Foreground = [Windows.Media.BrushConverter]::new().ConvertFrom("#6B6B85")
    }
    $b.Template = [Windows.Markup.XamlReader]::Parse(
        "<ControlTemplate xmlns='http://schemas.microsoft.com/winfx/2006/xaml/presentation' TargetType='Button'>" +
        "<Border Background='{TemplateBinding Background}' CornerRadius='15' Padding='{TemplateBinding Padding}'>" +
        "<ContentPresenter HorizontalAlignment='Center' VerticalAlignment='Center'/></Border></ControlTemplate>"
    )
    return $b
}

function Refresh-Cards {
    $CardPanel.Children.Clear()
    $list = if ($script:ActiveCat -eq "All") { $ToolData } else { $ToolData | Where-Object { $_.Category -eq $script:ActiveCat } }

    foreach ($tool in $list) {
        $t = $tool
        $card = New-Object System.Windows.Controls.Border
        $card.Width = 220
        $card.Height = 108
        $card.Margin = "8"
        $card.CornerRadius = 12
        $card.Background = [Windows.Media.BrushConverter]::new().ConvertFrom("#161622")
        $card.BorderBrush = [Windows.Media.BrushConverter]::new().ConvertFrom("#252538")
        $card.BorderThickness = 1
        $card.Cursor = "Hand"
        $card.Padding = "16,14"

        $stack = New-Object System.Windows.Controls.StackPanel
        $name = New-Object System.Windows.Controls.TextBlock
        $name.Text = $t.Name
        $name.FontSize = 13
        $name.FontWeight = "SemiBold"
        $name.Foreground = [Windows.Media.BrushConverter]::new().ConvertFrom("#F0F0F8")
        $name.TextWrapping = "Wrap"

        $desc = New-Object System.Windows.Controls.TextBlock
        $desc.Text = $t.Desc
        $desc.FontSize = 11
        $desc.Foreground = [Windows.Media.BrushConverter]::new().ConvertFrom("#6B6B85")
        $desc.TextWrapping = "Wrap"
        $desc.Margin = "0,6,0,0"

        $stack.Children.Add($name) | Out-Null
        $stack.Children.Add($desc) | Out-Null
        $card.Child = $stack

        $card.Add_MouseEnter({
            $_.Source.Background = [Windows.Media.BrushConverter]::new().ConvertFrom("#1E1E2E")
            $_.Source.BorderBrush = [Windows.Media.BrushConverter]::new().ConvertFrom("#FF3CAC")
        })
        $card.Add_MouseLeave({
            $_.Source.Background = [Windows.Media.BrushConverter]::new().ConvertFrom("#161622")
            $_.Source.BorderBrush = [Windows.Media.BrushConverter]::new().ConvertFrom("#252538")
        })

        $card.Add_MouseLeftButtonUp({
            $nameText = ($_.Source.Child.Children[0]).Text
            $td = $ToolData | Where-Object { $_.Name -eq $nameText } | Select-Object -First 1
            if (-not $td) { return }

            if ($td.Type -eq "Builtin") {
                Start-KettehModAnalyzer
                return
            }
            if ($td.Type -eq "Link") {
                Start-Process $td.URL
                Set-Status "Ready" "Opened browser" "IDLE"
                return
            }
            if ($td.Type -eq "Cmd") {
                Set-Status "Running" $td.Name "BUSY"
                Write-Log "Launching $($td.Name)"
                Start-Process powershell -ArgumentList "-NoExit","-NoProfile","-ExecutionPolicy","Bypass","-Command",$td.Command
                Set-Status "Ready" "Launched" "IDLE"
                return
            }

            # Download
            Set-Status "Downloading" $td.Name "BUSY"
            Write-Log "Downloading $($td.Name)..."

            $rs = [runspacefactory]::CreateRunspace(); $rs.Open()
            $rs.SessionStateProxy.SetVariable("td",$td)
            $rs.SessionStateProxy.SetVariable("installDir",$installDir)
            $rs.SessionStateProxy.SetVariable("dispatcher",$window.Dispatcher)
            $rs.SessionStateProxy.SetVariable("StatusTitle",$StatusTitle)
            $rs.SessionStateProxy.SetVariable("StatusSub",$StatusSub)
            $rs.SessionStateProxy.SetVariable("StatusBadge",$StatusBadge)
            $rs.SessionStateProxy.SetVariable("LogBox",$LogBox)

            $ps = [powershell]::Create(); $ps.Runspace = $rs
            $null = $ps.AddScript({
                function L($m){ $dispatcher.Invoke([Action]{ $LogBox.AppendText("[$(Get-Date -f HH:mm:ss)] $m`n"); $LogBox.ScrollToEnd() }) }
                function S($t,$s,$b){ $dispatcher.Invoke([Action]{ $StatusTitle.Text=$t; $StatusSub.Text=$s; $StatusBadge.Text=$b }) }
                try {
                    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                    $dir = "$installDir\$($td.Category)\$($td.Name)"
                    if (-not (Test-Path $dir)) { New-Item $dir -ItemType Directory -Force | Out-Null }

                    if ($td.Type -eq "GitHub") {
                        $parts = $td.URL -replace "https://github.com/","" -split "/"
                        $api = "https://api.github.com/repos/$($parts[0])/$($parts[1])/releases/latest"
                        $rel = Invoke-RestMethod $api -Headers @{ "User-Agent"="Ketteh" }
                        $asset = $rel.assets | Where-Object { $_.name -match "\.(zip|exe)$" } | Select-Object -First 1
                        if (-not $asset) { throw "No asset" }
                        $url = $asset.browser_download_url
                        $fn = $asset.name
                    } else {
                        $url = $td.URL
                        $fn = ($url -split "/")[-1]
                    }
                    $out = "$dir\$fn"
                    if (-not (Test-Path $out)) {
                        L "Downloading $fn..."
                        (New-Object Net.WebClient).DownloadFile($url, $out)
                    } else { L "Cached $fn" }

                    if ($fn -match "\.zip$") {
                        Expand-Archive $out $dir -Force
                        $exe = Get-ChildItem $dir -Filter *.exe -Recurse | Select-Object -First 1
                        if ($exe) { Start-Process $exe.FullName; L "Launched $($exe.Name)" }
                        else { Start-Process explorer $dir }
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
            $null = $ps.BeginInvoke()
        }.GetNewClosure())

        $CardPanel.Children.Add($card) | Out-Null
    }
}

# Build pills
foreach ($cat in $Categories) {
    $pill = New-Pill $cat ($cat -eq "All")
    $pill.Add_Click({
        $script:ActiveCat = $this.Content
        $CatPills.Children.Clear()
        foreach ($c in $Categories) {
            $p = New-Pill $c ($c -eq $script:ActiveCat)
            $p.Add_Click($pill.Add_Click)  # re-bind later properly
            $CatPills.Children.Add($p) | Out-Null
        }
        # simpler rebuild
        $CatPills.Children.Clear()
        foreach ($c in $Categories) {
            $np = New-Pill $c ($c -eq $script:ActiveCat)
            $np.Add_Click({
                $script:ActiveCat = $this.Content
                # rebuild pills
                $CatPills.Children.Clear()
                foreach ($cc in $Categories) {
                    $pp = New-Pill $cc ($cc -eq $script:ActiveCat)
                    $pp.Add_Click($np.Add_Click)
                    $CatPills.Children.Add($pp) | Out-Null
                }
                Refresh-Cards
            }.GetNewClosure())
            $CatPills.Children.Add($np) | Out-Null
        }
        Refresh-Cards
    }.GetNewClosure())
    $CatPills.Children.Add($pill) | Out-Null
}

Refresh-Cards

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
        $n = @(Get-ChildItem $installDir -Force).Count
        Get-ChildItem $installDir -Force | Remove-Item -Recurse -Force -EA SilentlyContinue
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
