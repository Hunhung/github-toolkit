@echo off
chcp 936 >nul
title GitHub 打不开 - 诊断
echo ==========================================
echo    GitHub 打不开   自动诊断
echo ==========================================
echo.
echo [1/3] 清理 DNS 缓存 ...
ipconfig /flushdns >nul
echo       完成
echo.

echo [2/3] 检查 SakuraCat 代理 ...
powershell -NoProfile -Command "if(Get-NetTCPConnection -State Listen -LocalPort 12450 -ErrorAction SilentlyContinue){exit 0}else{exit 1}"
if errorlevel 1 (echo       没开) else (echo       在线)
echo.

echo [3/3] 实测两条线路 ...
set "AOK=0"
set "BOK=0"
curl.exe -s -o NUL -m 15 -f https://github.com
if not errorlevel 1 set "AOK=1"
curl.exe -s -o NUL -m 15 -f -x http://127.0.0.1:12450 https://github.com
if not errorlevel 1 set "BOK=1"
if "%AOK%"=="1" (echo       直连   : 通) else (echo       直连   : 不通)
if "%BOK%"=="1" (echo       走代理 : 通) else (echo       走代理 : 不通)
echo.
echo ============== 结论 ==============
if "%AOK%%BOK%"=="11" goto :allok
if "%AOK%%BOK%"=="01" goto :proxyonly
if "%AOK%%BOK%"=="10" goto :directonly
goto :bothfail

:allok
echo 网络完全正常，问题在浏览器。
echo   1. 在浏览器里按 Ctrl+F5 强制刷新
echo   2. 还不行就清一下浏览器缓存
echo   3. 或者换个浏览器打开试试
goto :end

:proxyonly
echo 直连不通，但走代理是通的。
echo 办法：让 SakuraCat 一直开着就行，别关。
goto :end

:directonly
echo 走代理不通，但直连是通的。
echo 办法：把 SakuraCat 的系统代理开关关掉，直接用直连。
goto :end

:bothfail
echo 两条路都不通。
echo   1. 先打开 SakuraCat，等它连上，再双击本文件
echo   2. 还不行就在 SakuraCat 里换个节点
echo   3. 实在不行用手机热点试一次
goto :end

:end
echo.
pause