
    KETTEHLYZER v2.2
    Minecraft Mod Security Analyzer
    No GUI - Pure Terminal

    Features:
      - Terminal-only operation (no WPF / WinForms)
      - Hash verification against Modrinth + Megabase
      - Cheat signature / string scanning
      - Bypass / injection scanning
      - Obfuscation scanning
      - Nested JAR scanning
      - Automatic Minecraft javaw.exe detection
      - Java runtime / uptime display
      - Sensitive JVM argument redaction
      - Shows exact cheat strings/signatures found in flagged mods

param(
    [string]$ModsPath = "",
    [switch]$DeepScanAll,
    [switch]$NoPause
)

$ErrorActionPreference = "SilentlyContinue"


function KL-Write {
    param(
        [string]$Text = "",
        [ConsoleColor]$Color = [ConsoleColor]::Gray
    )
    Write-Host $Text -ForegroundColor $Color
}

function KL-Line {
    KL-Write "----------------------------------------------------------------" DarkGray
}

function KL-Header {
    param([string]$Text)
    KL-Write ""
    KL-Write "================================================================" DarkCyan
    KL-Write " $Text" Cyan
    KL-Write "================================================================" DarkCyan
}

function KL-Info {
    param([string]$Text)
    KL-Write "[$(Get-Date -Format 'HH:mm:ss')] $Text" Gray
}

function KL-Good {
    param([string]$Text)
    KL-Write "[$(Get-Date -Format 'HH:mm:ss')] $Text" Green
}

function KL-Warn {
    param([string]$Text)
    KL-Write "[$(Get-Date -Format 'HH:mm:ss')] $Text" Yellow
}

function KL-Bad {
    param([string]$Text)
    KL-Write "[$(Get-Date -Format 'HH:mm:ss')] $Text" Red
}

function KL-HeaderBanner {
    Clear-Host

    KL-Write ""
    KL-Write " ██╗  ██╗███████╗████████╗████████╗███████╗██╗  ██╗" Cyan
    KL-Write " ██║ ██╔╝██╔════╝╚══██╔══╝╚══██╔══╝██╔════╝██║  ██║" Cyan
    KL-Write " █████╔╝ █████╗     ██║      ██║   █████╗  ███████║" Cyan
    KL-Write " ██╔═██╗ ██╔══╝     ██║      ██║   ██╔══╝  ██╔══██║" Cyan
    KL-Write " ██║  ██╗███████╗   ██║      ██║   ███████╗██║  ██║" Cyan
    KL-Write " ╚═╝  ╚═╝╚══════╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝" Cyan
    KL-Write ""
    KL-Write "                  KETTEHLYZER v2.2" Yellow
    KL-Write "           Minecraft Mod Security Analyzer" White
    KL-Write "               No GUI • Pure Terminal" DarkGray
    KL-Write ""
}


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

$cheatStrings = @($cheatStrings | Where-Object { $_ } | Select-Object -Unique)
$suspiciousPatterns = @($suspiciousPatterns | Where-Object { $_ } | Select-Object -Unique)

$patternRegex = @(
    $suspiciousPatterns |
        ForEach-Object { [regex]::Escape($_) } |
        Sort-Object Length -Descending
) -join '|'

$fullwidthRegex = [regex]'[\uFF01-\uFF5E]'

$cheatStringSet = @{}
foreach ($s in $cheatStrings) {
    $cheatStringSet[$s.ToLowerInvariant()] = $true
}


function KL-NormalizeText {
    param([string]$Text)

    if ([string]::IsNullOrEmpty($Text)) {
        return ""
    }

    $t = $Text.Replace([char]0, ' ')

    $chars = $t.ToCharArray()
    for ($i = 0; $i -lt $chars.Length; $i++) {
        $n = [int][char]$chars[$i]
        if ($n -ge 0xFF01 -and $n -le 0xFF5E) {
            $chars[$i] = [char]($n - 0xFEE0)
        }
    }

    return (-join $chars)
}


function Get-KLJavaProcesses {
    $procs = @()

    try {
        $procs = @(
            Get-CimInstance Win32_Process `
                -Filter "Name='javaw.exe' OR Name='java.exe'" `
                -ErrorAction SilentlyContinue
        )
    } catch {}

    foreach ($p in $procs) {
        $cmd = [string]$p.CommandLine
        $isMinecraft = $false

        if ($cmd -match '(?i)net\.fabricmc\.loader|KnotClient|net\.minecraft\.client\.main\.Main|com\.modrinth\.theseus\.MinecraftLaunch') {
            $isMinecraft = $true
        }

        $start = $null

        try {
            if ($p.CreationDate) {
                $start = [Management.ManagementDateTimeConverter]::ToDateTime($p.CreationDate)
            }
        } catch {}

        if (-not $start) {
            try {
                $start = (Get-Process -Id $p.ProcessId -ErrorAction Stop).StartTime
            } catch {}
        }

        [pscustomobject]@{
            ProcessId   = [int]$p.ProcessId
            Name        = [string]$p.Name
            CommandLine = $cmd
            StartTime   = $start
            IsMinecraft = $isMinecraft
        }
    }
}

