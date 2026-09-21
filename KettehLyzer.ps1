<#
    KettehLyzer  v2
    ───────────────────────────────────────────────────────────────────────────
    Local mods-folder scanner — KettehTools suite.

    Scans a Minecraft mods directory and classifies each JAR as:
      VERIFIED    — SHA-1 hash matched on Modrinth or Megabase
      UNKNOWN     — not found in any hash database
      FLAGGED     — cheat-client signatures / module strings found
      BYPASS      — anticheat-bypass or runtime-injection code detected
      OBFUSCATED  — heavy obfuscation with no clean hash match
      JVM ISSUE   — live Java process carries suspicious agents or flags

    Only reads files inside the folder you select.
    Hash lookups go to api.modrinth.com and megabase.vercel.app only;
    nothing else leaves the machine.

    KettehTools — kettehtools.com
#>

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Xaml
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.IO.Compression.FileSystem
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12


# ═══════════════════════════════════════════════════════════════════════════════
#  DETECTION DATA
# ═══════════════════════════════════════════════════════════════════════════════

$suspiciousPatterns = @(
    "AimAssist","AnchorTweaks","AutoAnchor","AutoCrystal","AutoDoubleHand",
    "JDWP.VirtualMachine.AllModules","AutoHitCrystal","AutoPot","AutoTotem",
    "AutoArmor","InventoryTotem","LegitTotem","PingSpoof","SelfDestruct",
    "ShieldBreaker","TriggerBot","AxeSpam","WebMacro","FastPlace",
    "WalskyOptimizer","WalksyOptimizer","walsky.optimizer",
    "WalksyCrystalOptimizerMod","Donut","Replace Mod","ShieldDisabler",
    "SilentAim","Totem Hit","Wtap","FakeLag","dev.virel","orchard",
    "BlockESP","dev.krypton","dev/krypton","skid.krypton","skid/krypton",
    "AntiMissClick","LagReach","PopSwitch","SprintReset","ChestSteal","AntiBot",
    "ElytraSwap","FastXP","FastExp","Refill","AirAnchor","jnativehook",
    "FakeInv","HoverTotem","AutoClicker","AutoFirework","PackSpoof",
    "Antiknockback","catlean","AuthBypass","Asteria","Prestige","AutoEat",
    "AutoMine","MaceSwap","Macro198","StunSlam","SafeAnchor","DoubleAnchor",
    "AutoTPA","BaseFinder","Xenon","gypsy","AutoPotRefill","KeyPearl",
    "AutoNethPot","AutoDtap","AutoWeb","AnchorAction",
    "org.chainlibs.module.impl.modules.Crystal.Y",
    "org.chainlibs.module.impl.modules.Crystal.bF",
    "org.chainlibs.module.impl.modules.Crystal.bM",
    "org.chainlibs.module.impl.modules.Crystal.bY",
    "org.chainlibs.module.impl.modules.Crystal.bq",
    "org.chainlibs.module.impl.modules.Crystal.cv",
    "org.chainlibs.module.impl.modules.Crystal.o",
    "org.chainlibs.module.impl.modules.Blatant.I",
    "org.chainlibs.module.impl.modules.Blatant.bR",
    "org.chainlibs.module.impl.modules.Blatant.bx",
    "org.chainlibs.module.impl.modules.Blatant.cj",
    "org.chainlibs.module.impl.modules.Blatant.dk",
    "imgui.gl3","imgui.glfw","BowAim","Criticals","Fakenick","FakeItem",
    "invsee","ItemExploit","Hellion","hellion","LicenseCheckMixin",
    "ClientPlayerInteractionManagerAccessor","ClientPlayerEntityMixim",
    "dev.gambleclient","obfuscatedAuth","phantom-refmap.json","xyz.greaj",
    "じ.class","ふ.class","ぶ.class","ぷ.class","た.class","ね.class",
    "そ.class","な.class","ど.class","ぐ.class","ず.class","で.class",
    "つ.class","べ.class","せ.class","と.class","み.class","び.class",
    "す.class","の.class"
)

