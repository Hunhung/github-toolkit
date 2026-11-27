@echo off
chcp 936 >nul
title git 推送失败 - 修复
echo ==========================================
echo    git 推送代码失败   检查与修复
echo ==========================================
echo.
set "REPO=%USERPROFILE%\.workbuddy\skills"
if not exist "%REPO%\.git" (
    echo 没找到测试用的仓库，跳过实测。
    goto :setproxy
)
echo [1/3] 当前 git 有没有配代理 ...
git config --global --get http.proxy
if errorlevel 1 (echo      没配) else (echo      上面就是当前配置)
echo.

echo [2/3] 实测连一次 GitHub ...
git -C "%REPO%" ls-remote origin refs/heads/main >nul 2>&1
if errorlevel 1 (echo      连不上) else (echo      连得上)
echo.

echo [3/3] 设置 git 走代理 ...
:setproxy
git config --global http.proxy "http://127.0.0.1:12450"
git config --global https.proxy "http://127.0.0.1:12450"
echo       已设置：http://127.0.0.1:12450
echo.

if exist "%REPO%\.git" (
    echo 再测一次 ...
    git -C "%REPO%" ls-remote origin refs/heads/main >nul 2>&1
    if errorlevel 1 (
        echo     还是连不上。
        echo     请先打开 SakuraCat，确认代理在跑，再双击本文件一次。
    ) else (
        echo     成功！现在可以正常推送了。
    )
)
echo.
echo 小提示：以后如果关了代理想恢复直连，双击本文件后
echo 告诉我，或者跟我说一声我帮你改回来。
echo.
pause