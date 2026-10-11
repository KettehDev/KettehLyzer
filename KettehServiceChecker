<#
    KETTEH SERVICES v1.0
    Screenshare system check - services, logs, prefetch, recycle bin
    made by ketteh  ·  discord: zoe_mahhh
#>

$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference    = 'SilentlyContinue'
$script:Version        = '1.0'
$script:Clock          = [Diagnostics.Stopwatch]::StartNew()

# ════════════════════════════════════════════════════════════════════
#  output helpers  (everything printed is also kept for the report)
# ════════════════════════════════════════════════════════════════════

$script:Report   = New-Object System.Text.StringBuilder
$script:Findings = New-Object System.Collections.Generic.List[object]

function Out-K {
    param([string]$Text = '', [string]$Color = 'Gray', [switch]$NoNewline)
    Write-Host $Text -ForegroundColor $Color -NoNewline:$NoNewline
    [void]$script:Report.Append($Text)
    if (-not $NoNewline) { [void]$script:Report.AppendLine() }
}

function Section {
    param([string]$Title)
    Out-K
    Out-K ('  ▌ ' ) Magenta -NoNewline
    Out-K ($Title.ToUpper() + ' ') White -NoNewline
    Out-K ('─' * [Math]::Max(4, 58 - $Title.Length)) DarkMagenta
}

$script:Chips = @{
    OK   = @('  ok  ', 'Green',  'Gray')
    WARN = @(' warn ', 'Yellow', 'Yellow')
    FAIL = @(' fail ', 'Red',    'Red')
    INFO = @(' info ', 'Cyan',   'Gray')
}

function Row {
    param(
        [ValidateSet('OK', 'WARN', 'FAIL', 'INFO')][string]$Level,
        [string]$Label,
        [string]$Value,
        [string]$Extra = ''
    )
    $chip = $script:Chips[$Level]
    Out-K '   ' -NoNewline
    Out-K $chip[0] $chip[1] -NoNewline
    Out-K ' │ ' DarkGray -NoNewline
    Out-K ('{0,-24}' -f $Label) White -NoNewline
    if ($Extra) {
        Out-K $Value $chip[2] -NoNewline
        Out-K ('   ' + $Extra) DarkGray
    } else {
        Out-K $Value $chip[2]
    }
    if ($Level -eq 'WARN' -or $Level -eq 'FAIL') {
        $script:Findings.Add([pscustomobject]@{ Level = $Level; Text = "$Label · $Value" })
    }
}

function Sub {
    param([string]$Text, [string]$Color = 'DarkGray')
    Out-K ('          │   ↳ ' + $Text) $Color
}

function Ago {
    param([datetime]$When)
    $span = (Get-Date) - $When
    if ($span.TotalSeconds -lt 0)  { return 'in the future?' }
    if ($span.TotalMinutes -lt 1)  { return 'just now' }
    if ($span.TotalHours   -lt 1)  { return ('{0}m ago' -f [int][Math]::Floor($span.TotalMinutes)) }
    if ($span.TotalDays    -lt 1)  { return ('{0}h {1}m ago' -f [int][Math]::Floor($span.TotalHours), $span.Minutes) }
    return ('{0}d {1}h ago' -f [int][Math]::Floor($span.TotalDays), $span.Hours)
}

function Stamp {
    param([datetime]$When)
    return $When.ToString('yyyy-MM-dd HH:mm:ss')
}

function Size-Text {
    param([double]$Bytes)
    if ($Bytes -ge 1GB) { return ('{0:N1} GB' -f ($Bytes / 1GB)) }
    if ($Bytes -ge 1MB) { return ('{0:N1} MB' -f ($Bytes / 1MB)) }
    if ($Bytes -ge 1KB) { return ('{0:N1} KB' -f ($Bytes / 1KB)) }
    return ('{0} B' -f [int64]$Bytes)
}

function Get-Reg {
    param([string]$Path, [string]$Name)
    try { return (Get-ItemProperty -LiteralPath $Path -Name $Name -ErrorAction Stop).$Name } catch { return $null }
}

# ════════════════════════════════════════════════════════════════════
#  admin check - relaunch elevated instead of just quitting
# ════════════════════════════════════════════════════════════════════

