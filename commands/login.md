---
description: 登录 ChatGPT 账号，把 Codex 订阅额度接入本地代理（OAuth）
---

帮助用户完成 Codex OAuth 登录，步骤如下：

1. 先确认代理是否在跑（避免登录期间端口冲突）：
   `powershell -NoProfile -Command "(Test-NetConnection -ComputerName 127.0.0.1 -Port 8317 -WarningAction SilentlyContinue).TcpTestSucceeded"`
2. 后台运行登录命令（会弹出浏览器，让用户在浏览器里完成 ChatGPT 授权）：
   `cd D:/AI/AI_program/Kimicode_WebUI_to_Desktop/tools/cliproxyapi && ./cli-proxy-api.exe -config config.yaml -codex-login`
   若本机浏览器不可用，加 `-no-browser`，把终端里打印的授权 URL 发给用户手动打开。
3. 登录成功后（auth/ 目录下出现 codex 的 token JSON），验证：
   `curl http://127.0.0.1:8317/v1/models -H "Authorization: Bearer $(grep 'api-keys' -A1 config.yaml | tail -1 | tr -d ' \"-')"`
   能看到 gpt-5-codex 系模型即完成。
4. 提醒用户：token 会自动刷新；若以后 401，重新跑本命令即可。