function Format-KLUptime {
    param([datetime]$StartTime)

    if (-not $StartTime) {
        return "Unknown"
    }

    $span = (Get-Date) - $StartTime

    if ($span.TotalSeconds -lt 0) {
        return "Unknown"
    }

    return ('{0:00}d {1:00}h {2:00}m {3:00}s' -f `
        [int]$span.TotalDays,
        $span.Hours,
        $span.Minutes,
        $span.Seconds)
}

function KL-RedactCommandLine {
    param([string]$CommandLine)

    if ([string]::IsNullOrWhiteSpace($CommandLine)) {
        return ""
    }

    $safe = $CommandLine

    $patterns = @(
        '(?i)(--accessToken(?:=|\s+))("[^"]*"|\S+)',
        '(?i)(--access-token(?:=|\s+))("[^"]*"|\S+)',
        '(?i)(--refreshToken(?:=|\s+))("[^"]*"|\S+)',
        '(?i)(--refresh-token(?:=|\s+))("[^"]*"|\S+)',
        '(?i)(--clientSecret(?:=|\s+))("[^"]*"|\S+)',
        '(?i)(--client-secret(?:=|\s+))("[^"]*"|\S+)',
        '(?i)(--password(?:=|\s+))("[^"]*"|\S+)',
        '(?i)(--token(?:=|\s+))("[^"]*"|\S+)',
        '(?i)(accessToken\s*=\s*)("[^"]*"|\S+)',
        '(?i)(access_token\s*=\s*)("[^"]*"|\S+)',
        '(?i)(refreshToken\s*=\s*)("[^"]*"|\S+)',
        '(?i)(authorization\s*:\s*)(Bearer\s+)?\S+',
        '(?i)(Bearer\s+)\S+'
    )

    foreach ($pattern in $patterns) {
        try {
            $safe = [regex]::Replace($safe, $pattern, '$1[REDACTED]')
        } catch {}
    }

    $safe = [regex]::Replace(
        $safe,
        '(?<![A-Za-z0-9_-])eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+',
        '[REDACTED-JWT]'
    )

    return $safe
}

function Get-KLJavaRuntime {
    $all = @(Get-KLJavaProcesses)

    if (-not $all) {
        return @()
    }

    $minecraft = @($all | Where-Object { $_.IsMinecraft })

    if ($minecraft.Count -gt 0) {
        $selected = $minecraft |
            Sort-Object StartTime -Descending |
            Select-Object -First 1
    } else {
        $selected = $all |
            Sort-Object StartTime -Descending |
            Select-Object -First 1
    }

    foreach ($p in $all) {
        $uptime = if ($p.StartTime) {
            Format-KLUptime $p.StartTime
        } else {
            "Unknown"
        }

        $type = if ($p.IsMinecraft) {
            "MINECRAFT"
        } elseif ($p.ProcessId -eq $selected.ProcessId) {
            "JAVA"
        } else {
            "JAVA HELPER"
        }

        [pscustomobject]@{
            PID         = $p.ProcessId
            Process     = $p.Name
            Started     = $p.StartTime
            Uptime      = $uptime
            IsMinecraft = $p.IsMinecraft
            Type        = $type
            CommandLine = KL-RedactCommandLine $p.CommandLine
            Selected    = ($p.ProcessId -eq $selected.ProcessId)
        }
    }
}

function Show-KLJavaRuntime {
    $items = @(Get-KLJavaRuntime)

    KL-Header "CURRENT JAVA RUNTIME"

    if (-not $items) {
        KL-Warn "No javaw.exe/java.exe process found."
        return
    }

    foreach ($j in $items) {
        $labelColor = if ($j.IsMinecraft) { "Green" } else { "Gray" }

        KL-Write ""
        KL-Write " Process : $($j.Process)" $labelColor
        KL-Write " PID     : $($j.PID)" White
        KL-Write " Type    : $($j.Type)" $labelColor

        if ($j.Started) {
            KL-Write (" Started : {0}" -f $j.Started.ToString("yyyy-MM-dd HH:mm:ss")) White
        } else {
            KL-Write " Started : Unknown" Yellow
        }

        KL-Write " Uptime  : $($j.Uptime)" White
        KL-Write " Status  : RUNNING" Green

        if ($j.Selected) {
            KL-Write " Selected: YES" Cyan
        }
    }

    $selected = $items | Where-Object { $_.Selected } | Select-Object -First 1

    if ($selected -and $selected.CommandLine) {
        KL-Write ""
        KL-Write " Command Line (sensitive values redacted):" DarkCyan
        KL-Write "   $($selected.CommandLine)" DarkGray
    }

    KL-Write ""
    KL-Write " Authentication tokens, JWTs, passwords, secrets and bearer" Yellow
    KL-Write " credentials are automatically redacted from the output." Yellow
}


function KL-SHA1 {
    param([string]$Path)

    try {
        $sha1 = [System.Security.Cryptography.SHA1]::Create()

        try {
            $stream = [System.IO.File]::OpenRead($Path)

            try {
                $hash = $sha1.ComputeHash($stream)
            } finally {
                $stream.Dispose()
            }
        } finally {
            $sha1.Dispose()
        }

        return ([BitConverter]::ToString($hash) -replace '-', '').ToLowerInvariant()
    } catch {
        return $null
    }
}

function KL-GetJarEntries {
    param([string]$JarPath)

    $entries = @()

    try {
        Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction SilentlyContinue

        $zip = [System.IO.Compression.ZipFile]::OpenRead($JarPath)

        try {
            foreach ($entry in $zip.Entries) {
                if (-not [string]::IsNullOrWhiteSpace($entry.FullName)) {
                    $entries += $entry
                }
            }
        } finally {
            $zip.Dispose()
        }
    } catch {}

    return $entries
}

function KL-ReadZipEntryText {
    param(
        $Entry,
        [int]$MaxBytes = 5242880
    )

    try {
        $stream = $Entry.Open()

        try {
            $ms = New-Object System.IO.MemoryStream
            try {
                $buffer = New-Object byte[] 65536
                $total = 0

                while (($read = $stream.Read($buffer, 0, $buffer.Length)) -gt 0) {
                    $remaining = $MaxBytes - $total
                    if ($remaining -le 0) { break }

                    $take = [Math]::Min($read, $remaining)
                    $ms.Write($buffer, 0, $take)
                    $total += $take

                    if ($total -ge $MaxBytes) { break }
                }

                return [System.Text.Encoding]::UTF8.GetString($ms.ToArray())
            } finally {
                $ms.Dispose()
            }
        } finally {
            $stream.Dispose()
        }
    } catch {
        return ""
    }
}

function KL-ReadZipEntryBytes {
    param(
        $Entry,
        [int]$MaxBytes = 5242880
    )

    try {
        $stream = $Entry.Open()

        try {
            $ms = New-Object System.IO.MemoryStream
            try {
                $buffer = New-Object byte[] 65536
                $total = 0

                while (($read = $stream.Read($buffer, 0, $buffer.Length)) -gt 0) {
                    $remaining = $MaxBytes - $total
                    if ($remaining -le 0) { break }

                    $take = [Math]::Min($read, $remaining)
                    $ms.Write($buffer, 0, $take)
                    $total += $take

                    if ($total -ge $MaxBytes) { break }
                }

                return $ms.ToArray()
            } finally {
                $ms.Dispose()
            }
        } finally {
            $stream.Dispose()
        }
    } catch {
        return @()
    }
}


function KL-ScanSigs {
    param([string]$JarPath)

    $pats = New-Object System.Collections.Generic.List[string]
    $strs = New-Object System.Collections.Generic.List[string]
    $filesHit = New-Object System.Collections.Generic.List[string]

    $entries = @(KL-GetJarEntries $JarPath)

    $scanEntries = @($entries)

    foreach ($outer in $entries) {
        if ($outer.FullName -match '(?i)(^|/)META-INF/jars/.+\.jar$') {
            try {
                $bytes = KL-ReadZipEntryBytes $outer 52428800
                if ($bytes.Count -gt 0) {
                    $ms = New-Object System.IO.MemoryStream(,$bytes)
                    $nestedZip = [System.IO.Compression.ZipArchive]::new(
                        $ms,
                        [System.IO.Compression.ZipArchiveMode]::Read,
                        $false
                    )

                    foreach ($nested in $nestedZip.Entries) {
                        if ($nested.FullName -and -not $nested.FullName.EndsWith('/')) {
                            $text = KL-ReadZipEntryText $nested 5242880

                            if ($text) {
                                foreach ($m in [regex]::Matches(
                                    $text,
                                    $patternRegex,
                                    [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
                                )) {
                                    $value = $m.Value
                                    if (-not $pats.Contains($value)) {
                                        [void]$pats.Add($value)
                                    }
                                }

                                $normalized = KL-NormalizeText $text

                                foreach ($s in $cheatStrings) {
                                    if ($normalized.IndexOf(
                                        $s,
                                        [System.StringComparison]::OrdinalIgnoreCase
                                    ) -ge 0) {
                                        if (-not $strs.Contains($s)) {
                                            [void]$strs.Add($s)
                                        }
                                    }
                                }

                                if ($fullwidthRegex.IsMatch($text)) {
                                    $resolved = KL-NormalizeText $text

                                    foreach ($s in $cheatStrings) {
                                        if ($resolved.IndexOf(
                                            $s,
                                            [System.StringComparison]::OrdinalIgnoreCase
                                        ) -ge 0) {
                                            if (-not $strs.Contains($s)) {
                                                [void]$strs.Add($s)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    $nestedZip.Dispose()
                    $ms.Dispose()
                }
            } catch {}
        }
    }

    foreach ($entry in $entries) {
        if ($entry.FullName.EndsWith('/')) { continue }

        $name = [string]$entry.FullName
        $lower = $name.ToLowerInvariant()

        foreach ($s in $cheatStrings) {
            if ($lower.Contains($s.ToLowerInvariant())) {
                if (-not $strs.Contains($s)) {
                    [void]$strs.Add($s)
                }

                if (-not $filesHit.Contains($name)) {
                    [void]$filesHit.Add($name)
                }
            }
        }

        foreach ($s in $suspiciousPatterns) {
            if ($lower.Contains($s.ToLowerInvariant())) {
                if (-not $pats.Contains($s)) {
                    [void]$pats.Add($s)
                }

                if (-not $filesHit.Contains($name)) {
                    [void]$filesHit.Add($name)
                }
            }
        }

        if (
            $lower.EndsWith('.class') -or
            $lower.EndsWith('.json') -or
            $lower.EndsWith('.toml') -or
            $lower.EndsWith('.properties') -or
            $lower.EndsWith('.cfg') -or
            $lower.EndsWith('.txt') -or
            $lower.EndsWith('.xml') -or
            $lower.EndsWith('.mf')
        ) {
            $bytes = KL-ReadZipEntryBytes $entry 5242880

            if ($bytes.Count -gt 0) {
                $ascii = [System.Text.Encoding]::ASCII.GetString($bytes)
                $utf8  = [System.Text.Encoding]::UTF8.GetString($bytes)

                foreach ($blob in @($ascii, $utf8)) {
                    $normalized = KL-NormalizeText $blob

                    if ($patternRegex) {
                        foreach ($m in [regex]::Matches(
                            $normalized,
                            $patternRegex,
                            [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
                        )) {
                            $value = $m.Value

                            if (-not $pats.Contains($value)) {
                                [void]$pats.Add($value)
                            }

                            if (-not $filesHit.Contains($name)) {
                                [void]$filesHit.Add($name)
                            }
                        }
                    }

                    foreach ($s in $cheatStrings) {
                        if ($normalized.IndexOf(
                            $s,
                            [System.StringComparison]::OrdinalIgnoreCase
                        ) -ge 0) {
                            if (-not $strs.Contains($s)) {
                                [void]$strs.Add($s)
                            }

                            if (-not $filesHit.Contains($name)) {
                                [void]$filesHit.Add($name)
                            }
                        }
                    }
                }
            }
        }
    }

    $final = @(
        @($pats)
        @($strs)
    ) | Where-Object { $_ } | Select-Object -Unique

    return @{
        P     = @($pats)
        S     = @($strs)
        FW    = @()
        Files = @($filesHit)
        Total = @($final)
    }
}


function KL-ScanBypass {
    param([string]$JarPath)

    $hits = New-Object System.Collections.Generic.List[string]

    $entries = @(KL-GetJarEntries $JarPath)

    foreach ($entry in $entries) {
        if ($entry.FullName.EndsWith('/')) { continue }

        $name = [string]$entry.FullName
        $lower = $name.ToLowerInvariant()

        $nameChecks = @(
            'javaagent',
            'agentmain',
            'premain',
            'instrumentation',
            'nativehook',
            'injector',
            'injection',
            'dll',
            'jnidispatch',
            'loadlibrary',
            'createremotethread',
            'virtualalloc'
        )

        foreach ($needle in $nameChecks) {
            if ($lower.Contains($needle)) {
                if (-not $hits.Contains("Entry: $name -> $needle")) {
                    [void]$hits.Add("Entry: $name -> $needle")
                }
            }
        }

        if (
            $lower.EndsWith('.class') -or
            $lower.EndsWith('.json') -or
            $lower.EndsWith('.mf') -or
            $lower.EndsWith('.txt')
        ) {
            $text = KL-ReadZipEntryText $entry 5242880
            if (-not $text) { continue }

            $normalized = KL-NormalizeText $text

            $checks = @(
                @{ Regex = '(?i)javaagent'; Label = 'javaagent' },
                @{ Regex = '(?i)\bInstrumentation\b'; Label = 'Instrumentation' },
                @{ Regex = '(?i)\bAgentBuilder\b'; Label = 'AgentBuilder' },
                @{ Regex = '(?i)\bClassFileTransformer\b'; Label = 'ClassFileTransformer' },
                @{ Regex = '(?i)\bVirtualAlloc\b'; Label = 'VirtualAlloc' },
                @{ Regex = '(?i)\bCreateRemoteThread\b'; Label = 'CreateRemoteThread' },
                @{ Regex = '(?i)\bSetWindowsHookEx\b'; Label = 'SetWindowsHookEx' },
                @{ Regex = '(?i)\bLoadLibrary(?:A|W)?\b'; Label = 'LoadLibrary' },
                @{ Regex = '(?i)\bJNI\b'; Label = 'JNI' },
                @{ Regex = '(?i)\bJNA\b'; Label = 'JNA' },
                @{ Regex = '(?i)Runtime\.getRuntime\(\)\.exec'; Label = 'Runtime.exec' },
                @{ Regex = '(?i)ProcessBuilder'; Label = 'ProcessBuilder' },
                @{ Regex = '(?i)URLClassLoader'; Label = 'URLClassLoader' },
                @{ Regex = '(?i)defineClass'; Label = 'defineClass' },
                @{ Regex = '(?i)ClassLoader'; Label = 'ClassLoader' },
                @{ Regex = '(?i)https?://'; Label = 'HTTP URL' },
                @{ Regex = '(?i)URLConnection'; Label = 'URLConnection' },
                @{ Regex = '(?i)HttpClient'; Label = 'HttpClient' },
                @{ Regex = '(?i)HttpURLConnection'; Label = 'HttpURLConnection' },
                @{ Regex = '(?i)\bPOST\b'; Label = 'HTTP POST' },
                @{ Regex = '(?i)webhook'; Label = 'Webhook' },
                @{ Regex = '(?i)discord(?:app)?\.com/api/webhooks'; Label = 'Discord Webhook' }
            )

            foreach ($check in $checks) {
                if ($normalized -match $check.Regex) {
                    $hit = "$($check.Label) in $name"

                    if (-not $hits.Contains($hit)) {
                        [void]$hits.Add($hit)
                    }
                }
            }
        }
    }

    return @($hits | Select-Object -Unique)
}


function KL-ScanObf {
    param([string]$JarPath)

    $hits = New-Object System.Collections.Generic.List[string]

    $entries = @(KL-GetJarEntries $JarPath)

    $classCount = 0
    $shortClassCount = 0
    $weirdNameCount = 0

    foreach ($entry in $entries) {
        if ($entry.FullName -notmatch '(?i)\.class$') {
            continue
        }

        $classCount++

        $base = [System.IO.Path]::GetFileNameWithoutExtension($entry.FullName)

        if ($base.Length -le 2) {
            $shortClassCount++
        }

        if ($base -match '^[A-Za-z0-9_$]{1,3}$') {
            $weirdNameCount++
        }
    }

    if ($classCount -gt 20) {
        $shortRatio = $shortClassCount / [double]$classCount

        if ($shortRatio -ge 0.35) {
            [void]$hits.Add(
                ("High short-class-name ratio: {0:P0} ({1}/{2})" -f `
                    $shortRatio, $shortClassCount, $classCount)
            )
        }
    }

    if ($weirdNameCount -ge 20) {
        [void]$hits.Add(
            "Many unusually short/opaque class names: $weirdNameCount"
        )
    }

    foreach ($entry in $entries) {
        if ($entry.FullName -notmatch '(?i)\.class$') {
            continue
        }

        $bytes = KL-ReadZipEntryBytes $entry 2097152
        if ($bytes.Count -eq 0) { continue }

        $ascii = [System.Text.Encoding]::ASCII.GetString($bytes)

        $checks = @(
            @{ Regex = '(?i)invokedynamic'; Label = 'invokedynamic-heavy bytecode' },
            @{ Regex = '(?i)java/lang/reflect'; Label = 'reflection' },
            @{ Regex = '(?i)defineClass'; Label = 'dynamic class definition' },
            @{ Regex = '(?i)Base64'; Label = 'Base64 reference' },
            @{ Regex = '(?i)Cipher'; Label = 'Cipher reference' },
            @{ Regex = '(?i)MessageDigest'; Label = 'MessageDigest reference' }
        )

        foreach ($check in $checks) {
            if ($ascii -match $check.Regex) {
                $hit = "$($check.Label) in $($entry.FullName)"

                if (-not $hits.Contains($hit)) {
                    [void]$hits.Add($hit)
                }
            }
        }
    }

    return @($hits | Select-Object -Unique)
}