$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host ''
    Write-Host '   ╭────────────────────────────────────────────────╮' -ForegroundColor DarkMagenta
    Write-Host '   │  ' -ForegroundColor DarkMagenta -NoNewline
    Write-Host 'admin needed </3' -ForegroundColor Magenta -NoNewline
    Write-Host '                              │' -ForegroundColor DarkMagenta
    Write-Host '   │  ' -ForegroundColor DarkMagenta -NoNewline
    Write-Host 'logs, prefetch and services need admin rights' -ForegroundColor Gray -NoNewline
    Write-Host ' │' -ForegroundColor DarkMagenta
    Write-Host '   ╰────────────────────────────────────────────────╯' -ForegroundColor DarkMagenta

    if ($PSCommandPath) {
        try {
            Start-Process powershell.exe -Verb RunAs -ErrorAction Stop `
                -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
            Write-Host '   relaunching as admin...' -ForegroundColor DarkGray
            exit
        } catch {}
    }
    Write-Host '   right-click PowerShell -> Run as administrator, then run this again.' -ForegroundColor Gray
    Read-Host '   press enter to close'
    exit 1
}

try { $Host.UI.RawUI.WindowTitle = "ketteh services v$script:Version  ·  zoe_mahhh" } catch {}

# ════════════════════════════════════════════════════════════════════
#  banner
# ════════════════════════════════════════════════════════════════════

Clear-Host
$banner = @(
    @(' ██╗  ██╗███████╗████████╗████████╗███████╗██╗  ██╗', 'Magenta'),
    @(' ██║ ██╔╝██╔════╝╚══██╔══╝╚══██╔══╝██╔════╝██║  ██║', 'Magenta'),
    @(' █████╔╝ █████╗     ██║      ██║   █████╗  ███████║', 'DarkMagenta'),
    @(' ██╔═██╗ ██╔══╝     ██║      ██║   ██╔══╝  ██╔══██║', 'DarkMagenta'),
    @(' ██║  ██╗███████╗   ██║      ██║   ███████╗██║  ██║', 'Cyan'),
    @(' ╚═╝  ╚═╝╚══════╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝', 'DarkCyan')
)
Out-K
foreach ($line in $banner) { Out-K ('  ' + $line[0]) $line[1] }
Out-K
Out-K '           s e r v i c e   c h e c k' White -NoNewline
Out-K "   v$script:Version" DarkGray
Out-K '        by ketteh  ' DarkGray -NoNewline
Out-K '·' Magenta -NoNewline
Out-K '  discord: zoe_mahhh  ' DarkGray -NoNewline
Out-K '</3' Magenta

# ════════════════════════════════════════════════════════════════════
#  system
# ════════════════════════════════════════════════════════════════════

$os   = Get-CimInstance Win32_OperatingSystem
$boot = if ($os) { $os.LastBootUpTime } else { (Get-Date).AddDays(-1) }
$up   = (Get-Date) - $boot

Section 'System'
Row INFO 'Computer' $env:COMPUTERNAME ("user: $env:USERNAME")
if ($os) { Row INFO 'Windows' $os.Caption ("build $($os.BuildNumber)") }
Row INFO 'Scan time' (Stamp (Get-Date)) ([TimeZoneInfo]::Local.StandardName)

$upText = '{0}d {1:D2}h {2:D2}m' -f [int][Math]::Floor($up.TotalDays), $up.Hours, $up.Minutes
if ($up.TotalMinutes -lt 15) {
    Row WARN 'Last boot' (Stamp $boot) "up $upText  ·  rebooted very recently"
} else {
    Row INFO 'Last boot' (Stamp $boot) "up $upText"
}

# ════════════════════════════════════════════════════════════════════
#  drives
# ════════════════════════════════════════════════════════════════════

Section 'Drives'
$driveTypes = @{ 2 = 'removable'; 3 = 'local'; 4 = 'network'; 6 = 'ram disk' }
$drives = @(Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DriveType -ne 5 })
foreach ($d in $drives) {
    $type  = $driveTypes[[int]$d.DriveType]; if (-not $type) { $type = 'other' }
    $fs    = if ($d.FileSystem) { $d.FileSystem } else { 'no fs' }
    $label = if ($d.VolumeName) { "`"$($d.VolumeName)`"" } else { 'no label' }
    $space = if ($d.Size) { '{0} free of {1}' -f (Size-Text $d.FreeSpace), (Size-Text $d.Size) } else { '' }
    $level = if ($d.DriveType -eq 2) { 'WARN' } else { 'INFO' }
    Row $level $d.DeviceID "$fs · $type · $label" $space
}
if ($drives.Count -eq 0) { Row WARN 'Drives' 'none found' }

# ════════════════════════════════════════════════════════════════════
#  services
# ════════════════════════════════════════════════════════════════════

Section 'Services'

$services = [ordered]@{
    'SysMain'    = 'SysMain / Superfetch'
    'PcaSvc'     = 'Program Compatibility Assistant'
    'DPS'        = 'Diagnostic Policy Service'
    'EventLog'   = 'Windows Event Log'
    'Schedule'   = 'Task Scheduler'
    'DusmSvc'    = 'Data Usage'
    'Appinfo'    = 'Application Information'
    'CDPSvc'     = 'Connected Devices Platform'
    'DcomLaunch' = 'DCOM Server Process Launcher'
    'PlugPlay'   = 'Plug and Play'
    'WSearch'    = 'Windows Search'
    'DiagTrack'  = 'Connected User Experiences'
}

$filter = ($services.Keys | ForEach-Object { "Name='$_'" }) -join ' OR '
$found  = @{}
foreach ($s in @(Get-CimInstance Win32_Service -Filter $filter)) { $found[$s.Name] = $s }

foreach ($name in $services.Keys) {
    $desc = $services[$name]
    $s    = $found[$name]

    if (-not $s) { Row FAIL $name 'missing' $desc; continue }

    $mode = ([string]$s.StartMode).ToLower()      # auto / manual / disabled

    if ($s.State -eq 'Running') {
        $started = $null
        if ($s.ProcessId -gt 0) {
            $p = Get-Process -Id $s.ProcessId -ErrorAction SilentlyContinue
            if ($p) { try { $started = $p.StartTime } catch {} }
        }

        if ($started -and $mode -eq 'auto' -and ($started - $boot).TotalMinutes -gt 10) {
            # auto services start with Windows; one that started much later was restarted
            Row WARN $name 'running · restarted after boot' ("since $($started.ToString('HH:mm:ss'))  ·  $(Ago $started)")
        } elseif ($started) {
            Row OK $name 'running' ("since $($started.ToString('HH:mm:ss'))  ·  $desc")
        } else {
            Row OK $name 'running' $desc
        }
    } else {
        $level = if ($mode -eq 'disabled' -or $mode -eq 'auto') { 'FAIL' } else { 'WARN' }
        Row $level $name ("{0} · {1}" -f ([string]$s.State).ToLower(), $mode) $desc
    }
}

# Background Activity Moderator is a kernel driver, not a normal service
$bam = Get-CimInstance Win32_SystemDriver -Filter "Name='bam'"
if (-not $bam) {
    Row WARN 'bam' 'driver not found' 'Background Activity Moderator'
} elseif ($bam.State -eq 'Running') {
    Row OK 'bam' 'running' 'Background Activity Moderator (driver)'
} else {
    Row FAIL 'bam' ("{0} · {1}" -f ([string]$bam.State).ToLower(), ([string]$bam.StartMode).ToLower()) 'Background Activity Moderator (driver)'
}

# ════════════════════════════════════════════════════════════════════
#  registry
# ════════════════════════════════════════════════════════════════════

Section 'Registry'

$cmd = Get-Reg 'HKCU:\Software\Policies\Microsoft\Windows\System' 'DisableCMD'
if ($cmd -eq 1 -or $cmd -eq 2) { Row FAIL 'Command Prompt' 'disabled by policy' "DisableCMD = $cmd" }
else                           { Row OK   'Command Prompt' 'allowed' }

$pfReg = Get-Reg 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters' 'EnablePrefetcher'
switch ($pfReg) {
    0       { Row FAIL 'Prefetch' 'disabled' 'EnablePrefetcher = 0' }
    1       { Row WARN 'Prefetch' 'boot prefetch off (apps still tracked)' 'EnablePrefetcher = 1' }
    2       { Row FAIL 'Prefetch' 'app prefetch off (boot only)' 'EnablePrefetcher = 2' }
    default { Row OK   'Prefetch' 'enabled' $(if ($null -ne $pfReg) { "EnablePrefetcher = $pfReg" } else { 'default' }) }
}

$feed = Get-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' 'EnableActivityFeed'
$pub  = Get-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' 'PublishUserActivities'
if ($feed -eq 0 -or $pub -eq 0) { Row WARN 'Activity history' 'disabled by policy' }
else                            { Row OK   'Activity history' 'allowed' }

$track = Get-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' 'Start_TrackProgs'
if ($track -eq 0) { Row WARN 'UserAssist tracking' 'turned off' 'Start_TrackProgs = 0' }
else              { Row OK   'UserAssist tracking' 'on' }

$sbl = Get-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging' 'EnableScriptBlockLogging'
if ($sbl -eq 1) { Row INFO 'PowerShell logging' 'script block logging on' }
else            { Row INFO 'PowerShell logging' 'not configured' 'windows default' }

# ════════════════════════════════════════════════════════════════════
#  event logs
# ════════════════════════════════════════════════════════════════════

Section 'Event logs'

function Get-LastEvent {
    param([string]$Log, [int[]]$Id, [string]$Provider)
    $f = @{ LogName = $Log; Id = $Id }
    if ($Provider) { $f.ProviderName = $Provider }
    try { return Get-WinEvent -FilterHashtable $f -MaxEvents 1 -ErrorAction Stop } catch { return $null }
}

function Event-Row {
    # -Tamper: anything found is a warning, and a fail if it happened since the last boot
    param([string]$Label, [string]$Log, [int[]]$Id, [string]$Provider, [switch]$Tamper)
    $e = Get-LastEvent -Log $Log -Id $Id -Provider $Provider
    if (-not $e) {
        if ($Tamper) { Row OK $Label 'no records' } else { Row INFO $Label 'no records' }
        return
    }
    $level = 'INFO'
    if ($Tamper) { $level = if ($e.TimeCreated -ge $boot) { 'FAIL' } else { 'WARN' } }
    Row $level $Label (Stamp $e.TimeCreated) ("$(Ago $e.TimeCreated)  ·  id $($e.Id)")
}

Event-Row 'Security log cleared'  'Security'    1102 -Tamper
Event-Row 'System log cleared'    'System'      104  -Tamper
Event-Row 'USN journal deleted'   'Application' 3079 -Tamper
Event-Row 'System time changed'   'System'      1    'Microsoft-Windows-Kernel-General'
Event-Row 'Last shutdown/restart' 'System'      1074
Event-Row 'Unexpected shutdown'   'System'      6008
Event-Row 'Event log started'     'System'      6005
Event-Row 'Device configured'     'Microsoft-Windows-Kernel-PnP/Configuration' 400

# ════════════════════════════════════════════════════════════════════
#  prefetch
# ════════════════════════════════════════════════════════════════════

Section 'Prefetch'

$pfDir = Join-Path $env:SystemRoot 'Prefetch'
if (-not (Test-Path -LiteralPath $pfDir)) {
    Row FAIL 'Prefetch folder' 'missing' $pfDir
} else {
    $pf = @(Get-ChildItem -LiteralPath $pfDir -Filter '*.pf' -File -Force)

    if ($pf.Count -eq 0) {
        Row FAIL 'Prefetch files' 'none' 'the folder is empty'
    } else {
        if ($pf.Count -lt 30) { Row WARN 'Prefetch files' "$($pf.Count) files" 'unusually low, could have been cleared' }
        else                  { Row OK   'Prefetch files' "$($pf.Count) files" }

        $newest = $pf | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        Row INFO 'Newest entry' $newest.Name (Ago $newest.LastWriteTime)

        $oldest = $pf | Sort-Object CreationTime | Select-Object -First 1
        if ($oldest.CreationTime -ge $boot) {
            Row WARN 'Oldest entry' (Stamp $oldest.CreationTime) 'everything was created after the last boot'
        } else {
            Row INFO 'Oldest entry' (Stamp $oldest.CreationTime) (Ago $oldest.CreationTime)
        }

        $hidden   = @($pf | Where-Object { $_.Attributes -band [IO.FileAttributes]::Hidden })
        $readOnly = @($pf | Where-Object { $_.Attributes -band [IO.FileAttributes]::ReadOnly })

        if ($hidden.Count -gt 0) {
            Row WARN 'Hidden files' "$($hidden.Count) found"
            $hidden | Select-Object -First 10 | ForEach-Object { Sub $_.Name White }
            if ($hidden.Count -gt 10) { Sub "... and $($hidden.Count - 10) more" }
        } else { Row OK 'Hidden files' 'none' }

        if ($readOnly.Count -gt 0) {
            Row WARN 'Read-only files' "$($readOnly.Count) found"
            $readOnly | Select-Object -First 10 | ForEach-Object { Sub $_.Name White }
            if ($readOnly.Count -gt 10) { Sub "... and $($readOnly.Count - 10) more" }
        } else { Row OK 'Read-only files' 'none' }

        $dupes = @($pf | Get-FileHash -Algorithm SHA256 | Group-Object Hash | Where-Object { $_.Count -gt 1 })
        if ($dupes.Count -gt 0) {
            Row WARN 'Duplicate files' "$($dupes.Count) set(s)" 'identical prefetch files usually mean copies'
            foreach ($set in $dupes) {
                Sub (($set.Group | ForEach-Object { Split-Path $_.Path -Leaf }) -join '  =  ') White
            }
        } else { Row OK 'Duplicate files' 'none' }
    }
}

# ════════════════════════════════════════════════════════════════════
#  recycle bin (reads the real names out of the $I files)
# ════════════════════════════════════════════════════════════════════

Section 'Recycle bin'

function Read-RecycleInfo {
    param([string]$Path)
    try {
        $b = [IO.File]::ReadAllBytes($Path)
        if ($b.Length -lt 24) { return $null }
        $ver  = [BitConverter]::ToInt64($b, 0)
        $size = [BitConverter]::ToInt64($b, 8)
        $when = [DateTime]::FromFileTime([BitConverter]::ToInt64($b, 16))
        $name = ''
        if ($ver -eq 2 -and $b.Length -ge 28) {
            $len = [BitConverter]::ToInt32($b, 24)
            if ($len -gt 1 -and (28 + ($len - 1) * 2) -le $b.Length) {
                $name = [Text.Encoding]::Unicode.GetString($b, 28, ($len - 1) * 2)
            }
        } else {
            $name = [Text.Encoding]::Unicode.GetString($b, 24, [Math]::Min(520, $b.Length - 24)).Split([char]0)[0]
        }
        return [pscustomobject]@{ Name = $name; Size = $size; Deleted = $when }
    } catch { return $null }
}

$riskyExt = '\.(jar|exe|dll|zip|rar|7z|bat|cmd|ps1|vbs|ahk|py|sys)$'
$anyBin = $false

foreach ($d in ($drives | Where-Object { $_.DriveType -eq 2 -or $_.DriveType -eq 3 })) {
    $bin = Join-Path ($d.DeviceID + '\') '$Recycle.Bin'
    if (-not (Test-Path -LiteralPath $bin)) { continue }
    $anyBin = $true

    $sidFolders = @(Get-ChildItem -LiteralPath $bin -Directory -Force)
    $items = New-Object System.Collections.Generic.List[object]
    $lastChange = (Get-Item -LiteralPath $bin -Force).LastWriteTime

    foreach ($sid in $sidFolders) {
        if ($sid.LastWriteTime -gt $lastChange) { $lastChange = $sid.LastWriteTime }
        foreach ($info in @(Get-ChildItem -LiteralPath $sid.FullName -Filter '$I*' -File -Force)) {
            $r = Read-RecycleInfo $info.FullName
            if ($r) { $items.Add($r) }
        }
    }

    $label = "Bin $($d.DeviceID)"
    if ($items.Count -eq 0) {
        if ($lastChange -ge $boot) { Row WARN $label 'empty' "emptied since last boot  ·  $(Ago $lastChange)" }
        else                       { Row OK   $label 'empty' "last change $(Ago $lastChange)" }
        continue
    }

    Row INFO $label "$($items.Count) item(s)" "last change $(Ago $lastChange)"
    foreach ($it in ($items | Sort-Object Deleted -Descending | Select-Object -First 6)) {
        $color = if ($it.Name -match $riskyExt) { 'Yellow' } else { 'DarkGray' }
        Sub ('{0}  {1}  ({2})' -f $it.Deleted.ToString('MM-dd HH:mm'), $it.Name, (Size-Text $it.Size)) $color
    }
    if ($items.Count -gt 6) { Sub "... and $($items.Count - 6) more" }
}
if (-not $anyBin) { Row WARN 'Recycle bin' 'not found on any drive' }

# ════════════════════════════════════════════════════════════════════
#  powershell history
# ════════════════════════════════════════════════════════════════════

Section 'PowerShell history'

$histPath = Join-Path $env:APPDATA 'Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt'
if (Test-Path -LiteralPath $histPath) {
    $hist  = Get-Item -LiteralPath $histPath -Force
    $lines = @(Get-Content -LiteralPath $histPath).Count
    Row INFO 'History file' "$lines commands" ("{0}  ·  modified {1}" -f (Size-Text $hist.Length), (Ago $hist.LastWriteTime))

    $attr = $hist.Attributes
    if ($attr -band ([IO.FileAttributes]::Hidden -bor [IO.FileAttributes]::ReadOnly)) {
        Row WARN 'Attributes' ([string]$attr) 'hidden or read-only history file'
    } else {
        Row OK 'Attributes' 'normal'
    }
    if ($hist.CreationTime -ge $boot) {
        Row WARN 'Created' (Stamp $hist.CreationTime) 'history file is newer than the last boot'
    }
} else {
    Row INFO 'History file' 'not found' 'never used, or deleted'
}

# ════════════════════════════════════════════════════════════════════
#  summary
# ════════════════════════════════════════════════════════════════════

Section 'Summary'

$fails = @($script:Findings | Where-Object { $_.Level -eq 'FAIL' })
$warns = @($script:Findings | Where-Object { $_.Level -eq 'WARN' })

Out-K '   ' -NoNewline
if ($fails.Count -gt 0) {
    Out-K ' fail ' Red -NoNewline
    Out-K ' │ ' DarkGray -NoNewline
    Out-K "$($fails.Count) fail, $($warns.Count) warn  ·  look closely" Red
} elseif ($warns.Count -gt 0) {
    Out-K ' warn ' Yellow -NoNewline
    Out-K ' │ ' DarkGray -NoNewline
    Out-K "$($warns.Count) warning(s)  ·  check them below" Yellow
} else {
    Out-K '  ok  ' Green -NoNewline
    Out-K ' │ ' DarkGray -NoNewline
    Out-K 'nothing suspicious found' Green
}

foreach ($f in $fails) { Out-K ('          │   ✗ ' + $f.Text) Red }
foreach ($w in $warns) { Out-K ('          │   ! ' + $w.Text) Yellow }

Out-K
Out-K ('   scan took {0:N1}s' -f $script:Clock.Elapsed.TotalSeconds) DarkGray

# ════════════════════════════════════════════════════════════════════
#  save report + goodbye
# ════════════════════════════════════════════════════════════════════

Out-K
$save = Read-Host '   save this report to your desktop? [y/n]'
if ($save -match '^(?i)(y|yes)$') {
    $desktop = [Environment]::GetFolderPath('Desktop')
    $file    = Join-Path $desktop ("ketteh_services_{0}.txt" -f (Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'))
    try {
        [IO.File]::WriteAllText($file, $script:Report.ToString(), (New-Object Text.UTF8Encoding($true)))
        Write-Host "   saved -> $file" -ForegroundColor Green
    } catch {
        Write-Host "   couldn't save the report: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ''
Write-Host '   ────────────────────────────────────────────────────────' -ForegroundColor DarkMagenta
Write-Host '   made by ketteh  ' -ForegroundColor Gray -NoNewline
Write-Host '·' -ForegroundColor Magenta -NoNewline
Write-Host '  issues? discord: ' -ForegroundColor Gray -NoNewline
Write-Host 'zoe_mahhh' -ForegroundColor Magenta -NoNewline
Write-Host '  </3' -ForegroundColor DarkMagenta
Write-Host ''
Read-Host '   press enter to close'
