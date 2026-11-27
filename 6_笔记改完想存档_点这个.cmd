@echo off
chcp 936 >nul
title 笔记改完想存档
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0_内部脚本\存档笔记.ps1"
echo.
pause
