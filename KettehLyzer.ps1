Add-Type -AssemblyName PresentationFramework,PresentationCore,WindowsBase,System.Xaml,System.IO.Compression.FileSystem,System.Windows.Forms
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$installDir = "$env:USERPROFILE\Downloads\KettehSSTool"

$ToolData = @(
    @{ Name="Ketteh Mod Analyzer"; Desc="Full cheat + rat scanner for Minecraft mods"; Category="Ketteh"; Type="Builtin" },
    @{ Name="PrefetchView"; Desc="Parses prefetch, extracts file info"; Category="Orbdiff"; Type="GitHub"; URL="https://github.com/Orbdiff/PrefetchView/releases/latest" },
    @{ Name="BAMReveal"; Desc="Parses BAM forensic artefact"; Category="Orbdiff"; Type="GitHub"; URL="https://github.com/Orbdiff/BAMReveal/releases/latest" },
    @{ Name="StringsParser"; Desc="Strings + YARA + signatures scanner"; Category="Orbdiff"; Type="GitHub"; URL="https://github.com/Orbdiff/StringsParser/releases/latest" },
    @{ Name="Fileless"; Desc="Detects fileless via eventlog + memdump"; Category="Orbdiff"; Type="GitHub"; URL="https://github.com/Orbdiff/Fileless/releases/latest" },
    @{ Name="DPS-Analyzer"; Desc="Analyzes DPS memory"; Category="Orbdiff"; Type="GitHub"; URL="https://github.com/Orbdiff/DPS-Analyzer/releases/latest" },
    @{ Name="UserAssistView"; Desc="Parses UserAssist registry artifact"; Category="Orbdiff"; Type="GitHub"; URL="https://github.com/Orbdiff/UserAssistView/releases/latest" },
    @{ Name="JournalParser"; Desc="Parses NTFS USNJournal entries"; Category="Orbdiff"; Type="GitHub"; URL="https://github.com/Orbdiff/JournalParser/releases/latest" },
    @{ Name="InjGen"; Desc="Detects JNI/JVMTI memory injections"; Category="Orbdiff"; Type="GitHub"; URL="https://github.com/Orbdiff/InjGen/releases/latest" },
    @{ Name="USBDetector"; Desc="Detects USB device history"; Category="Orbdiff"; Type="GitHub"; URL="https://github.com/Orbdiff/USBDetector/releases/latest" },
    @{ Name="PFTrace"; Desc="Rundll32/Regsvr32 prefetch analysis"; Category="Orbdiff"; Type="GitHub"; URL="https://github.com/Orbdiff/PFTrace/releases/latest" },
    @{ Name="CheckDeletedUSN"; Desc="Compares USN timestamp vs boot time"; Category="Orbdiff"; Type="GitHub"; URL="https://github.com/Orbdiff/CheckDeletedUSN/releases/latest" },
    @{ Name="JARParser"; Desc="Parses JAR prefetch, DcomLaunch strings"; Category="Orbdiff"; Type="GitHub"; URL="https://github.com/Orbdiff/JARParser/releases/latest" },
    @{ Name="BAM-parser"; Desc="Parses BAM entries for execution history"; Category="Spokwn"; Type="GitHub"; URL="https://github.com/spokwn/BAM-parser/releases/latest" },
    @{ Name="PathsParser"; Desc="Extracts and analyzes executable paths"; Category="Spokwn"; Type="GitHub"; URL="https://github.com/spokwn/PathsParser/releases/latest" },
    @{ Name="JournalTrace"; Desc="Traces file activity via USN journal"; Category="Spokwn"; Type="GitHub"; URL="https://github.com/spokwn/JournalTrace/releases/latest" },
    @{ Name="KernelLiveDumpTool"; Desc="Captures live kernel memory dump"; Category="Spokwn"; Type="GitHub"; URL="https://github.com/spokwn/KernelLiveDumpTool/releases/latest" },
    @{ Name="BamDeletedKeys"; Desc="Finds deleted BAM registry keys"; Category="Spokwn"; Type="GitHub"; URL="https://github.com/spokwn/BamDeletedKeys/releases/latest" },
    @{ Name="Espouken Tool"; Desc="All-in-one SS forensics toolkit"; Category="Spokwn"; Type="GitHub"; URL="https://github.com/spokwn/Tool/releases/latest" },
    @{ Name="pcasvc-executed"; Desc="Extracts PCA service execution records"; Category="Spokwn"; Type="GitHub"; URL="https://github.com/spokwn/pcasvc-executed/releases/latest" },
    @{ Name="process-parser"; Desc="Parses process execution artefacts"; Category="Spokwn"; Type="GitHub"; URL="https://github.com/spokwn/process-parser/releases/latest" },
    @{ Name="prefetch-parser"; Desc="Parses Windows prefetch files"; Category="Spokwn"; Type="GitHub"; URL="https://github.com/spokwn/prefetch-parser/releases/latest" },
    @{ Name="ActivitiesCache"; Desc="Parses ActivitiesCache execution history"; Category="Spokwn"; Type="GitHub"; URL="https://github.com/spokwn/ActivitiesCache-execution/releases/latest" },
    @{ Name="MeowDoomsdayFucker"; Desc="Detects Doomsday cheat artefacts"; Category="Tonynoh"; Type="GitHub"; URL="https://github.com/MeowTonynoh/MeowDoomsdayFucker/releases/latest" },
    @{ Name="MeowModAnalyzer"; Desc="Analyzes mod files for suspicious content"; Category="Tonynoh"; Type="Cmd"; Command="Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/MeowTonynoh/MeowModAnalyzer/main/MeowModAnalyzer.ps1')" },
    @{ Name="MeowResolver"; Desc="Resolves obfuscated strings in binaries"; Category="Tonynoh"; Type="GitHub"; URL="https://github.com/MeowTonynoh/MeowResolver/releases/latest" },
    @{ Name="MeowNovowareFucker"; Desc="Detects Novoware cheat artefacts"; Category="Tonynoh"; Type="GitHub"; URL="https://github.com/MeowTonynoh/MeowNovowareFucker/releases/latest" },
    @{ Name="MeowImportsChecker"; Desc="Checks PE imports for suspicious DLLs"; Category="Tonynoh"; Type="GitHub"; URL="https://github.com/MeowTonynoh/MeowImportsChecker/releases/latest" },
    @{ Name="MeowClientsFucker"; Desc="Detects known cheat client artefacts"; Category="Tonynoh"; Type="GitHub"; URL="https://github.com/MeowTonynoh/MeowClientFucker/releases/latest" },
    @{ Name="PSHunter"; Desc="Hunts suspicious PowerShell activity"; Category="Praiselily"; Type="GitHub"; URL="https://github.com/praiselily/PSHunter/releases/latest" },
    @{ Name="AltDetector"; Desc="Detects alternate account artefacts"; Category="Praiselily"; Type="GitHub"; URL="https://github.com/praiselily/AltDetector/releases/latest" },
    @{ Name="WeHateFakers"; Desc="Checks hotspot / tethering logs"; Category="Praiselily"; Type="Cmd"; Command="iwr https://raw.githubusercontent.com/praiselily/WeHateFakers/refs/heads/main/HotspotLogs.ps1 | iex" },
    @{ Name="CommonDirectories"; Desc="Lists files in common suspicious dirs"; Category="Praiselily"; Type="Cmd"; Command="Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/praiselily/lilith-ps/refs/heads/main/CommonDirectories.ps1')" },
    @{ Name="HarddiskConverter"; Desc="Converts harddisk identifiers for review"; Category="Praiselily"; Type="Cmd"; Command="Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/praiselily/lilith-ps/refs/heads/main/HarddiskConverter.ps1')" },
    @{ Name="Services"; Desc="Lists and analyzes running services"; Category="Praiselily"; Type="Cmd"; Command="Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/praiselily/lilith-ps/refs/heads/main/Services.ps1')" },
    @{ Name="SignedScheduledTasks"; Desc="Finds unsigned / suspicious scheduled tasks"; Category="Praiselily"; Type="Cmd"; Command="Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/praiselily/lilith-ps/refs/heads/main/Signed-Scheduled-Tasks.ps1')" },
    @{ Name="RL ModAnalyzer"; Desc="Analyzes mod files for cheat indicators"; Category="RedLotus"; Type="GitHub"; URL="https://github.com/ItzIceHere/RedLotus-Mod-Analyzer/releases/latest" },
    @{ Name="RL TaskSentinel"; Desc="Monitors scheduled tasks for anomalies"; Category="RedLotus"; Type="GitHub"; URL="https://github.com/ItzIceHere/RedLotus-Task-Sentinel/releases/latest" },
    @{ Name="RL AltChecker"; Desc="Checks for alternate account indicators"; Category="RedLotus"; Type="GitHub"; URL="https://github.com/ItzIceHere/RedLotusAltChecker/releases/latest" },
    @{ Name="ComputerActivityView"; Desc="Timeline of computer activity events"; Category="Others"; Type="Web"; URL="https://www.nirsoft.net/utils/computer_activity_view.html" },
    @{ Name="AmcacheParser"; Desc="Parses AMCache with YARA + signatures"; Category="Others"; Type="Web"; URL="https://download.ericzimmermanstools.com/net9/AmcacheParser.zip" },
    @{ Name="SystemInformer"; Desc="Advanced process and kernel inspector"; Category="Others"; Type="Link"; URL="https://www.systeminformer.com/canary" },
    @{ Name="DIE-engine"; Desc="Detects file type, packer, compiler"; Category="Others"; Type="Web"; URL="https://github.com/horsicq/DIE-engine/releases" },
    @{ Name="MacroDetector"; Desc="Detects macro / clicker software traces"; Category="Others"; Type="Cmd"; Command="Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/NiccBlahh/MacroDetector/refs/heads/main/MacroDetector.ps1')" },
    @{ Name="Jarabel"; Desc="Locates .jar files with detailed checks"; Category="Others"; Type="GitHub"; URL="https://github.com/nay-cat/Jarabel/releases/latest" },
    @{ Name="Luyten"; Desc="Open source Java decompiler GUI"; Category="Others"; Type="GitHub"; URL="https://github.com/deathmarine/Luyten/releases/latest" },
    @{ Name="VMAware"; Desc="Advanced VM detection library and tool"; Category="Others"; Type="GitHub"; URL="https://github.com/kernelwernel/VMAware/releases/latest" },
    @{ Name="Velociraptor"; Desc="Endpoint DFIR and threat hunting agent"; Category="Others"; Type="GitHub"; URL="https://github.com/Velocidex/velociraptor/releases/latest" },
    @{ Name="NTFS Parser"; Desc="NTFS forensics: MFT, Bitlocker, USN"; Category="Others"; Type="GitHub"; URL="https://github.com/thewhiteninja/ntfstool/releases/latest" },
    @{ Name="Hayabusa"; Desc="Fast forensics timeline generator"; Category="Others"; Type="GitHub"; URL="https://github.com/Yamato-Security/hayabusa/releases/latest" },
    @{ Name="Everything"; Desc="Instant filename search engine for Windows"; Category="Others"; Type="Link"; URL="https://www.voidtools.com/downloads/" },
    @{ Name="HxD"; Desc="Fast hex editor with disk and RAM editing"; Category="Others"; Type="Link"; URL="https://mh-nexus.de/en/hxd/" },
    @{ Name="bstrings"; Desc="Searches strings with regex + YARA"; Category="Zimmerman"; Type="Web"; URL="https://download.ericzimmermanstools.com/net9/bstrings.zip" },
    @{ Name="JLECmd"; Desc="Parses Jump List files (CLI)"; Category="Zimmerman"; Type="Web"; URL="https://download.ericzimmermanstools.com/net9/JLECmd.zip" },
    @{ Name="JumpListExplorer"; Desc="GUI explorer for Jump List artefacts"; Category="Zimmerman"; Type="Web"; URL="https://download.ericzimmermanstools.com/net9/JumpListExplorer.zip" },
    @{ Name="MFTECmd"; Desc="Parses MFT, UsnJrnl, LogFile, Boot"; Category="Zimmerman"; Type="Web"; URL="https://download.ericzimmermanstools.com/net9/MFTECmd.zip" },
    @{ Name="PECmd"; Desc="Parses Windows prefetch files (CLI)"; Category="Zimmerman"; Type="Web"; URL="https://download.ericzimmermanstools.com/net9/PECmd.zip" },
    @{ Name="RecentFileCacheParser"; Desc="Parses RecentFileCache.bcf artefact"; Category="Zimmerman"; Type="Web"; URL="https://download.ericzimmermanstools.com/net9/RecentFileCacheParser.zip" },
    @{ Name="RegistryExplorer"; Desc="GUI explorer for registry hives"; Category="Zimmerman"; Type="Web"; URL="https://download.ericzimmermanstools.com/net9/RegistryExplorer.zip" },
    @{ Name="ShellBagsExplorer"; Desc="GUI explorer for ShellBags artefacts"; Category="Zimmerman"; Type="Web"; URL="https://download.ericzimmermanstools.com/net9/ShellBagsExplorer.zip" },
    @{ Name="SrumECmd"; Desc="Parses SRUM database for usage data"; Category="Zimmerman"; Type="Web"; URL="https://download.ericzimmermanstools.com/net9/SrumECmd.zip" },
    @{ Name="TimelineExplorer"; Desc="GUI viewer for CSV timeline output"; Category="Zimmerman"; Type="Web"; URL="https://download.ericzimmermanstools.com/net9/TimelineExplorer.zip" },
    @{ Name="FullEventLogView"; Desc="Views all Windows event log entries"; Category="NirSoft"; Type="Web"; URL="https://www.nirsoft.net/utils/fulleventlogview.zip" },
    @{ Name="NetworkUsageView"; Desc="Shows network usage per process"; Category="NirSoft"; Type="Web"; URL="https://www.nirsoft.net/utils/networkusageview.zip" },
    @{ Name="BrowserDownloadsView"; Desc="Lists all browser download history"; Category="NirSoft"; Type="Web"; URL="https://www.nirsoft.net/utils/browserdownloadsview.zip" },
    @{ Name="AlternateStreamView"; Desc="Reveals hidden NTFS alternate streams"; Category="NirSoft"; Type="Web"; URL="https://www.nirsoft.net/utils/alternatestreamview.zip" },
    @{ Name="USBDeview"; Desc="Lists all USB devices ever connected"; Category="NirSoft"; Type="Web"; URL="https://www.nirsoft.net/utils/usbdeview.zip" },
    @{ Name="OpenSaveFilesView"; Desc="Shows files opened/saved via dialogs"; Category="NirSoft"; Type="Web"; URL="https://www.nirsoft.net/utils/opensavefilesview.zip" },
    @{ Name="ExecutedProgramsList"; Desc="Lists programs run from various sources"; Category="NirSoft"; Type="Web"; URL="https://www.nirsoft.net/utils/executedprogramslist.zip" },
    @{ Name="TaskSchedulerView"; Desc="Views all scheduled tasks and history"; Category="NirSoft"; Type="Web"; URL="https://www.nirsoft.net/utils/taskschedulerview.zip" },
    @{ Name="JumpListsView"; Desc="Views Jump List recent/frequent files"; Category="NirSoft"; Type="Web"; URL="https://www.nirsoft.net/utils/jumplistsview.zip" },
    @{ Name="WinPrefetchView"; Desc="Views Windows prefetch file details"; Category="NirSoft"; Type="Web"; URL="https://www.nirsoft.net/utils/winprefetchview.zip" },
    @{ Name="RegScanner"; Desc="Scans registry for values / patterns"; Category="NirSoft"; Type="Web"; URL="https://www.nirsoft.net/utils/regscanner.zip" },
    @{ Name="ShellBagsView"; Desc="Views ShellBags folder access history"; Category="NirSoft"; Type="Web"; URL="https://www.nirsoft.net/utils/shellbagsview.zip" },
    @{ Name="NET 9.0"; Desc="Microsoft .NET 9 SDK runtime"; Category="Dependencies"; Type="Web"; URL="https://download.visualstudio.microsoft.com/download/pr/92dba916-bc51-4e76-8b0e-d41d37ce5fa4/ab08f3e95bf7a3d3da336a7e8c8eca63/dotnet-sdk-9.0.203-win-x64.exe" },
    @{ Name="VSRedist"; Desc="Visual C++ redistributable (x64)"; Category="Dependencies"; Type="Web"; URL="https://aka.ms/vs/17/release/vc_redist.x64.exe" }
)

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Ketteh" Width="1340" Height="840"
        WindowStartupLocation="CenterScreen" WindowStyle="None"
        AllowsTransparency="True" Background="Transparent" FontFamily="Segoe UI">

  <Border Background="#05050A" CornerRadius="20" BorderBrush="#1A1A28" BorderThickness="1">
    <Grid>
      <!-- Strong ambient glows -->
      <Ellipse x:Name="Glow1" Width="560" Height="560" HorizontalAlignment="Left" VerticalAlignment="Top"
               Margin="-200,-180,0,0" Opacity="0.22" IsHitTestVisible="False">
        <Ellipse.Fill>
          <RadialGradientBrush>
            <GradientStop Color="#FF2A6A" Offset="0"/>
            <GradientStop Color="#00000000" Offset="1"/>
          </RadialGradientBrush>
        </Ellipse.Fill>
      </Ellipse>
      <Ellipse x:Name="Glow2" Width="480" Height="480" HorizontalAlignment="Right" VerticalAlignment="Bottom"
               Margin="0,0,-160,-120" Opacity="0.18" IsHitTestVisible="False">
        <Ellipse.Fill>
          <RadialGradientBrush>
            <GradientStop Color="#00D4FF" Offset="0"/>
            <GradientStop Color="#00000000" Offset="1"/>
          </RadialGradientBrush>
        </Ellipse.Fill>
      </Ellipse>
      <Ellipse x:Name="Glow3" Width="300" Height="300" HorizontalAlignment="Center" VerticalAlignment="Center"
               Opacity="0.08" IsHitTestVisible="False">
        <Ellipse.Fill>
          <RadialGradientBrush>
            <GradientStop Color="#A855F7" Offset="0"/>
            <GradientStop Color="#00000000" Offset="1"/>
          </RadialGradientBrush>
        </Ellipse.Fill>
      </Ellipse>

      <Grid>
        <Grid.RowDefinitions>
          <RowDefinition Height="64"/>
          <RowDefinition Height="56"/>
          <RowDefinition Height="*"/>
          <RowDefinition Height="132"/>
        </Grid.RowDefinitions>

        <!-- HEADER -->
        <Border Grid.Row="0" Background="#0A0A12" CornerRadius="20,20,0,0">
          <Grid Margin="26,0">
            <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
              <TextBlock FontSize="20" FontWeight="Bold">
                <TextBlock.Foreground>
                  <LinearGradientBrush StartPoint="0,0.5" EndPoint="1,0.5">
                    <GradientStop Color="#FF3D7F" Offset="0"/>
                    <GradientStop Color="#00D4FF" Offset="1"/>
                  </LinearGradientBrush>
                </TextBlock.Foreground>
                KETTEH
              </TextBlock>
              <TextBlock Text="  SS TOOLKIT" FontSize="13" Foreground="#4A4A62" VerticalAlignment="Center" Margin="8,2,0,0"/>
            </StackPanel>

            <Border x:Name="BadgeHost" HorizontalAlignment="Right" Margin="0,0,100,0" CornerRadius="20" Padding="18,7" VerticalAlignment="Center" Background="#12121E">
              <TextBlock x:Name="StatusBadge" Text="IDLE" FontSize="11" FontWeight="Bold" Foreground="#00D4FF"/>
            </Border>

            <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Center">
              <Button x:Name="MinBtn" Content="─" Width="42" Height="36" Background="Transparent" Foreground="#5A5A72" BorderThickness="0" Cursor="Hand"/>
              <Button x:Name="CloseBtn" Content="✕" Width="42" Height="36" Background="Transparent" Foreground="#5A5A72" BorderThickness="0" Cursor="Hand"/>
            </StackPanel>
          </Grid>
        </Border>

        <!-- CATEGORIES -->
        <Border Grid.Row="1" Background="#080810" BorderBrush="#12121E" BorderThickness="0,0,0,1">
          <ScrollViewer HorizontalScrollBarVisibility="Hidden" VerticalScrollBarVisibility="Disabled">
            <StackPanel x:Name="CatBar" Orientation="Horizontal" Margin="22,0" VerticalAlignment="Center"/>
          </ScrollViewer>
        </Border>

        <!-- BODY -->
        <Grid Grid.Row="2">
          <Grid.ColumnDefinitions>
            <ColumnDefinition Width="220"/>
            <ColumnDefinition Width="*"/>
          </Grid.ColumnDefinitions>

          <!-- LEFT RAIL -->
          <Border Grid.Column="0" Background="#080810" BorderBrush="#12121E" BorderThickness="0,0,1,0">
            <StackPanel Margin="18,22">
              <TextBlock Text="ACTIONS" FontSize="10" FontWeight="Bold" Foreground="#3A3A52" Margin="6,0,0,14"/>

              <Button x:Name="OpenFolderBtn" Content="Open Folder" Height="44" Margin="0,0,0,10"
                      Background="#12121E" Foreground="#C8C8E0" BorderThickness="0" Cursor="Hand" FontSize="13"
                      HorizontalContentAlignment="Left">
                <Button.Template>
                  <ControlTemplate TargetType="Button">
                    <Border x:Name="bd" Background="{TemplateBinding Background}" CornerRadius="12">
                      <ContentPresenter HorizontalAlignment="Left" VerticalAlignment="Center" Margin="16,0"/>
                    </Border>
                    <ControlTemplate.Triggers>
                      <Trigger Property="IsMouseOver" Value="True">
                        <Setter TargetName="bd" Property="Background" Value="#1A1A2E"/>
                      </Trigger>
                    </ControlTemplate.Triggers>
                  </ControlTemplate>
                </Button.Template>
              </Button>

              <Button x:Name="ClearCacheBtn" Content="Clear Cache" Height="44" Margin="0,0,0,10"
                      Background="#12121E" Foreground="#C8C8E0" BorderThickness="0" Cursor="Hand" FontSize="13"
                      HorizontalContentAlignment="Left">
                <Button.Template>
                  <ControlTemplate TargetType="Button">
                    <Border x:Name="bd" Background="{TemplateBinding Background}" CornerRadius="12">
                      <ContentPresenter HorizontalAlignment="Left" VerticalAlignment="Center" Margin="16,0"/>
                    </Border>
                    <ControlTemplate.Triggers>
                      <Trigger Property="IsMouseOver" Value="True">
                        <Setter TargetName="bd" Property="Background" Value="#1A1A2E"/>
                      </Trigger>
                    </ControlTemplate.Triggers>
                  </ControlTemplate>
                </Button.Template>
              </Button>

              <Button x:Name="OpenPsBtn" Content="PowerShell" Height="44" Margin="0,0,0,10"
                      Background="#12121E" Foreground="#C8C8E0" BorderThickness="0" Cursor="Hand" FontSize="13"
                      HorizontalContentAlignment="Left">
                <Button.Template>
                  <ControlTemplate TargetType="Button">
                    <Border x:Name="bd" Background="{TemplateBinding Background}" CornerRadius="12">
                      <ContentPresenter HorizontalAlignment="Left" VerticalAlignment="Center" Margin="16,0"/>
                    </Border>
                    <ControlTemplate.Triggers>
                      <Trigger Property="IsMouseOver" Value="True">
                        <Setter TargetName="bd" Property="Background" Value="#1A1A2E"/>
                      </Trigger>
                    </ControlTemplate.Triggers>
                  </ControlTemplate>
                </Button.Template>
              </Button>

              <TextBlock Text="STATUS" FontSize="10" FontWeight="Bold" Foreground="#3A3A52" Margin="6,32,0,10"/>
              <TextBlock x:Name="StatusTitle" Text="Ready" FontSize="17" FontWeight="SemiBold" Foreground="#E8E8FF" Margin="6,0,0,4"/>
              <TextBlock x:Name="StatusSub" Text="Select a tool" FontSize="12.5" Foreground="#5A5A72" TextWrapping="Wrap" Margin="6,0,0,0"/>
            </StackPanel>
          </Border>

          <!-- CARDS -->
          <ScrollViewer Grid.Column="1" VerticalScrollBarVisibility="Auto" Background="#05050A">
            <WrapPanel x:Name="CardPanel" Margin="18"/>
          </ScrollViewer>
        </Grid>

        <!-- CONSOLE -->
        <Border Grid.Row="3" Background="#06060C" CornerRadius="0,0,20,20" BorderBrush="#12121E" BorderThickness="0,1,0,0">
          <Grid Margin="24,12">
            <Grid.RowDefinitions>
              <RowDefinition Height="Auto"/>
              <RowDefinition Height="*"/>
            </Grid.RowDefinitions>
            <TextBlock Text="ACTIVITY CONSOLE" FontSize="10" FontWeight="Bold" Foreground="#3A3A52" Margin="0,0,0,6"/>
            <TextBox x:Name="LogBox" Grid.Row="1" Background="Transparent" Foreground="#00D4FF"
                     BorderThickness="0" FontFamily="Consolas" FontSize="12.5"
                     IsReadOnly="True" VerticalScrollBarVisibility="Auto" TextWrapping="Wrap"/>
          </Grid>
        </Border>
      </Grid>
    </Grid>
  </Border>
