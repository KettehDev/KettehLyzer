Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Xaml
Add-Type -AssemblyName System.Windows.Forms

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$installDir = "$env:USERPROFILE\Downloads\KettehSSTool"

# =============================================================================
# TOOL DATA
# =============================================================================
$ToolData = @(
    # Ketteh built-in
    @{ Name="Ketteh Mod Analyzer";   Desc="Full cheat + rat scanner for Minecraft mods"; Category="Ketteh"; Type="Builtin"; Command="ModAnalyzer" },

    # Orbdiff
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

    # Spokwn
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

    # Tonynoh
    @{ Name="MeowDoomsdayFucker";    Desc="Detects Doomsday cheat artefacts";             Category="Tonynoh";    Type="GitHub"; URL="https://github.com/MeowTonynoh/MeowDoomsdayFucker/releases/latest" },
    @{ Name="MeowModAnalyzer";       Desc="Analyzes mod files for suspicious content";    Category="Tonynoh";    Type="Cmd";    Command="Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/MeowTonynoh/MeowModAnalyzer/main/MeowModAnalyzer.ps1')" },
    @{ Name="MeowResolver";          Desc="Resolves obfuscated strings in binaries";      Category="Tonynoh";    Type="GitHub"; URL="https://github.com/MeowTonynoh/MeowResolver/releases/latest" },
    @{ Name="MeowNovowareFucker";    Desc="Detects Novoware cheat artefacts";             Category="Tonynoh";    Type="GitHub"; URL="https://github.com/MeowTonynoh/MeowNovowareFucker/releases/latest" },
    @{ Name="MeowImportsChecker";    Desc="Checks PE imports for suspicious DLLs";        Category="Tonynoh";    Type="GitHub"; URL="https://github.com/MeowTonynoh/MeowImportsChecker/releases/latest" },
    @{ Name="MeowClientsFucker";     Desc="Detects known cheat client artefacts";         Category="Tonynoh";    Type="GitHub"; URL="https://github.com/MeowTonynoh/MeowClientFucker/releases/latest" },

    # Praiselily
    @{ Name="PSHunter";              Desc="Hunts suspicious PowerShell activity";         Category="Praiselily"; Type="GitHub"; URL="https://github.com/praiselily/PSHunter/releases/latest" },
    @{ Name="AltDetector";           Desc="Detects alternate account artefacts";          Category="Praiselily"; Type="GitHub"; URL="https://github.com/praiselily/AltDetector/releases/latest" },
    @{ Name="WeHateFakers";          Desc="Checks hotspot / tethering logs";              Category="Praiselily"; Type="Cmd";    Command="iwr https://raw.githubusercontent.com/praiselily/WeHateFakers/refs/heads/main/HotspotLogs.ps1 | iex" },
    @{ Name="CommonDirectories";     Desc="Lists files in common suspicious dirs";        Category="Praiselily"; Type="Cmd";    Command="Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/praiselily/lilith-ps/refs/heads/main/CommonDirectories.ps1')" },
    @{ Name="HarddiskConverter";     Desc="Converts harddisk identifiers for review";     Category="Praiselily"; Type="Cmd";    Command="Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/praiselily/lilith-ps/refs/heads/main/HarddiskConverter.ps1')" },
    @{ Name="Services";              Desc="Lists and analyzes running services";          Category="Praiselily"; Type="Cmd";    Command="Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/praiselily/lilith-ps/refs/heads/main/Services.ps1')" },
    @{ Name="SignedScheduledTasks";  Desc="Finds unsigned / suspicious scheduled tasks"; Category="Praiselily"; Type="Cmd";    Command="Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/praiselily/lilith-ps/refs/heads/main/Signed-Scheduled-Tasks.ps1')" },

    # RedLotus
    @{ Name="RL ModAnalyzer";        Desc="Analyzes mod files for cheat indicators";     Category="RedLotus";   Type="GitHub"; URL="https://github.com/ItzIceHere/RedLotus-Mod-Analyzer/releases/latest" },
    @{ Name="RL TaskSentinel";       Desc="Monitors scheduled tasks for anomalies";      Category="RedLotus";   Type="GitHub"; URL="https://github.com/ItzIceHere/RedLotus-Task-Sentinel/releases/latest" },
    @{ Name="RL AltChecker";         Desc="Checks for alternate account indicators";     Category="RedLotus";   Type="GitHub"; URL="https://github.com/ItzIceHere/RedLotusAltChecker/releases/latest" },

    # Others
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

    # Zimmerman
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

    # NirSoft
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

    # Dependencies
    @{ Name="NET 9.0";               Desc="Microsoft .NET 9 SDK runtime";                Category="Dependencies"; Type="Web"; URL="https://download.visualstudio.microsoft.com/download/pr/92dba916-bc51-4e76-8b0e-d41d37ce5fa4/ab08f3e95bf7a3d3da336a7e8c8eca63/dotnet-sdk-9.0.203-win-x64.exe" },
    @{ Name="VSRedist";              Desc="Visual C++ redistributable (x64)";            Category="Dependencies"; Type="Web"; URL="https://aka.ms/vs/17/release/vc_redist.x64.exe" }
)

