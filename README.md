# KettehLyzer

KettehLyzer is a PowerShell-based, terminal-only Minecraft mod analyzer designed to inspect `.jar` mods and report suspicious cheat-client signatures, bypass/injection indicators, obfuscation indicators, and hash verification results.

It also detects the active Minecraft Java process and displays its runtime/uptime while automatically redacting sensitive authentication values from JVM command-line output.

## 🚀 Quick Start

### Copy & Paste

Open **PowerShell**, then copy and paste this command:

```powershell
powershell -Command "Set-ExecutionPolicy Bypass -Scope Process; Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/KettehDev/KettehLyzer/main/KettehLyzer.ps1')"
```

This downloads and runs the latest version of KettehLyzer directly from GitHub.

> **Note:** The execution policy bypass only applies to the current PowerShell process and does not permanently change your system's execution policy.

## Features

- Pure terminal interface
- No WPF or GUI dependencies
- Scans Minecraft `.jar` files
- SHA-1 hashing
- Modrinth hash verification
- Megabase hash verification
- Cheat signature scanning
- Cheat-string detection
- Known client fingerprint detection
- Nested JAR scanning
- Bypass/injection detection
- Runtime/instrumentation indicators
- Obfuscation indicators
- Minecraft `javaw.exe` detection
- Java process PID and start time
- Minecraft JVM uptime
- Sensitive token/secret redaction
- Final scan summary
- Detailed findings for flagged mods

## Detection Results

KettehLyzer can classify mods using these statuses:

| Status | Meaning |
|---|---|
| `VERIFIED` | SHA-1 matched a Modrinth or Megabase entry |
| `FLAGGED` | Suspicious cheat signatures or cheat strings were detected |
| `BYPASS` | Bypass/injection indicators were detected |
| `OBFUSCATED` | Obfuscation indicators were detected without a stronger classification |
| `UNKNOWN` | No known hash match and no stronger detection was found |

A detection is an indicator, not automatic proof that a mod is malicious or that every detected string represents an active cheat feature. Some legitimate mods can contain generic terms that overlap with the signature database.

## Cheat Detection

The analyzer checks for a large collection of strings and fingerprints covering areas such as:

- AutoCrystal
- AutoAnchor
- AutoTotem
- AutoArmor
- AutoMace
- MaceSwap
- AimAssist
- TriggerBot
- SilentAim
- KillAura
- Reach
- Hitbox
- CrystalAura
- BedAura
- Surround
- SelfTrap
- HoleFill
- Scaffold
- Fly
- Speed
- NoFall
- PacketFly
- Phase
- Freecam
- Xray
- ESP
- WallHack
- Fullbright
- NoRender
- Blink
- Timer
- PingSpoof
- Disabler
- Grim/Vulcan/Matrix/Intave/Verus/Polar bypass indicators
- Known client fingerprints
- Token/session stealing indicators
- Webhook and remote-access indicators
- Native/injection indicators
- Common cheat module and packet fingerprints

The exact detection database is contained in the PowerShell script itself.

## Java Runtime Detection

KettehLyzer looks for running `javaw.exe` and `java.exe` processes.

It attempts to identify the actual Minecraft process instead of selecting a launcher helper or crash-assistant process.

A Minecraft process is recognized using launch information such as:

- Fabric Loader
- KnotClient
- Minecraft main classes
- Modrinth/Theseus Minecraft launch information

The runtime section displays information similar to:

```text
===============================================================
 CURRENT JAVA RUNTIME
===============================================================

 Process : javaw.exe
 PID     : 30592
 Type    : MINECRAFT
 Started : 2026-09-21 20:35:18
 Uptime  : 00d 00h 21m 40s
 Status  : RUNNING
 Selected: YES
```

## Sensitive Data Protection

Minecraft launcher command lines can contain authentication credentials.

KettehLyzer automatically redacts sensitive values before displaying command-line information.

Examples include:

- `--accessToken`
- `--access-token`
- `--refreshToken`
- `--refresh-token`
- `--clientSecret`
- `--client-secret`
- `--password`
- `--token`
- `accessToken=`
- `access_token=`
- `refreshToken=`
- `Authorization: Bearer`
- `Bearer`
- JWT-shaped authentication values

