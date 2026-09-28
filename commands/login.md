---
description: 登录 ChatGPT 账号，把 Codex 订阅额度接入本地代理（OAuth）
---

帮助用户完成 Codex OAuth 登录，步骤如下（命令在 Git Bash 中运行）：

1. 代理目录优先取 `KIMI_CODEX_PROXY_DIR`，否则使用 README 中的旧版默认目录。若目录没有 `cli-proxy-api.exe` 和 `config.yaml`，请用户设置环境变量；每次 Bash 调用都要重新解析目录，不要猜测其他目录。
2. 先确认代理是否在跑（避免登录期间端口冲突）：
   `powershell -NoProfile -Command "(Test-NetConnection -ComputerName 127.0.0.1 -Port 8317 -WarningAction SilentlyContinue).TcpTestSucceeded"`
3. 后台运行登录命令（会弹出浏览器，让用户在浏览器里完成 ChatGPT 授权）：
   `cd "${KIMI_CODEX_PROXY_DIR:-D:/AI/AI_program/Kimicode_WebUI_to_Desktop/tools/cliproxyapi}" && ./cli-proxy-api.exe -config config.yaml -codex-login`
   若本机浏览器不可用，加 `-no-browser`，把终端里打印的授权 URL 发给用户手动打开。
4. 登录成功后（`auth/` 下出现 codex 的 token JSON；不要读取或打印其内容），在同一次 Bash 调用中用本地 API key 验证：
   `dir="${KIMI_CODEX_PROXY_DIR:-D:/AI/AI_program/Kimicode_WebUI_to_Desktop/tools/cliproxyapi}"; key=$(grep -m1 -A1 '^  api-keys:' "$dir/config.yaml" | tail -1 | sed -E 's/^[[:space:]]*-[[:space:]]*[\x22\x27]?//; s/[\x22\x27]?[[:space:]]*$//'); if [ -n "$key" ]; then curl -s http://127.0.0.1:8317/v1/models -H "Authorization: Bearer $key"; else printf '未找到 access.api-keys，请手动检查配置\n'; fi; unset key`
   不要在对话中输出 key；若 YAML 使用其他格式，询问用户如何安全地验证，勿猜测 key。能看到已配置的 Codex 模型即完成。
5. 提醒用户：token 会自动刷新；若以后 401，先区分本地 key 错误和上游认证失效。
