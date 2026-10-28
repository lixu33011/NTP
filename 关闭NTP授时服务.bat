@echo off
chcp 65001 >nul
echo 关闭NTP授时服务（本机不再对外提供123授时，仍可同步外网）
reg add "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpServer" /v Enabled /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Config" /v AnnounceFlags /t REG_DWORD /d 10 /f
netsh advfirewall firewall delete rule name="NTP-Server-UDP123" >nul 2>&1
net stop w32time
net start w32time
echo.
echo ========== 验证方法（管理员CMD执行） ==========
echo w32tm /query /configuration
echo 查找 NtpServer 下 Enabled:0 即为关闭成功
echo 出现 error:0x800705B4 是正常现象，代表不提供NTP授时
echo ==============================================
pause
