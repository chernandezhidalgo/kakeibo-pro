# Genera el AAB de release con la configuracion de .env.
# Falla si faltan SUPABASE_URL o SUPABASE_ANON_KEY.
# Uso: powershell -ExecutionPolicy Bypass -File tool\build_release.ps1
$ErrorActionPreference = 'Stop'
Set-Location (Split-Path $PSScriptRoot -Parent)
if (-not (Test-Path .env)) { throw 'Falta el archivo .env en la raiz del proyecto.' }
$vals = @{}
foreach ($l in Get-Content .env) {
  if ($l -match '^\s*#' -or $l -notmatch '=') { continue }
  $k, $v = $l -split '=', 2
  $vals[$k.Trim()] = $v.Trim().Trim('"')
}
$required = 'SUPABASE_URL', 'SUPABASE_ANON_KEY'
$optional = 'REVENUECAT_API_KEY', 'GEMINI_API_KEY'
foreach ($k in $required) { if (-not $vals[$k]) { throw "Falta $k en .env. No se genera el AAB." } }
if ($vals['SUPABASE_URL'] -notmatch '^https://[a-z0-9]+\.supabase\.co/?$') { throw 'SUPABASE_URL no parece una URL valida de Supabase.' }
foreach ($k in $optional) { if (-not $vals[$k]) { Write-Warning "$k no esta en .env; esa funcion quedara desactivada en el AAB." } }
# Solo pasa al binario las claves que la app usa (nunca ANTHROPIC_API_KEY ni otras).
$tmp = Join-Path $env:TEMP 'kakeibo_dart_defines.json'
$o = [ordered]@{}
foreach ($k in $required + $optional) { if ($vals[$k]) { $o[$k] = $vals[$k] } }
$o['APP_ENV'] = 'production'
$o | ConvertTo-Json | Set-Content $tmp -Encoding ascii
try {
  flutter build appbundle --release --dart-define-from-file=$tmp
  if ($LASTEXITCODE -ne 0) { throw "flutter build fallo ($LASTEXITCODE)" }
} finally { Remove-Item $tmp -ErrorAction SilentlyContinue }
