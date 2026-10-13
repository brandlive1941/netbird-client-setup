# Installs the NetBird client on Windows and creates one profile per environment.
# Run in PowerShell as Administrator.
$ErrorActionPreference = "Stop"

$Url  = "https://netbird.brandlive.cloud"
$Name = Read-Host "Your first name"
$Envs = @("dev-qa", "staging") # add "prod" only if you have been given prod access

if (-not (Get-Command netbird -ErrorAction SilentlyContinue)) {
  $msi = Join-Path $env:TEMP "netbird.msi"
  Invoke-WebRequest "https://pkgs.netbird.io/windows/msi/x64" -OutFile $msi
  Start-Process msiexec -Wait -ArgumentList "/i `"$msi`" /qn"
  $env:Path += ";C:\Program Files\NetBird"
}

foreach ($e in $Envs) {
  $existing = (netbird profile list) -join "`n"
  if ($existing -notmatch "(?m)^$([regex]::Escape($e))\s") { netbird profile add $e }
  netbird login --profile $e --management-url $Url --hostname "$Name-$e"
}

netbird profile select dev-qa
netbird up
Write-Host "Done. Switch environments with: netbird profile select dev-qa|staging"
