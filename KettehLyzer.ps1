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
    @{ Name="Ketteh Mod Analyzer"; Desc="Full cheat + rat scanner for Minecraft mods"; Category="Ketteh"; Type="Builtin" },

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
# NEON CYBER UI
# =============================================================================
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Ketteh" Width="1280" Height="820"
        WindowStartupLocation="CenterScreen" WindowStyle="None"
        AllowsTransparency="True" Background="Transparent"
        FontFamily="Segoe UI">

    <Border Background="#06060F" CornerRadius="16" BorderBrush="#1E1E3A" BorderThickness="1">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="64"/>
                <RowDefinition Height="56"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="140"/>
            </Grid.RowDefinitions>

            <!-- TOP BAR -->
            <Border Grid.Row="0" Background="#0C0C1A" CornerRadius="16,16,0,0">
                <Grid Margin="24,0">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="Auto"/>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="Auto"/>
                        <ColumnDefinition Width="Auto"/>
                    </Grid.ColumnDefinitions>

                    <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
                        <TextBlock Text="KETTEH" FontSize="20" FontWeight="Bold">
                            <TextBlock.Foreground>
                                <LinearGradientBrush StartPoint="0,0" EndPoint="1,0">
                                    <GradientStop Color="#FF2E63" Offset="0"/>
                                    <GradientStop Color="#00F5FF" Offset="1"/>
                                </LinearGradientBrush>
                            </TextBlock.Foreground>
                        </TextBlock>
                        <TextBlock Text="  // SS TOOLKIT" FontSize="12" Foreground="#4A4A6A" VerticalAlignment="Center" Margin="8,0,0,0"/>
                    </StackPanel>

                    <Border Grid.Column="2" x:Name="StatusBadgeBorder" Background="#0A2A2A" CornerRadius="20" Padding="16,6" VerticalAlignment="Center" Margin="0,0,16,0">
                        <TextBlock x:Name="StatusBadge" Text="IDLE" FontSize="12" FontWeight="Bold" Foreground="#00F5FF"/>
                    </Border>

                    <StackPanel Grid.Column="3" Orientation="Horizontal" VerticalAlignment="Center">
                        <Button x:Name="MinBtn" Content="─" Width="40" Height="34" Background="Transparent" Foreground="#5A5A7A" BorderThickness="0" Cursor="Hand" FontSize="14"/>
                        <Button x:Name="CloseBtn" Content="✕" Width="40" Height="34" Background="Transparent" Foreground="#5A5A7A" BorderThickness="0" Cursor="Hand" FontSize="14"/>
                    </StackPanel>
                </Grid>
            </Border>

            <!-- CATEGORY STRIP -->
            <Border Grid.Row="1" Background="#0A0A16" BorderBrush="#1A1A30" BorderThickness="0,0,0,1">
                <ScrollViewer HorizontalScrollBarVisibility="Hidden" VerticalScrollBarVisibility="Disabled">
                    <StackPanel x:Name="CatBar" Orientation="Horizontal" Margin="20,0" VerticalAlignment="Center"/>
                </ScrollViewer>
            </Border>

            <!-- MAIN AREA -->
            <Grid Grid.Row="2">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="200"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>

                <!-- LEFT ACTIONS -->
                <Border Grid.Column="0" Background="#0A0A16" BorderBrush="#1A1A30" BorderThickness="0,0,1,0">
                    <StackPanel Margin="16,20">
                        <TextBlock Text="ACTIONS" FontSize="10" FontWeight="Bold" Foreground="#3A3A5A" Margin="4,0,0,12"/>
                        
                        <Button x:Name="OpenFolderBtn" Content="  Open Folder" Height="42" Margin="0,0,0,8"
                                Background="#12122A" Foreground="#C0C0E0" BorderThickness="0" Cursor="Hand"
                                FontSize="13" HorizontalContentAlignment="Left"/>
                        <Button x:Name="ClearCacheBtn" Content="  Clear Cache" Height="42" Margin="0,0,0,8"
                                Background="#12122A" Foreground="#C0C0E0" BorderThickness="0" Cursor="Hand"
                                FontSize="13" HorizontalContentAlignment="Left"/>
                        <Button x:Name="OpenPsBtn" Content="  PowerShell" Height="42" Margin="0,0,0,8"
                                Background="#12122A" Foreground="#C0C0E0" BorderThickness="0" Cursor="Hand"
                                FontSize="13" HorizontalContentAlignment="Left"/>

                        <TextBlock Text="STATUS" FontSize="10" FontWeight="Bold" Foreground="#3A3A5A" Margin="4,28,0,8"/>
                        <TextBlock x:Name="StatusTitle" Text="Ready" FontSize="16" FontWeight="SemiBold" Foreground="#E0E0FF" Margin="4,0,0,4"/>
                        <TextBlock x:Name="StatusSub" Text="Select a tool" FontSize="12" Foreground="#5A5A7A" TextWrapping="Wrap" Margin="4,0,0,0"/>
                    </StackPanel>
                </Border>

                <!-- CARDS -->
                <ScrollViewer Grid.Column="1" VerticalScrollBarVisibility="Auto" Background="#06060F">
                    <WrapPanel x:Name="CardPanel" Margin="16"/>
                </ScrollViewer>
            </Grid>

            <!-- CONSOLE -->
            <Border Grid.Row="3" Background="#04040A" CornerRadius="0,0,16,16" BorderBrush="#1A1A30" BorderThickness="0,1,0,0">
                <Grid Margin="20,12">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    <TextBlock Text="ACTIVITY CONSOLE" FontSize="10" FontWeight="Bold" Foreground="#3A3A5A" Margin="0,0,0,6"/>
                    <TextBox x:Name="LogBox" Grid.Row="1"
                             Background="Transparent" Foreground="#00F5FF"
                             BorderThickness="0" FontFamily="Consolas" FontSize="12"
                             IsReadOnly="True" VerticalScrollBarVisibility="Auto" TextWrapping="Wrap"/>
                </Grid>
            </Border>
        </Grid>
    </Border>
