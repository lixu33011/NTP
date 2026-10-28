@echo off
chcp 65001 >nul
echo -------------------------------------
echo      NTP服务器本机状态检测【新版】
echo -------------------------------------
sc query w32time
echo.
echo [读取注册表 NtpServer.Enabled]
reg query "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpServer" /v Enabled
echo.
for /f "tokens=3" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpServer" /v Enabled ^|findstr Enabled') do set NTPSRV_EN=%%a
if %NTPSRV_EN% EQU 0 (
    echo ❌ 当前：NTP服务端【已关闭】，不能对外授时
) else (
    echo ✅ 当前：NTP服务端【已开启】，可以对外授时
)
echo.
echo [2] 连通性测试 127.0.0.1:123
w32tm /stripchart /computer:127.0.0.1 /dataonly /samples:2
echo.
pause
