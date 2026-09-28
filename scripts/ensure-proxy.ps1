$ErrorActionPreference = 'SilentlyContinue'

# Codex 代理自启钩子：8317 没监听就拉起 CLIProxyAPI，然后立即退出（不阻塞会话启动）
$port = 8317
$dir  = 'D:\AI\AI_program\Kimicode_WebUI_to_Desktop\tools\cliproxyapi'
$exe  = Join-Path $dir 'cli-proxy-api.exe'
$cfg  = Join-Path $dir 'config.yaml'

$alive = $false
try {
    $client = New-Object System.Net.Sockets.TcpClient
    $iar = $client.BeginConnect('127.0.0.1', $port, $null, $null)
    $alive = $iar.AsyncWaitHandle.WaitOne(1000)
    $client.Close()
} catch {}

if (-not $alive -and (Test-Path $exe) -and (Test-Path $cfg)) {
    Start-Process -WindowStyle Hidden -FilePath $exe -ArgumentList '-config', 'config.yaml' -WorkingDirectory $dir
}
exit 0