$cheatStrings = @(
    # AutoCrystal
    "AutoCrystal","autocrystal","auto crystal","cw crystal","JDWP.VirtualMachine.AllModules",
    "dontPlaceCrystal","dontBreakCrystal","dev.virel","orchard",
    "AutoHitCrystal","autohitcrystal","canPlaceCrystalServer","healPotSlot",
    "ＡｕｔｏＣｒｙｓｔａｌ","Ａｕｔｏ Ｃｒｙｓｔａｌ","ＡｕｔｏＨｉｔＣｒｙｓｔａｌ",
    # Anchor
    "AutoAnchor","autoanchor","auto anchor","DoubleAnchor","HasAnchor",
    "anchortweaks","anchor macro","safe anchor","safeanchor","SafeAnchor","AirAnchor",
    "ＡｕｔｏＡｎｃｈｏｒ","Ａｕｔｏ Ａｎｃｈｏｒ","ＤｏｕｂｌｅＡｎｃｈｏｒ","Ｄｏｕｂｌｅ Ａｎｃｈｏｒ",
    "ＳａｆｅＡｎｃｈｏｒ","Ｓａｆｅ Ａｎｃｈｏｒ","Ａｎｃｈｏｒ Ｍａｃｒｏ","anchorMacro",
    # Totem
    "AutoTotem","autototem","auto totem","InventoryTotem","inventorytotem",
    "HoverTotem","hover totem","legittotem",
    "ＡｕｔｏＴｏｔｅｍ","Ａｕｔｏ Ｔｏｔｅｍ","ＨｏｖｅｒＴｏｔｅｍ","Ｈｏｖｅｒ Ｔｏｔｅｍ",
    "ＩｎｖｅｎｔｏｒｙＴｏｔｅｍ","Ａｕｔｏ Ｉｎｖｅｎｔｏｒｙ Ｔｏｔｅｍ","Ａｕｔｏ Ｔｏｔｅｍ Ｈｉｔ",
    # AutoPot / AutoArmor
    "AutoPot","autopot","auto pot","speedPotSlot","strengthPotSlot",
    "AutoArmor","autoarmor","auto armor","ＡｕｔｏＰｏｔ","Ａｕｔｏ Ｐｏｔ",
    "Ａｕｔｏ Ｐｏｔ Ｒｅｆｉｌｌ","AutoPotRefill","ＡｕｔｏＡｒｍｏｒ","Ａｕｔｏ Ａｒｍｏｒ",
    # Shield
    "preventSwordBlockBreaking","preventSwordBlockAttack","ShieldDisabler","ShieldBreaker",
    "ＳｈｉｅｌｄＤｉｓａｂｌｅｒ","Ｓｈｉｅｌｄ Ｄｉｓａｂｌｅｒ","Breaking shield with axe...",
    # Mace / Spear
    "AutoDoubleHand","autodoublehand","auto double hand",
    "ＡｕｔｏＤｏｕｂｌｅＨａｎｄ","Ａｕｔｏ Ｄｏｕｂｌｅ Ｈａｎｄ",
    "AutoClicker","ＡｕｔｏＣｌｉｃｋｅｒ","Failed to switch to mace after axe!",
    "AutoMace","MaceSwap","SpearSwap","ＡｕｔｏＭａｃｅ","Ａｕｔｏ Ｍａｃｅ",
    "ＭａｃｅＳｗａｐ","Ｍａｃｅ Ｓｗａｐ","Ｓｐｅａｒ Ｓｗａｐ","Ｓｔｕｎ Ｓｌａｍ","StunSlam",
    # Aim / KB / Lag
    "Donut","JumpReset","axespam","axe spam","findKnockbackSword","attackRegisteredThisClick",
    "AimAssist","aimassist","aim assist","triggerbot","trigger bot",
    "ＡｉｍＡｓｓｉｓｔ","Ａｉｍ Ａｓｓｉｓｔ","ＴｒｉｇｇｅｒＢｏｔ","Ｔｒｉｇｇｅｒ Ｂｏｔ",
    "Silent Rotations","SilentRotations","Ｓｉｌｅｎｔ Ｒｏｔａｔｉｏｎｓ",
    "FakeInv","swapBackToOriginalSlot","FakeLag","pingspoof","ping spoof",
    "ＦａｋｅＬａｇ","Ｆａｋｅ Ｌａｇ","fakePunch","Fake Punch","Ｆａｋｅ Ｐｕｎｃｈ",
    # Enum constants
    "mace_swap","quick_strike","macro_198","stun_slam","safe_anchor","double_anchor",
    "auto_pot_refill","walksy_optimizer","key_pearl","aim_assist","auto_neth_pot",
    "auto_dtap","trigger_bot","auto_web",
    "DOUBLE_ESCAPE","DOUBLE_RIGHTCLICK_FIRST","DOUBLE_RIGHTCLICK_SECOND",
    "POST_CYCLE_DELAY","PLACE_OBI","WAIT_OBI","PLACE_CRYSTAL","BREAK_CRYSTAL",
    "ROTATING_DOWN","ROTATING_BACK","REFILLING","PLANTING","BONEMEALING",
    "AnchorAction","REOFFHAND_TOTEM",
    # Web
    "webmacro","web macro","AntiWeb","AutoWeb","Ａｎｔｉ Ｗｅｂ","ＡｕｔｏＷｅｂ",
    # Known dev fingerprints
    "lvstrng","dqrkis","selfdestruct","self destruct",
    "WalksyCrystalOptimizerMod","WalksyOptimizer","WalskyOptimizer","Ｗａｌｋｓｙ Ｏｐｔｉｍｉｚｅｒ",
    "autoCrystalPlaceClock",
    # Movement / misc features
    "AutoFirework","ElytraSwap","FastXP","FastExp","NoJumpDelay",
    "ＥｌｙｔｒａＳｗａｐ","Ｅｌｙｔｒａ Ｓｗａｐ","PackSpoof","Antiknockback","catlean",
    "AuthBypass","obfuscatedAuth","LicenseCheckMixin","BaseFinder","invsee","ItemExploit",
    "FreezePlayer","Ｎｏ Ｃｌｉｐ","Ｆｒｅｅｚｅ Ｐｌａｙｅｒ",
    "LWFH Crystal","JDWP.VirtualMachine.AllModules","ＬＷＦＨ Ｃｒｙｓｔａｌ",
    "KeyPearl","LootYeeter","ＫｅｙＰｅａｒｌ","Ｋｅｙ Ｐｅａｒｌ","Ｌｏｏｔ Ｙｅｅｔｅｒ",
    "FastPlace","Ｆａｓｔ Ｐｌａｃｅ","AutoBreach","Ａｕｔｏ Ｂｒｅａｃｈ",
    # Internals / runtime hooks
    "setBlockBreakingCooldown","getBlockBreakingCooldown","blockBreakingCooldown",
    "onBlockBreaking","setItemUseCooldown","invokeDoAttack","invokeDoItemUse",
    "invokeOnMouseButton","onPushOutOfBlocks","onIsGlowing",
    "arrayOfString","POT_CHEATS","Dqrkis Client","Entity.isGlowing",
    "placeInterval","breakInterval","stopOnKill","activateOnRightClick","holdCrystal",
    # Cheat categories
    "KillAura","ClickAura","MultiAura","ForceField","LegitAura",
    "AimBot","AutoAim","SilentAim","AimLock","HeadSnap",
    "CrystalAura","AnchorAura","AnchorFill","AnchorPlace",
    "BedAura","AutoBed","BedBomb","BedPlace","BowAimbot","BowSpam","AutoBow",
    "AutoCrit","CritBypass","AlwaysCrit","CriticalHit",
    "ReachHack","ExtendReach","LongReach","HitboxExpand",
    "AntiKB","NoKnockback","GrimVelocity","GrimDisabler","VelocitySpoof","KBReduce",
    "OffhandTotem","TotemSwitch","AutoWeapon","AutoSword","AutoCity","Burrow","SelfTrap",
    "HoleFiller","AntiSurround","AntiBurrow","WTap","TargetStrafe","AutoGap","AutoPearl",
    "FlyHack","CreativeFlight","BoatFly","PacketFly","AirJump","SpeedHack","BHop","BunnyHop",
    "AntiFall","NoFallDamage","SafeFall","StepHack","FastClimb","AutoStep","HighStep",
    "WaterWalk","LiquidWalk","LavaWalk","NoSlow","NoSlowdown","NoWeb","NoSoulSand",
    "WallHack","ElytraSpeed","InstantElytra","ScaffoldWalk","FastBridge","BuildHelper","AutoBridge",
    "Nuker","NukerLegit","InstantBreak","GhostHand","NoSwing",
    "PlaceAssist","AirPlace","AutoPlace","InstantPlace",
    "PlayerESP","MobESP","ItemESP","StorageESP","ChestESP","Tracers","NameTagsHack",
    "XRayHack","OreFinder","CaveFinder","OreESP","NewChunks","ChunkBorders","TunnelFinder",
    "TargetHUD","ReachDisplay","DoubleClicker","JitterClick","ButterflyClick","CPSBoost",
    "ChestStealer","InvManager","InvMovebypass","AutoSprint","AntiAFK","AutoRespawn","PopSwitch",
    "FakeLatency","FakePing","SpoofRotation","PositionSpoof","GameSpeed","SpeedTimer",
    "GrimBypass","VulcanBypass","MatrixBypass","AACBypass","VerusDisabler","IntaveBypass","WatchdogBypass",
    "PacketMine","PacketWalk","PacketSneak","PacketCancel","PacketDupe","PacketSpam","SelfDestruct","HideClient",
    "SessionStealer","TokenLogger","TokenGrabber","DiscordToken",
    "RemoteAccess","ReverseShell","C2Server","Backdoor","KeyLogger","StashFinder","TrailFinder",
    "imgui.binding","JNativeHook","GlobalScreen","NativeKeyListener",
    "client-refmap.json","cheat-refmap.json",
    # Package / class paths
    "meteordevelopment","cc/novoline","com/alan/clients","club/maxstats","wtf/moonlight",
    "me/zeroeightsix/kami","net/ccbluex","today/opai",
    "net/minecraft/injection","org/chainlibs/module/impl/modules",
    "xyz/greaj","com/cheatbreaker","com/moonsworth",
    # Known clients
    "doomsdayclient","DoomsdayClient","doomsday.jar","novaclient","api.novaclient.lol",
    "vape.gg","vapeclient","VapeClient","VapeLite","intent.store","IntentClient",
    "rise.today","riseclient.com","meteor-client","meteorclient","meteordevelopment.meteorclient",
    "liquidbounce","fdp-client","net.ccbluex","novoware","novoclient",
    "aristois","impactclient","azura","pandaware","skilled","moonClient","astolfo",
    "futureClient","konas","rusherhack","inertia","exhibition",
    "dev.krypton","dev/krypton","skid.krypton","skid/krypton",
    "VirginClient","virgin client","catlean","CatleanClient","catlean client",
    "ArgonClient","argon client","Asteria","AsteriaClient","asteria client",
    "Prestige","PrestigeClient","prestige client","prestigeclient.vip",
    "gypsy","GypsyClient","gypsy client","Xenon","XenonClient","xenon client",
    "GrimClient","grim client","phantom-refmap.json","dqrkis.xyz","Dqrkis Client"
)

$patternRegex = [regex]::new(
    '(?<![A-Za-z])(' + ($suspiciousPatterns -join '|') + ')(?![A-Za-z])',
    [System.Text.RegularExpressions.RegexOptions]::Compiled
)
$cheatStringSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
foreach ($s in $cheatStrings) { [void]$cheatStringSet.Add($s) }
$fullwidthRegex = [regex]::new(
    '[\uFF21-\uFF3A\uFF41-\uFF5A\uFF10-\uFF19]{2,}',
    [System.Text.RegularExpressions.RegexOptions]::Compiled
)


# ═══════════════════════════════════════════════════════════════════════════════
#  XAML — UI
# ═══════════════════════════════════════════════════════════════════════════════