function KL-Source {
    param([string]$JarPath)

    try {
        $zone = Get-Content -LiteralPath "$JarPath`:Zone.Identifier" `
            -Raw -ErrorAction Stop

        if ($zone -match 'MediaFire') { return 'MediaFire' }
        if ($zone -match 'Discord') { return 'Discord' }
        if ($zone -match 'Dropbox') { return 'Dropbox' }
        if ($zone -match 'Google Drive') { return 'Google Drive' }
        if ($zone -match 'MEGA') { return 'MEGA' }
        if ($zone -match 'GitHub') { return 'GitHub' }
        if ($zone -match 'Modrinth') { return 'Modrinth' }
        if ($zone -match 'CurseForge') { return 'CurseForge' }
    } catch {}

    return 'Unknown'
}

function KL-Modrinth {
    param([string]$Hash)

    try {
        $uri = "https://api.modrinth.com/v2/version_file/$Hash"
        $r = Invoke-RestMethod -Uri $uri -Method Get -TimeoutSec 10

        if ($r) {
            $projectId = $r.project_id

            if ($projectId) {
                try {
                    $p = Invoke-RestMethod `
                        -Uri "https://api.modrinth.com/v2/project/$projectId" `
                        -Method Get `
                        -TimeoutSec 10

                    return @{
                        Found = $true
                        Name  = $p.title
                        Slug  = $p.slug
                        Source = 'Modrinth'
                    }
                } catch {}
            }

            return @{
                Found = $true
                Name  = 'Verified Modrinth file'
                Slug  = $projectId
                Source = 'Modrinth'
            }
        }
    } catch {}

    return @{
        Found = $false
        Name = $null
        Slug = $null
        Source = $null
    }
}

