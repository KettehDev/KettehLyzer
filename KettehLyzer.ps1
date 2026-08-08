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
# XAML
# =============================================================================
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Ketteh" Width="1280" Height="820"
        WindowStartupLocation="CenterScreen" WindowStyle="None"
        AllowsTransparency="True" Background="Transparent" FontFamily="Segoe UI">

    <Border Background="#07070C" CornerRadius="14" BorderBrush="#252538" BorderThickness="1">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="56"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="130"/>
            </Grid.RowDefinitions>

            <!-- TOP BAR -->
            <Border Grid.Row="0" Background="#0F0F18" CornerRadius="14,14,0,0">
                <Grid Margin="20,0">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="Auto"/>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="Auto"/>
                        <ColumnDefinition Width="Auto"/>
                    </Grid.ColumnDefinitions>

                    <TextBlock Text="KETTEH" FontSize="18" FontWeight="Bold" Foreground="#FF3CAC" VerticalAlignment="Center"/>

                    <ScrollViewer Grid.Column="1" HorizontalScrollBarVisibility="Hidden" VerticalScrollBarVisibility="Disabled" Margin="24,0">
                        <StackPanel x:Name="CatPills" Orientation="Horizontal" VerticalAlignment="Center"/>
                    </ScrollViewer>

                    <Border Grid.Column="2" Background="#1A1A28" CornerRadius="16" Padding="12,5" VerticalAlignment="Center" Margin="0,0,12,0">
                        <TextBlock x:Name="StatusBadge" Text="IDLE" FontSize="11" FontWeight="SemiBold" Foreground="#00E5FF"/>
                    </Border>

                    <StackPanel Grid.Column="3" Orientation="Horizontal" VerticalAlignment="Center">
                        <Button x:Name="MinBtn" Content="─" Width="34" Height="30" Background="Transparent" Foreground="#6B6B85" BorderThickness="0" Cursor="Hand"/>
                        <Button x:Name="CloseBtn" Content="✕" Width="34" Height="30" Background="Transparent" Foreground="#6B6B85" BorderThickness="0" Cursor="Hand"/>
                    </StackPanel>
                </Grid>
            </Border>

            <!-- BODY -->
            <Grid Grid.Row="1">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="190"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>

                <!-- LEFT RAIL -->
                <Border Grid.Column="0" Background="#0F0F18" BorderBrush="#252538" BorderThickness="0,0,1,0">
                    <StackPanel Margin="14,18">
                        <TextBlock Text="ACTIONS" FontSize="10" FontWeight="Bold" Foreground="#6B6B85" Margin="4,0,0,10"/>
                        <Button x:Name="OpenFolderBtn" Content="  Open Folder" Height="38" Margin="0,0,0,6"
                                Background="#161622" Foreground="#F0F0F8" BorderThickness="0" Cursor="Hand"
                                HorizontalContentAlignment="Left" FontSize="12"/>
                        <Button x:Name="ClearCacheBtn" Content="  Clear Cache" Height="38" Margin="0,0,0,6"
                                Background="#161622" Foreground="#F0F0F8" BorderThickness="0" Cursor="Hand"
                                HorizontalContentAlignment="Left" FontSize="12"/>
                        <Button x:Name="OpenPsBtn" Content="  PowerShell" Height="38" Margin="0,0,0,6"
                                Background="#161622" Foreground="#F0F0F8" BorderThickness="0" Cursor="Hand"
                                HorizontalContentAlignment="Left" FontSize="12"/>

                        <TextBlock Text="STATUS" FontSize="10" FontWeight="Bold" Foreground="#6B6B85" Margin="4,22,0,8"/>
                        <TextBlock x:Name="StatusTitle" Text="Ready" FontSize="15" FontWeight="SemiBold" Foreground="#F0F0F8" Margin="4,0,0,4"/>
                        <TextBlock x:Name="StatusSub" Text="Select a tool" FontSize="11" Foreground="#6B6B85" TextWrapping="Wrap" Margin="4,0,0,0"/>
                    </StackPanel>
                </Border>

                <!-- CARDS -->
                <ScrollViewer Grid.Column="1" VerticalScrollBarVisibility="Auto" Background="#07070C">
                    <WrapPanel x:Name="CardPanel" Margin="16"/>
                </ScrollViewer>
            </Grid>

            <!-- CONSOLE -->
            <Border Grid.Row="2" Background="#05050A" CornerRadius="0,0,14,14" BorderBrush="#252538" BorderThickness="0,1,0,0">
                <Grid Margin="18,10">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    <TextBlock Text="CONSOLE" FontSize="10" FontWeight="Bold" Foreground="#6B6B85" Margin="0,0,0,4"/>
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
# DISCLAIMER
# =============================================================================
[xml]$discXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Ketteh" Width="460" Height="300"
        WindowStartupLocation="CenterScreen" WindowStyle="None"
        AllowsTransparency="True" Background="Transparent" FontFamily="Segoe UI">
    <Border Background="#0F0F18" CornerRadius="12" BorderBrush="#252538" BorderThickness="1" Padding="26">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="*"/>
                <RowDefinition Height="50"/>
            </Grid.RowDefinitions>
            <StackPanel>
                <TextBlock Text="Ketteh" FontSize="20" FontWeight="Bold" Foreground="#FF3CAC" Margin="0,0,0,12"/>
                <TextBlock TextWrapping="Wrap" Foreground="#F0F0F8" FontSize="13" Margin="0,0,0,8"
                           Text="Tools are downloaded from official sources and stored locally."/>
                <TextBlock TextWrapping="Wrap" Foreground="#F0F0F8" FontSize="13" Margin="0,0,0,8"
                           Text="Each tool is maintained by its own author. Use at your own risk."/>
                <TextBlock TextWrapping="Wrap" Foreground="#6B6B85" FontSize="12" Text="Click Accept to continue."/>
            </StackPanel>
            <Grid Grid.Row="1">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="10"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>
                <Button x:Name="CancelBtn" Grid.Column="0" Content="Cancel" Height="38"
                        Background="Transparent" Foreground="#F0F0F8" BorderBrush="#252538" BorderThickness="1" Cursor="Hand"/>
                <Button x:Name="AcceptBtn" Grid.Column="2" Content="Accept" Height="38"
                        Background="#161622" Foreground="#FF3CAC" BorderBrush="#FF3CAC" BorderThickness="1" Cursor="Hand" FontWeight="SemiBold"/>
            </Grid>
        </Grid>
    </Border>