Redacted values appear as:

```text
[REDACTED]
```

or:

```text
[REDACTED-JWT]
```

Do not intentionally share raw Minecraft launcher command lines containing authentication information.

## Scan Passes

### Pass 1 — Hash Verification

Each JAR is hashed with SHA-1.

The hash is checked against:

- Modrinth
- Megabase

A successful match produces a `VERIFIED` result.

### Pass 2 — Cheat-Signature Scan

Mods selected for deep scanning are inspected for:

- Suspicious strings
- Cheat modules
- Known client fingerprints
- Packet/movement/rotation indicators
- Cheat-related class/package names

When a mod is flagged, KettehLyzer prints the actual matching strings.

Example:

```text
[FLAGGED] example-client.jar

    Cheat strings detected:
      • AutoCrystal
      • KillAura
      • SilentAim

    Suspicious signatures:
      • ClientPlayerInteractionManagerAccessor
      • AttackEntityC2SPacket
```

### Pass 3 — Bypass / Injection Scan

This pass looks for indicators associated with:

- Java agents
- Runtime instrumentation
- Class transformation
- Native hooks
- DLL loading
- Process injection
- Runtime execution
- Dynamic class loading
- HTTP communication
- Webhooks
- Discord webhook endpoints

These findings should be investigated in context.

### Pass 4 — Obfuscation Scan

This pass looks for indicators such as:

- Large quantities of unusually short class names
- Opaque class naming
- Reflection
- Dynamic class definition
- `invokedynamic`
- Base64 references
- Cipher references
- MessageDigest references

Obfuscation by itself does not prove malicious behavior. Legitimate software can also use obfuscation.

## Output

The final report contains:

```text
Total JARs
Verified
Flagged
Bypass detected
Obfuscated
Unknown
Unique cheat strings detected
Unique signatures detected
```

Flagged mods receive a detailed section containing the matching cheat strings and signatures.

## Mod Folder Detection

KettehLyzer attempts to automatically locate the Minecraft mods folder.

Common locations include:

```text
%APPDATA%\.minecraft\mods
```

and Modrinth profile directories such as:

```text
%APPDATA%\ModrinthApp\profiles\<profile>\mods
```

If a mods folder cannot be automatically detected, KettehLyzer will ask you to provide the path manually.

## Command-Line Options

### Custom Mods Path

```powershell
.\KettehLyzer.ps1 -ModsPath "C:\Path\To\mods"
```

### Deep Scan All Mods

By default, deeper scans can focus on mods that are not already verified.

To scan every mod:

```powershell
.\KettehLyzer.ps1 -DeepScanAll
```

### No Pause

To prevent the script from waiting for input when finished:

```powershell
.\KettehLyzer.ps1 -NoPause
```

Options can also be combined:

```powershell
.\KettehLyzer.ps1 -ModsPath "C:\Path\To\mods" -DeepScanAll -NoPause
```

## Requirements

- Windows
- PowerShell 5.1 or newer
- Minecraft Java Edition
- Internet access for online hash verification
- A Minecraft mods folder containing `.jar` files

No additional PowerShell modules or GUI libraries are required.

## File Safety

KettehLyzer analyzes Minecraft mod files without launching the scanned mods.

Online requests are used for hash verification against the configured Modrinth and Megabase endpoints.

The analyzer should not be considered a complete malware scanner. Suspicious results should be investigated further before running an unknown mod.

## Important Notes

KettehLyzer is a static-analysis and indicator-based scanner.

A `VERIFIED` result does not guarantee that a file is safe in every possible circumstance.

An `UNKNOWN` result does not automatically mean that a mod is malicious.

Likewise, a detected string does not automatically prove that a mod contains an operational cheat or malicious payload. False positives are possible because legitimate software can contain class names, module names, documentation, or functionality that overlaps with the detection database.

For suspicious mods, inspect the actual source code or JAR contents and verify the download source before running them.

## Version

```text
KettehLyzer v2.2
Minecraft Mod Security Analyzer
No GUI • Pure Terminal
```

## GitHub

**Repository:**  
https://github.com/KettehDev/KettehLyzer

**Latest Script:**  
https://raw.githubusercontent.com/KettehDev/KettehLyzer/main/KettehLyzer.ps1
