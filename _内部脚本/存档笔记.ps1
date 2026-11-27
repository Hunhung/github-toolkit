# 笔记库一键存档：add -> commit -> push
$ErrorActionPreference = "Continue"
$vault = "D:\ObsidianData\Vaults\我的笔记"
$good  = "77909766+Hunhung@users.noreply.github.com"

Write-Host ""
Write-Host "==== 笔记库存档 ====" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $vault)) {
    Write-Host "[x] 找不到笔记库：$vault" -ForegroundColor Red
    return
}

$email = (git -C $vault config user.email) 2>$null
if ($email -ne $good) {
    git -C $vault config user.email $good | Out-Null
    git -C $vault config user.name "Hunhung" | Out-Null
    Write-Host "[!] 提交邮箱不对，已改回正确地址。" -ForegroundColor Yellow
}

git -C $vault add -A 2>$null
$changed = git -C $vault status --porcelain
if (-not $changed) {
    Write-Host "[OK] 没有改动，不用存。" -ForegroundColor Green
    Write-Host ""
    return
}

$count = ($changed | Measure-Object).Count
Write-Host "改了 $count 个文件："
$changed | Select-Object -First 12 | ForEach-Object { Write-Host "    $_" }
if ($count -gt 12) { Write-Host "    ...（还有 $($count - 12) 个）" }
Write-Host ""

$msg = "笔记存档 " + (Get-Date -Format "yyyy-MM-dd HH:mm")
git -C $vault commit -m $msg | Out-Null
Write-Host "[1/2] 已提交：$msg"
Write-Host "[2/2] 正在推 GitHub（走代理，慢的话等十几秒）..."

$out = git -C $vault -c http.proxy=http://127.0.0.1:12450 -c https.proxy=http://127.0.0.1:12450 push origin main 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] 推上去了。" -ForegroundColor Green
} else {
    Write-Host "[x] 推送失败。先双击 4_git推送失败_点这个.cmd 查代理，再来一次。" -ForegroundColor Red
    $out | Select-Object -Last 5 | ForEach-Object { Write-Host "    $_" }
}
Write-Host ""