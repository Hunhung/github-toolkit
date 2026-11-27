@echo off
chcp 936 >nul
title 提交邮箱检查
echo ==========================================
echo    检查提交邮箱有没有写错
echo ==========================================
echo.
echo 正确的邮箱必须是：
echo    77909766+Hunhung@users.noreply.github.com
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0_内部脚本\检查邮箱.ps1"
echo.
pause