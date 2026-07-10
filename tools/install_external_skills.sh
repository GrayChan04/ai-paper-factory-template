#!/usr/bin/env bash
set -euo pipefail

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
INSTALLER="$CODEX_HOME/skills/.system/skill-installer/scripts/install-skill-from-github.py"

if [ ! -f "$INSTALLER" ]; then
  echo "未找到 Codex skill installer: $INSTALLER"
  echo "请在 Codex 中使用 $skill-installer，或手动安装 skills.manifest.json 中的外部 Skill。"
  exit 0
fi

python - <<'PY'
import json, subprocess, os
manifest=json.load(open("skills.manifest.json",encoding="utf-8"))
installer=os.path.expanduser(os.environ.get("CODEX_HOME", "~/.codex") + "/skills/.system/skill-installer/scripts/install-skill-from-github.py")
for s in manifest["external_skills"]:
    print(f"Installing {s['name']}...")
    subprocess.run(["python", installer, "--repo", s["repo"], "--ref", s["ref"], "--path", s["path"], "--method", "git"], check=False)
PY

echo "完成。请重启 Codex 并运行 /skills。"
