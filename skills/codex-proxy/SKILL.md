---
name: codex-proxy
description: Codex 代理（CLIProxyAPI）排障与运维指引。当用户遇到 codex 模型 401/429/连不上代理、token 过期、端口冲突时使用。
---

# Codex 代理运维指引

本机通过 CLIProxyAPI 把 ChatGPT/Codex 订阅额度暴露为本地 OpenAI 兼容接口：

- 安装目录：优先使用 `KIMI_CODEX_PROXY_DIR`，未设置时沿用 `D:/AI/AI_program/Kimicode_WebUI_to_Desktop/tools/cliproxyapi/`；需要包含 `cli-proxy-api.exe` 和 `config.yaml`
- 监听：`127.0.0.1:8317`，本地 API key 在 `config.yaml` 的 `access.api-keys` 里
- OAuth token 目录：上述安装目录的 `auth/`（**绝不要提交、上传或打印 token 内容**）
- Kimi Code 侧：`config.toml` 里 `providers.codex`（type = `openai_responses`）指向 `http://127.0.0.1:8317/v1`

## 常见故障

**Kimi Code 报连不上 / connection refused**
代理没在跑。执行插件钩子同款脚本拉起：
`powershell -NoProfile -ExecutionPolicy Bypass -File <插件目录>/scripts/ensure-proxy.ps1`
或先进入上述代理安装目录，再执行 `./cli-proxy-api.exe -config config.yaml`。

**401 / unauthorized（上游）**
ChatGPT token 过期且自动刷新失败。先进入上述代理安装目录，再重新登录：
`./cli-proxy-api.exe -config config.yaml -codex-login`

**401 / invalid api key（本地）**
请求头里的 key 和 `config.yaml` 的 `access.api-keys` 不一致，以 config.yaml 为准。

**429 / rate limit**
订阅额度窗口用完（Codex 有 5 小时 / 每周两个窗口）。等窗口重置，或登录第二个账号（CLIProxyAPI 支持多账号轮询：再跑一次 `-codex-login` 即可追加）。

**端口被占用**
`netstat -ano | findstr :8317` 找到占用进程；确认不是正在使用的代理后，再决定是否停掉它。若修改 `config.yaml` 的 `server.port`，还须同步修改 Kimi Code `config.toml` 的 `base_url`、`scripts/ensure-proxy.ps1` 的 `$port` 和两个命令中的端口。

## 升级 CLIProxyAPI

从 https://github.com/router-for-me/CLIProxyAPI/releases 下载最新 windows_amd64 zip，停掉旧进程后替换 `cli-proxy-api.exe` 即可，config 和 auth 不动。

## 风险提醒

用 ChatGPT 订阅额度驱动非官方客户端违反 OpenAI 条款，有限流/封号风险。用户已知悉并接受；如账号出现异常，建议改用正式 API key 或停止此用法。
