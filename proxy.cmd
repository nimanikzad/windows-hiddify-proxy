@echo off
rem Windows Hiddify Proxy. MIT License; see LICENSE.
rem Run from an existing CMD window. From another batch file, use CALL.
setlocal EnableExtensions EnableDelayedExpansion
set "choice=%~1"
set "port="
set "scheme="
if not defined choice goto menu
goto dispatch

:menu
echo.
echo Terminal Proxy Switcher
echo 1^) Hiddify HTTP/mixed proxy - port 12334
echo 2^) Direct SOCKS5 proxy - port 1080
echo 3^) Custom port on 127.0.0.1
echo 4^) Exit and keep current settings
echo 0^) Disable proxy for this CMD window
echo s^) Show status
set /p "choice=Choice [1-4/0/s]: "
if not defined choice goto finish

:dispatch
if /i "!choice!"=="1" goto hiddify
if /i "!choice!"=="on" goto hiddify
if /i "!choice!"=="2" goto socks
if /i "!choice!"=="socks" goto socks
if /i "!choice!"=="3" goto custom
if /i "!choice!"=="0" goto disable
if /i "!choice!"=="off" goto disable
if /i "!choice!"=="status" goto status
if /i "!choice!"=="s" goto status
if /i "!choice!"=="4" goto finish
if /i "!choice!"=="q" goto finish
if /i "!choice!"=="exit" goto finish
echo Usage: proxy [on [PORT] ^| socks [PORT] ^| off ^| status]
endlocal
exit /b 1

:hiddify
set "scheme=http"
set "port=12334"
if defined HIDDIFY_PROXY_PORT set "port=!HIDDIFY_PROXY_PORT!"
if not "%~2"=="" set "port=%~2"
goto validate

:socks
set "scheme=socks5h"
set "port=1080"
if not "%~2"=="" set "port=%~2"
goto validate

:custom
set /p "port=Port (1-65535): "
set "scheme=http"
set "answer="
set /p "answer=Type [h]ttp / [s]ocks5 (default http): "
if /i "!answer!"=="s" set "scheme=socks5h"
if /i "!answer!"=="socks5" set "scheme=socks5h"
goto validate

:validate
if not defined port goto invalid
if not "!port:~5!"=="" goto invalid
rem Remove all digits; any remaining character makes the input invalid.
set "nondigits=!port!"
for %%D in (0 1 2 3 4 5 6 7 8 9) do set "nondigits=!nondigits:%%D=!"
if defined nondigits goto invalid
rem Prefix padded digits with 1 to avoid CMD's leading-zero octal parsing.
set "padded=00000!port!"
set "padded=!padded:~-5!"
set /a "port=1!padded!-100000" >nul
if !port! LSS 1 goto invalid
if !port! GTR 65535 goto invalid
set "url=!scheme!://127.0.0.1:!port!"
rem Commit only validated values to the caller's CMD environment.
endlocal & set "http_proxy=%url%" & set "https_proxy=%url%" & set "all_proxy=%url%" & set "no_proxy=localhost,127.0.0.1,::1"
echo Proxy enabled for this CMD window: %http_proxy%
exit /b 0

:invalid
echo Invalid port. Enter digits from 1 to 65535.
endlocal
exit /b 1

:disable
endlocal
set "http_proxy="
set "https_proxy="
set "all_proxy="
set "no_proxy="
echo Proxy variables cleared for this CMD window.
exit /b 0

:status
echo Proxy environment variables:
set http_proxy 2>nul
set https_proxy 2>nul
set all_proxy 2>nul
set no_proxy 2>nul
echo If no variables are listed, none are set by these names.
endlocal
exit /b 0

:finish
endlocal
exit /b 0
