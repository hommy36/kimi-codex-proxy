$ErrorActionPreference = 'Stop'

# Codex 代理自启钩子：8317 无法连接时拉起 CLIProxyAPI，然后立即退出（不阻塞会话启动）
$port = 8317
$dir = if ($env:KIMI_CODEX_PROXY_DIR) { $env:KIMI_CODEX_PROXY_DIR } else { 'D:\AI\AI_program\Kimicode_WebUI_to_Desktop\tools\cliproxyapi' }
$exe = [System.IO.Path]::Combine($dir, 'cli-proxy-api.exe')
$cfg = [System.IO.Path]::Combine($dir, 'config.yaml')

$alive = $false
$client = $null
try {
    $client = New-Object System.Net.Sockets.TcpClient
    $iar = $client.BeginConnect('127.0.0.1', $port, $null, $null)
    if ($iar.AsyncWaitHandle.WaitOne(1000)) {
        $client.EndConnect($iar)
        $alive = $true
    }
} catch {
    $alive = $false
} finally {
    if ($client) { $client.Close() }
}

if ($alive) { exit 0 }
if (-not (Test-Path -LiteralPath $exe -PathType Leaf) -or -not (Test-Path -LiteralPath $cfg -PathType Leaf)) {
    Write-Warning "CLIProxyAPI executable or config missing in $dir"
    exit 1
}
try {
    Start-Process -WindowStyle Hidden -FilePath $exe -ArgumentList '-config', 'config.yaml' -WorkingDirectory $dir -ErrorAction Stop
} catch {
    Write-Warning "Failed to start CLIProxyAPI in $dir"
    exit 1
}
exit 0
