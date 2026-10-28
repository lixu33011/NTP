@echo off
chcp 65001 >nul
:: 检测管理员权限
fltmc >nul 2>&1 || (
    echo ❌ 当前不是管理员权限！
    echo 请右键此bat文件 → 以管理员身份重新运行！
    pause
    exit /b
)

echo ==============================================
echo          一键开启Windows NTP时间服务器
echo ==============================================
echo.
echo [1] 修改注册表开启NTP Server
reg add "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpServer" /v Enabled /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Config" /v AnnounceFlags /t REG_DWORD /d 5 /f
w32tm /config /manualpeerlist:"ntp.aliyun.com,0x8" /syncfromflags:manual /reliable:yes /update

echo [2] 防火墙放行UDP 123端口（NTP默认端口）
netsh advfirewall firewall show rule name="NTP-Server-UDP123" >nul
if %errorlevel% neq 0 (
    netsh advfirewall firewall add rule name="NTP-Server-UDP123" dir=in action=allow protocol=UDP localport=123 remoteip=any profile=any enable=yes
) else (
    echo 防火墙规则已存在，跳过
)

echo [3] 重启Windows时间服务
net stop w32time
net start w32time

echo [4] 强制本机同步一次外网时间
w32tm /resync /force

echo.
echo ==============================================
echo ✅ 配置完成！
echo 👉 其他设备NTP服务器地址填：本机内网IP
echo 👉 测试命令：w32tm /stripchart /computer:IP地址 /dataonly
echo ==============================================
pause