</Window>
"@

# =============================================================================
# DISCLAIMER
# =============================================================================
[xml]$discXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Ketteh" Width="480" Height="300"
        WindowStartupLocation="CenterScreen" WindowStyle="None"
        AllowsTransparency="True" Background="Transparent" FontFamily="Segoe UI">
    <Border Background="#0C0C1A" CornerRadius="14" BorderBrush="#1E1E3A" BorderThickness="1" Padding="28">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="*"/>
                <RowDefinition Height="50"/>
            </Grid.RowDefinitions>
            <StackPanel>
                <TextBlock Text="KETTEH" FontSize="22" FontWeight="Bold" Foreground="#00F5FF" Margin="0,0,0,14"/>
                <TextBlock TextWrapping="Wrap" Foreground="#C0C0E0" FontSize="13" Margin="0,0,0,10"
                           Text="Tools are downloaded from official sources and stored locally. Nothing is collected."/>
                <TextBlock TextWrapping="Wrap" Foreground="#C0C0E0" FontSize="13" Margin="0,0,0,10"
                           Text="Each tool is maintained by its own author. Use at your own risk."/>
                <TextBlock TextWrapping="Wrap" Foreground="#5A5A7A" FontSize="12" Text="Click Accept to continue."/>
            </StackPanel>
            <Grid Grid.Row="1">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="12"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>
                <Button x:Name="CancelBtn" Grid.Column="0" Content="Cancel" Height="40"
                        Background="Transparent" Foreground="#C0C0E0" BorderBrush="#2A2A4A" BorderThickness="1" Cursor="Hand"/>
                <Button x:Name="AcceptBtn" Grid.Column="2" Content="Accept" Height="40"
                        Background="#12122A" Foreground="#00F5FF" BorderBrush="#00F5FF" BorderThickness="1" Cursor="Hand" FontWeight="SemiBold"/>
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

