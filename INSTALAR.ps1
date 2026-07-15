# Instalador da skill de design para o Claude Code (Windows / PowerShell).
$ErrorActionPreference = "Stop"

$Here = Split-Path -Parent $MyInvocation.MyCommand.Path
$Dest = Join-Path $env:USERPROFILE ".claude"

Write-Host "==> Instalando a skill de design no Claude Code"
Write-Host "    Origem : $Here"
Write-Host "    Destino: $Dest"
Write-Host ""

New-Item -ItemType Directory -Force -Path (Join-Path $Dest "skills") | Out-Null

function Backup-IfExists([string]$Target) {
  if (Test-Path $Target) {
    $Bak = "$Target.backup-antigo"
    Write-Host "    (ja existia) fazendo backup: $Target -> $Bak"
    if (Test-Path $Bak) { Remove-Item -Recurse -Force $Bak }
    Move-Item $Target $Bak
  }
}

# 1. skill principal
$t1 = Join-Path $Dest "skills\design-system"
Backup-IfExists $t1
Copy-Item -Recurse (Join-Path $Here "skills\design-system") $t1
Write-Host "  [ok] skills/design-system"

# 2. skill de motion
$t2 = Join-Path $Dest "skills\design-motion-principles"
Backup-IfExists $t2
Copy-Item -Recurse (Join-Path $Here "skills\design-motion-principles") $t2
Write-Host "  [ok] skills/design-motion-principles"

# 3. biblioteca de design systems
$t3 = Join-Path $Dest "design-systems"
Backup-IfExists $t3
Copy-Item -Recurse (Join-Path $Here "design-systems") $t3
Write-Host "  [ok] design-systems (60 design systems)"

Write-Host ""
Write-Host "==> Pronto!"
Write-Host "    Feche e abra o Claude Code de novo, e digite  /design"
Write-Host "    (Leia o README.md pra requisitos: Node.js e MCP do Playwright.)"