[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="KettehLyzer" Width="1220" Height="840"
    MinWidth="1220" MinHeight="840"
    WindowStartupLocation="CenterScreen"
    ResizeMode="NoResize" WindowStyle="None"
    AllowsTransparency="True" Background="Transparent"
    FontFamily="Segoe UI">

    <Window.Resources>
        <SolidColorBrush x:Key="Bg0"       Color="#090D12"/>
        <SolidColorBrush x:Key="Bg1"       Color="#0C1117"/>
        <SolidColorBrush x:Key="Bg2"       Color="#101720"/>
        <SolidColorBrush x:Key="Bg3"       Color="#0D1319"/>
        <SolidColorBrush x:Key="Accent"    Color="#00E5A8"/>
        <SolidColorBrush x:Key="AccentDim" Color="#097A5B"/>
        <SolidColorBrush x:Key="Danger"    Color="#FF4D6B"/>
        <SolidColorBrush x:Key="Warn"      Color="#FFBB44"/>
        <SolidColorBrush x:Key="Purple"    Color="#C97DFF"/>
        <SolidColorBrush x:Key="Orange"    Color="#FF8A50"/>
        <SolidColorBrush x:Key="Info"      Color="#56C3FF"/>
        <SolidColorBrush x:Key="TextHi"    Color="#DFF0EA"/>
        <SolidColorBrush x:Key="TextLo"    Color="#445A54"/>
        <SolidColorBrush x:Key="Border0"   Color="#162028"/>
        <SolidColorBrush x:Key="ConsoleBg" Color="#060910"/>

        <Style x:Key="FlatBtn" TargetType="Button">
            <Setter Property="Background" Value="Transparent"/>
            <Setter Property="Foreground" Value="{StaticResource TextHi}"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="Height" Value="36"/>
            <Setter Property="Margin" Value="0,0,0,4"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" CornerRadius="6">
                            <ContentPresenter HorizontalAlignment="Left" VerticalAlignment="Center" Margin="12,0"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter Property="Background" Value="#141E28"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style x:Key="PrimaryBtn" TargetType="Button">
            <Setter Property="Background" Value="{StaticResource Accent}"/>
            <Setter Property="Foreground" Value="#031209"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="Height" Value="40"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" CornerRadius="7">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter Property="Background" Value="#2EFFC0"/>
                            </Trigger>
                            <Trigger Property="IsEnabled" Value="False">
                                <Setter Property="Background" Value="#0D2A1E"/>
                                <Setter Property="Foreground" Value="#2A5042"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style x:Key="TitleBtn" TargetType="Button">
            <Setter Property="Background" Value="Transparent"/>
            <Setter Property="Foreground" Value="{StaticResource TextLo}"/>
            <Setter Property="Width" Value="38"/>
            <Setter Property="Height" Value="34"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter Property="Background" Value="#182330"/>
                                <Setter Property="Foreground" Value="{StaticResource Accent}"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>

    <Border Background="{StaticResource Bg0}" BorderBrush="{StaticResource Border0}"
            BorderThickness="1" CornerRadius="10">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="42"/>
                <RowDefinition Height="*"/>
            </Grid.RowDefinitions>

            <!-- ── Title bar ── -->
            <Border Grid.Row="0" Background="{StaticResource Bg1}" CornerRadius="10,10,0,0">
                <Grid Margin="16,0">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="Auto"/>
                    </Grid.ColumnDefinitions>
                    <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
                        <Ellipse Width="9" Height="9" Fill="{StaticResource Accent}" Margin="0,0,10,0"/>
                        <TextBlock Text="KettehLyzer" FontSize="13" FontWeight="Bold"
                                   Foreground="{StaticResource TextHi}"/>
                        <TextBlock Text="  v2  ·  mods scanner" FontSize="11"
                                   Foreground="{StaticResource TextLo}"
                                   VerticalAlignment="Center" Margin="6,1,0,0"/>
                        <TextBlock Text="  KettehTools" FontSize="11"
                                   Foreground="{StaticResource AccentDim}"
                                   VerticalAlignment="Center" Margin="12,1,0,0"/>
                    </StackPanel>
                    <StackPanel Grid.Column="1" Orientation="Horizontal">
                        <Button x:Name="MinBtn"   Style="{StaticResource TitleBtn}" Content="_"/>
                        <Button x:Name="CloseBtn" Style="{StaticResource TitleBtn}" Content="X"/>
                    </StackPanel>
                </Grid>
            </Border>

            <!-- ── Body ── -->
            <Grid Grid.Row="1">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="262"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>

                <!-- ── Sidebar ── -->
                <Border Grid.Column="0" Background="{StaticResource Bg1}"
                        BorderBrush="{StaticResource Border0}" BorderThickness="0,0,1,0">
                    <ScrollViewer VerticalScrollBarVisibility="Auto">
                        <StackPanel Margin="14,16,14,16">

                            <!-- Folder -->
                            <TextBlock Text="MODS FOLDER" FontSize="9" FontWeight="Bold"
                                       Foreground="{StaticResource TextLo}" Margin="2,0,0,6"/>
                            <TextBox x:Name="PathBox" Height="34" Padding="8,7" FontSize="11"
                                     Background="{StaticResource Bg3}" Foreground="{StaticResource TextHi}"
                                     BorderBrush="{StaticResource Border0}" BorderThickness="1"
                                     Margin="0,0,0,5"/>
                            <Button x:Name="BrowseBtn" Content="  Browse…"
                                    Style="{StaticResource FlatBtn}"
                                    Background="{StaticResource Bg3}"/>
                            <Button x:Name="ScanBtn" Content="Run Scan"
                                    Style="{StaticResource PrimaryBtn}" Margin="0,12,0,0"/>

                            <!-- Safety note -->
                            <Border Background="{StaticResource Bg3}" CornerRadius="6"
                                    Margin="0,12,0,0" Padding="10">
                                <TextBlock TextWrapping="Wrap" FontSize="10"
                                           Foreground="{StaticResource TextLo}"
                                           Text="Reads only the .jar files in the folder above. Hash lookups go to Modrinth and Megabase only — nothing else leaves this machine."/>
                            </Border>

                            <Separator Background="{StaticResource Border0}" Margin="0,16,0,14"/>

                            <!-- Stats -->
                            <TextBlock Text="LAST SCAN" FontSize="9" FontWeight="Bold"
                                       Foreground="{StaticResource TextLo}" Margin="2,0,0,8"/>
                            <TextBlock x:Name="StatFiles"     Text="Files: —"        FontSize="11" Foreground="{StaticResource TextHi}"  Margin="2,2"/>
                            <TextBlock x:Name="StatVerified"  Text="Verified: —"     FontSize="11" Foreground="{StaticResource Accent}"  Margin="2,2"/>
                            <TextBlock x:Name="StatUnknown"   Text="Unknown: —"      FontSize="11" Foreground="{StaticResource Warn}"    Margin="2,2"/>
                            <TextBlock x:Name="StatObf"       Text="Obfuscated: —"   FontSize="11" Foreground="{StaticResource Orange}"  Margin="2,2"/>
                            <TextBlock x:Name="StatBypass"    Text="Bypass: —"       FontSize="11" Foreground="{StaticResource Purple}"  Margin="2,2"/>
                            <TextBlock x:Name="StatFlagged"   Text="Flagged: —"      FontSize="11" Foreground="{StaticResource Danger}"  Margin="2,2"/>
                            <TextBlock x:Name="StatJvm"       Text="JVM Issues: —"   FontSize="11" Foreground="{StaticResource Warn}"    Margin="2,2"/>

                            <Separator Background="{StaticResource Border0}" Margin="0,16,0,14"/>

                            <!-- JVM panel -->
                            <TextBlock Text="JVM RUNTIME" FontSize="9" FontWeight="Bold"
                                       Foreground="{StaticResource TextLo}" Margin="2,0,0,8"/>
                            <Border x:Name="JvmCard" Background="{StaticResource Bg3}"
                                    CornerRadius="6" Padding="10,8">
                                <StackPanel>
                                    <StackPanel Orientation="Horizontal" Margin="0,0,0,4">
                                        <Ellipse x:Name="JvmDot" Width="8" Height="8"
                                                 Fill="{StaticResource TextLo}"
                                                 VerticalAlignment="Center" Margin="0,0,7,0"/>
                                        <TextBlock x:Name="JvmStatusLine" Text="Checking…"
                                                   FontSize="11" Foreground="{StaticResource TextHi}"
                                                   VerticalAlignment="Center"/>
                                    </StackPanel>
                                    <TextBlock x:Name="JvmUptimeLine" Text=""
                                               FontSize="11" Foreground="{StaticResource Accent}"
                                               Margin="15,0,0,0"/>
                                    <TextBlock x:Name="JvmStartedLine" Text=""
                                               FontSize="10" Foreground="{StaticResource TextLo}"
                                               Margin="15,2,0,0"/>
                                </StackPanel>
                            </Border>

                            <Separator Background="{StaticResource Border0}" Margin="0,16,0,14"/>
                            <TextBlock Text="KettehTools" FontSize="11" FontWeight="SemiBold"
                                       Foreground="{StaticResource TextHi}"/>
                            <TextBlock Text="KettehLyzer  v2" FontSize="10"
                                       Foreground="{StaticResource TextLo}" Margin="0,3,0,0"/>

                        </StackPanel>
                    </ScrollViewer>
                </Border>

                <!-- ── Main panel ── -->
                <Grid Grid.Column="1" Margin="18,16,18,16">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="10"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="10"/>
                        <RowDefinition Height="148"/>
                    </Grid.RowDefinitions>

                    <!-- Status card -->
                    <Border Grid.Row="0" Background="{StaticResource Bg2}"
                            CornerRadius="8" Padding="20,13">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="Auto"/>
                            </Grid.ColumnDefinitions>
                            <StackPanel>
                                <TextBlock x:Name="StatusTitle" Text="Ready"
                                           FontSize="20" FontWeight="SemiBold"
                                           Foreground="{StaticResource TextHi}"/>
                                <TextBlock x:Name="StatusSub"
                                           Text="Pick a mods folder and click Run Scan."
                                           FontSize="11" Foreground="{StaticResource TextLo}"/>
                            </StackPanel>
                            <Border Grid.Column="1" x:Name="BadgeBorder"
                                    Background="#082417" CornerRadius="5"
                                    Padding="12,5" VerticalAlignment="Center">
                                <TextBlock x:Name="StatusBadge" Text="IDLE"
                                           FontSize="12" FontWeight="Bold"
                                           Foreground="{StaticResource Accent}"/>
                            </Border>
                        </Grid>
                    </Border>

                    <!-- Results -->
                    <Border Grid.Row="2" Background="{StaticResource Bg2}" CornerRadius="8">
                        <ScrollViewer x:Name="ResultsScroll"
                                      VerticalScrollBarVisibility="Auto" Padding="16,14">
                            <StackPanel x:Name="ResultsPanel"/>
                        </ScrollViewer>
                    </Border>

                    <!-- Console -->
                    <Border Grid.Row="4" Background="{StaticResource ConsoleBg}"
                            CornerRadius="8" Padding="14,10">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <TextBlock Text="ACTIVITY LOG" FontSize="9" FontWeight="Bold"
                                       Foreground="{StaticResource TextLo}"
                                       FontFamily="Consolas" Margin="0,0,0,4"/>
                            <TextBox x:Name="LogBox" Grid.Row="1"
                                     Background="Transparent"
                                     Foreground="{StaticResource Accent}"
                                     BorderThickness="0" FontFamily="Consolas"
                                     FontSize="11" IsReadOnly="True"
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

$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

# Element refs
$MinBtn        = $window.FindName("MinBtn")
$CloseBtn      = $window.FindName("CloseBtn")
$PathBox       = $window.FindName("PathBox")
$BrowseBtn     = $window.FindName("BrowseBtn")
$ScanBtn       = $window.FindName("ScanBtn")
$StatusTitle   = $window.FindName("StatusTitle")
$StatusSub     = $window.FindName("StatusSub")
$StatusBadge   = $window.FindName("StatusBadge")
$LogBox        = $window.FindName("LogBox")
$ResultsPanel  = $window.FindName("ResultsPanel")
$ResultsScroll = $window.FindName("ResultsScroll")
$StatFiles     = $window.FindName("StatFiles")
$StatVerified  = $window.FindName("StatVerified")
$StatUnknown   = $window.FindName("StatUnknown")
$StatFlagged   = $window.FindName("StatFlagged")
$StatBypass    = $window.FindName("StatBypass")
$StatObf       = $window.FindName("StatObf")
$StatJvm       = $window.FindName("StatJvm")
$JvmDot        = $window.FindName("JvmDot")
$JvmStatusLine = $window.FindName("JvmStatusLine")
$JvmUptimeLine = $window.FindName("JvmUptimeLine")
$JvmStartedLine= $window.FindName("JvmStartedLine")

$PathBox.Text = "$env:USERPROFILE\AppData\Roaming\.minecraft\mods"


# ═══════════════════════════════════════════════════════════════════════════════
#  JVM SIDEBAR  —  live refresh (DispatcherTimer, UI thread)
# ═══════════════════════════════════════════════════════════════════════════════

function Update-KLJvmPanel {
    $jp = Get-Process javaw -ErrorAction SilentlyContinue
    if (-not $jp) { $jp = Get-Process java -ErrorAction SilentlyContinue }
    if ($jp) {
        $p  = $jp | Select-Object -First 1
        $up = (Get-Date) - $p.StartTime
        $JvmDot.Fill        = [Windows.Media.BrushConverter]::new().ConvertFrom("#00E5A8")
        $JvmStatusLine.Text = "$($p.Name)  ·  PID $($p.Id)"
        $JvmUptimeLine.Text = "Uptime  $($up.Hours)h $($up.Minutes)m $($up.Seconds)s"
        $JvmStartedLine.Text= "Started $($p.StartTime.ToString('HH:mm:ss'))"
    } else {
        $JvmDot.Fill        = [Windows.Media.BrushConverter]::new().ConvertFrom("#1E3028")
        $JvmStatusLine.Text = "No Java process running"
        $JvmUptimeLine.Text = ""
        $JvmStartedLine.Text= ""
    }
}

$jvmTimer          = New-Object System.Windows.Threading.DispatcherTimer
$jvmTimer.Interval = [TimeSpan]::FromSeconds(4)
$jvmTimer.Add_Tick({ Update-KLJvmPanel })
$jvmTimer.Start()


# ═══════════════════════════════════════════════════════════════════════════════
#  EVENTS
# ═══════════════════════════════════════════════════════════════════════════════

$window.Add_MouseLeftButtonDown({ try { $window.DragMove() } catch {} })
$CloseBtn.Add_Click({ $jvmTimer.Stop(); $window.Close() })
$MinBtn.Add_Click({ $window.WindowState = "Minimized" })

$BrowseBtn.Add_Click({
    $dlg = New-Object System.Windows.Forms.FolderBrowserDialog
    $dlg.Description = "Select a Minecraft mods folder to scan"
    if (Test-Path $PathBox.Text) { $dlg.SelectedPath = $PathBox.Text }
    if ($dlg.ShowDialog() -eq "OK") { $PathBox.Text = $dlg.SelectedPath }
})


# ═══════════════════════════════════════════════════════════════════════════════
#  SCAN  —  background runspace  (all 4 passes + JVM)
# ═══════════════════════════════════════════════════════════════════════════════

$ScanBtn.Add_Click({

    $modsPath = $PathBox.Text
    if (-not (Test-Path $modsPath -PathType Container)) {
        $StatusTitle.Text = "Invalid path"
        $StatusSub.Text   = "That folder doesn't exist."
        $StatusBadge.Text = "ERR"
        $LogBox.AppendText("[$(Get-Date -f 'HH:mm:ss')] Path not found: $modsPath`r`n")
        return
    }

    $ScanBtn.IsEnabled = $false
    $ResultsPanel.Children.Clear()
    $LogBox.Clear()
    $StatusTitle.Text = "Scanning…"
    $StatusSub.Text   = "Starting scan on $modsPath"
    $StatusBadge.Text = "SCANNING"

    $rs = [runspacefactory]::CreateRunspace()
    $rs.ApartmentState = "STA"
    $rs.ThreadOptions  = "ReuseThread"
    $rs.Open()

    foreach ($v in @(
        @("modsPath",       $modsPath),
        @("dispatcher",     $window.Dispatcher),
        @("patternRegex",   $patternRegex),
        @("cheatStringSet", $cheatStringSet),
        @("cheatStrings",   $cheatStrings),
        @("fullwidthRegex", $fullwidthRegex),
        @("ScanBtn",        $ScanBtn),
        @("StatusTitle",    $StatusTitle),
        @("StatusSub",      $StatusSub),
        @("StatusBadge",    $StatusBadge),
        @("LogBox",         $LogBox),
        @("ResultsPanel",   $ResultsPanel),
        @("StatFiles",      $StatFiles),
        @("StatVerified",   $StatVerified),
        @("StatUnknown",    $StatUnknown),
        @("StatFlagged",    $StatFlagged),
        @("StatBypass",     $StatBypass),
        @("StatObf",        $StatObf),
        @("StatJvm",        $StatJvm),
        @("JvmDot",         $JvmDot),
        @("JvmStatusLine",  $JvmStatusLine),
        @("JvmUptimeLine",  $JvmUptimeLine),
        @("JvmStartedLine", $JvmStartedLine)
    )) { $rs.SessionStateProxy.SetVariable($v[0], $v[1]) }

    $ps = [powershell]::Create()
    $ps.Runspace = $rs

    $null = $ps.AddScript({

        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        # ── UI helpers ────────────────────────────────────────────────────────

        function KL-Log { param($m)
            $dispatcher.Invoke([Action]{
                $LogBox.AppendText("[$(Get-Date -f 'HH:mm:ss')] $m`r`n")
                $LogBox.ScrollToEnd()
            })
        }

        function KL-Status { param($t,$s,$b="SCANNING")
            $dispatcher.Invoke([Action]{
                $StatusTitle.Text = $t
                $StatusSub.Text   = $s
                $StatusBadge.Text = $b
            })
        }

        function KL-AddSection { param([string]$Title,[int]$Count,[string]$Color)
            if ($Count -eq 0) { return }
            $dispatcher.Invoke([Action]{
                $sep = New-Object System.Windows.Controls.Border
                $sep.Height = 1
                $sep.Background = [Windows.Media.BrushConverter]::new().ConvertFrom("#162028")
                $sep.Margin = "0,14,0,10"
                $ResultsPanel.Children.Add($sep) | Out-Null

                $sp = New-Object System.Windows.Controls.StackPanel
                $sp.Orientation = "Horizontal"
                $sp.Margin = "0,0,0,8"

                $dot = New-Object System.Windows.Controls.Ellipse
                $dot.Width = 8; $dot.Height = 8
                $dot.Fill = [Windows.Media.BrushConverter]::new().ConvertFrom($Color)
                $dot.VerticalAlignment = "Center"
                $dot.Margin = "0,0,8,0"
                $sp.Children.Add($dot) | Out-Null

                $tb = New-Object System.Windows.Controls.TextBlock
                $tb.Text = "$Title"
                $tb.FontSize = 11; $tb.FontWeight = "Bold"
                $tb.Foreground = [Windows.Media.BrushConverter]::new().ConvertFrom($Color)
                $tb.VerticalAlignment = "Center"
                $sp.Children.Add($tb) | Out-Null

                $ct = New-Object System.Windows.Controls.TextBlock
                $ct.Text = "  ($Count)"
                $ct.FontSize = 11
                $ct.Foreground = [Windows.Media.BrushConverter]::new().ConvertFrom("#445A54")
                $ct.VerticalAlignment = "Center"
                $sp.Children.Add($ct) | Out-Null

                $ResultsPanel.Children.Add($sp) | Out-Null
            })
        }

        function KL-AddCard {
            param(
                [string]$FileName,
                [string]$BadgeText,
                [string]$BadgeBg,
                [string]$BorderColor,
                [string[]]$Chips    = @(),
                [string]$ChipBg    = "#101720",
                [string]$ChipFg    = "#AECCC5",
                [string]$SubNote   = ""
            )
            $dispatcher.Invoke([Action]{
                $card = New-Object System.Windows.Controls.Border
                $card.Background     = [Windows.Media.BrushConverter]::new().ConvertFrom("#0D1319")
                $card.BorderBrush    = [Windows.Media.BrushConverter]::new().ConvertFrom($BorderColor)
                $card.BorderThickness= "1"
                $card.CornerRadius   = 7
                $card.Padding        = "14,10"
                $card.Margin         = "0,0,0,7"

                $stack = New-Object System.Windows.Controls.StackPanel

                # Header row
                $hdr = New-Object System.Windows.Controls.StackPanel
                $hdr.Orientation = "Horizontal"

                $bdg = New-Object System.Windows.Controls.Border
                $bdg.Background   = [Windows.Media.BrushConverter]::new().ConvertFrom($BadgeBg)
                $bdg.CornerRadius = 3
                $bdg.Padding      = "7,2"
                $bdg.Margin       = "0,0,9,0"
                $bdgTb = New-Object System.Windows.Controls.TextBlock
                $bdgTb.Text       = $BadgeText
                $bdgTb.FontSize   = 9
                $bdgTb.FontWeight = "Bold"
                $bdgTb.Foreground = [Windows.Media.BrushConverter]::new().ConvertFrom("#050D0A")
                $bdg.Child = $bdgTb
                $hdr.Children.Add($bdg) | Out-Null

                $nm = New-Object System.Windows.Controls.TextBlock
                $nm.Text       = $FileName
                $nm.FontSize   = 12
                $nm.FontWeight = "SemiBold"
                $nm.Foreground = [Windows.Media.BrushConverter]::new().ConvertFrom("#DFF0EA")
                $nm.VerticalAlignment = "Center"
                $nm.TextTrimming = "CharacterEllipsis"
                $hdr.Children.Add($nm) | Out-Null
                $stack.Children.Add($hdr) | Out-Null

                # Sub-note
                if ($SubNote) {
                    $sn = New-Object System.Windows.Controls.TextBlock
                    $sn.Text       = $SubNote
                    $sn.FontSize   = 10
                    $sn.Foreground = [Windows.Media.BrushConverter]::new().ConvertFrom("#3A5248")
                    $sn.Margin     = "0,4,0,0"
                    $stack.Children.Add($sn) | Out-Null
                }

                # Chips
                if ($Chips.Count -gt 0) {
                    $wrap = New-Object System.Windows.Controls.WrapPanel
                    $wrap.Margin = "0,9,0,0"
                    foreach ($c in ($Chips | Select-Object -Unique)) {
                        $chip = New-Object System.Windows.Controls.Border
                        $chip.Background   = [Windows.Media.BrushConverter]::new().ConvertFrom($ChipBg)
                        $chip.CornerRadius = 4
                        $chip.Padding      = "7,3"
                        $chip.Margin       = "0,0,5,5"
                        $chipTb = New-Object System.Windows.Controls.TextBlock
                        $chipTb.Text        = $c
                        $chipTb.FontSize    = 10
                        $chipTb.TextWrapping= "Wrap"
                        $chipTb.Foreground  = [Windows.Media.BrushConverter]::new().ConvertFrom($ChipFg)
                        $chip.Child = $chipTb
                        $wrap.Children.Add($chip) | Out-Null
                    }
                    $stack.Children.Add($wrap) | Out-Null
                }

                $card.Child = $stack
                $ResultsPanel.Children.Add($card) | Out-Null
            })
        }

        # ── Scan helpers ──────────────────────────────────────────────────────

        function KL-SHA1 { param($p) (Get-FileHash $p -Algorithm SHA1).Hash }

        function KL-Source { param($p)
            $z = Get-Content -Raw -Stream Zone.Identifier $p -ErrorAction SilentlyContinue
            if ($z -match "HostUrl=(.+)") {
                $u = $matches[1].Trim()
                if ($u -match "mediafire\.com")                          { return "MediaFire" }
                if ($u -match "discord(app)?\.com|cdn\.discordapp\.com") { return "Discord" }
                if ($u -match "dropbox\.com")                            { return "Dropbox" }
                if ($u -match "drive\.google\.com")                      { return "Google Drive" }
                if ($u -match "mega\.(nz|co\.nz)")                       { return "MEGA" }
                if ($u -match "github\.com")                             { return "GitHub" }
                if ($u -match "modrinth\.com")                           { return "Modrinth" }
                if ($u -match "curseforge\.com")                         { return "CurseForge" }
                if ($u -match "prestigeclient\.vip")                     { return "PrestigeClient ⚠" }
                if ($u -match "dqrkis\.xyz")                             { return "Dqrkis ⚠" }
                if ($u -match "https?://(?:www\.)?([^/?]+)")             { return $matches[1] }
            }
            return $null
        }

        function KL-Modrinth { param($h)
            try {
                $vi = Invoke-RestMethod "https://api.modrinth.com/v2/version_file/$h" -UseBasicParsing -EA Stop
                if ($vi.project_id) {
                    $pi = Invoke-RestMethod "https://api.modrinth.com/v2/project/$($vi.project_id)" -UseBasicParsing -EA Stop
                    return @{ Name=$pi.title; Slug=$pi.slug }
                }
            } catch {}
            return @{ Name=""; Slug="" }
        }

        function KL-Megabase { param($h)
            try {
                $r = Invoke-RestMethod "https://megabase.vercel.app/api/query?hash=$h" -UseBasicParsing -EA Stop
                if (-not $r.error -and $r.data) { return $r.data }
            } catch {}
            return $null
        }

        function KL-ScanSigs { param($path)
            $pats = [System.Collections.Generic.HashSet[string]]::new()
            $strs = [System.Collections.Generic.HashSet[string]]::new()
            $fws  = [System.Collections.Generic.HashSet[string]]::new()
            try {
                $zip = [System.IO.Compression.ZipFile]::OpenRead($path)
                $all = [System.Collections.Generic.List[object]]::new()
                foreach ($e in $zip.Entries) { $all.Add($e) }
                foreach ($nj in ($zip.Entries | Where-Object { $_.FullName -match '^META-INF/jars/.+\.jar$' })) {
                    try {
                        $ns=$nj.Open(); $ms=New-Object System.IO.MemoryStream
                        $ns.CopyTo($ms); $ns.Close(); $ms.Position=0
                        $iz=[System.IO.Compression.ZipArchive]::new($ms)
                        foreach ($ie in $iz.Entries) { $all.Add($ie) }
                    } catch {}
                }
                foreach ($e in $all) {
                    foreach ($m in $patternRegex.Matches($e.FullName)) { [void]$pats.Add($m.Value) }
                    if ($e.FullName -match '\.(class|json)$|MANIFEST\.MF') {
                        try {
                            $st=$e.Open(); $ms2=New-Object System.IO.MemoryStream
                            $st.CopyTo($ms2); $st.Close()
                            $b=$ms2.ToArray(); $ms2.Dispose()
                            $a=[System.Text.Encoding]::ASCII.GetString($b)
                            $u8=[System.Text.Encoding]::UTF8.GetString($b)
                            foreach ($m in $patternRegex.Matches($a)) { [void]$pats.Add($m.Value) }
                            foreach ($s in $cheatStringSet) {
                                if ($a.Contains($s) -or $u8.Contains($s)) { [void]$strs.Add($s) }
                            }
                            foreach ($m in $fullwidthRegex.Matches($u8)) { [void]$fws.Add($m.Value) }
                        } catch {}
                    }
                }
                $zip.Dispose()
            } catch {}
            # Resolve fullwidth matches to canonical cheat-string names
            $pool = @($cheatStrings | Where-Object { $_ -cmatch '[\uFF21-\uFF3A\uFF41-\uFF5A\uFF10-\uFF19]' })
            $res  = [System.Collections.Generic.HashSet[string]]::new()
            foreach ($f in @($fws)) {
                if ($f.Length -lt 3) { continue }
                $best = $null
                foreach ($cs in $pool) {
                    if ($cs.Contains($f) -and ($null -eq $best -or $cs.Length -lt $best.Length)) { $best = $cs }
                }
                if ($null -ne $best) { [void]$res.Add($best) } elseif ($f.Length -ge 6) { [void]$res.Add($f) }
            }
            $ra    = @($res)
            $final = [System.Collections.Generic.HashSet[string]]::new()
            foreach ($f in $ra) {
                $red = $false
                foreach ($o in $ra) { if ($f.Length -lt $o.Length -and $o.Contains($f)) { $red=$true; break } }
                if (-not $red) { [void]$final.Add($f) }
            }
            return @{ P=$pats; S=$strs; FW=$final }
        }

        function KL-ScanBypass { param($path)
            $flags   = [System.Collections.Generic.List[string]]::new()
            $mvnPfx  = @("com_","org_","net_","io_","dev_","gs_","xyz_","app_","me_","tv_","uk_","be_","fr_","de_")
            $legitIds= @("vmp-fabric","vmp","lithium","sodium","iris","fabric-api","modmenu",
                         "ferrite-core","lazydfu","starlight","entityculling","memoryleakfix",
                         "krypton","c2me-fabric","smoothboot-fabric","immediatelyfast","noisium","threadtweak")
            try {
                $zip    = [System.IO.Compression.ZipFile]::OpenRead($path)
                $nested = @($zip.Entries | Where-Object { $_.FullName -match '^META-INF/jars/.+\.jar$' })
                $outer  = @($zip.Entries | Where-Object { $_.FullName -match '\.class$' })

                foreach ($nj in $nested) {
                    $nb = [System.IO.Path]::GetFileName($nj.FullName)
                    $b  = [System.IO.Path]::GetFileNameWithoutExtension($nb)
                    $susp = -not ($b -match '\d') -and $b.Length -le 20
                    foreach ($px in $mvnPfx) { if ($b.ToLower().StartsWith($px)) { $susp = $false } }
                    if ($susp) { $flags.Add("Suspicious nested JAR — unversioned / unknown dep: $nb") }
                }
                if ($nested.Count -eq 1 -and $outer.Count -lt 3) {
                    $flags.Add("Hollow shell — $($outer.Count) own class(es), wraps: $([IO.Path]::GetFileName(($nested|Select -First 1).FullName))")
                }

                $modId = ""
                $fmj = $zip.Entries | Where-Object { $_.FullName -eq "fabric.mod.json" } | Select-Object -First 1
                if ($fmj) {
                    try {
                        $t = (New-Object System.IO.StreamReader($fmj.Open())).ReadToEnd()
                        if ($t -match '"id"\s*:\s*"([^"]+)"') { $modId = $matches[1] }
                    } catch {}
                }

                $all = [System.Collections.Generic.List[object]]::new()
                foreach ($e in $zip.Entries) { $all.Add($e) }
                $innerZ = [System.Collections.Generic.List[object]]::new()
                foreach ($nj in $nested) {
                    try {
                        $ns=$nj.Open(); $ms=New-Object System.IO.MemoryStream
                        $ns.CopyTo($ms); $ns.Close(); $ms.Position=0
                        $iz=[System.IO.Compression.ZipArchive]::new($ms); $innerZ.Add($iz)
                        foreach ($ie in $iz.Entries) { $all.Add($ie) }
                    } catch {}
                }

                $rtExec=$false; $httpDl=$false; $httpEx=$false
                $obfN=0; $numN=0; $uniN=0; $totN=0

                foreach ($e in $all) {
                    if ($e.FullName -match '\.class$') {
                        $totN++
                        $cn = [IO.Path]::GetFileNameWithoutExtension(($e.FullName -split '/')[-1])
                        if ($cn -match '^\d+$')       { $numN++ }
                        if ($cn -match '[^\x00-\x7F]') { $uniN++ }
                        $sg=$( ($e.FullName -replace '\.class$','') -split '/' )
                        $cs=0; $mx=0
                        foreach ($s in $sg) { if ($s.Length -eq 1) { $cs++; if ($cs -gt $mx){$mx=$cs} } else { $cs=0 } }
                        if ($mx -ge 3) { $obfN++ }
                        try {
                            $st=$e.Open(); $ms2=New-Object System.IO.MemoryStream
                            $st.CopyTo($ms2); $st.Close()
                            $ct=[System.Text.Encoding]::ASCII.GetString($ms2.ToArray()); $ms2.Dispose()
                            if ($ct -match 'java/lang/Runtime' -and $ct -match 'getRuntime' -and $ct -match '\bexec\b') { $rtExec=$true }
                            if ($ct -match 'openConnection' -and $ct -match 'HttpURLConnection' -and $ct -match 'FileOutputStream') { $httpDl=$true }
                            if ($ct -match 'openConnection' -and $ct -match 'setDoOutput' -and $ct -match 'getOutputStream' -and $ct -match 'getProperty') { $httpEx=$true }
                        } catch {}
                    }
                }
                foreach ($iz in $innerZ) { try { $iz.Dispose() } catch {} }
                $zip.Dispose()

                $obfP = if ($totN -ge 10) { [math]::Round($obfN/$totN*100) } else { 0 }
                $numP = if ($totN -ge 5)  { [math]::Round($numN/$totN*100) } else { 0 }
                $uniP = if ($totN -ge 5)  { [math]::Round($uniN/$totN*100) } else { 0 }

                if ($rtExec -and $obfP -ge 25) { $flags.Add("Runtime.exec() in obfuscated code — can run arbitrary OS commands") }
                if ($httpDl)    { $flags.Add("HTTP file download — fetches and writes files from a remote server at runtime") }
                if ($httpEx)    { $flags.Add("HTTP POST exfiltration — sends system data to an external server") }
                if ($totN -ge 10 -and $obfP -ge 25) { $flags.Add("Heavy path obfuscation — $obfP% of classes use single-letter segments (a/b/c)") }
                if ($numP -ge 20) { $flags.Add("Numeric class names — $numP% of classes are numbered (e.g. 1234.class)") }
                if ($uniP -ge 10) { $flags.Add("Non-ASCII class names — $uniP% of classes use Unicode identifiers") }

                if ($modId -and ($legitIds -contains $modId) -and
                    ($flags | Where-Object { $_ -match 'Runtime|HTTP|Heavy|Suspicious' }).Count -gt 0) {
                    $flags.Add("Fake mod identity — claims to be '$modId' but contains dangerous code")
                }
            } catch {}
            return $flags
        }

        function KL-ScanObf { param($path)
            $flags = [System.Collections.Generic.List[string]]::new()
            try {
                $zip = [System.IO.Compression.ZipFile]::OpenRead($path)
                $tot=0;$num=0;$uni=0;$fw=0;$jp=0;$s1=0;$s2=0;$gib=0;$nov=0;$conf=0;$spkg=0
                $sample=[System.Text.StringBuilder]::new(); $ssz=0
                $obfuscators = @{
                    "Skidfuscator"   = @("dev/skidfuscator","Skidfuscator","skidfuscator.dev")
                    "Paramorphism"   = @("Paramorphism","paramorphism-","dev/paramorphism")
                    "Radon"          = @("ItzSomebody/Radon","me/itzsomebody/radon","Radon Obfuscator")
                    "Caesium"        = @("sim0n/Caesium","Caesium Obfuscator","dev/sim0n/caesium")
                    "Bozar"          = @("vimasig/Bozar","Bozar Obfuscator","com/bozar")
                    "Branchlock"     = @("Branchlock","branchlock.dev")
                    "Binscure"       = @("Binscure","com/binscure")
                    "SuperBlaubeere" = @("superblaubeere","superblaubeere27")
                    "Qprotect"       = @("Qprotect","QProtect","mdma.dev/qprotect")
                    "Zelix"          = @("ZKMFLOW","ZKM","ZelixKlassMaster","com/zelix")
                    "Stringer"       = @("StringerJavaObfuscator","com/licel/stringer")
                    "JNIC"           = @("JNIC","jnic.obf","jnic-obfuscator")
                    "Scuti"          = @("ScutiObf","scuti.obf")
                    "Smoke"          = @("SmokeObf","smoke.obf")
                }
                foreach ($e in $zip.Entries) {
                    if ($e.FullName -match '\.class$') {
                        $tot++
                        $cn=[IO.Path]::GetFileNameWithoutExtension(($e.FullName -split '/')[-1])
                        if ($cn -match '^\d+$')  { $num++ }
                        if ($cn -match '[^\x00-\x7F]') { $uni++ }
                        if ($cn -match '[\uFF21-\uFF3A\uFF41-\uFF5A\uFF10-\uFF19]') { $fw++ }
                        if ($cn -match '[\u3040-\u309F\u30A0-\u30FF]') { $jp++ }
                        if ($cn -match '^[a-zA-Z]$')   { $s1++ }
                        if ($cn -match '^[a-zA-Z]{2}$') { $s2++ }
                        if ($cn -match '^[Il1O0]+$|^[_]+$') { $conf++ }
                        if ($cn.Length -ge 3 -and $cn.Length -le 8 -and $cn -match '^[a-zA-Z]+$') {
                            $v=($cn.ToCharArray()|Where-Object{$_ -match '[aeiouAEIOU]'}).Count
                            if ($v -eq 0) { $nov++ }
                            if ($cn -match '[bcdfghjklmnpqrstvwxyzBCDFGHJKLMNPQRSTVWXYZ]{3,}' -and $v/$cn.Length -lt 0.3) { $gib++ }
                        }
                        $segs=(($e.FullName -replace '\.class$','') -split '/')
                        foreach ($sg in $segs[0..([math]::Max(0,$segs.Count-2))]) { if ($sg.Length -eq 1) { $spkg++ } }
                        if ($ssz -lt 150000 -and $e.Length -lt 100000 -and $e.Length -gt 100) {
                            try {
                                $st=$e.Open(); $ms=New-Object System.IO.MemoryStream
                                $st.CopyTo($ms); $st.Close()
                                $a=[System.Text.Encoding]::ASCII.GetString($ms.ToArray()); $ms.Dispose()
                                [void]$sample.Append($a); $ssz+=$a.Length
                            } catch {}
                        }
                    }
                }
                $zip.Dispose()
                if ($tot -lt 5) { return $flags }
                $P = { param($n) if ($tot -gt 0) { [math]::Round($n/$tot*100) } else { 0 } }
                if ((& $P $num) -ge 20) { $flags.Add("Numeric class names — $(& $P $num)% of classes have numeric-only names") }
                if ((& $P $uni) -ge 10) { $flags.Add("Non-ASCII class names — $(& $P $uni)% of classes use non-ASCII identifiers") }
                if ($fw -gt 0)          { $flags.Add("Fullwidth Unicode class names — $(& $P $fw)% use ａｂｃ / ＡＢＣ / ０１２ chars ($fw classes)") }
                if ($jp -gt 0)          { $flags.Add("Japanese obfuscation — $(& $P $jp)% use hiragana or katakana class names ($jp classes)") }
                if ((& $P $s1) -ge 15)  { $flags.Add("Single-letter class names — $(& $P $s1)% ($s1 classes)") }
                if ((& $P $s2) -ge 20)  { $flags.Add("Two-letter class names — $(& $P $s2)% ($s2 classes)") }
                if ((& $P $gib) -ge 5)  { $flags.Add("Gibberish class names — $(& $P $gib)% consonant clusters / no vowels ($gib classes)") }
                if ((& $P $nov) -ge 8)  { $flags.Add("No-vowel class names — $(& $P $nov)% ($nov classes)") }
                if ((& $P $conf) -ge 3) { $flags.Add("Confusion-char names (Il1O0 / _) — $(& $P $conf)% ($conf classes)") }
                if ($spkg -ge 6)        { $flags.Add("Single-char package paths — $spkg path segments (a/b/c style)") }
                $fwm=[regex]::Matches($sample.ToString(),'[\uFF21-\uFF3A\uFF41-\uFF5A\uFF10-\uFF19]{2,}')
                if ($fwm.Count -gt 0) {
                    $ex=($fwm|Select -First 3|ForEach-Object{$_.Value})-join", "
                    $flags.Add("Fullwidth strings in bytecode — $($fwm.Count) occurrences (e.g. $ex)")
                }
                $ss=$sample.ToString()
                foreach ($on in $obfuscators.Keys) {
                    foreach ($op in $obfuscators[$on]) {
                        if ($ss.Contains($op)) { $flags.Add("Known cheat obfuscator detected — $on (matched '$op')"); break }
                    }
                }
            } catch {}
            return $flags
        }

        function KL-ScanJvm {
            $r = [System.Collections.Generic.List[string]]::new()
            $jp = Get-Process javaw -EA SilentlyContinue
            if (-not $jp) { $jp = Get-Process java -EA SilentlyContinue }
            if (-not $jp) { return $r }
            $pid0 = ($jp | Select-Object -First 1).Id
            try {
                $w = Get-WmiObject Win32_Process -Filter "ProcessId = $pid0" -EA Stop
                $cmd = $w.CommandLine
                if ($cmd) {
                    foreach ($m in [regex]::Matches($cmd, '-javaagent:([^\s"]+)')) {
                        $ap = $m.Groups[1].Value.Trim('"').Trim("'")
                        $an = [IO.Path]::GetFileName($ap)
                        $legit = @("jmxremote","yjp","jrebel","newrelic","jacoco","theseus")
                        if (-not ($legit | Where-Object { $an -match $_ })) {
                            $r.Add("JVM agent — -javaagent:$an  (full path: $ap)")
                        }
                    }
                    @(
                        @{F="-Xbootclasspath/p:"; D="prepends to bootstrap classpath — can override core Java classes"},
                        @{F="-Xbootclasspath/a:"; D="appends to bootstrap classpath — injects code below the classloader"},
                        @{F="-agentlib:jdwp";     D="JDWP debug agent active — remote debugging is enabled"},
                        @{F="-agentpath:";         D="native agent loaded — bypasses the Java security sandbox"}
                    ) | ForEach-Object {
                        if ($cmd -match [regex]::Escape($_.F)) {
                            $r.Add("Suspicious JVM flag — $($_.F)  $($_.D)")
                        }
                    }
                }
            } catch {}
            return $r
        }


        # ══════════════════════════════════════════════════════════════════════
        #  MAIN SCAN
        # ══════════════════════════════════════════════════════════════════════

        try {
            $jars = Get-ChildItem $modsPath -Filter *.jar -EA Stop
            if ($jars.Count -eq 0) {
                KL-Status "No JARs found" "That folder has no .jar files." "IDLE"
                KL-Log "No .jar files in $modsPath"
                $dispatcher.Invoke([Action]{ $ScanBtn.IsEnabled = $true })
                $rs.Close(); return
            }
            KL-Log "Found $($jars.Count) JAR(s) in $modsPath"

            # ── JVM check (updates sidebar panel) ──────────────────────────
            KL-Status "Scanning" "Checking JVM runtime…" "SCANNING"
            $jvmFlags = KL-ScanJvm
            $jp2 = Get-Process javaw -EA SilentlyContinue
            if (-not $jp2) { $jp2 = Get-Process java -EA SilentlyContinue }
            if ($jp2) {
                $p0 = $jp2 | Select-Object -First 1
                $up = (Get-Date) - $p0.StartTime
                $dispatcher.Invoke([Action]{
                    $JvmDot.Fill         = [Windows.Media.BrushConverter]::new().ConvertFrom("#00E5A8")
                    $JvmStatusLine.Text  = "$($p0.Name)  ·  PID $($p0.Id)"
                    $JvmUptimeLine.Text  = "Uptime  $($up.Hours)h $($up.Minutes)m $($up.Seconds)s"
                    $JvmStartedLine.Text = "Started $($p0.StartTime.ToString('HH:mm:ss'))"
                })
                if ($jvmFlags.Count -gt 0) {
                    KL-Log "  JVM: $($jvmFlags.Count) suspicious flag(s) found on PID $($p0.Id)"
                } else {
                    KL-Log "  JVM: PID $($p0.Id) looks clean"
                }
            } else {
                KL-Log "  JVM: no Java process detected"
            }

            # ── Pass 1 — Hash verification ────────────────────────────────
            KL-Status "Scanning" "Pass 1/4 — Hash verification (Modrinth + Megabase)…" "SCANNING"
            KL-Log "Pass 1 — Hash verification"

            $verified = @(); $remaining = @()

            foreach ($jar in $jars) {
                KL-Log "  Hash: $($jar.Name)"
                $h = KL-SHA1 $jar.FullName
                $ok = $false
                if ($h) {
                    $mr = KL-Modrinth $h
                    if ($mr.Slug) {
                        $verified += [PSCustomObject]@{ Label=$mr.Name; File=$jar.Name; Path=$jar.FullName }
                        $ok = $true
                    }
                    if (-not $ok) {
                        $mb = KL-Megabase $h
                        if ($mb -and $mb.name) {
                            $verified += [PSCustomObject]@{ Label=$mb.name; File=$jar.Name; Path=$jar.FullName }
                            $ok = $true
                        }
                    }
                }
                if (-not $ok) {
                    $remaining += [PSCustomObject]@{
                        File   = $jar.Name
                        Path   = $jar.FullName
                        Source = (KL-Source $jar.FullName)
                    }
                }
            }
            KL-Log "  Verified: $($verified.Count)  |  To deep-scan: $($remaining.Count)"

            # ── Pass 2 — Signature scan (unverified only) ─────────────────
            KL-Status "Scanning" "Pass 2/4 — Signature scan…" "SCANNING"
            KL-Log "Pass 2 — Cheat-signature scan"

            $flagged = @(); $stillUnknown = @()

            foreach ($u in $remaining) {
                KL-Log "  Sigs: $($u.File)"
                $r = KL-ScanSigs $u.Path
                if ($r.P.Count -gt 0 -or $r.S.Count -gt 0 -or $r.FW.Count -gt 0) {
                    $tags = @(@($r.P) + @($r.S) + @($r.FW) | Select-Object -Unique)
                    $flagged += [PSCustomObject]@{ File=$u.File; Tags=$tags }
                } else {
                    $stillUnknown += $u
                }
            }
            KL-Log "  Flagged: $($flagged.Count)  |  Remaining: $($stillUnknown.Count)"

            # ── Pass 3 — Bypass / injection scan ─────────────────────────
            KL-Status "Scanning" "Pass 3/4 — Bypass detection…" "SCANNING"
            KL-Log "Pass 3 — Bypass / injection scan"

            $bypass = @(); $afterBypass = @()

            foreach ($u in $stillUnknown) {
                KL-Log "  Bypass: $($u.File)"
                $bf = KL-ScanBypass $u.Path
                if ($bf.Count -gt 0) {
                    $bypass += [PSCustomObject]@{ File=$u.File; Flags=$bf }
                } else {
                    $afterBypass += $u
                }
            }
            KL-Log "  Bypass flagged: $($bypass.Count)  |  Remaining: $($afterBypass.Count)"

            # ── Pass 4 — Obfuscation scan ──────────────────────────────────
            KL-Status "Scanning" "Pass 4/4 — Obfuscation analysis…" "SCANNING"
            KL-Log "Pass 4 — Obfuscation scan"

            $obfuscated = @(); $unknown = @()

            foreach ($u in $afterBypass) {
                KL-Log "  Obf: $($u.File)"
                $of = KL-ScanObf $u.Path
                if ($of.Count -gt 0) {
                    $obfuscated += [PSCustomObject]@{ File=$u.File; Flags=$of }
                } else {
                    $unknown += $u
                }
            }
            KL-Log "  Obfuscated: $($obfuscated.Count)  |  Unknown (clean, unverified): $($unknown.Count)"

            # ── Render results ────────────────────────────────────────────
            $dispatcher.Invoke([Action]{ $ResultsPanel.Children.Clear() })

            if ($verified.Count -gt 0) {
                KL-AddSection "VERIFIED" $verified.Count "#00E5A8"
                foreach ($v in $verified) {
                    KL-AddCard "$($v.Label)  →  $($v.File)" "VERIFIED" "#00E5A8" "#097A5B"
                }
            }

            if ($unknown.Count -gt 0) {
                KL-AddSection "UNKNOWN" $unknown.Count "#FFBB44"
                foreach ($u in $unknown) {
                    $note = if ($u.Source) { "Downloaded from: $($u.Source)" } else { "Not in Modrinth or Megabase — source unknown" }
                    KL-AddCard $u.File "UNKNOWN" "#FFBB44" "#6B4C10" -SubNote $note
                }
            }

            if ($obfuscated.Count -gt 0) {
                KL-AddSection "OBFUSCATED" $obfuscated.Count "#FF8A50"
                foreach ($o in $obfuscated) {
                    KL-AddCard $o.File "OBFUSCATED" "#FF8A50" "#7A3A14" `
                        -Chips $o.Flags -ChipBg "#1A0D06" -ChipFg "#FFA870"
                }
            }

            if ($bypass.Count -gt 0) {
                KL-AddSection "BYPASS / INJECTION" $bypass.Count "#C97DFF"
                foreach ($b in $bypass) {
                    KL-AddCard $b.File "BYPASS" "#C97DFF" "#5C1E8A" `
                        -Chips $b.Flags -ChipBg "#180D2A" -ChipFg "#D8A8FF"
                }
            }

            if ($flagged.Count -gt 0) {
                KL-AddSection "FLAGGED  ─  CHEAT SIGNATURES" $flagged.Count "#FF4D6B"
                foreach ($f in $flagged) {
                    KL-AddCard $f.File "FLAGGED" "#FF4D6B" "#7A1428" `
                        -Chips $f.Tags -ChipBg "#1F060C" -ChipFg "#FF7D8F"
                }
            }

            if ($jvmFlags.Count -gt 0) {
                KL-AddSection "JVM / RUNTIME ISSUES" $jvmFlags.Count "#FFD45C"
                KL-AddCard "javaw  ·  live process" "JVM" "#FFD45C" "#7A5C10" `
                    -Chips $jvmFlags -ChipBg "#1F1800" -ChipFg "#FFE080"
            }

            # ── Update stats ──────────────────────────────────────────────
            $totIssues = $flagged.Count + $bypass.Count + $obfuscated.Count + $jvmFlags.Count
            $dispatcher.Invoke([Action]{
                $StatFiles.Text    = "Files: $($jars.Count)"
                $StatVerified.Text = "Verified: $($verified.Count)"
                $StatUnknown.Text  = "Unknown: $($unknown.Count)"
                $StatFlagged.Text  = "Flagged: $($flagged.Count)"
                $StatBypass.Text   = "Bypass: $($bypass.Count)"
                $StatObf.Text      = "Obfuscated: $($obfuscated.Count)"
                $StatJvm.Text      = "JVM Issues: $($jvmFlags.Count)"
            })

            KL-Log "Scan complete — $totIssues issue(s) across $($jars.Count) file(s)."
            if ($totIssues -gt 0) {
                KL-Status "Scan complete" "$($jars.Count) files scanned  ·  $totIssues issue(s) found" "DONE"
            } else {
                KL-Status "All clear" "$($jars.Count) files scanned  ·  no issues detected" "CLEAN"
            }

        } catch {
            KL-Log "Fatal error: $_"
            KL-Status "Error" "Scan failed — see log for details." "ERR"
        }

        $dispatcher.Invoke([Action]{ $ScanBtn.IsEnabled = $true })
        $rs.Close()
    })

    $null = $ps.BeginInvoke()
})


# ── Initial state ─────────────────────────────────────────────────────────────

function Write-KLLog { param($m)
    $LogBox.AppendText("[$(Get-Date -f 'HH:mm:ss')] $m`r`n")
    $LogBox.ScrollToEnd()
}

Write-KLLog "KettehLyzer v2 ready  ·  KettehTools"
Update-KLJvmPanel

$window.ShowDialog() | Out-Null
$jvmTimer.Stop()
