# kimi-codex-proxy

在 [Kimi Code](https://www.kimi.com/code) 里使用 **ChatGPT 订阅的 Codex 额度**——通过本地 [CLIProxyAPI](https://github.com/router-for-me/CLIProxyAPI) OAuth 代理，把 Codex 后端暴露为本地 OpenAI 兼容接口，Kimi Code 以 `openai_responses` provider 接入。

## 功能

- `/codex-proxy:login` —— 引导完成 ChatGPT OAuth 授权
- `/codex-proxy:status` —— 检查代理存活、已登录账号、可用模型
- SessionStart 钩子：每次开会话时若代理没在跑则自动拉起
- 排障 skill：401/429/端口冲突/升级等常见问题处理

## 安装

```
/plugins install https://github.com/hommy36/kimi-codex-proxy
```

## 配置（一次性）

1. 下载 [CLIProxyAPI](https://github.com/router-for-me/CLIProxyAPI/releases) Windows 版，解压到固定目录
2. 写 `config.yaml`（监听 `127.0.0.1:8317`、设本地 `access.api-keys`、如需代理设 `requests.proxy-url`）
3. 运行 `./cli-proxy-api.exe -config config.yaml -codex-login` 完成浏览器授权
4. 在 `~/.kimi-code/config.toml` 注册 provider：

```toml
[providers.codex]
type = "openai_responses"
base_url = "http://127.0.0.1:8317/v1"
api_key = "<config.yaml 里的本地 key>"

[models."codex/gpt-5.6-sol"]
provider = "codex"
model = "gpt-5.6-sol"
max_context_size = 400000
capabilities = [ "thinking", "image_in", "tool_use" ]
```

5. TUI 里 `/model` 切到 `codex/...` 即可使用

此插件目前仅支持 Windows。代理安装在其他目录时，请在启动 Kimi Code 前设置环境变量 `KIMI_CODEX_PROXY_DIR` 为包含 `cli-proxy-api.exe` 和 `config.yaml` 的绝对路径，并重启 Kimi Code。未设置时沿用旧版默认目录 `D:/AI/AI_program/Kimicode_WebUI_to_Desktop/tools/cliproxyapi/`，以保持现有安装可用；登录、状态命令和自启钩子使用同一个目录约定。若修改代理端口，还需同步修改 `scripts/ensure-proxy.ps1` 和两个命令中的 `8317`。

从本地源码修改插件后，需要重新安装该插件，再运行 `/reload` 或开启新会话；已安装的托管副本不会随源码自动更新。

## 风险声明

用 ChatGPT 订阅额度驱动非官方客户端**违反 OpenAI 服务条款**，存在限流/封号风险。请自行评估，建议使用不重要的账号。

## License

MIT
