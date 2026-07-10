$CodexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME ".codex" }
$Installer = Join-Path $CodexHome "skills/.system/skill-installer/scripts/install-skill-from-github.py"
if (-Not (Test-Path $Installer)) {
    Write-Host "未找到 Codex skill installer: $Installer"
    Write-Host "请在 Codex 中使用 `$skill-installer，或手动安装 skills.manifest.json 中的外部 Skill。"
    exit 0
}
$manifest = Get-Content skills.manifest.json | ConvertFrom-Json
foreach ($s in $manifest.external_skills) {
    Write-Host "Installing $($s.name)..."
    python $Installer --repo $s.repo --ref $s.ref --path $s.path --method git
}
Write-Host "完成。请重启 Codex 并运行 /skills。"
