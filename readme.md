KettehLyzer is a PowerShell-based, terminal-only Minecraft mod analyzer designed to inspect `.jar` mods and report suspicious cheat-client signatures, bypass/injection indicators, obfuscation indicators, and hash verification results.

It also detects the active Minecraft Java process and displays its runtime/uptime while automatically redacting sensitive authentication values from JVM command-line output.

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

## Powershell Script
Paste this to RUN the full script
| ` powershell -Command "Set-ExecutionPolicy Bypass -Scope Process; Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/KettehDev/KettehLyzer/main/KettehLyzer.ps1')"` |

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