# =============================================================================
# UI (Ketteh theme - deep cyber purple + cyan)
# =============================================================================
[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="KettehSSTool"
    Width="1200" Height="760"
    MinWidth="1200" MinHeight="760"
    WindowStartupLocation="CenterScreen"
    ResizeMode="NoResize"
    WindowStyle="None"
    AllowsTransparency="True"
    Background="Transparent"
    FontFamily="Segoe UI">

    <Window.Resources>
        <SolidColorBrush x:Key="MainBg"     Color="#0A0A12"/>
        <SolidColorBrush x:Key="SidebarBg"  Color="#12121C"/>
        <SolidColorBrush x:Key="CardBg"     Color="#1A1A28"/>
        <SolidColorBrush x:Key="Accent"     Color="#5CE1FF"/>
        <SolidColorBrush x:Key="AccentDim"  Color="#2A8A9E"/>
        <SolidColorBrush x:Key="TextMain"   Color="#E8F4FF"/>
        <SolidColorBrush x:Key="TextMuted"  Color="#6A7A9A"/>
        <SolidColorBrush x:Key="ConsoleBg"  Color="#06060C"/>

        <Style x:Key="SideBtn" TargetType="Button">
            <Setter Property="Background" Value="Transparent"/>
            <Setter Property="Foreground" Value="{StaticResource TextMain}"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="Height" Value="38"/>
            <Setter Property="Margin" Value="0,0,0,4"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" CornerRadius="6">
                            <ContentPresenter HorizontalAlignment="Left" VerticalAlignment="Center" Margin="14,0"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter Property="Background" Value="#1E2A40"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style x:Key="TitleBtn" TargetType="Button">
            <Setter Property="Background" Value="Transparent"/>
            <Setter Property="Foreground" Value="{StaticResource TextMuted}"/>
            <Setter Property="Width" Value="40"/>
            <Setter Property="Height" Value="36"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter Property="Background" Value="#335CE1FF"/>
                                <Setter Property="Foreground" Value="#5CE1FF"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>

    <Border Background="{StaticResource MainBg}" BorderBrush="#2A3A5A" BorderThickness="1" CornerRadius="10">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="42"/>
                <RowDefinition Height="*"/>
            </Grid.RowDefinitions>

            <!-- Title Bar -->
            <Border Grid.Row="0" Background="{StaticResource SidebarBg}" CornerRadius="10,10,0,0">
                <Grid Margin="16,0">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="Auto"/>
                    </Grid.ColumnDefinitions>
                    <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
                        <TextBlock Text="Ketteh" FontSize="14" FontWeight="Bold" Foreground="{StaticResource Accent}"/>
                        <TextBlock Text="  SS Tool" FontSize="14" FontWeight="SemiBold" Foreground="{StaticResource TextMain}"/>
                    </StackPanel>
                    <StackPanel Grid.Column="1" Orientation="Horizontal">
                        <Button x:Name="MinBtn"   Style="{StaticResource TitleBtn}" Content="_"/>
                        <Button x:Name="CloseBtn" Style="{StaticResource TitleBtn}" Content="X"/>
                    </StackPanel>
                </Grid>
            </Border>

            <!-- Body -->
            <Grid Grid.Row="1">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="210"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>

                <!-- Sidebar -->
                <Border Grid.Column="0" Background="{StaticResource SidebarBg}" BorderBrush="#2A3A5A" BorderThickness="0,0,1,0">
                    <StackPanel Margin="12,16,12,16">

                        <Border Background="#0E0E18" CornerRadius="8" Margin="0,0,0,16" Padding="0,14">
                            <TextBlock Text="Ketteh" FontSize="22" FontWeight="Bold"
                                       Foreground="{StaticResource Accent}"
                                       HorizontalAlignment="Center"/>
                        </Border>

                        <TextBlock Text="ACTIONS" FontSize="9" FontWeight="Bold" Foreground="{StaticResource TextMuted}" Margin="4,0,0,8"/>
                        <Button x:Name="OpenFolderBtn" Content="  Open Install Folder"      Style="{StaticResource SideBtn}"/>
                        <Button x:Name="ClearCacheBtn" Content="  Clear Downloaded Files"   Style="{StaticResource SideBtn}"/>
                        <Button x:Name="OpenCmdBtn"    Content="  Open PowerShell"          Style="{StaticResource SideBtn}"/>

                        <Separator Background="#2A3A5A" Margin="0,14,0,14"/>

                        <TextBlock x:Name="InstPathBlock" Text="" FontSize="9" Foreground="#4A5A7A" TextWrapping="Wrap" Margin="4,0"/>
                    </StackPanel>
                </Border>

                <!-- Main Panel -->
                <Grid Grid.Column="1" Margin="16,14,16,14">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="10"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="10"/>
                        <RowDefinition Height="150"/>
                    </Grid.RowDefinitions>

                    <!-- Status card -->
                    <Border Grid.Row="0" Background="{StaticResource CardBg}" CornerRadius="8" Padding="18,12">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="Auto"/>
                            </Grid.ColumnDefinitions>
                            <StackPanel>
                                <TextBlock x:Name="StatusTitle" Text="Ready" FontSize="20" FontWeight="SemiBold" Foreground="{StaticResource TextMain}"/>
                                <TextBlock x:Name="StatusSub"   Text="Select a tool to launch or download it." FontSize="12" Foreground="{StaticResource TextMuted}"/>
                            </StackPanel>
                            <Border Grid.Column="1" Background="#0A2A2A" CornerRadius="6" Padding="12,5" VerticalAlignment="Center">
                                <TextBlock x:Name="StatusBadge" Text="IDLE" FontSize="12" FontWeight="Bold" Foreground="{StaticResource Accent}"/>
                            </Border>
                        </Grid>
                    </Border>

                    <!-- Tab control -->
                    <Border Grid.Row="2" Background="{StaticResource CardBg}" CornerRadius="8">
                        <TabControl x:Name="ToolsTab" Background="Transparent" BorderThickness="0" Padding="0">
                            <TabControl.Resources>
                                <Style TargetType="TabItem">
                                    <Setter Property="Foreground" Value="{StaticResource TextMuted}"/>
                                    <Setter Property="FontSize" Value="11"/>
                                    <Setter Property="Padding" Value="12,6"/>
                                    <Setter Property="Cursor" Value="Hand"/>
                                    <Setter Property="Template">
                                        <Setter.Value>
                                            <ControlTemplate TargetType="TabItem">
                                                <Border x:Name="TabBorder" Background="Transparent" CornerRadius="6" Margin="3,4,3,0" Padding="12,5">
                                                    <ContentPresenter ContentSource="Header" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                                </Border>
                                                <ControlTemplate.Triggers>
                                                    <Trigger Property="IsSelected" Value="True">
                                                        <Setter TargetName="TabBorder" Property="Background" Value="{StaticResource Accent}"/>
                                                        <Setter Property="Foreground" Value="#0A0A12"/>
                                                    </Trigger>
                                                    <MultiTrigger>
                                                        <MultiTrigger.Conditions>
                                                            <Condition Property="IsMouseOver" Value="True"/>
                                                            <Condition Property="IsSelected" Value="False"/>
                                                        </MultiTrigger.Conditions>
                                                        <Setter TargetName="TabBorder" Property="Background" Value="#1E2A40"/>
                                                        <Setter Property="Foreground" Value="{StaticResource TextMain}"/>
                                                    </MultiTrigger>
                                                </ControlTemplate.Triggers>
                                            </ControlTemplate>
                                        </Setter.Value>
                                    </Setter>
                                </Style>
                            </TabControl.Resources>
                        </TabControl>
                    </Border>

                    <!-- Console -->
                    <Border Grid.Row="4" Background="{StaticResource ConsoleBg}" CornerRadius="8" Padding="14,10">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <TextBlock Text="ACTIVITY" FontSize="9" FontWeight="Bold" Foreground="#4A5A7A" FontFamily="Consolas" Margin="0,0,0,6"/>
                            <TextBox x:Name="LogBox"
                                Grid.Row="1"
                                Background="Transparent"
                                Foreground="{StaticResource Accent}"
                                BorderThickness="0"
                                FontFamily="Consolas"
                                FontSize="11"
                                IsReadOnly="True"
                                VerticalScrollBarVisibility="Auto"
                                TextWrapping="Wrap"/>
                        </Grid>
                    </Border>
                </Grid>
            </Grid>
        </Grid>
    </Border>
</Window>
"@

# =============================================================================
# DISCLAIMER
# =============================================================================
[xml]$disclaimerXaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="KettehSSTool"
    Width="540" Height="420"
    WindowStartupLocation="CenterScreen"
    ResizeMode="NoResize"
    WindowStyle="None"
    AllowsTransparency="True"
    Background="Transparent"
    FontFamily="Segoe UI">
    <Border Background="#0A0A12" BorderBrush="#2A3A5A" BorderThickness="1" CornerRadius="10" Padding="28">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="*"/>
                <RowDefinition Height="56"/>
            </Grid.RowDefinitions>
            <StackPanel Grid.Row="0">
                <TextBlock Text="KettehSSTool" FontSize="22" FontWeight="Bold" Foreground="#5CE1FF" Margin="0,0,0,16"/>
                <TextBlock TextWrapping="Wrap" Foreground="#E8F4FF" FontSize="13" Margin="0,0,0,12"
                           Text="Tools are downloaded from their official sources and stored locally. Nothing is collected or modified on your system beyond what the individual tools themselves do."/>
                <TextBlock TextWrapping="Wrap" Foreground="#E8F4FF" FontSize="13" Margin="0,0,0,16"
                           Text="Each tool is maintained by its own author. Use at your own risk."/>
                <TextBlock TextWrapping="Wrap" Foreground="#E8F4FF" FontSize="13" FontWeight="SemiBold"
                           Text="Click Accept to continue."/>
            </StackPanel>
            <Grid Grid.Row="1" VerticalAlignment="Bottom">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="12"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>
                <Button x:Name="CancelBtn" Grid.Column="0" Content="Cancel" Height="40"
                        Background="Transparent" Foreground="#E8F4FF" BorderBrush="#2A3A5A" BorderThickness="1"
                        Cursor="Hand" FontSize="13"/>
                <Button x:Name="AcceptBtn" Grid.Column="2" Content="Accept &amp; Continue" Height="40"
                        Background="#1A1A28" Foreground="#5CE1FF" BorderBrush="#5CE1FF" BorderThickness="1"
                        Cursor="Hand" FontSize="13" FontWeight="SemiBold"/>
            </Grid>
        </Grid>
    </Border>
</Window>
"@

$disclaimerReader = New-Object System.Xml.XmlNodeReader $disclaimerXaml
$disclaimerWindow = [Windows.Markup.XamlReader]::Load($disclaimerReader)
$disclaimerWindow.Add_MouseLeftButtonDown({ try { $disclaimerWindow.DragMove() } catch {} })

$CancelBtn = $disclaimerWindow.FindName("CancelBtn")
$AcceptBtn = $disclaimerWindow.FindName("AcceptBtn")
$script:disclaimerAccepted = $false

$AcceptBtn.Add_Click({ $script:disclaimerAccepted = $true; $disclaimerWindow.Close() })
$CancelBtn.Add_Click({ $script:disclaimerAccepted = $false; $disclaimerWindow.Close() })

$disclaimerWindow.ShowDialog() | Out-Null
if (-not $script:disclaimerAccepted) { exit }

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
$ToolsTab      = $window.FindName("ToolsTab")
$OpenFolderBtn = $window.FindName("OpenFolderBtn")
$ClearCacheBtn = $window.FindName("ClearCacheBtn")
$OpenCmdBtn    = $window.FindName("OpenCmdBtn")
$InstPathBlock = $window.FindName("InstPathBlock")

$InstPathBlock.Text = "Install path:`n$installDir"

# =============================================================================
# HELPERS
# =============================================================================
function Write-Log {
    param([string]$msg)
    $time = Get-Date -Format "HH:mm:ss"
    $LogBox.Dispatcher.Invoke([Action]{
        $LogBox.AppendText("[$time] $msg`r`n")
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

function Start-AppOrScript {
    param([string]$Path, [string]$WorkingDirectory)
    if (-not $WorkingDirectory) { $WorkingDirectory = Split-Path -Parent $Path }
    $extension = [System.IO.Path]::GetExtension($Path).ToLowerInvariant()
    $quotedPath = '"' + $Path + '"'
    switch ($extension) {
        ".cmd" { Start-Process -FilePath "cmd.exe" -ArgumentList "/k", $quotedPath -WorkingDirectory $WorkingDirectory }
        ".bat" { Start-Process -FilePath "cmd.exe" -ArgumentList "/k", $quotedPath -WorkingDirectory $WorkingDirectory }
        default { Start-Process -FilePath $Path -WorkingDirectory $WorkingDirectory }
    }
}

function Start-DownloadedTool {
    param([string]$Directory, [string]$PreferredFile)
    if ($PreferredFile -and (Test-Path -LiteralPath $PreferredFile) -and ($PreferredFile -notmatch "\.zip$")) {
        Write-Log "Launching $(Split-Path -Leaf $PreferredFile)"
        Start-AppOrScript -Path $PreferredFile -WorkingDirectory (Split-Path -Parent $PreferredFile)
        return $true
    }
    $launchable = Get-ChildItem -Path $Directory -Recurse -File -ErrorAction SilentlyContinue |
        Where-Object { $_.Extension -match "^\.(exe|cmd|bat)$" } |
        Sort-Object @{ Expression = { if ($_.Extension -eq ".exe") { 0 } else { 1 } } }, FullName |
        Select-Object -First 1
    if ($launchable) {
        Write-Log "Launching $($launchable.Name)"
        Start-AppOrScript -Path $launchable.FullName -WorkingDirectory $launchable.DirectoryName
        return $true
    }
    Write-Log "No executable found - opening folder."
    Start-Process explorer.exe "`"$Directory`""
    return $false
}

function Save-UrlToFile {
    param([string]$Uri, [string]$OutFile)
    $tempFile = "$OutFile.download"
    if (Test-Path -LiteralPath $tempFile) { Remove-Item -LiteralPath $tempFile -Force -ErrorAction SilentlyContinue }
    $client = New-Object System.Net.WebClient
    $client.Headers.Add("User-Agent", "KettehSSTool")
    try {
        $client.DownloadFile($Uri, $tempFile)
        if (Test-Path -LiteralPath $OutFile) { Remove-Item -LiteralPath $OutFile -Force -ErrorAction Stop }
        Move-Item -LiteralPath $tempFile -Destination $OutFile -Force
    } finally {
        $client.Dispose()
        if (Test-Path -LiteralPath $tempFile) { Remove-Item -LiteralPath $tempFile -Force -ErrorAction SilentlyContinue }
    }
}

# =============================================================================
# BUILTIN: Ketteh Mod Analyzer (your full scanner)
# =============================================================================
function Start-KettehModAnalyzer {
    $analyzerScript = @'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 | Out-Null
Clear-Host

Write-Host @"
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   ██╗  ██╗███████╗████████╗████████╗███████╗██╗  ██╗                     ║
║   ██║ ██╔╝██╔════╝╚══██╔══╝╚══██╔══╝██╔════╝██║  ██║                     ║
║   █████╔╝ █████╗     ██║      ██║   █████╗  ███████║                     ║
║   ██╔═██╗ ██╔══╝     ██║      ██║   ██╔══╝  ██╔══██║                     ║
║   ██║  ██╗███████╗   ██║      ██║   ███████╗██║  ██║                     ║
║   ╚═╝  ╚═╝╚══════╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝                     ║
║                                                                           ║
║              M O D   A N A L Y Z E R                                      ║
╚═══════════════════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

Write-Host ""
Write-Host "  Enter path to the mods folder (press Enter for default):" -ForegroundColor White
Write-Host "  ────▶ " -ForegroundColor Cyan -NoNewline
$modsPath = Read-Host

if ([string]::IsNullOrWhiteSpace($modsPath)) {
    $modsPath = "$env:APPDATA\.minecraft\mods"
    Write-Host "  Using default: $modsPath" -ForegroundColor Yellow
}

if (-not (Test-Path $modsPath -PathType Container)) {
    Write-Host "  Invalid path!" -ForegroundColor Red
    Write-Host "  Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

Add-Type -AssemblyName System.IO.Compression.FileSystem

$cheatPatterns = @(
    "wurst","meteor","impact","liquidbounce","aristois","future","sigma","vape",
    "dqrkis","grim","prestige","asteria","catlean","vengeance","exhibition",
    "rusherhack","novoline","ghostclient","kamiblue","salhack","clickcrystals",
    "baritone","doomsday","kuro","rise","flux","zero","astolfo","xenon",
    "autocrystal","crystalaura","anchoraura","bedaura","autocrystalaura",
    "autodoublehand","autohitcrystal","crystaloptimizer","anchoroptimizer",
    "killaura","aimassist","reach","hitbox","triggerbot","bowaimbot",
    "antiknockback","velocity","criticals","autoclicker",
    "nofall","bhop","flight","phase","blink","freecam","scaffold",
    "elytrafly","speedmine","jumpreset","longjump",
    "xray","esp","nametags","chams","tracers","radar",
    "cheststealer","nuker","autoarmor","autopot","autototem",
    "inventorytotem","pingspoof","selfdestruct","fastplace","fastbreak",
    "meteordevelopment","cc/novoline","com/alan/clients","club/maxstats",
    "wtf/moonlight","me/zeroeightsix/kami","net/ccbluex",
    "xyz/greaj","com/cheatbreaker","com/moonsworth","phantom-refmap.json",
    "sessionstealer","tokenlogger","tokengrabber","discordtoken",
    "remoteaccess","reverseshell","c2server","backdoor"
)

function Get-FileSHA1 { param([string]$Path) (Get-FileHash -Path $Path -Algorithm SHA1).Hash }

function Query-Modrinth {
    param([string]$Hash)
    try {
        $ver = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/version_file/$Hash" -Method Get -UseBasicParsing -ErrorAction Stop
        if ($ver.project_id) {
            $proj = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/project/$($ver.project_id)" -Method Get -UseBasicParsing -ErrorAction Stop
            return @{ Name = $proj.title; Slug = $proj.slug }
        }
    } catch {}
    return @{ Name = ""; Spug = ""; Slug = "" }
}

function Invoke-ScanJar {
    param([string]$FilePath)
    $found = [System.Collections.Generic.HashSet[string]]::new()
    $isCheatClient = $false
    try {
        $archive = [System.IO.Compression.ZipFile]::OpenRead($FilePath)
        foreach ($entry in $archive.Entries) {
            $name = $entry.FullName.ToLower()
            foreach ($cheat in $cheatPatterns) {
                if ($name -match [regex]::Escape($cheat)) {
                    $found.Add($cheat) | Out-Null
                    if ($cheat -match "wurst|meteor|impact|sigma|vengeance|dqrkis|grim|prestige|exhibition|rusherhack|novoline") {
                        $isCheatClient = $true
                    }
                }
            }
            if ($name -match '\.class$') {
                try {
                    $st = $entry.Open(); $ms = New-Object System.IO.MemoryStream
                    $st.CopyTo($ms); $st.Close()
                    $bytes = $ms.ToArray(); $ms.Dispose()
                    $text = [System.Text.Encoding]::ASCII.GetString($bytes).ToLower()
                    foreach ($cheat in $cheatPatterns) {
                        if ($cheat.Length -gt 4 -and $text -match [regex]::Escape($cheat)) {
                            $found.Add($cheat) | Out-Null
                            if ($cheat -match "wurst|meteor|impact|sigma|vengeance|dqrkis|grim|prestige|exhibition|rusherhack|novoline") {
                                $isCheatClient = $true
                            }
                        }
                    }
                } catch {}
            }
        }
        $archive.Dispose()
    } catch {}
    return @{ Hits = $found; IsCheatClient = $isCheatClient; HitCount = $found.Count }
}

function Invoke-DeepScan {
    param([string]$FilePath)
    $flags = [System.Collections.Generic.List[string]]::new()
    try {
        $zip = [System.IO.Compression.ZipFile]::OpenRead($FilePath)
        $hasRuntimeExec = $false; $hasHttpDownload = $false; $hasHttpExfil = $false; $hasObfuscation = $false
        foreach ($entry in $zip.Entries) {
            if ($entry.FullName -match '\.class$') {
                try {
                    $st = $entry.Open(); $ms = New-Object System.IO.MemoryStream
                    $st.CopyTo($ms); $st.Close()
                    $bytes = $ms.ToArray(); $ms.Dispose()
                    $text = [System.Text.Encoding]::ASCII.GetString($bytes)
                    if ($text -match "java/lang/Runtime" -and $text -match "exec") { $hasRuntimeExec = $true }
                    if ($text -match "HttpURLConnection" -and $text -match "FileOutputStream") { $hasHttpDownload = $true }
                    if ($text -match "setDoOutput" -and $text -match "getOutputStream") { $hasHttpExfil = $true }
                    if ($text -match "ProGuard|Allatori|ZKM|Stringer|Radon|Paramorphism") { $hasObfuscation = $true }
                } catch {}
            }
        }
        $zip.Dispose()
        if ($hasRuntimeExec)  { $flags.Add("RUNTIME.EXEC — Can execute OS commands") }
        if ($hasHttpDownload) { $flags.Add("HTTP DOWNLOAD — Fetches files from remote") }
        if ($hasHttpExfil)    { $flags.Add("DATA EXFIL — Sends data to external server") }
        if ($hasObfuscation)  { $flags.Add("OBFUSCATION — Uses known obfuscators") }
    } catch {}
    return $flags
}

$jarFiles = Get-ChildItem -Path $modsPath -Filter *.jar -File -ErrorAction SilentlyContinue
$total = $jarFiles.Count
Write-Host ""
Write-Host "  Found $total JAR files" -ForegroundColor Green
Write-Host ""

$verifiedMods = @(); $unknownMods = @(); $cheatMods = @(); $suspiciousMods = @(); $dangerousMods = @()
$idx = 0

foreach ($jar in $jarFiles) {
    $idx++
    Write-Host "`r  Scanning $idx/$total — $($jar.Name)" -ForegroundColor Cyan -NoNewline

    $hash = Get-FileSHA1 -Path $jar.FullName
    $modrinthData = Query-Modrinth -Hash $hash
    if ($modrinthData.Slug) {
        $verifiedMods += [PSCustomObject]@{ FileName = $jar.Name; ModName = $modrinthData.Name }
        continue
    }

    $scanResult = Invoke-ScanJar -FilePath $jar.FullName
    if ($scanResult.IsCheatClient) {
        $cheatMods += [PSCustomObject]@{ FileName = $jar.Name; Hits = $scanResult.Hits; HitCount = $scanResult.HitCount }
        $flags = Invoke-DeepScan -FilePath $jar.FullName
        if ($flags.Count -gt 0) {
            $dangerousMods += [PSCustomObject]@{ FileName = $jar.Name; Flags = $flags }
        }
    } elseif ($scanResult.HitCount -gt 0) {
        $suspiciousMods += [PSCustomObject]@{ FileName = $jar.Name; Hits = $scanResult.Hits; HitCount = $scanResult.HitCount }
    } else {
        $unknownMods += [PSCustomObject]@{ FileName = $jar.Name }
    }
}

Write-Host "`r" + (" " * 80) + "`r" -NoNewline
Write-Host ""
Write-Host "  ══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  RESULTS" -ForegroundColor Cyan
Write-Host "  ══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Verified: $($verifiedMods.Count)   Unknown: $($unknownMods.Count)   Suspicious: $($suspiciousMods.Count)   Cheats: $($cheatMods.Count)   Dangerous: $($dangerousMods.Count)" -ForegroundColor White
Write-Host ""

if ($cheatMods.Count -gt 0) {
    Write-Host "  ── CHEATS DETECTED ──" -ForegroundColor Red
    foreach ($mod in $cheatMods) {
        Write-Host "  $($mod.FileName)" -ForegroundColor Red
        Write-Host "    Hits: $($mod.Hits -join ', ')" -ForegroundColor Yellow
    }
    Write-Host ""
}

if ($dangerousMods.Count -gt 0) {
    Write-Host "  ── DANGEROUS ──" -ForegroundColor DarkRed
    foreach ($mod in $dangerousMods) {
        Write-Host "  $($mod.FileName)" -ForegroundColor DarkRed
        foreach ($f in $mod.Flags) { Write-Host "    $f" -ForegroundColor Red }
    }
    Write-Host ""
}

if ($suspiciousMods.Count -gt 0) {
    Write-Host "  ── SUSPICIOUS ──" -ForegroundColor Yellow
    foreach ($mod in $suspiciousMods) {
        Write-Host "  $($mod.FileName)  →  $($mod.Hits -join ', ')" -ForegroundColor Yellow
    }
    Write-Host ""
}

Write-Host "  Press any key to exit..." -ForegroundColor DarkGray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
'@

    $tempFile = [System.IO.Path]::Combine($env:TEMP, "KettehModAnalyzer_$([guid]::NewGuid().ToString('N').Substring(0,8)).ps1")
    Set-Content -LiteralPath $tempFile -Value $analyzerScript -Encoding UTF8 -Force
    Start-Process powershell.exe -ArgumentList "-NoExit", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", "`"$tempFile`""
    Write-Log "Launched Ketteh Mod Analyzer"
    Set-Status "Ready" "Mod Analyzer launched in new window." "IDLE"
}

# =============================================================================
# BUILD TABS + CARDS
# =============================================================================
$Categories = @("Ketteh","Orbdiff","Spokwn","Tonynoh","Praiselily","RedLotus","Zimmerman","NirSoft","Dependencies","Others")

foreach ($cat in $Categories) {
    $tab = New-Object System.Windows.Controls.TabItem
    $tab.Header = $cat

    $scroll = New-Object System.Windows.Controls.ScrollViewer
    $scroll.VerticalScrollBarVisibility = "Auto"
    $scroll.HorizontalScrollBarVisibility = "Disabled"

    $wrap = New-Object System.Windows.Controls.WrapPanel
    $wrap.Margin = "10"

    $catTools = $ToolData | Where-Object { $_.Category -eq $cat }

    foreach ($tool in $catTools) {
        $t = $tool

        $btn = New-Object System.Windows.Controls.Button
        $btn.Width = 210
        $btn.Height = 82
        $btn.Margin = "6"
        $btn.Cursor = "Hand"
        $btn.Foreground = "#E8F4FF"

        $btnStack = New-Object System.Windows.Controls.StackPanel
        $btnStack.Margin = "12,10"
        $nameBlock = New-Object System.Windows.Controls.TextBlock
        $nameBlock.Text = $t.Name
        $nameBlock.FontSize = 12
        $nameBlock.FontWeight = "SemiBold"
        $nameBlock.TextWrapping = "Wrap"
        $descBlock = New-Object System.Windows.Controls.TextBlock
        $descBlock.Text = $t.Desc
        $descBlock.FontSize = 10
        $descBlock.Opacity = 0.55
        $descBlock.TextWrapping = "Wrap"
        $descBlock.Margin = "0,4,0,0"
        $btnStack.Children.Add($nameBlock) | Out-Null
        $btnStack.Children.Add($descBlock) | Out-Null
        $btn.Content = $btnStack

        $btnBg = [Windows.Media.SolidColorBrush]::new([Windows.Media.Color]::FromRgb(0x1A, 0x1A, 0x28))
        $btnScale = [Windows.Media.ScaleTransform]::new(1.0, 1.0)

        $btn.Template = [Windows.Markup.XamlReader]::Parse(
            "<ControlTemplate xmlns='http://schemas.microsoft.com/winfx/2006/xaml/presentation' TargetType='Button'>" +
            "  <Border CornerRadius='8' BorderThickness='1' RenderTransformOrigin='0.5,0.5'" +
            "          Background='{TemplateBinding Background}'" +
            "          RenderTransform='{TemplateBinding Tag}'" +
            "          BorderBrush='#335CE1FF'>" +
            "    <ContentPresenter HorizontalAlignment='Center' VerticalAlignment='Center'/>" +
            "  </Border>" +
            "</ControlTemplate>"
        )
        $btn.Background = $btnBg
        $btn.Tag = $btnScale

        $btn.Add_MouseEnter({
            $b = $_.Source
            $bg = $b.Background
            $sc = $b.Tag
            if (-not $bg -or -not $sc) { return }
            $d = [Windows.Duration]::new([TimeSpan]::FromMilliseconds(120))
            $a = [Windows.Media.Animation.ColorAnimation]::new([Windows.Media.Color]::FromRgb(0x5C,0xE1,0xFF), $d)
            $bg.BeginAnimation([Windows.Media.SolidColorBrush]::ColorProperty, $a)
            $ax = [Windows.Media.Animation.DoubleAnimation]::new(1.04, $d)
            $sc.BeginAnimation([Windows.Media.ScaleTransform]::ScaleXProperty, $ax)
            $ay = [Windows.Media.Animation.DoubleAnimation]::new(1.04, $d)
            $sc.BeginAnimation([Windows.Media.ScaleTransform]::ScaleYProperty, $ay)
            $b.Foreground = [Windows.Media.Brushes]::Black
        })

        $btn.Add_MouseLeave({
            $b = $_.Source
            $bg = $b.Background
            $sc = $b.Tag
            if (-not $bg -or -not $sc) { return }
            $d = [Windows.Duration]::new([TimeSpan]::FromMilliseconds(160))
            $a = [Windows.Media.Animation.ColorAnimation]::new([Windows.Media.Color]::FromRgb(0x1A,0x1A,0x28), $d)
            $bg.BeginAnimation([Windows.Media.SolidColorBrush]::ColorProperty, $a)
            $ax = [Windows.Media.Animation.DoubleAnimation]::new(1.0, $d)
            $sc.BeginAnimation([Windows.Media.ScaleTransform]::ScaleXProperty, $ax)
            $ay = [Windows.Media.Animation.DoubleAnimation]::new(1.0, $d)
            $sc.BeginAnimation([Windows.Media.ScaleTransform]::ScaleYProperty, $ay)
            $b.Foreground = [Windows.Media.BrushConverter]::new().ConvertFrom("#E8F4FF")
        })

        $btn.Add_Click({
            $clickedBtn = $_.Source
            $tName = ($clickedBtn.Content.Children[0]).Text
            $tData = $ToolData | Where-Object { $_.Name -eq $tName } | Select-Object -First 1
            $clickedBtn.IsEnabled = $false

            if ($tData.Type -eq "Builtin" -and $tData.Command -eq "ModAnalyzer") {
                Start-KettehModAnalyzer
                $clickedBtn.IsEnabled = $true
                return
            }

            if ($tData.Type -eq "Link") {
                Start-Process $tData.URL
                Set-Status "Ready" "Opened $tName in browser." "IDLE"
                $clickedBtn.IsEnabled = $true
                return
            }

            if ($tData.Type -eq "Cmd") {
                Set-Status "Running" "Launching $tName..." "BUSY"
                Write-Log "Starting: $tName"
                Start-Process powershell.exe -ArgumentList "-NoExit","-NoProfile","-ExecutionPolicy","Bypass","-Command",$tData.Command
                Set-Status "Ready" "$tName launched." "IDLE"
                $clickedBtn.IsEnabled = $true
                return
            }

            # Download tools (GitHub / Web)
            Set-Status "Downloading" "Fetching $tName..." "BUSY"
            Write-Log "Starting download: $tName"

            $rs = [runspacefactory]::CreateRunspace()
            $rs.ApartmentState = "STA"
            $rs.ThreadOptions = "ReuseThread"
            $rs.Open()

            $rs.SessionStateProxy.SetVariable("tData", $tData)
            $rs.SessionStateProxy.SetVariable("installDir", $installDir)
            $rs.SessionStateProxy.SetVariable("dispatcher", $clickedBtn.Dispatcher)
            $rs.SessionStateProxy.SetVariable("btn", $clickedBtn)
            $rs.SessionStateProxy.SetVariable("StatusTitle", $StatusTitle)
            $rs.SessionStateProxy.SetVariable("StatusSub", $StatusSub)
            $rs.SessionStateProxy.SetVariable("StatusBadge", $StatusBadge)
            $rs.SessionStateProxy.SetVariable("LogBox", $LogBox)

            $ps = [powershell]::Create()
            $ps.Runspace = $rs

            $null = $ps.AddScript({
                function Set-StatusBg { param($t,$s,$b)
                    $dispatcher.Invoke([Action]{ $StatusTitle.Text=$t; $StatusSub.Text=$s; $StatusBadge.Text=$b })
                }
                function Write-LogBg { param($m)
                    $dispatcher.Invoke([Action]{ $LogBox.AppendText("[$(Get-Date -f 'HH:mm:ss')] $m`n"); $LogBox.ScrollToEnd() })
                }

                $name = $tData.Name
                $url  = $tData.URL
                $cat  = $tData.Category
                $type = $tData.Type

                try {
                    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                    $destDir = "$installDir\$cat\$name"
                    if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }

                    if ($type -eq "GitHub") {
                        $urlParts = $url -replace "https://github.com/", "" -split "/"
                        $owner = $urlParts[0]; $repo = $urlParts[1]
                        $apiUrl = "https://api.github.com/repos/$owner/$repo/releases/latest"
                        $release = Invoke-RestMethod -Uri $apiUrl -Headers @{ "User-Agent" = "KettehSSTool" } -ErrorAction Stop
                        $asset = $release.assets | Where-Object { $_.name -match "\.(zip|exe)$" } | Select-Object -First 1
                        if (-not $asset) { throw "No downloadable asset found." }
                        $dlUrl = $asset.browser_download_url
                        $fileName = $asset.name
                        $destFile = "$destDir\$fileName"
                    } else {
                        $dlUrl = $url
                        $fileName = ($url -split "/")[-1]
                        $destFile = "$destDir\$fileName"
                    }

                    if (Test-Path $destFile) {
                        Write-LogBg "Cached: $fileName"
                    } else {
                        Write-LogBg "Downloading $fileName..."
                        $wc = New-Object System.Net.WebClient
                        $wc.DownloadFile($dlUrl, $destFile)
                        Write-LogBg "Download complete"
                    }

                    if ($fileName -match "\.zip$") {
                        Expand-Archive -Path $destFile -DestinationPath $destDir -Force -ErrorAction Stop
                        $exe = Get-ChildItem -Path $destDir -Filter "*.exe" -Recurse | Select-Object -First 1
                        if ($exe) {
                            Write-LogBg "Launching $($exe.Name)"
                            Start-Process $exe.FullName
                        } else {
                            $dispatcher.Invoke([Action]{ Start-Process explorer.exe "`"$destDir`"" })
                        }
                    } else {
                        Write-LogBg "Launching $fileName"
                        Start-Process $destFile
                    }

                    Set-StatusBg "Ready" "$name launched." "IDLE"
                } catch {
                    Write-LogBg "Error: $_"
                    Set-StatusBg "Error" "Failed: $name" "ERR"
                }

                $dispatcher.Invoke([Action]{ $btn.IsEnabled = $true })
            })

            $null = $ps.BeginInvoke()
        })

        $wrap.Children.Add($btn) | Out-Null
    }

    $scroll.Content = $wrap
    $tab.Content = $scroll
    $ToolsTab.Items.Add($tab) | Out-Null
}

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
        $items = Get-ChildItem -Path $installDir -Force -ErrorAction SilentlyContinue
        $count = @($items).Count
        $items | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        Write-Log "Cleared $count item(s)"
        Set-Status "Clean" "Removed downloaded files." "IDLE"
    } else {
        Write-Log "Nothing to clear"
    }
})

$OpenCmdBtn.Add_Click({
    Start-Process powershell.exe
    Write-Log "Opened PowerShell"
})

Write-Log "KettehSSTool ready"
Write-Log "Install path: $installDir"
Set-Status "Ready" "Select a tool to launch or download it." "IDLE"

$window.ShowDialog() | Out-Null