$MinBtn            = $window.FindName("MinBtn")
$CloseBtn          = $window.FindName("CloseBtn")
$StatusTitle       = $window.FindName("StatusTitle")
$StatusSub         = $window.FindName("StatusSub")
$StatusBadge       = $window.FindName("StatusBadge")
$StatusBadgeBorder = $window.FindName("StatusBadgeBorder")
$LogBox            = $window.FindName("LogBox")
$CatBar            = $window.FindName("CatBar")
$CardPanel         = $window.FindName("CardPanel")
$OpenFolderBtn     = $window.FindName("OpenFolderBtn")
$ClearCacheBtn     = $window.FindName("ClearCacheBtn")
$OpenPsBtn         = $window.FindName("OpenPsBtn")

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
    param([string]$title, [string]$sub, [string]$badge = "BUSY", [string]$color = "#00F5FF")
    $window.Dispatcher.Invoke([Action]{
        $StatusTitle.Text = $title
        $StatusSub.Text   = $sub
        $StatusBadge.Text = $badge
        $StatusBadge.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString($color)
    })
}

# =============================================================================
# MOD ANALYZER (working)
# =============================================================================
function Start-KettehModAnalyzer {
    $code = @'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Clear-Host
Write-Host ""
Write-Host "  KETTEH MOD ANALYZER" -ForegroundColor Cyan
Write-Host "  -------------------" -ForegroundColor DarkCyan
Write-Host ""
Write-Host "  Enter mods folder path (Enter = default):" -ForegroundColor Gray
Write-Host "  > " -NoNewline -ForegroundColor Cyan
$path = Read-Host
if ([string]::IsNullOrWhiteSpace($path)) {
    $path = Join-Path $env:APPDATA ".minecraft\mods"
    Write-Host "  Using: $path" -ForegroundColor DarkGray
}
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
    "sessionstealer","tokenlogger","tokengrabber","discordtoken","backdoor",
    "meteordevelopment","cc/novoline","com/alan/clients","net/ccbluex"
)

function Get-SHA1([string]$p) { (Get-FileHash -Path $p -Algorithm SHA1).Hash }

function Query-Modrinth([string]$hash) {
    try {
        $ver = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/version_file/$hash" -ErrorAction Stop
        if ($ver.project_id) {
            $proj = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/project/$($ver.project_id)" -ErrorAction Stop
            return @{ Name = $proj.title; Slug = $proj.slug }
        }
    } catch {}
    return @{ Name = ""; Slug = "" }
}

function Scan-Jar([string]$fp) {
    $hits = [System.Collections.Generic.HashSet[string]]::new()
    $isClient = $false
    try {
        $zip = [System.IO.Compression.ZipFile]::OpenRead($fp)
        foreach ($entry in $zip.Entries) {
            $name = $entry.FullName.ToLower()
            foreach ($p in $patterns) {
                if ($name -match [regex]::Escape($p)) {
                    [void]$hits.Add($p)
                    if ($p -match "wurst|meteor|impact|sigma|vengeance|dqrkis|grim|prestige|exhibition|rusherhack|novoline") { $isClient = $true }
                }
            }
            if ($name -match '\.class$') {
                try {
                    $stream = $entry.Open()
                    $ms = New-Object System.IO.MemoryStream
                    $stream.CopyTo($ms)
                    $stream.Close()
                    $text = [System.Text.Encoding]::ASCII.GetString($ms.ToArray()).ToLower()
                    $ms.Dispose()
                    foreach ($p in $patterns) {
                        if ($p.Length -gt 4 -and $text -match [regex]::Escape($p)) {
                            [void]$hits.Add($p)
                            if ($p -match "wurst|meteor|impact|sigma|vengeance|dqrkis|grim|prestige|exhibition|rusherhack|novoline") { $isClient = $true }
                        }
                    }
                } catch {}
            }
        }
        $zip.Dispose()
    } catch {}
    return @{ Hits = $hits; IsClient = $isClient; Count = $hits.Count }
}

$jars = Get-ChildItem -Path $path -Filter *.jar -File -ErrorAction SilentlyContinue
Write-Host ""
Write-Host "  Found $($jars.Count) JARs" -ForegroundColor Green
Write-Host ""