</Window>
"@

$discReader = New-Object System.Xml.XmlNodeReader $discXaml
$discWin = [Windows.Markup.XamlReader]::Load($discReader)
$discWin.Add_MouseLeftButtonDown({ try { $discWin.DragMove() } catch {} })
$script:accepted = $false
$discWin.FindName("AcceptBtn").Add_Click({ $script:accepted = $true; $discWin.Close() })
$discWin.FindName("CancelBtn").Add_Click({ $script:accepted = $false; $discWin.Close() })
$discWin.ShowDialog() | Out-Null
if (-not $script:accepted) { exit }

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
    param([string]$title, [string]$sub, [string]$badge = "BUSY")
    $window.Dispatcher.Invoke([Action]{
        $StatusTitle.Text = $title
        $StatusSub.Text   = $sub
        $StatusBadge.Text = $badge
    })
}

# =============================================================================
# MOD ANALYZER
# =============================================================================
function Start-KettehModAnalyzer {
    $code = @'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Clear-Host
Write-Host ""
Write-Host "  KETTEH MOD ANALYZER" -ForegroundColor Magenta
Write-Host "  ===================" -ForegroundColor DarkMagenta
Write-Host ""
Write-Host "  Enter path to mods folder (press Enter for default):" -ForegroundColor White
Write-Host "  > " -ForegroundColor Cyan -NoNewline
$path = Read-Host
if ([string]::IsNullOrWhiteSpace($path)) {
    $path = Join-Path $env:APPDATA ".minecraft\mods"
    Write-Host "  Using: $path" -ForegroundColor Yellow
}
if (-not (Test-Path $path -PathType Container)) {
    Write-Host "  Invalid path." -ForegroundColor Red
    Write-Host "  Press any key to exit..."
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
                    if ($p -match "wurst|meteor|impact|sigma|vengeance|dqrkis|grim|prestige|exhibition|rusherhack|novoline") {
                        $isClient = $true
                    }
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
    return @{ Hits = $hits; IsClient = $isClient; Count = $hits.Count }
}

$jars = Get-ChildItem -Path $path -Filter *.jar -File -ErrorAction SilentlyContinue
Write-Host ""
Write-Host "  Found $($jars.Count) JAR files" -ForegroundColor Green
Write-Host ""

$verified = @(); $unknown = @(); $cheats = @(); $suspicious = @()
$i = 0
foreach ($jar in $jars) {
    $i++
    Write-Host "`r  Scanning $i/$($jars.Count) - $($jar.Name)          " -NoNewline -ForegroundColor Cyan

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

Write-Host "`r" + (" " * 70) + "`r"
Write-Host ""
Write-Host "  RESULTS" -ForegroundColor Cyan
Write-Host "  -------"
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
    Start-Process -FilePath "powershell.exe" -ArgumentList "-NoExit","-NoProfile","-ExecutionPolicy","Bypass","-File","`"$tmp`""
    Write-Log "Launched Ketteh Mod Analyzer"
    Set-Status "Ready" "Mod Analyzer launched" "IDLE"
}

# =============================================================================
# CARD + PILL LOGIC (clean)
# =============================================================================
$script:ActiveCategory = "All"
$Categories = @("All","Ketteh","Orbdiff","Spokwn","Tonynoh","Praiselily","RedLotus","Zimmerman","NirSoft","Others","Dependencies")

function New-CategoryPill {
    param([string]$Text, [bool]$IsActive)

    $btn = New-Object System.Windows.Controls.Button
    $btn.Content = $Text
    $btn.Height = 28
    $btn.Margin = "0,0,6,0"
    $btn.Padding = "12,0"
    $btn.FontSize = 12
    $btn.Cursor = "Hand"
    $btn.BorderThickness = 0
    $btn.Tag = $Text

    if ($IsActive) {
        $btn.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#FF3CAC")
        $btn.Foreground = [System.Windows.Media.Brushes]::White
    } else {
        $btn.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#161622")
        $btn.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#6B6B85")
    }

    $btn.Template = [Windows.Markup.XamlReader]::Parse(@"
<ControlTemplate xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" TargetType="Button">
    <Border Background="{TemplateBinding Background}" CornerRadius="14" Padding="{TemplateBinding Padding}">
        <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
    </Border>
</ControlTemplate>
"@)

    $btn.Add_Click({
        $script:ActiveCategory = $this.Tag
        Build-Pills
        Build-Cards
    })

    return $btn
}

function Build-Pills {
    $CatPills.Children.Clear()
    foreach ($cat in $Categories) {
        $pill = New-CategoryPill -Text $cat -IsActive ($cat -eq $script:ActiveCategory)
        [void]$CatPills.Children.Add($pill)
    }
}

function Build-Cards {
    $CardPanel.Children.Clear()

    $list = if ($script:ActiveCategory -eq "All") {
        $ToolData
    } else {
        $ToolData | Where-Object { $_.Category -eq $script:ActiveCategory }
    }

    foreach ($tool in $list) {
        $card = New-Object System.Windows.Controls.Border
        $card.Width = 220
        $card.Height = 100
        $card.Margin = "6"
        $card.CornerRadius = 10
        $card.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#161622")
        $card.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#252538")
        $card.BorderThickness = 1
        $card.Cursor = "Hand"
        $card.Padding = "14,12"
        $card.Tag = $tool

        $stack = New-Object System.Windows.Controls.StackPanel

        $nameBlock = New-Object System.Windows.Controls.TextBlock
        $nameBlock.Text = $tool.Name
        $nameBlock.FontSize = 13
        $nameBlock.FontWeight = "SemiBold"
        $nameBlock.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#F0F0F8")
        $nameBlock.TextWrapping = "Wrap"

        $descBlock = New-Object System.Windows.Controls.TextBlock
        $descBlock.Text = $tool.Desc
        $descBlock.FontSize = 11
        $descBlock.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#6B6B85")
        $descBlock.TextWrapping = "Wrap"
        $descBlock.Margin = "0,5,0,0"

        [void]$stack.Children.Add($nameBlock)
        [void]$stack.Children.Add($descBlock)
        $card.Child = $stack

        $card.Add_MouseEnter({
            $this.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#1E1E2E")
            $this.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#FF3CAC")
        })
        $card.Add_MouseLeave({
            $this.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#161622")
            $this.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#252538")
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
                    Set-Status "Ready" "Opened in browser" "IDLE"
                    Write-Log "Opened $($td.Name)"
                }
                "Cmd" {
                    Set-Status "Running" $td.Name "BUSY"
                    Write-Log "Launching $($td.Name)"
                    Start-Process powershell.exe -ArgumentList "-NoExit","-NoProfile","-ExecutionPolicy","Bypass","-Command",$td.Command
                    Set-Status "Ready" "Launched" "IDLE"
                }
                default {
                    # GitHub / Web download
                    Set-Status "Downloading" $td.Name "BUSY"
                    Write-Log "Downloading $($td.Name)..."

                    $runspace = [runspacefactory]::CreateRunspace()
                    $runspace.Open()
                    $runspace.SessionStateProxy.SetVariable("tool", $td)
                    $runspace.SessionStateProxy.SetVariable("dir", $installDir)
                    $runspace.SessionStateProxy.SetVariable("ui", $window.Dispatcher)
                    $runspace.SessionStateProxy.SetVariable("titleCtrl", $StatusTitle)
                    $runspace.SessionStateProxy.SetVariable("subCtrl", $StatusSub)
                    $runspace.SessionStateProxy.SetVariable("badgeCtrl", $StatusBadge)
                    $runspace.SessionStateProxy.SetVariable("logCtrl", $LogBox)

                    $ps = [powershell]::Create()
                    $ps.Runspace = $runspace
                    [void]$ps.AddScript({
                        function Log($m) {
                            $ui.Invoke([Action]{
                                $logCtrl.AppendText("[$(Get-Date -Format 'HH:mm:ss')] $m`r`n")
                                $logCtrl.ScrollToEnd()
                            })
                        }
                        function Status($t, $s, $b) {
                            $ui.Invoke([Action]{
                                $titleCtrl.Text = $t
                                $subCtrl.Text = $s
                                $badgeCtrl.Text = $b
                            })
                        }

                        try {
                            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                            $target = Join-Path $dir "$($tool.Category)\$($tool.Name)"
                            if (-not (Test-Path $target)) {
                                New-Item -ItemType Directory -Path $target -Force | Out-Null
                            }

                            if ($tool.Type -eq "GitHub") {
                                $parts = $tool.URL -replace "https://github.com/", "" -split "/"
                                $api = "https://api.github.com/repos/$($parts[0])/$($parts[1])/releases/latest"
                                $release = Invoke-RestMethod -Uri $api -Headers @{ "User-Agent" = "Ketteh" }
                                $asset = $release.assets | Where-Object { $_.name -match "\.(zip|exe)$" } | Select-Object -First 1
                                if (-not $asset) { throw "No downloadable asset found" }
                                $url = $asset.browser_download_url
                                $fileName = $asset.name
                            } else {
                                $url = $tool.URL
                                $fileName = ($url -split "/")[-1]
                            }

                            $outFile = Join-Path $target $fileName
                            if (-not (Test-Path $outFile)) {
                                Log "Downloading $fileName..."
                                $wc = New-Object System.Net.WebClient
                                $wc.DownloadFile($url, $outFile)
                                Log "Download complete"
                            } else {
                                Log "Using cached $fileName"
                            }

                            if ($fileName -match "\.zip$") {
                                Expand-Archive -Path $outFile -DestinationPath $target -Force
                                $exe = Get-ChildItem -Path $target -Filter "*.exe" -Recurse | Select-Object -First 1
                                if ($exe) {
                                    Start-Process $exe.FullName
                                    Log "Launched $($exe.Name)"
                                } else {
                                    Start-Process explorer.exe $target
                                    Log "Opened folder (no exe found)"
                                }
                            } else {
                                Start-Process $outFile
                                Log "Launched $fileName"
                            }

                            Status "Ready" "Done" "IDLE"
                        }
                        catch {
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

# Initial build
Build-Pills
Build-Cards

# =============================================================================
# WINDOW EVENTS
# =============================================================================
$window.Add_MouseLeftButtonDown({
    try { $window.DragMove() } catch {}
})

$CloseBtn.Add_Click({ $window.Close() })
$MinBtn.Add_Click({ $window.WindowState = "Minimized" })

$OpenFolderBtn.Add_Click({
    if (-not (Test-Path $installDir)) {
        New-Item -ItemType Directory -Path $installDir -Force | Out-Null
    }
    Start-Process explorer.exe $installDir
    Write-Log "Opened install folder"
})

$ClearCacheBtn.Add_Click({
    if (Test-Path $installDir) {
        $items = Get-ChildItem -Path $installDir -Force -ErrorAction SilentlyContinue
        $count = @($items).Count
        $items | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        Write-Log "Cleared $count item(s)"
        Set-Status "Ready" "Cache cleared" "IDLE"
    } else {
        Write-Log "Nothing to clear"
    }
})

$OpenPsBtn.Add_Click({
    Start-Process powershell.exe
    Write-Log "Opened PowerShell"
})

Write-Log "Ketteh ready"
Set-Status "Ready" "Select a tool" "IDLE"

$window.ShowDialog() | Out-Null