</Window>
"@

# Disclaimer
[xml]$discXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Ketteh" Width="460" Height="280" WindowStartupLocation="CenterScreen"
        WindowStyle="None" AllowsTransparency="True" Background="Transparent" FontFamily="Segoe UI">
  <Border Background="#0A0A12" CornerRadius="16" BorderBrush="#1A1A28" BorderThickness="1" Padding="28">
    <Grid>
      <Grid.RowDefinitions>
        <RowDefinition Height="*"/>
        <RowDefinition Height="48"/>
      </Grid.RowDefinitions>
      <StackPanel>
        <TextBlock Text="KETTEH" FontSize="22" FontWeight="Bold" Foreground="#00D4FF" Margin="0,0,0,14"/>
        <TextBlock TextWrapping="Wrap" Foreground="#C0C0E0" FontSize="13.5" Margin="0,0,0,10"
                   Text="Tools are downloaded from official sources and stored locally."/>
        <TextBlock TextWrapping="Wrap" Foreground="#C0C0E0" FontSize="13.5" Text="Use at your own risk."/>
      </StackPanel>
      <Grid Grid.Row="1">
        <Grid.ColumnDefinitions>
          <ColumnDefinition Width="*"/><ColumnDefinition Width="12"/><ColumnDefinition Width="*"/>
        </Grid.ColumnDefinitions>
        <Button x:Name="CancelBtn" Grid.Column="0" Content="Cancel" Height="40" Background="Transparent"
                Foreground="#AAAACC" BorderBrush="#2A2A40" BorderThickness="1" Cursor="Hand"/>
        <Button x:Name="AcceptBtn" Grid.Column="2" Content="Accept" Height="40" Background="#16162A"
                Foreground="#00D4FF" BorderThickness="0" Cursor="Hand" FontWeight="SemiBold"/>
      </Grid>
    </Grid>
  </Border>