$verified = @(); $unknown = @(); $cheats = @(); $suspicious = @()
$i = 0
foreach ($jar in $jars) {
    $i++
    Write-Host "`r  [$i/$($jars.Count)] $($jar.Name)                    " -NoNewline -ForegroundColor Cyan
    $hash = Get-SHA1 $jar.FullName
    $mod = Query-Modrinth $hash
    if ($mod.Slug) {
        $verified += [PSCustomObject]@{ File = $jar.Name; Name = $mod.Name }
        continue
    }
    $result = Scan-Jar $jar.FullName
    if ($result.IsClient) {
        $cheats += [PSCustomObject]@{ File = $jar.Name; Hits = ($result.Hits -join ", ") }
    }
    elseif ($result.Count -gt 0) {
        $suspicious += [PSCustomObject]@{ File = $jar.Name; Hits = ($result.Hits -join ", ") }
    }
    else {
        $unknown += [PSCustomObject]@{ File = $jar.Name }
    }
}

Write-Host "`r" + (" " * 60) + "`r"
Write-Host ""
Write-Host "  Verified   : $($verified.Count)" -ForegroundColor Green
Write-Host "  Unknown    : $($unknown.Count)" -ForegroundColor Gray
Write-Host "  Suspicious : $($suspicious.Count)" -ForegroundColor Yellow
Write-Host "  Cheats     : $($cheats.Count)" -ForegroundColor Red
Write-Host ""

if ($cheats.Count -gt 0) {
    Write-Host "  CHEATS DETECTED" -ForegroundColor Red
    foreach ($c in $cheats) {
        Write-Host "  $($c.File)" -ForegroundColor Red
        Write-Host "    $($c.Hits)" -ForegroundColor DarkRed
    }
    Write-Host ""
}
if ($suspicious.Count -gt 0) {
    Write-Host "  SUSPICIOUS" -ForegroundColor Yellow
    foreach ($s in $suspicious) {
        Write-Host "  $($s.File)  ->  $($s.Hits)" -ForegroundColor Yellow
    }
    Write-Host ""
}

