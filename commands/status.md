---
description: 检查 Codex 本地代理状态、已登录账号和可用模型
---

检查 Codex 代理健康状况并汇报（命令在 Git Bash 中运行）：

1. 代理目录优先取 `KIMI_CODEX_PROXY_DIR`，否则使用 README 中的旧版默认目录；每次 Bash 调用都要重新解析目录。若目录不存在，请用户设置环境变量。
2. 代理端口：`powershell -NoProfile -Command "(Test-NetConnection -ComputerName 127.0.0.1 -Port 8317 -WarningAction SilentlyContinue).TcpTestSucceeded"`
3. 已登录的 OAuth 凭证：`ls "${KIMI_CODEX_PROXY_DIR:-D:/AI/AI_program/Kimicode_WebUI_to_Desktop/tools/cliproxyapi}/auth"/codex-*.json`（只看文件名，绝不读取、上传或打印 token 内容）
4. 可用模型列表（不在对话中输出本地 API key；以下内容在同一次 Bash 调用中运行）：
   `dir="${KIMI_CODEX_PROXY_DIR:-D:/AI/AI_program/Kimicode_WebUI_to_Desktop/tools/cliproxyapi}"; key=$(grep -m1 -A1 '^  api-keys:' "$dir/config.yaml" | tail -1 | sed -E 's/^[[:space:]]*-[[:space:]]*[\x22\x27]?//; s/[\x22\x27]?[[:space:]]*$//'); if [ -n "$key" ]; then curl -s http://127.0.0.1:8317/v1/models -H "Authorization: Bearer $key"; else printf '未找到 access.api-keys，请手动检查配置\n'; fi; unset key`
   若 YAML 使用其他格式，不要猜测或泄露 key，向用户说明无法自动验证模型列表。
5. 汇总：代理是否存活、已登录哪些 ChatGPT 账号、可用模型清单。若有异常，按 codex-proxy skill 的排障指引处理。