</Window>
"@

$discReader = New-Object System.Xml.XmlNodeReader $discXaml
$discWin = [Windows.Markup.XamlReader]::Load($discReader)
$discWin.Add_MouseLeftButtonDown({ try{$discWin.DragMove()}catch{} })
$script:ok = $false
$discWin.FindName("AcceptBtn").Add_Click({ $script:ok=$true; $discWin.Close() })
$discWin.FindName("CancelBtn").Add_Click({ $script:ok=$false; $discWin.Close() })
$discWin.ShowDialog() | Out-Null
if (-not $script:ok) { exit }

$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

$MinBtn=$window.FindName("MinBtn"); $CloseBtn=$window.FindName("CloseBtn")
$StatusTitle=$window.FindName("StatusTitle"); $StatusSub=$window.FindName("StatusSub")
$StatusBadge=$window.FindName("StatusBadge"); $BadgeHost=$window.FindName("BadgeHost")
$LogBox=$window.FindName("LogBox"); $CatBar=$window.FindName("CatBar"); $CardPanel=$window.FindName("CardPanel")
$OpenFolderBtn=$window.FindName("OpenFolderBtn"); $ClearCacheBtn=$window.FindName("ClearCacheBtn")
$OpenPsBtn=$window.FindName("OpenPsBtn")
$Glow1=$window.FindName("Glow1"); $Glow2=$window.FindName("Glow2"); $Glow3=$window.FindName("Glow3")

