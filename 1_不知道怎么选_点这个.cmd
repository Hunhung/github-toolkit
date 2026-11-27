@echo off
chcp 936 >nul
title 电脑工具
:menu
cls
echo ==========================================
echo                电脑工具
echo ==========================================
echo.
echo   你遇到的是哪种情况？按数字，回车。
echo.
echo    [1] GitHub 打不开 / 跳到写着 nginx 的怪页面
echo    [2] 贡献数不涨 / 提交没有头像
echo    [3] git 推送代码失败 / 一直卡住
echo    [4] 网络或代理出问题（上不了外网）
echo    [5] 打开说明
echo    [6] 笔记改完想存档（推 Obsidian 到 GitHub）
echo    [0] 退出
echo.
set "CH="
set /p "CH=  请输入数字: "
if "%CH%"=="1" call "%~dp02_GitHub打不开_点这个.cmd"
if "%CH%"=="2" call "%~dp03_贡献数不涨_点这个.cmd"
if "%CH%"=="3" call "%~dp04_git推送失败_点这个.cmd"
if "%CH%"=="4" start "" "%~dp05_网络或代理出问题_点这个.lnk"
if "%CH%"=="5" start "" notepad "%~dp0说明.txt"
if "%CH%"=="6" call "%~dp06_笔记改完想存档_点这个.cmd"
if "%CH%"=="0" exit /b
goto menu