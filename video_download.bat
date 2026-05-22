@echo off
chcp 65001 >nul
title 视频下载器 - yt-dlp（自动下载模式）

:: 创建下载文件夹
if not exist "source" mkdir "source"

echo ========================================
echo        视频下载器（yt-dlp 自动模式）
echo ========================================
echo.

:: 检查 yt-dlp.exe 是否存在，不存在则自动下载
if not exist "yt-dlp.exe" (
    echo [信息] 未检测到 yt-dlp.exe，正在自动下载最新版本...
    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe' -OutFile 'yt-dlp.exe'"
    
    if exist "yt-dlp.exe" (
        echo [成功] yt-dlp.exe 下载完成！
    ) else (
        echo [错误] 下载失败，请手动下载 yt-dlp.exe 并放在当前目录。
        echo 下载地址: https://github.com/yt-dlp/yt-dlp/releases/latest
        pause
        exit /b
    )
    echo.
)

:loop
set URL=
set /p URL=请输入视频链接（直接回车或输入 q 退出）：

if "%URL%"=="" goto :end
if /i "%URL%"=="q" goto :end
if /i "%URL%"=="exit" goto :end

echo.
echo ========================================
echo 正在下载：%URL%
echo ========================================
echo.

yt-dlp ^
  --concurrent-fragments 16 ^
  --retries 10 ^
  --fragment-retries 10 ^
  -f "bestvideo+bestaudio/best" ^
  --merge-output-format mp4 ^
  -o "source\%%(title)s [%%(id)s].%%(ext)s" ^
  "%URL%"

echo.
echo ========================================
echo 下载完成！文件已保存到 source 文件夹
echo ========================================
echo.

timeout /t 1 /nobreak >nul
goto loop

:end
echo.
echo 程序已退出。
timeout /t 1 /nobreak >nul
exit