# Stronger ambient animation
$anim = New-Object System.Windows.Threading.DispatcherTimer
$anim.Interval = [TimeSpan]::FromMilliseconds(35)
$script:t = 0.0
$anim.Add_Tick({
    $script:t += 0.045
    $Glow1.Opacity = 0.14 + [Math]::Sin($script:t) * 0.10
    $Glow2.Opacity = 0.12 + [Math]::Cos($script:t * 0.9) * 0.09
    $Glow3.Opacity = 0.06 + [Math]::Sin($script:t * 0.6) * 0.05
})
$anim.Start()

function Write-Log($msg) {
    $t = Get-Date -Format "HH:mm:ss"
    $LogBox.Dispatcher.Invoke([Action]{ $LogBox.AppendText("[$t] $msg`r`n"); $LogBox.ScrollToEnd() })
}
function Set-Status($title,$sub,$badge="BUSY") {
    $window.Dispatcher.Invoke([Action]{
        $StatusTitle.Text=$title; $StatusSub.Text=$sub; $StatusBadge.Text=$badge
        if ($badge -eq "BUSY") { $StatusBadge.Foreground=[System.Windows.Media.Brushes]::Orange; $BadgeHost.Background=[System.Windows.Media.BrushConverter]::new().ConvertFromString("#2A1A0A") }
        elseif ($badge -eq "ERR") { $StatusBadge.Foreground=[System.Windows.Media.Brushes]::Red; $BadgeHost.Background=[System.Windows.Media.BrushConverter]::new().ConvertFromString("#2A0A0A") }
        else { $StatusBadge.Foreground=[System.Windows.Media.BrushConverter]::new().ConvertFromString("#00D4FF"); $BadgeHost.Background=[System.Windows.Media.BrushConverter]::new().ConvertFromString("#12121E") }
    })
}

