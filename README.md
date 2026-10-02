# Windows Hiddify Proxy

A small CMD helper for Windows 11 users who use Hiddify. Enable, disable, and inspect terminal proxy environment variables from a menu or a single command.

Supports Hiddify's local HTTP/mixed listener, a local SOCKS5 listener, and custom ports. No administrator privileges or installation required.

## Before you start

1. Start Hiddify and connect to your server.
2. Check its local HTTP/mixed listener port. This helper uses **12334** by default; your configuration may differ.
3. Open **Command Prompt (CMD)**. In Windows Terminal, select the Command Prompt profile.

## Download and run

Download `proxy.cmd` from this repository using GitHub's raw-file download button. Save it in a folder you want to keep, such as `C:\Tools\hiddify-proxy`.

In an existing CMD window, run:

```bat
cd /d C:\Tools\hiddify-proxy
proxy
```

Do not launch it by double-clicking: the proxy settings belong to the CMD window that runs the helper and disappear when that window closes.

## Commands

```bat
proxy
proxy on
proxy on 8080
proxy socks
proxy socks 1081
proxy status
proxy off
```

`proxy` opens the menu. `on` selects HTTP/mixed mode (default port 12334), `socks` selects SOCKS5 (default port 1080), `status` displays variables, and `off` clears them. An optional port overrides the default.

The menu also offers a custom port and a choice between HTTP and SOCKS5. Port 1080 is a configurable convention, not a guarantee that a SOCKS proxy is running there.

To change the default Hiddify port for the current window:

```bat
set "HIDDIFY_PROXY_PORT=8080"
proxy on
```

From another `.cmd` or `.bat` file, use `call` so execution returns to your script:

```bat
call C:\Tools\hiddify-proxy\proxy.cmd on
curl.exe --max-time 15 --head https://example.com
```

## Use from any folder

For the current CMD window only, add the helper folder to PATH:

```bat
set "PATH=C:\Tools\hiddify-proxy;%PATH%"
```

For a persistent setup, search Windows for **Edit environment variables for your account**, edit your user **Path**, and add `C:\Tools\hiddify-proxy` as a new entry. Open a new CMD window afterward. Add the folder, not the `proxy.cmd` file itself.

## Quick check

```bat
proxy on
proxy status
curl.exe --max-time 15 --head https://example.com
```

If curl cannot connect, verify that Hiddify is connected and the local listener port and protocol match. The helper sets variables; it does not start Hiddify or verify connectivity automatically.

## Scope and behavior

- Sets `http_proxy`, `https_proxy`, `all_proxy`, and `no_proxy` for the current CMD process and programs subsequently started from it that honor these variables.
- Windows environment-variable names are case-insensitive, so separate uppercase copies are unnecessary.
- HTTP mode uses `http://127.0.0.1:PORT`, including for HTTPS destinations through the proxy. SOCKS5 mode uses `socks5h://127.0.0.1:PORT` for clients that support it.
- Localhost is excluded through `no_proxy`.
- Does not change Windows system proxy settings, other terminal windows, or already-running applications. Some programs ignore these environment variables.
- `proxy off` clears the variables rather than restoring previous values. It does not disable Hiddify's TUN mode or a system proxy.
- Intended for CMD. Running it directly from PowerShell will not change PowerShell's environment.

## Remove

Run `proxy off` in windows where it is enabled. Remove the helper folder from your user Path if you added it, and delete the downloaded helper with File Explorer.

## Validation

This release was authored and reviewed on Linux. It has **not yet been executed on Windows 11**. Test it in CMD before relying on it; issue reports and fixes are welcome.

## License

MIT. See [LICENSE](LICENSE). This is an independent helper and is not affiliated with Hiddify or Microsoft.