function KL-Megabase {
    param([string]$Hash)

    try {
        $uri = "https://megabase.vercel.app/api/query?hash=$Hash"
        $r = Invoke-RestMethod -Uri $uri -Method Get -TimeoutSec 10

        if ($r) {
            return @{
                Found = $true
                Name = if ($r.name) { $r.name } else { 'Megabase match' }
                Slug = $null
                Source = 'Megabase'
            }
        }
    } catch {}

    return @{
        Found = $false
        Name = $null
        Slug = $null
        Source = $null
    }
}


function New-KLResult {
    param(
        [string]$Path,
        [string]$Status = 'UNKNOWN'
    )

    [pscustomobject]@{
        Name        = [System.IO.Path]::GetFileName($Path)
        Path        = $Path
        SHA1        = $null
        Status      = $Status
        Source      = 'Unknown'
        VerifiedAs  = $null
        Signatures  = @()
        CheatStrings = @()
        HitFiles    = @()
        Bypass      = @()
        Obfuscation = @()
        ScanError   = $null
    }
}

function KL-PrintFindings {
    param($Result)

    if ($Result.Signatures.Count -gt 0) {
        KL-Write "    Suspicious signatures:" Yellow

        foreach ($hit in ($Result.Signatures | Select-Object -Unique)) {
            KL-Write "      • $hit" Yellow
        }
    }

    if ($Result.CheatStrings.Count -gt 0) {
        KL-Write "    Cheat strings detected:" Red

        foreach ($hit in ($Result.CheatStrings | Select-Object -Unique)) {
            KL-Write "      • $hit" Red
        }
    }

    if ($Result.Bypass.Count -gt 0) {
        KL-Write "    Bypass / injection indicators:" Magenta

        foreach ($hit in ($Result.Bypass | Select-Object -Unique)) {
            KL-Write "      • $hit" Magenta
        }
    }

    if ($Result.Obfuscation.Count -gt 0) {
        KL-Write "    Obfuscation indicators:" DarkYellow

        foreach ($hit in ($Result.Obfuscation | Select-Object -Unique)) {
            KL-Write "      • $hit" DarkYellow
        }
    }

    if ($Result.HitFiles.Count -gt 0) {
        KL-Write "    Matching archive entries:" DarkGray

        foreach ($hit in ($Result.HitFiles | Select-Object -First 30)) {
            KL-Write "      • $hit" DarkGray
        }

        if ($Result.HitFiles.Count -gt 30) {
            KL-Write "      • ... and $($Result.HitFiles.Count - 30) more" DarkGray
        }
    }
}


