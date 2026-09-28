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

> 注意：插件钩子里的代理路径目前按作者本机路径写死（`scripts/ensure-proxy.ps1` 顶部的 `$dir`），在其他机器使用请改成自己的安装路径。

## 风险声明

用 ChatGPT 订阅额度驱动非官方客户端**违反 OpenAI 服务条款**，存在限流/封号风险。请自行评估，建议使用不重要的账号。

## License

MIT
