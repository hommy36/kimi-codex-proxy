---
description: 检查 Codex 本地代理状态、已登录账号和可用模型
---

检查 Codex 代理健康状况并汇报：

1. 代理进程：`powershell -NoProfile -Command "(Test-NetConnection -ComputerName 127.0.0.1 -Port 8317 -WarningAction SilentlyContinue).TcpTestSucceeded"`
2. 已登录的 OAuth 凭证：`ls D:/AI/AI_program/Kimicode_WebUI_to_Desktop/tools/cliproxyapi/auth/`（每个 codex-*.json 是一个账号）
3. 可用模型列表：
   `curl -s http://127.0.0.1:8317/v1/models -H "Authorization: Bearer $(grep 'api-keys' -A1 D:/AI/AI_program/Kimicode_WebUI_to_Desktop/tools/cliproxyapi/config.yaml | tail -1 | tr -d ' \"-')"`
4. 汇总：代理是否存活、已登录哪些 ChatGPT 账号、可用模型清单。若有异常，按 codex-proxy skill 的排障指引处理。