function Get-KLDefaultModsPath {
    $candidates = @(
        (Join-Path $env:APPDATA '.minecraft\mods'),
        (Join-Path $env:APPDATA 'ModrinthApp\profiles'),
        (Join-Path $env:USERPROFILE 'AppData\Roaming\.minecraft\mods')
    )

    foreach ($path in $candidates) {
        if (Test-Path -LiteralPath $path -PathType Container) {
            if ($path -match '(?i)ModrinthApp\\profiles$') {
                $profiles = Get-ChildItem -LiteralPath $path -Directory -ErrorAction SilentlyContinue

                foreach ($profile in $profiles) {
                    $mods = Join-Path $profile.FullName 'mods'
                    if (Test-Path -LiteralPath $mods -PathType Container) {
                        return $mods
                    }
                }
            } else {
                return $path
            }
        }
    }

    return $null
}


KL-HeaderBanner

Show-KLJavaRuntime

if ([string]::IsNullOrWhiteSpace($ModsPath)) {
    $ModsPath = Get-KLDefaultModsPath
}

if ([string]::IsNullOrWhiteSpace($ModsPath) -or
    -not (Test-Path -LiteralPath $ModsPath -PathType Container)) {

    KL-Write ""
    KL-Warn "Mods folder was not automatically found."
    KL-Write ""

    $ModsPath = Read-Host "Enter the full path to the mods folder"

    if (-not (Test-Path -LiteralPath $ModsPath -PathType Container)) {
        KL-Bad "Folder not found: $ModsPath"

        if (-not $NoPause) {
            Read-Host "Press Enter to exit"
        }

        exit 1
    }
}