function Start-KettehModAnalyzer {
    $code = @'
[Console]::OutputEncoding=[Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle="Ketteh Mod Analyzer"
Clear-Host
Write-Host "`n  KETTEH MOD ANALYZER" -ForegroundColor Cyan
Write-Host "  -------------------`n" -ForegroundColor DarkCyan
Write-Host "  Enter mods folder (Enter = default):" -ForegroundColor White
Write-Host "  > " -NoNewline -ForegroundColor Cyan
$path=Read-Host
if([string]::IsNullOrWhiteSpace($path)){$path=Join-Path $env:APPDATA ".minecraft\mods"}
if(-not(Test-Path -LiteralPath $path -PathType Container)){Write-Host "  Invalid path." -ForegroundColor Red; $null=$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown"); exit}
Add-Type -AssemblyName System.IO.Compression.FileSystem
$patterns=@("wurst","meteor","impact","liquidbounce","aristois","future","sigma","vape","dqrkis","grim","prestige","asteria","vengeance","exhibition","rusherhack","novoline","ghostclient","kamiblue","salhack","clickcrystals","baritone","doomsday","kuro","rise","flux","zero","astolfo","xenon","autocrystal","crystalaura","killaura","aimassist","reach","hitbox","triggerbot","nofall","bhop","flight","phase","blink","freecam","scaffold","xray","esp","nametags","chams","tracers","sessionstealer","tokenlogger","tokengrabber","discordtoken","backdoor","meteordevelopment","cc/novoline","com/alan/clients","net/ccbluex")
function Get-SHA1($f){try{(Get-FileHash -LiteralPath $f -Algorithm SHA1).Hash}catch{$null}}
function Query-Modrinth($h){if(-not $h){return $null};try{$v=Invoke-RestMethod "https://api.modrinth.com/v2/version_file/$h" -TimeoutSec 6;if($v.project_id){(Invoke-RestMethod "https://api.modrinth.com/v2/project/$($v.project_id)" -TimeoutSec 6).title}}catch{}}
function Scan-Jar($f){$hits=[Collections.Generic.List[string]]::new();$client=$false;try{$z=[IO.Compression.ZipFile]::OpenRead($f);foreach($e in $z.Entries){$n=$e.FullName.ToLower();foreach($p in $patterns){if($n.Contains($p)){if(-not $hits.Contains($p)){$hits.Add($p)};if($p -match "wurst|meteor|impact|sigma|vengeance|dqrkis|grim|prestige|exhibition|rusherhack|novoline"){$client=$true}}};if($n.EndsWith(".class")){try{$s=$e.Open();$m=New-Object IO.MemoryStream;$s.CopyTo($m);$s.Close();$t=[Text.Encoding]::ASCII.GetString($m.ToArray()).ToLower();$m.Dispose();foreach($p in $patterns){if($p.Length -gt 4 -and $t.Contains($p)){if(-not $hits.Contains($p)){$hits.Add($p)};if($p -match "wurst|meteor|impact|sigma|vengeance|dqrkis|grim|prestige|exhibition|rusherhack|novoline"){$client=$true}}}}catch{}}};$z.Dispose()}catch{};return @{Hits=$hits;IsClient=$client}}
$jars=@(Get-ChildItem -LiteralPath $path -Filter *.jar -File -EA SilentlyContinue)
Write-Host "`n  Found $($jars.Count) JARs`n" -ForegroundColor Green
$v=@();$u=@();$c=@();$s=@();$i=0
foreach($jar in $jars){$i++;Write-Host ("`r  [{0,3}%] {1}" -f ([math]::Round($i/$jars.Count*100)),$jar.Name.PadRight(45).Substring(0,[Math]::Min(45,$jar.Name.Length))) -NoNewline -ForegroundColor Cyan
$h=Get-SHA1 $jar.FullName;$name=Query-Modrinth $h
if($name){$v+=[PSCustomObject]@{File=$jar.Name;Name=$name};continue}
$r=Scan-Jar $jar.FullName
if($r.IsClient){$c+=[PSCustomObject]@{File=$jar.Name;Hits=($r.Hits -join ", ")}}
elseif($r.Hits.Count -gt 0){$s+=[PSCustomObject]@{File=$jar.Name;Hits=($r.Hits -join ", ")}}
else{$u+=[PSCustomObject]@{File=$jar.Name}}}
Write-Host "`r"+(" "*70)+"`r`n"
Write-Host "  Verified   : $($v.Count)" -ForegroundColor Green
Write-Host "  Unknown    : $($u.Count)" -ForegroundColor Gray
Write-Host "  Suspicious : $($s.Count)" -ForegroundColor Yellow
Write-Host "  Cheats     : $($c.Count)" -ForegroundColor Red
Write-Host ""
if($c.Count -gt 0){Write-Host "  CHEATS" -ForegroundColor Red;foreach($x in $c){Write-Host "  $($x.File)" -ForegroundColor Red;Write-Host "    $($x.Hits)" -ForegroundColor DarkRed};Write-Host ""}
if($s.Count -gt 0){Write-Host "  SUSPICIOUS" -ForegroundColor Yellow;foreach($x in $s){Write-Host "  $($x.File)  →  $($x.Hits)" -ForegroundColor Yellow};Write-Host ""}
Write-Host "  Press any key to exit..." -ForegroundColor DarkGray
$null=$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
'@
    $tmp = Join-Path $env:TEMP "KettehMA.ps1"
    Set-Content -LiteralPath $tmp -Value $code -Encoding UTF8 -Force
    Start-Process powershell -ArgumentList "-NoExit","-NoProfile","-ExecutionPolicy","Bypass","-File","`"$tmp`""
    Write-Log "Launched Mod Analyzer"
    Set-Status "Ready" "Mod Analyzer running" "IDLE"
}

$script:ActiveCat = "All"
$Categories = @("All","Ketteh","Orbdiff","Spokwn","Tonynoh","Praiselily","RedLotus","Zimmerman","NirSoft","Others","Dependencies")

function New-CatBtn([string]$text,[bool]$active) {
    $b = New-Object System.Windows.Controls.Button
    $b.Content=$text; $b.Height=36; $b.Margin="0,0,8,0"; $b.Padding="18,0"; $b.FontSize=12.5; $b.Cursor="Hand"; $b.BorderThickness=0; $b.Tag=$text
    if ($active) {
        $b.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#FF3D7F")
        $b.Foreground = [System.Windows.Media.Brushes]::White
        $b.FontWeight = "SemiBold"
    } else {
        $b.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#12121E")
        $b.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#8888A0")
    }
    $b.Template = [Windows.Markup.XamlReader]::Parse(@"
<ControlTemplate xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" TargetType="Button">
  <Border Background="{TemplateBinding Background}" CornerRadius="18" Padding="{TemplateBinding Padding}">
    <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
  </Border>
</ControlTemplate>
"@)
    $b.Add_Click({ $script:ActiveCat=$this.Tag; Build-Cats; Build-Cards })
    return $b
}

function Build-Cats {
    $CatBar.Children.Clear()
    foreach ($c in $Categories) { [void]$CatBar.Children.Add((New-CatBtn $c ($c -eq $script:ActiveCat))) }
}

function Build-Cards {
    $CardPanel.Children.Clear()
    $list = if ($script:ActiveCat -eq "All") { $ToolData } else { $ToolData | Where-Object Category -eq $script:ActiveCat }

    foreach ($tool in $list) {
        $card = New-Object System.Windows.Controls.Border
        $card.Width=240; $card.Height=112; $card.Margin="8"; $card.CornerRadius=16
        $card.Background=[System.Windows.Media.BrushConverter]::new().ConvertFromString("#0E0E18")
        $card.BorderBrush=[System.Windows.Media.BrushConverter]::new().ConvertFromString("#22223A")
        $card.BorderThickness=1.5; $card.Cursor="Hand"; $card.Padding="16,14"; $card.Tag=$tool

        $scale = New-Object System.Windows.Media.ScaleTransform 1,1
        $card.RenderTransform=$scale; $card.RenderTransformOrigin="0.5,0.5"

        $sp = New-Object System.Windows.Controls.StackPanel
        $n = New-Object System.Windows.Controls.TextBlock
        $n.Text=$tool.Name; $n.FontSize=14; $n.FontWeight="SemiBold"
        $n.Foreground=[System.Windows.Media.BrushConverter]::new().ConvertFromString("#F0F0FF")
        $n.TextWrapping="Wrap"

        $d = New-Object System.Windows.Controls.TextBlock
        $d.Text=$tool.Desc; $d.FontSize=11.5
        $d.Foreground=[System.Windows.Media.BrushConverter]::new().ConvertFromString("#5A5A78")
        $d.TextWrapping="Wrap"; $d.Margin="0,7,0,0"

        [void]$sp.Children.Add($n); [void]$sp.Children.Add($d)
        $card.Child=$sp

        $card.Add_MouseEnter({
            $this.BorderBrush=[System.Windows.Media.BrushConverter]::new().ConvertFromString("#00D4FF")
            $this.Background=[System.Windows.Media.BrushConverter]::new().ConvertFromString("#16162A")
            $sc=$this.RenderTransform
            $ax=New-Object System.Windows.Media.Animation.DoubleAnimation 1.06,([TimeSpan]::FromMilliseconds(140))
            $ay=New-Object System.Windows.Media.Animation.DoubleAnimation 1.06,([TimeSpan]::FromMilliseconds(140))
            $sc.BeginAnimation([System.Windows.Media.ScaleTransform]::ScaleXProperty,$ax)
            $sc.BeginAnimation([System.Windows.Media.ScaleTransform]::ScaleYProperty,$ay)
        })
        $card.Add_MouseLeave({
            $this.BorderBrush=[System.Windows.Media.BrushConverter]::new().ConvertFromString("#22223A")
            $this.Background=[System.Windows.Media.BrushConverter]::new().ConvertFromString("#0E0E18")
            $sc=$this.RenderTransform
            $ax=New-Object System.Windows.Media.Animation.DoubleAnimation 1.0,([TimeSpan]::FromMilliseconds(160))
            $ay=New-Object System.Windows.Media.Animation.DoubleAnimation 1.0,([TimeSpan]::FromMilliseconds(160))
            $sc.BeginAnimation([System.Windows.Media.ScaleTransform]::ScaleXProperty,$ax)
            $sc.BeginAnimation([System.Windows.Media.ScaleTransform]::ScaleYProperty,$ay)
        })

        $card.Add_MouseLeftButtonUp({
            $td=$this.Tag; if(-not $td){return}
            switch($td.Type){
                "Builtin"{ Start-KettehModAnalyzer }
                "Link"{ Start-Process $td.URL; Write-Log "Opened $($td.Name)"; Set-Status "Ready" "Opened browser" "IDLE" }
                "Cmd"{
                    Set-Status "Running" $td.Name "BUSY"; Write-Log "Launching $($td.Name)"
                    Start-Process powershell -ArgumentList "-NoExit","-NoProfile","-ExecutionPolicy","Bypass","-Command",$td.Command
                    Set-Status "Ready" "Launched" "IDLE"
                }
                default{
                    Set-Status "Downloading" $td.Name "BUSY"; Write-Log "Downloading $($td.Name)..."
                    $rs=[runspacefactory]::CreateRunspace(); $rs.Open()
                    $rs.SessionStateProxy.SetVariable("tool",$td); $rs.SessionStateProxy.SetVariable("dir",$installDir)
                    $rs.SessionStateProxy.SetVariable("ui",$window.Dispatcher)
                    $rs.SessionStateProxy.SetVariable("titleC",$StatusTitle); $rs.SessionStateProxy.SetVariable("subC",$StatusSub)
                    $rs.SessionStateProxy.SetVariable("badgeC",$StatusBadge); $rs.SessionStateProxy.SetVariable("logC",$LogBox)
                    $ps=[powershell]::Create(); $ps.Runspace=$rs
                    [void]$ps.AddScript({
                        function L($m){$ui.Invoke([Action]{$logC.AppendText("[$(Get-Date -f HH:mm:ss)] $m`r`n");$logC.ScrollToEnd()})}
                        function S($t,$s,$b){$ui.Invoke([Action]{$titleC.Text=$t;$subC.Text=$s;$badgeC.Text=$b})}
                        try{
                            [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
                            $target=Join-Path $dir "$($tool.Category)\$($tool.Name)"
                            if(-not(Test-Path $target)){New-Item $target -ItemType Directory -Force|Out-Null}
                            if($tool.Type -eq "GitHub"){
                                $parts=$tool.URL -replace "https://github.com/","" -split "/"
                                $api="https://api.github.com/repos/$($parts[0])/$($parts[1])/releases/latest"
                                $rel=Invoke-RestMethod $api -Headers @{"User-Agent"="Ketteh"}
                                $asset=$rel.assets|Where-Object{$_.name -match "\.(zip|exe)$"}|Select-Object -First 1
                                if(-not $asset){throw "No asset"}; $url=$asset.browser_download_url; $fn=$asset.name
                            }else{ $url=$tool.URL; $fn=($url -split "/")[-1] }
                            $out=Join-Path $target $fn
                            if(-not(Test-Path $out)){ L "Downloading $fn..."; (New-Object Net.WebClient).DownloadFile($url,$out); L "Done" }
                            else{ L "Cached $fn" }
                            if($fn -match "\.zip$"){
                                Expand-Archive $out $target -Force
                                $exe=Get-ChildItem $target -Filter *.exe -Recurse|Select-Object -First 1
                                if($exe){Start-Process $exe.FullName; L "Launched $($exe.Name)"}else{Start-Process explorer $target}
                            }else{ Start-Process $out; L "Launched $fn" }
                            S "Ready" "Done" "IDLE"
                        }catch{ L "Error: $_"; S "Error" "Failed" "ERR" }
                    })
                    [void]$ps.BeginInvoke()
                }
            }
        })
        [void]$CardPanel.Children.Add($card)
    }
}

Build-Cats; Build-Cards

$window.Add_MouseLeftButtonDown({ try{$window.DragMove()}catch{} })
$CloseBtn.Add_Click({ $anim.Stop(); $window.Close() })
$MinBtn.Add_Click({ $window.WindowState="Minimized" })
$OpenFolderBtn.Add_Click({
    if(-not(Test-Path $installDir)){New-Item $installDir -ItemType Directory -Force|Out-Null}
    Start-Process explorer $installDir; Write-Log "Opened folder"
})
$ClearCacheBtn.Add_Click({
    if(Test-Path $installDir){
        $n=@(Get-ChildItem $installDir -Force -EA SilentlyContinue).Count
        Get-ChildItem $installDir -Force -EA SilentlyContinue|Remove-Item -Recurse -Force -EA SilentlyContinue
        Write-Log "Cleared $n items"; Set-Status "Ready" "Cache cleared" "IDLE"
    }
})
$OpenPsBtn.Add_Click({ Start-Process powershell; Write-Log "Opened PowerShell" })

Write-Log "Ketteh ready"
Set-Status "Ready" "Select a tool" "IDLE"
$window.ShowDialog() | Out-Null
