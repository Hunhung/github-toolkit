$ErrorActionPreference = "SilentlyContinue"
$good = "77909766+Hunhung@users.noreply.github.com"

Write-Host "[1/2] 全局配置："
$g = (git config --global user.email) 2>$null
if (-not $g) {
    Write-Host "      没设置"
} elseif ($g -eq $good) {
    Write-Host "      [对] $g"
} else {
    Write-Host "      [错] $g"
    Write-Host "      应该是：$good"
}
Write-Host ""

Write-Host "[2/2] 扫描本机仓库（可能要十几秒）..."
$roots = @(
    (Join-Path $env:USERPROFILE ".workbuddy"),
    (Join-Path $env:USERPROFILE "Documents"),
    (Join-Path $env:USERPROFILE "Desktop"),
    (Join-Path $env:USERPROFILE "OneDrive")
)
$count = 0
$bad = 0
foreach ($r in $roots) {
    if (-not (Test-Path $r)) { continue }
    Get-ChildItem -Path $r -Directory -Recurse -Depth 3 -Filter ".git" -Force |
        ForEach-Object {
            $repo = $_.Parent.FullName
            $e = (git -C $repo config --local user.email) 2>$null
            if ($e) {
                $script:count++
                if ($e -ne $good) {
                    $script:bad++
                    Write-Host "      [错] $repo"
                    Write-Host "           邮箱 = $e"
                } else {
                    Write-Host "      [对] $repo"
                }
            }
        }
}
if ($count -eq 0) { Write-Host "      没找到任何配了邮箱的仓库" }
Write-Host ""
Write-Host "=========================================="
if ($bad -eq 0) {
    Write-Host "结论：全部正确，不用改。"
    Write-Host ""
    Write-Host "如果 GitHub 上提交还是没有头像、贡献不涨，"
    Write-Host "那是历史提交里的旧邮箱错了，跟我说一声，我帮你重写。"
} else {
    Write-Host "结论：发现 $bad 个仓库的邮箱是错的。"
    Write-Host ""
    Write-Host "请把这段结果截图发给我，我帮你修（要重写历史，别自己动手）。"
}
Write-Host "=========================================="