$ModsPath = (Resolve-Path -LiteralPath $ModsPath).Path

KL-Write ""
KL-Info "Mods path: $ModsPath"


$javaProcesses = @(Get-KLJavaProcesses)
$minecraftProcesses = @($javaProcesses | Where-Object { $_.IsMinecraft })

if ($minecraftProcesses.Count -gt 0) {
    KL-Write ""
    KL-Write "Current Minecraft javaw.exe process found." Cyan

    if (-not $NoPause) {
        $answer = Read-Host "Would you like to include its runtime in this scan? [y/n]"

        if ($answer -match '^(?i)y|yes$') {
            Show-KLJavaRuntime
        }
    }
}


$jars = @(
    Get-ChildItem -LiteralPath $ModsPath `
        -Filter '*.jar' `
        -File `
        -ErrorAction SilentlyContinue
)

KL-Write ""
KL-Info "Found $($jars.Count) JAR(s) in $ModsPath"

if ($jars.Count -eq 0) {
    KL-Warn "No JAR files were found."

    if (-not $NoPause) {
        Read-Host "Press Enter to exit"
    }

    exit 0
}

$results = New-Object System.Collections.Generic.List[object]

foreach ($jar in $jars) {
    [void]$results.Add((New-KLResult $jar.FullName))
}


KL-Header "PASS 1 — HASH VERIFICATION"

$index = 0

foreach ($result in $results) {
    $index++

    KL-Info "[$index/$($results.Count)] Hashing $($result.Name)"

    $result.SHA1 = KL-SHA1 $result.Path

    if (-not $result.SHA1) {
        $result.Status = 'UNKNOWN'
        $result.ScanError = 'Could not calculate SHA-1'
        KL-Warn "  SHA-1 failed"
        continue
    }

    $m = KL-Modrinth $result.SHA1

    if ($m.Found) {
        $result.Status = 'VERIFIED'
        $result.Source = $m.Source
        $result.VerifiedAs = $m.Name

        KL-Good "  VERIFIED: $($result.Name) -> $($m.Name)"
        continue
    }

    $mb = KL-Megabase $result.SHA1

    if ($mb.Found) {
        $result.Status = 'VERIFIED'
        $result.Source = $mb.Source
        $result.VerifiedAs = $mb.Name

        KL-Good "  VERIFIED: $($result.Name) -> $($mb.Name)"
        continue
    }

    $result.Status = 'UNKNOWN'
    $result.Source = KL-Source $result.Path

    KL-Warn "  UNKNOWN: $($result.Name)"
}

$verified = @($results | Where-Object { $_.Status -eq 'VERIFIED' })
$toScan = @($results | Where-Object {
    $_.Status -eq 'UNKNOWN' -or $DeepScanAll
})

KL-Write ""
KL-Info "Verified: $($verified.Count)  |  To deep-scan: $($toScan.Count)"


KL-Header "PASS 2 — CHEAT-SIGNATURE SCAN"

$scanIndex = 0

foreach ($result in $toScan) {
    $scanIndex++

    KL-Info "[$scanIndex/$($toScan.Count)] Scanning $($result.Name)"

    try {
        $sig = KL-ScanSigs $result.Path

        $result.Signatures = @($sig.P | Select-Object -Unique)
        $result.CheatStrings = @($sig.S | Select-Object -Unique)
        $result.HitFiles = @($sig.Files | Select-Object -Unique)

        if ($result.Signatures.Count -gt 0 -or
            $result.CheatStrings.Count -gt 0) {

            $result.Status = 'FLAGGED'

            KL-Bad "  FLAGGED: $($result.Name)"
            KL-PrintFindings $result
        } else {
            KL-Good "  Clean signature pass: $($result.Name)"
        }
    } catch {
        $result.ScanError = $_.Exception.Message
        KL-Warn "  Signature scan error: $($result.Name)"
    }
}

$flaggedAfterSigs = @($results | Where-Object { $_.Status -eq 'FLAGGED' }).Count

KL-Write ""
KL-Info "Flagged: $flaggedAfterSigs"


KL-Header "PASS 3 — BYPASS / INJECTION SCAN"

$bypassIndex = 0

foreach ($result in $toScan) {
    $bypassIndex++

    KL-Info "[$bypassIndex/$($toScan.Count)] Checking $($result.Name)"

    try {
        $hits = @(KL-ScanBypass $result.Path)
        $result.Bypass = @($hits | Select-Object -Unique)

        if ($result.Bypass.Count -gt 0) {
            if ($result.Status -ne 'FLAGGED') {
                $result.Status = 'BYPASS'
            }

            KL-Warn "  Bypass / injection indicators: $($result.Name)"

            foreach ($hit in $result.Bypass) {
                KL-Write "    • $hit" Magenta
            }
        } else {
            KL-Good "  Bypass clean: $($result.Name)"
        }
    } catch {
        $result.ScanError = $_.Exception.Message
        KL-Warn "  Bypass scan error: $($result.Name)"
    }
}

$bypassCount = @($results | Where-Object {
    $_.Bypass.Count -gt 0
}).Count

KL-Write ""
KL-Info "Bypass flagged: $bypassCount"


KL-Header "PASS 4 — OBFUSCATION SCAN"

$obfIndex = 0

foreach ($result in $toScan) {
    $obfIndex++

    KL-Info "[$obfIndex/$($toScan.Count)] Checking $($result.Name)"

    try {
        $hits = @(KL-ScanObf $result.Path)
        $result.Obfuscation = @($hits | Select-Object -Unique)

        if ($result.Obfuscation.Count -gt 0) {
            if ($result.Status -eq 'UNKNOWN') {
                $result.Status = 'OBFUSCATED'
            }

            KL-Warn "  Obfuscation indicators: $($result.Name)"

            foreach ($hit in $result.Obfuscation) {
                KL-Write "    • $hit" DarkYellow
            }
        } else {
            KL-Good "  Obfuscation clean: $($result.Name)"
        }
    } catch {
        $result.ScanError = $_.Exception.Message
        KL-Warn "  Obfuscation scan error: $($result.Name)"
    }
}


KL-Header "FINAL REPORT"

$verifiedCount = @($results | Where-Object { $_.Status -eq 'VERIFIED' }).Count
$flaggedCount = @($results | Where-Object { $_.Status -eq 'FLAGGED' }).Count
$bypassCount = @($results | Where-Object {
    $_.Bypass.Count -gt 0
}).Count
$obfCount = @($results | Where-Object {
    $_.Status -eq 'OBFUSCATED'
}).Count
$unknownCount = @($results | Where-Object {
    $_.Status -eq 'UNKNOWN'
}).Count

KL-Write ""

foreach ($result in $results | Sort-Object Name) {
    $color = switch ($result.Status) {
        'VERIFIED'  { 'Green' }
        'FLAGGED'   { 'Red' }
        'BYPASS'    { 'Magenta' }
        'OBFUSCATED'{ 'DarkYellow' }
        default     { 'Yellow' }
    }

    KL-Write "[$($result.Status)] $($result.Name)" $color

    if ($result.SHA1) {
        KL-Write "  SHA-1 : $($result.SHA1)" DarkGray
    }

    if ($result.Source -and $result.Source -ne 'Unknown') {
        KL-Write "  Source: $($result.Source)" DarkGray
    }

    if ($result.VerifiedAs) {
        KL-Write "  Match : $($result.VerifiedAs)" DarkGray
    }

    if ($result.Status -eq 'FLAGGED' -or
        $result.Signatures.Count -gt 0 -or
        $result.CheatStrings.Count -gt 0 -or
        $result.Bypass.Count -gt 0 -or
        $result.Obfuscation.Count -gt 0) {

        KL-PrintFindings $result
    }

    if ($result.ScanError) {
        KL-Write "  Scan error: $($result.ScanError)" Yellow
    }

    KL-Write ""
}


KL-Header "SCAN SUMMARY"

KL-Write " Total JARs       : $($results.Count)" White
KL-Write " Verified         : $verifiedCount" Green
KL-Write " Flagged          : $flaggedCount" Red
KL-Write " Bypass detected  : $bypassCount" Magenta
KL-Write " Obfuscated       : $obfCount" DarkYellow
KL-Write " Unknown          : $unknownCount" Yellow

$totalCheatHits = @(
    foreach ($r in $results) {
        $r.CheatStrings
    }
) | Where-Object { $_ } | Select-Object -Unique

$totalSigHits = @(
    foreach ($r in $results) {
        $r.Signatures
    }
) | Where-Object { $_ } | Select-Object -Unique

KL-Write ""
KL-Write " Unique cheat strings detected : $($totalCheatHits.Count)" White
KL-Write " Unique signatures detected    : $($totalSigHits.Count)" White

if ($flaggedCount -gt 0) {
    KL-Write ""
    KL-Bad "FLAGGED MOD DETAILS"

    foreach ($r in $results | Where-Object { $_.Status -eq 'FLAGGED' }) {
        KL-Write ""
        KL-Write " >>> $($r.Name)" Red

        if ($r.CheatStrings.Count -gt 0) {
            KL-Write "     Cheat strings:" Yellow
            foreach ($s in $r.CheatStrings | Select-Object -Unique) {
                KL-Write "       • $s" Yellow
            }
        }

        if ($r.Signatures.Count -gt 0) {
            KL-Write "     Signatures:" Yellow
            foreach ($s in $r.Signatures | Select-Object -Unique) {
                KL-Write "       • $s" Yellow
            }
        }
    }
}

KL-Write ""
KL-Write " Scan complete." Cyan

if (-not $NoPause) {
    KL-Write ""
    Read-Host "Press Enter to exit"
}