Write-Host "  Press any key to exit..." -ForegroundColor DarkGray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
'@

    $tmp = Join-Path $env:TEMP ("KettehMA_" + [guid]::NewGuid().ToString("N").Substring(0,8) + ".ps1")
    Set-Content -Path $tmp -Value $code -Encoding UTF8
    Start-Process powershell.exe -ArgumentList "-NoExit","-NoProfile","-ExecutionPolicy","Bypass","-File","`"$tmp`""
    Write-Log "Launched Ketteh Mod Analyzer"
    Set-Status "Ready" "Mod Analyzer running" "IDLE" "#00F5FF"
}

# =============================================================================
# BUILD CATEGORIES + CARDS (interactive)
# =============================================================================
$script:ActiveCat = "All"
$Categories = @("All","Ketteh","Orbdiff","Spokwn","Tonynoh","Praiselily","RedLotus","Zimmerman","NirSoft","Others","Dependencies")

function New-CatButton {
    param([string]$Text, [bool]$Active)

    $btn = New-Object System.Windows.Controls.Button
    $btn.Content = $Text
    $btn.Height = 34
    $btn.Margin = "0,0,8,0"
    $btn.Padding = "16,0"
    $btn.FontSize = 13
    $btn.Cursor = "Hand"
    $btn.BorderThickness = 0
    $btn.Tag = $Text

    if ($Active) {
        $btn.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#FF2E63")
        $btn.Foreground = [System.Windows.Media.Brushes]::White
        $btn.FontWeight = "SemiBold"
    } else {
        $btn.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#12122A")
        $btn.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#8A8AAA")
    }

    $btn.Template = [Windows.Markup.XamlReader]::Parse(@"
<ControlTemplate xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" TargetType="Button">
    <Border Background="{TemplateBinding Background}" CornerRadius="17" Padding="{TemplateBinding Padding}">
        <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
    </Border>
</ControlTemplate>
"@)

    $btn.Add_Click({
        $script:ActiveCat = $this.Tag
        Build-Categories
        Build-Cards
    })

    return $btn
}

function Build-Categories {
    $CatBar.Children.Clear()
    foreach ($cat in $Categories) {
        $b = New-CatButton -Text $cat -Active ($cat -eq $script:ActiveCat)
        [void]$CatBar.Children.Add($b)
    }
}

function Build-Cards {
    $CardPanel.Children.Clear()

    $list = if ($script:ActiveCat -eq "All") { $ToolData } else { $ToolData | Where-Object { $_.Category -eq $script:ActiveCat } }

    foreach ($tool in $list) {
        $card = New-Object System.Windows.Controls.Border
        $card.Width = 230
        $card.Height = 110
        $card.Margin = "8"
        $card.CornerRadius = 14
        $card.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#12122A")
        $card.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#2A2A4A")
        $card.BorderThickness = 1
        $card.Cursor = "Hand"
        $card.Padding = "16,14"
        $card.Tag = $tool

        # Scale transform for hover
        $scale = New-Object System.Windows.Media.ScaleTransform 1,1
        $card.RenderTransform = $scale
        $card.RenderTransformOrigin = "0.5,0.5"

        $stack = New-Object System.Windows.Controls.StackPanel

        $name = New-Object System.Windows.Controls.TextBlock
        $name.Text = $tool.Name
        $name.FontSize = 14
        $name.FontWeight = "SemiBold"
        $name.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#E8E8FF")
        $name.TextWrapping = "Wrap"

        $desc = New-Object System.Windows.Controls.TextBlock
        $desc.Text = $tool.Desc
        $desc.FontSize = 11
        $desc.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#6A6A8A")
        $desc.TextWrapping = "Wrap"
        $desc.Margin = "0,6,0,0"

        [void]$stack.Children.Add($name)
        [void]$stack.Children.Add($desc)
        $card.Child = $stack

        # Hover effects
        $card.Add_MouseEnter({
            $this.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#1A1A3A")
            $this.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#00F5FF")
            $sc = $this.RenderTransform
            if ($sc -is [System.Windows.Media.ScaleTransform]) {
                $animX = New-Object System.Windows.Media.Animation.DoubleAnimation 1.05, ([TimeSpan]::FromMilliseconds(120))
                $animY = New-Object System.Windows.Media.Animation.DoubleAnimation 1.05, ([TimeSpan]::FromMilliseconds(120))
                $sc.BeginAnimation([System.Windows.Media.ScaleTransform]::ScaleXProperty, $animX)
                $sc.BeginAnimation([System.Windows.Media.ScaleTransform]::ScaleYProperty, $animY)
            }
        })

        $card.Add_MouseLeave({
            $this.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#12122A")
            $this.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#2A2A4A")
            $sc = $this.RenderTransform
            if ($sc -is [System.Windows.Media.ScaleTransform]) {
                $animX = New-Object System.Windows.Media.Animation.DoubleAnimation 1.0, ([TimeSpan]::FromMilliseconds(150))
                $animY = New-Object System.Windows.Media.Animation.DoubleAnimation 1.0, ([TimeSpan]::FromMilliseconds(150))
                $sc.BeginAnimation([System.Windows.Media.ScaleTransform]::ScaleXProperty, $animX)
                $sc.BeginAnimation([System.Windows.Media.ScaleTransform]::ScaleYProperty, $animY)
            }
        })

        $card.Add_MouseLeftButtonUp({
            $td = $this.Tag
            if ($null -eq $td) { return }

            switch ($td.Type) {
                "Builtin" {
                    Start-KettehModAnalyzer
                }
                "Link" {
                    Start-Process $td.URL
                    Write-Log "Opened $($td.Name)"
                    Set-Status "Ready" "Opened in browser" "IDLE"
                }
                "Cmd" {
                    Set-Status "Running" $td.Name "BUSY" "#FF2E63"
                    Write-Log "Launching $($td.Name)"
                    Start-Process powershell.exe -ArgumentList "-NoExit","-NoProfile","-ExecutionPolicy","Bypass","-Command",$td.Command
                    Set-Status "Ready" "Launched" "IDLE"
                }
                default {
                    Set-Status "Downloading" $td.Name "BUSY" "#FF2E63"
                    Write-Log "Downloading $($td.Name)..."

                    $rs = [runspacefactory]::CreateRunspace()
                    $rs.Open()
                    $rs.SessionStateProxy.SetVariable("tool", $td)
                    $rs.SessionStateProxy.SetVariable("dir", $installDir)
                    $rs.SessionStateProxy.SetVariable("ui", $window.Dispatcher)
                    $rs.SessionStateProxy.SetVariable("titleCtrl", $StatusTitle)
                    $rs.SessionStateProxy.SetVariable("subCtrl", $StatusSub)
                    $rs.SessionStateProxy.SetVariable("badgeCtrl", $StatusBadge)
                    $rs.SessionStateProxy.SetVariable("logCtrl", $LogBox)

                    $ps = [powershell]::Create()
                    $ps.Runspace = $rs
                    [void]$ps.AddScript({
                        function Log($m) {
                            $ui.Invoke([Action]{
                                $logCtrl.AppendText("[$(Get-Date -Format 'HH:mm:ss')] $m`r`n")
                                $logCtrl.ScrollToEnd()
                            })
                        }
                        function Status($t,$s,$b) {
                            $ui.Invoke([Action]{
                                $titleCtrl.Text = $t
                                $subCtrl.Text = $s
                                $badgeCtrl.Text = $b
                            })
                        }

                        try {
                            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                            $target = Join-Path $dir "$($tool.Category)\$($tool.Name)"
                            if (-not (Test-Path $target)) { New-Item -ItemType Directory -Path $target -Force | Out-Null }

                            if ($tool.Type -eq "GitHub") {
                                $parts = $tool.URL -replace "https://github.com/","" -split "/"
                                $api = "https://api.github.com/repos/$($parts[0])/$($parts[1])/releases/latest"
                                $rel = Invoke-RestMethod -Uri $api -Headers @{ "User-Agent"="Ketteh" }
                                $asset = $rel.assets | Where-Object { $_.name -match "\.(zip|exe)$" } | Select-Object -First 1
                                if (-not $asset) { throw "No asset found" }
                                $url = $asset.browser_download_url
                                $fn = $asset.name
                            } else {
                                $url = $tool.URL
                                $fn = ($url -split "/")[-1]
                            }

                            $out = Join-Path $target $fn
                            if (-not (Test-Path $out)) {
                                Log "Downloading $fn..."
                                (New-Object Net.WebClient).DownloadFile($url, $out)
                                Log "Download complete"
                            } else {
                                Log "Using cache: $fn"
                            }

                            if ($fn -match "\.zip$") {
                                Expand-Archive -Path $out -DestinationPath $target -Force
                                $exe = Get-ChildItem $target -Filter "*.exe" -Recurse | Select-Object -First 1
                                if ($exe) {
                                    Start-Process $exe.FullName
                                    Log "Launched $($exe.Name)"
                                } else {
                                    Start-Process explorer.exe $target
                                    Log "Opened folder"
                                }
                            } else {
                                Start-Process $out
                                Log "Launched $fn"
                            }
                            Status "Ready" "Done" "IDLE"
                        } catch {
                            Log "Error: $_"
                            Status "Error" "Failed" "ERR"
                        }
                    })
                    [void]$ps.BeginInvoke()
                }
            }
        })

        [void]$CardPanel.Children.Add($card)
    }
}

Build-Categories
Build-Cards

# =============================================================================
# EVENTS
# =============================================================================
$window.Add_MouseLeftButtonDown({ try { $window.DragMove() } catch {} })
$CloseBtn.Add_Click({ $window.Close() })
$MinBtn.Add_Click({ $window.WindowState = "Minimized" })

$OpenFolderBtn.Add_Click({
    if (-not (Test-Path $installDir)) { New-Item -ItemType Directory -Path $installDir -Force | Out-Null }
    Start-Process explorer.exe $installDir
    Write-Log "Opened install folder"
})

$ClearCacheBtn.Add_Click({
    if (Test-Path $installDir) {
        $n = @(Get-ChildItem $installDir -Force -ErrorAction SilentlyContinue).Count
        Get-ChildItem $installDir -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        Write-Log "Cleared $n items"
        Set-Status "Ready" "Cache cleared" "IDLE"
    } else {
        Write-Log "Nothing to clear"
    }
})

$OpenPsBtn.Add_Click({
    Start-Process powershell.exe
    Write-Log "Opened PowerShell"
})

Write-Log "Ketteh ready — all systems online"
Set-Status "Ready" "Select a tool" "IDLE" "#00F5FF"

$window.ShowDialog() | Out-Null
